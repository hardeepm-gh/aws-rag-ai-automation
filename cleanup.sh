#!/bin/bash

echo "⚠️  WARNING: You are about to destroy all Day 25 infrastructure!"
echo "Are you sure? (y/n)"
read confirmation

if [ "$confirmation" != "y" ]; then
    echo "❌ Cleanup cancelled."
    exit 1
fi

echo "🗑️ Starting Terraform Destroy..."
terraform destroy -auto-approve -var="env=dev"

if [ "$?" == 0 ]; then
    echo "✅ AWS Resources Terminated Successfully."
    
    # Log the cleanup to progress.md
    echo "" >> progress.md
    echo "## Cleanup: $(date)" >> progress.md
    echo "- **Status**: Resources Destroyed to Save Cost 💰" >> progress.md
else
    echo "❌ Destroy failed! Please check the AWS Console manually."
    exit 1
fi