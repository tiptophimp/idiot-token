#!/bin/bash
# IDIOT Token Website Deployment Script

echo "🚀 Deploying IDIOT Token Website..."

# Set your server details here
SERVER="your-server.com"
USERNAME="your-username"
REMOTE_PATH="/path/to/public_html"

# Upload all files
echo "📤 Uploading files to server..."
rsync -avz --delete public_html/ $USERNAME@$SERVER:$REMOTE_PATH/

# Set proper permissions
echo "🔧 Setting permissions..."
ssh $USERNAME@$SERVER "chmod -R 755 $REMOTE_PATH && chmod 644 $REMOTE_PATH/.htaccess"

echo "✅ Deployment complete!"
echo "🌐 Website should be live at: https://$SERVER/"
