import psycopg2
import ollama
from langchain_community.document_loaders import PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter

# --- Configuration ---
RDS_HOST = "terraform-20260210152803083900000004.cm1gis6qotdd.us-east-1.rds.amazonaws.com"
DB_NAME = "postgres"
USER = "hardeep_admin"
PASSWORD = "SecurePassword123!"

def ingest_pdf(file_path):
    print(f"📄 Loading PDF: {file_path}")
    
    # 1. Load the PDF
    loader = PyPDFLoader(file_path)
    documents = loader.load()

    # 2. Split text into chunks (1000 chars with overlap for context)
    # This ensures sentences aren't cut in half without context
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=100)
    chunks = text_splitter.split_documents(documents)
    print(f"✂️ Split into {len(chunks)} chunks.")

    # 3. Connect to AWS RDS
    conn = psycopg2.connect(host=RDS_HOST, database=DB_NAME, user=USER, password=PASSWORD, sslmode="require")
    cur = conn.cursor()

    print("🧠 Generating embeddings and uploading to AWS...")
    for i, chunk in enumerate(chunks):
        content = chunk.page_content
        
        # Generate embedding using Nomic
        resp = ollama.embeddings(model='nomic-embed-text', prompt=content)
        embedding = resp['embedding']

        # Insert into pgvector table
        cur.execute(
            "INSERT INTO documents (content, embedding) VALUES (%s, %s)",
            (content, embedding)
        )
        if i % 5 == 0:
            print(f"✅ Processed {i}/{len(chunks)} chunks...")

    conn.commit()
    cur.close()
    conn.close()
    print("🚀 Ingestion Complete! Your AWS brain is now smarter.")

if __name__ == "__main__":
    # Change 'it_manual.pdf' to whatever PDF you have in your folder
    ingest_pdf("it_manual.pdf")

