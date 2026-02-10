import psycopg2

# 1. SETUP - Your verified AWS RDS credentials
RDS_HOST = "terraform-20260203161711479100000001.cm1gis6qotdd.us-east-1.rds.amazonaws.com"
DB_NAME = "postgres"
USER = "hardeep_admin"
PASSWORD = "SecurePassword123!" # <--- Update this!

def simple_ingest():
    try:
        conn = psycopg2.connect(
            host=RDS_HOST, database=DB_NAME, user=USER, 
            password=PASSWORD, sslmode="require"
        )
        cur = conn.cursor()
        
        # We are just putting text into the 'content' column for now
        # We leave the 'embedding' column empty (NULL)
        text_data = "WiFi Reset: Turn it off and on. VPN Setup: Use the corporate portal."
        
        print("🚀 Uploading text to AWS RDS...")
        cur.execute(
            "INSERT INTO documents (content) VALUES (%s)",
            (text_data,)
        )
        
        conn.commit()
        print("🏆 SUCCESS: Data is in the Cloud! No NumPy needed.")
        cur.close()
        conn.close()

    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    simple_ingest()