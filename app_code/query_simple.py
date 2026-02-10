import psycopg2

RDS_HOST = "terraform-20260205164130825200000003.cm1gis6qotdd.us-east-1.rds.amazonaws.com"
DB_NAME = "postgres"
USER = "hardeep_admin"
PASSWORD = "SecurePassword123!"

def search_manual(keyword):
    try:
        conn = psycopg2.connect(host=RDS_HOST, database=DB_NAME, user=USER, password=PASSWORD, sslmode="require")
        cur = conn.cursor()
        
        # Using ILIKE for a case-insensitive search in your 'content' column
        query = "SELECT content FROM documents WHERE content ILIKE %s LIMIT 1;"
        cur.execute(query, (f'%{keyword}%',))
        
        result = cur.fetchone()
        
        if result:
            print(f"\n✅ MATCH FOUND FOR '{keyword}':")
            print(f"--------------------------------------------------")
            print(result[0])
            print(f"--------------------------------------------------")
        else:
            print(f"\n❌ No procedures found containing '{keyword}'.")
            
        cur.close()
        conn.close()
    except Exception as e:
        print(f"❌ Query Error: {e}")

if __name__ == "__main__":
    search_term = input("Enter a search term (e.g., WiFi): ")
    search_manual(search_term)