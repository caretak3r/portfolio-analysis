#!/bin/bash
REPO_DIR=~/clawd/portfolio-analysis
GITHUB_TOKEN=$(cat ~/clawd/.secrets/github_token)

cd "$REPO_DIR"

while true; do
    COMPLETED=$(ls -1 reports/*.html 2>/dev/null | wc -l | tr -d ' ')
    echo "=== $(date +%H:%M:%S) ==="
    echo "Progress: $COMPLETED/21 reports complete"
    
    # Check for new/modified files
    NEW=$(git status --porcelain reports/*.html 2>/dev/null)
    
    if [ -n "$NEW" ]; then
        echo "New reports found! Committing..."
        git add reports/*.html
        COUNT=$(echo "$NEW" | wc -l | tr -d ' ')
        git commit -m "Add $COUNT financial report(s) - $(date +%H:%M)"
        git push https://${GITHUB_TOKEN}@github.com/caretak3r/portfolio-analysis.git main 2>&1 | tail -3
        echo "✓ Pushed to GitHub!"
    else
        echo "No new reports yet..."
    fi
    
    # Exit if all done
    if [ "$COMPLETED" -eq 21 ]; then
        echo "🎉 ALL REPORTS COMPLETE!"
        exit 0
    fi
    
    sleep 60
done
