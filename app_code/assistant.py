import ollama
import psycopg2

# --- Configuration ---
RDS_HOST = "terraform-20260205164130825200000003.cm1gis6qotdd.us-east-1.rds.amazonaws.com"
port=5432,        # Add this line
DB_NAME = "postgres"
USER = "hardeep_admin"
PASSWORD = "SecurePassword123!"

def get_context(question):
    # This is your Day 13 logic
    response = ollama.embeddings(model='nomic-embed-text', prompt=question)
    vector = response['embedding']
    
    conn = psycopg2.connect(host=RDS_HOST, database=DB_NAME, user=USER, password=PASSWORD, sslmode="require")
    cur = conn.cursor()
    cur.execute("SELECT content FROM documents ORDER BY embedding <=> %s LIMIT 1;", (str(vector),))
    result = cur.fetchone()
    cur.close()
    conn.close()
    return result[0] if result else "No manual entries found."

def ask_assistant(question):
    # 1. Get the facts from AWS
    context = get_context(question)
    
    # 2. Ask Llama3 to explain those facts
    prompt = f"Using ONLY the following context: {context}\n\nQuestion: {question}\n\nAnswer:"
    
    response = ollama.chat(model='llama2', messages=[
        {'role': 'system', 'content': 'You are a professional IT Support bot. Use the provided context to help the user.'},
        {'role': 'user', 'content': prompt},
    ])
    
    return response['message']['content']

if __name__ == "__main__":
    print("🤖 IT Assistant Online. (Type 'exit' to quit)")
    while True:
        query = input("\nUser: ")
        if query.lower() == 'exit': break
        print("Thinking...")
        answer = ask_assistant(query)
        print(f"\nAssistant: {answer}")