#!/bin/bash

# Run Terraform Apply
echo "🚀 Starting Terraform Apply..."
terraform apply -auto-approve -var="env=dev"

# Check if Terraform succeeded
if [ $? -eq 0 ]; then
    echo "✅ Apply Successful! Updating progress.md..."
    
    # Append the date and status to the end of the file
    echo "" >> progress.md
    echo "## Auto-Update: $(date)" >> progress.md
    echo "- **Status**: Terraform Apply Succeeded ✅" >> progress.md
    echo "- **Resources**: Managed by modular Landing Zone" >> progress.md
    
    echo "🏁 progress.md updated. Ready to push!"
else
    echo "❌ Terraform failed. Progress not updated."
    exit 1
fi