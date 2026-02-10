import streamlit as st
import ollama
import psycopg2
import tempfile
import os
from langchain_community.document_loaders import PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter

# --- 1. Page Configuration ---
st.set_page_config(page_title="AI Knowledge Portal", page_icon="🧠", layout="wide")
st.title("🧠 Enterprise IT Support Portal")
st.markdown("Interact with your AWS-hosted knowledge base or upload new manuals.")

# --- 2. Configuration ---
RDS_HOST = "terraform-20260209152911550000000003.cm1gis6qotdd.us-east-1.rds.amazonaws.com"
DB_NAME = "postgres"
USER = "hardeep_admin"
PASSWORD = "SecurePassword123!"

# --- 3. Sidebar: Knowledge Management ---
with st.sidebar:
    st.header("📂 Data Ingestion")
    st.info("Upload PDFs to expand the AI's knowledge base in AWS.")
    
    uploaded_file = st.file_uploader("Choose an IT Manual (PDF)", type="pdf")
    
    if uploaded_file:
        if st.button("🚀 Sync to AWS RDS"):
            with st.status("Processing Document...", expanded=True) as status:
                # Save to temp file
                with tempfile.NamedTemporaryFile(delete=False, suffix=".pdf") as tmp_file:
                    tmp_file.write(uploaded_file.getvalue())
                    tmp_path = tmp_file.name

                # Chunking logic
                st.write("✂️ Chunking text into fragments...")
                loader = PyPDFLoader(tmp_path)
                text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=100)
                chunks = text_splitter.split_documents(loader.load())
                
                # AWS Sync
                st.write(f"🧠 Uploading {len(chunks)} vectors to AWS...")
                conn = psycopg2.connect(host=RDS_HOST, database=DB_NAME, user=USER, password=PASSWORD, sslmode="require")
                cur = conn.cursor()
                
                for chunk in chunks:
                    resp = ollama.embeddings(model='nomic-embed-text', prompt=chunk.page_content)
                    cur.execute("INSERT INTO documents (content, embedding) VALUES (%s, %s)", 
                                (chunk.page_content, resp['embedding']))
                
                conn.commit()
                cur.close()
                conn.close() # Added parentheses here
                os.remove(tmp_path)
                
                status.update(label="✅ Sync Complete!", state="complete", expanded=False)
                st.success("Document successfully learned!")

    st.divider()
    if st.button("🗑️ Clear Chat History"):
        st.session_state.messages = []
        st.rerun()

# --- 4. RAG Logic ---
def get_ai_response(question):
    try:
        # Get Embedding
        resp = ollama.embeddings(model='nomic-embed-text', prompt=question)
        vector = resp['embedding']
        
        # Search AWS RDS
        conn = psycopg2.connect(host=RDS_HOST, database=DB_NAME, user=USER, password=PASSWORD, sslmode="require")
        cur = conn.cursor()
        cur.execute("SELECT content FROM documents ORDER BY embedding <=> %s LIMIT 1;", (str(vector),))
        result = cur.fetchone()
        context = result[0] if result else "No relevant context found in AWS."
        cur.close()
        conn.close()
        
        # Generate Answer
        prompt = f"Using ONLY the following context: {context}\n\nQuestion: {question}\n\nAnswer:"
        output = ollama.chat(model='llama2', messages=[
            {'role': 'system', 'content': 'You are a professional IT Support bot.'},
            {'role': 'user', 'content': prompt},
        ])
        return output['message']['content'], context

    except Exception as e:
        return f"System Error: {str(e)}", "N/A"

# --- 5. Chat Interface ---
if "messages" not in st.session_state:
    st.session_state.messages = []

# Display history
for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.markdown(message["content"])
        if "source" in message and message["role"] == "assistant":
            with st.expander("🔍 View Source Knowledge"):
                st.info(message["source"])

# User input
if user_query := st.chat_input("Ask a question about IT policies..."):
    st.session_state.messages.append({"role": "user", "content": user_query})
    with st.chat_message("user"):
        st.markdown(user_query)

    with st.chat_message("assistant"):
        with st.spinner("Consulting AWS Knowledge Base..."):
            answer, source_text = get_ai_response(user_query)
            st.markdown(answer)
            with st.expander("🔍 View Source Knowledge (from AWS)"):
                st.info(source_text)
    
    st.session_state.messages.append({
        "role": "assistant", 
        "content": answer, 
        "source": source_text
    })