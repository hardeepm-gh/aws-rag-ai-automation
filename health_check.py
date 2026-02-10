import boto3
import psycopg2
from botocore.exceptions import ClientError

# --- CONFIGURATION ---
S3_BUCKET = "hardeep-it-assistant-knowledge-lake-dev-01"
# Get this from your terraform output
RDS_HOST = "terraform-20260205164130825200000003.cm1gis6qotdd.us-east-1.rds.amazonaws.com" 

def check_aws_identity():
    print("🆔 Checking IAM Identity...")
    sts = boto3.client('sts')
    try:
        identity = sts.get_caller_identity()
        print(f"✅ Authenticated as: {identity['Arn']}")
    except Exception as e:
        print(f"❌ IAM Error: {e}")

def check_s3():
    print("\n📦 Checking S3 Bucket...")
    s3 = boto3.client('s3')
    try:
        s3.head_bucket(Bucket=S3_BUCKET)
        print(f"✅ S3 Bucket '{S3_BUCKET}' is reachable.")
    except ClientError as e:
        print(f"❌ S3 Error: {e}")

def check_rds():
    print("\n🐘 Checking RDS Connection...")
    try:
        conn = psycopg2.connect(
            host=RDS_HOST,
            database="postgres",
            user="hardeep_admin",
            password="SecurePassword123!", # <--- DOUBLE CHECK THIS MATCHES main.tf
            sslmode="require",                # <--- ADD THIS LINE
            connect_timeout=5
        )
        print("✅ RDS Database is reachable and authenticated!")
        conn.close()
    except Exception as e:
        print(f"❌ RDS Error: {e}")

if __name__ == "__main__":
    print("--- STARTING INFRASTRUCTURE HEALTH CHECK ---")
    check_aws_identity()
    check_s3()
    check_rds()
    print("\n--- HEALTH CHECK COMPLETE ---")