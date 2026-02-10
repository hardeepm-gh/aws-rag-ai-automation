import psycopg2

RDS_HOST = "terraform-20260205164130825200000003.cm1gis6qotdd.us-east-1.rds.amazonaws.com"
DB_NAME = "postgres"
USER = "hardeep_admin"
PASSWORD = "SecurePassword123!"

def check_data():
    try:
        conn = psycopg2.connect(host=RDS_HOST, database=DB_NAME, user=USER, password=PASSWORD, sslmode="require")
        cur = conn.cursor()
        
        cur.execute("SELECT count(*) FROM documents;")
        count = cur.fetchone()[0]
        
        print(f"📊 Total records in AWS Database: {count}")
        
        cur.execute("SELECT content FROM documents LIMIT 1;")
        row = cur.fetchone()
        if row:
            print(f"📄 Sample Content: {row[0]}")
            
        cur.close()
        conn.close()
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    check_data()