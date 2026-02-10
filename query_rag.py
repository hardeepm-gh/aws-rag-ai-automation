import ollama
import psycopg2
import numpy as np

# Configuration
RDS_HOST = "terraform-20260205164130825200000003.cm1gis6qotdd.us-east-1.rds.amazonaws.com"
DB_NAME = "postgres"
USER = "hardeep_admin"
PASSWORD = "SecurePassword123!"

def get_query_embedding(text):
    """Converts the user's question into a vector using local Ollama."""
    response = ollama.embeddings(model='nomic-embed-text', prompt=text)
    return response['embedding']

def retrieve_context(question):
    """Finds the most relevant text in AWS RDS using vector similarity."""
    try:
        # 1. Generate embedding for the question
        question_embedding = get_query_embedding(question)
        
        # 2. Connect to AWS
        conn = psycopg2.connect(host=RDS_HOST, database=DB_NAME, user=USER, password=PASSWORD, sslmode="require")
        cur = conn.cursor()

        # 3. Use the <=> operator (cosine distance) to find the closest match
        # This is where the pgvector magic happens!
        query = "SELECT content FROM documents ORDER BY embedding <=> %s LIMIT 1;"
        cur.execute(query, (str(question_embedding),))
        
        result = cur.fetchone()
        cur.close()
        conn.close()
        
        return result[0] if result else "No relevant information found."

    except Exception as e:
        return f"❌ Retrieval Error: {e}"

if __name__ == "__main__":
    user_input = input("🤔 Ask your IT Manual a question: ")
    print("🔍 Searching AWS Cloud Brain...")
    
    context = retrieve_context(user_input)
    
    print("\n✅ Most Relevant Instruction Found:")
    print("-" * 50)
    print(context)
    print("-" * 50)