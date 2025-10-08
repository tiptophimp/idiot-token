#!/bin/bash

# IDIOT Token Website - Railway Deployment Script
# This script helps deploy the website to Railway

echo "🚀 IDIOT Token Website - Railway Deployment"
echo "=========================================="

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI not found. Installing..."
    npm install -g @railway/cli
fi

# Check if user is logged in
if ! railway whoami &> /dev/null; then
    echo "🔐 Please log in to Railway:"
    railway login
fi

echo "📦 Building and deploying to Railway..."

# Deploy to Railway
railway up

echo "✅ Deployment initiated!"
echo ""
echo "🌐 Your website will be available at:"
echo "   https://your-project-name.up.railway.app"
echo ""
echo "📊 Monitor deployment at:"
echo "   https://railway.app/dashboard"
echo ""
echo "🔧 Next steps:"
echo "   1. Configure custom domain (stupidiots.com)"
echo "   2. Update DNS records"
echo "   3. Test all functionality"
echo ""
echo "📖 For detailed instructions, see:"
echo "   RAILWAY_WEBSITE_DEPLOYMENT.md"
