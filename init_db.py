import psycopg2

RDS_HOST = "terraform-20260209152911550000000003.cm1gis6qotdd.us-east-1.rds.amazonaws.com"
DB_NAME = "postgres"
USER = "hardeep_admin"
PASSWORD = "SecurePassword123!"

def init_db():
    try:
        conn = psycopg2.connect(host=RDS_HOST, database=DB_NAME, user=USER, password=PASSWORD, sslmode="require")
        cur = conn.cursor()

        # 1. Enable the pgvector extension
        print("🔧 Enabling pgvector extension...")
        cur.execute("CREATE EXTENSION IF NOT EXISTS vector;")

        # 2. Create the documents table
        print("📝 Creating 'documents' table...")
        cur.execute("""
            CREATE TABLE IF NOT EXISTS documents (
                id serial PRIMARY KEY,
                content text,
                embedding vector(768)
            );
        """)
        
        conn.commit()
        print("🏆 Database is ready for AI data!")
        cur.close()
        conn.close()
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    init_db()