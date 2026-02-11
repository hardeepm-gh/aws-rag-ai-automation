import boto3
import psycopg2
import os

# These would come from your Terraform Outputs
S3_BUCKET_NAME = "hardeep-rag-lake-2i09" # Replace with your output
RDS_ENDPOINT = "terraform-20260211012442571400000005.cm1gis6qotdd.us-east-1.rds.amazonaws.com"
DB_NAME = "ragdb"
DB_USER = "dbadmin"
DB_PASS = "HardeepSecurePass2026!"

def verify_s3():
    print("--- Testing S3 Connection ---")
    s3 = boto3.client('s3')
    try:
        response = s3.list_objects_v2(Bucket=S3_BUCKET_NAME)
        print(f"✅ Successfully connected to S3: {S3_BUCKET_NAME}")
    except Exception as e:
        print(f"❌ S3 Connection failed: {e}")

def verify_rds():
    print("\n--- Testing RDS Connection ---")
    try:
        # Note: This requires you to be on a VPN or inside the VPC
        conn = psycopg2.connect(
            host=RDS_ENDPOINT,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASS,
            connect_timeout=5
        )
        print("✅ Successfully connected to PostgreSQL Database")
        conn.close()
    except Exception as e:
        print(f"⚠️ RDS Connection Note: {e}")
        print("   (This usually fails from home because the DB is in a private subnet!)")

if __name__ == "__main__":
    verify_s3()
    verify_rds()