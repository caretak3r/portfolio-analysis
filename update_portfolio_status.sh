#!/bin/bash
# Update index.html with completed report status

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_DIR"

echo "Scanning reports directory..."
COMPLETED=()

for report in reports/*.html; do
    if [ -f "$report" ]; then
        ticker=$(basename "$report" .html)
        COMPLETED+=("$ticker")
        echo "✓ $ticker"
    fi
done

TOTAL_COMPLETED=${#COMPLETED[@]}
echo "Total completed: $TOTAL_COMPLETED/21"

# Update index.html
echo "Updating index.html..."

# Read current index.html
INDEX_FILE="index.html"

# For each completed ticker, ensure it has status: "completed" in the JavaScript object
for ticker in "${COMPLETED[@]}"; do
    # Check if ticker already has status
    if ! grep -q "\"$ticker\".*\"status\".*\"completed\"" "$INDEX_FILE"; then
        # Add status to the ticker object (before closing brace)
        # This is a simple approach - more sophisticated would parse JSON properly
        sed -i.bak "s/\(\"$ticker\": {[^}]*\)\(\"sector\": \"[^\"]*\"\)/\1\"sector\": \"\2\", \"status\": \"completed\"/" "$INDEX_FILE"
    fi
done

# Update the count in the header
sed -i.bak "s/<span class=\"px-3 py-1 bg-emerald-500\/10 text-emerald-400 rounded-full font-medium\">[0-9]* Holdings<\/span>/<span class=\"px-3 py-1 bg-emerald-500\/10 text-emerald-400 rounded-full font-medium\">21 Holdings<\/span>/" "$INDEX_FILE"

# Clean up backup file
rm -f "$INDEX_FILE.bak"

echo "✓ index.html updated"
echo "Completed reports: ${COMPLETED[*]}"
