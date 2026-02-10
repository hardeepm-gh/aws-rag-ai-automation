import psycopg2

# Use your verified credentials
RDS_HOST = "terraform-20260205164130825200000003.cm1gis6qotdd.us-east-1.rds.amazonaws.com"
DB_NAME = "postgres" 
USER = "hardeep_admin"
PASSWORD = "SecurePassword123!" # <--- Update this!

def init_db():
    try:
        # These lines MUST be indented 4 spaces
        conn = psycopg2.connect(
            host=RDS_HOST,
            database=DB_NAME,
            user=USER,
            password=PASSWORD,
            sslmode="require"
        )
        conn.autocommit = True
        cur = conn.cursor()

        print("🛠️ Installing pgvector extension...")
        cur.execute("CREATE EXTENSION IF NOT EXISTS vector;")

        print("🛠️ Creating the 'documents' table for your IT Manual...")
        cur.execute("""
            CREATE TABLE IF NOT EXISTS documents (
                id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
                content text,
                metadata jsonb,
                embedding vector(1536)
            );
        """)
        
        print("✅ Database is now AI-Ready!")
        cur.close()
        conn.close()
    except Exception as e:
        print(f"❌ Initialization Error: {e}")

if __name__ == "__main__":
    init_db()