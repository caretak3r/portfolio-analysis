#!/bin/bash
# Generate and push a single stock report
# Usage: ./generate_report.sh TICKER

set -e

TICKER=$1
REPO_DIR=~/clawd/portfolio-analysis

if [ -z "$TICKER" ]; then
    echo "Usage: $0 TICKER"
    echo "Example: $0 AAPL"
    exit 1
fi

echo "📊 Generating report for $TICKER..."

cd "$REPO_DIR"

# Pull latest changes first
echo "⬇️  Pulling latest changes..."
git pull origin main

# Generate the report (placeholder - actual generation logic elsewhere)
# This would call your report generation tool/script
echo "⚙️  Report generation should be done by your report tool"
echo "📁 Report should be saved to: $REPO_DIR/reports/$TICKER.html"

# Check if report exists
if [ ! -f "reports/$TICKER.html" ]; then
    echo "❌ Error: reports/$TICKER.html not found!"
    echo "Generate the report first, then run this script."
    exit 1
fi

# Commit and push ONLY the report
echo "📝 Committing $TICKER report..."
git add "reports/$TICKER.html"
git commit -m "Add $TICKER financial report"

echo "⬆️  Pushing to GitHub..."
git push origin main

echo "✅ Done! GitHub Actions will update index.html automatically."
echo "🌐 Check: https://github.com/caretak3r/portfolio-analysis/actions"
