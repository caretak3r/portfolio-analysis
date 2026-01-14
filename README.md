# Portfolio Analysis Automation

**Live Site:** https://caretak3r.github.io/portfolio-analysis/

## Workflow Overview

### 1. Generate & Push Reports Only
The simplified workflow:
1. Generate HTML report for a ticker
2. Save to `reports/{TICKER}.html`
3. Commit and push ONLY the report file
4. GitHub Actions workflow automatically updates `index.html` status

**DO NOT manually update `index.html`** - the GitHub Actions workflow handles this.

### 2. GitHub Actions Auto-Update
When a new report is pushed to `reports/*.html`:
- `.github/workflows/update-portfolio-status.yml` triggers
- Scans all reports in `reports/` directory
- Updates `index.html` with completion status
- Commits and pushes the updated `index.html`
- Deploys to GitHub Pages

### 3. Monitoring Script
`monitor_and_push.sh` - Optional background monitor that:
- Watches for new `.html` files in `reports/`
- Auto-commits and pushes them
- GitHub Actions takes over from there

## Files Excluded from Git
Per `.gitignore`:
- `*.backup` - Backup files
- `*.log` - Log files
- `*.error` - Error files
- `*_summary.md` - Summary markdown files
- `*_analysis_summary.md` - Analysis summaries
- `.secrets/` - Secret credentials

## Portfolio Status: 12/21 Complete (57%)

### ✅ Completed Reports
AMZN, AVGO, CRWD, GOOGL, IOT, LDOS, MSFT, NOC, PANW, SNPS, TER, TSLA

### ❌ Pending Reports
ASML, CBOE, CNSWF, COF, COST, ISRG, LLY, ORLY, TSM

## Quick Commands

```bash
# Pull latest
cd ~/clawd/portfolio-analysis && git pull

# Add a new report
git add reports/TICKER.html
git commit -m "Add TICKER financial report"
git push

# Monitor automatically (optional)
./monitor_and_push.sh
```

## Architecture

```
portfolio-analysis/
├── index.html              # Main page (auto-updated by GitHub Actions)
├── reports/                # Report directory
│   ├── AMZN.html
│   ├── GOOGL.html
│   └── ...
├── .github/workflows/
│   └── update-portfolio-status.yml  # Auto-updates index.html
└── monitor_and_push.sh     # Optional: auto-push new reports
```

## Important Rules
1. ✅ **DO**: Generate and push reports to `reports/*.html`
2. ✅ **DO**: Let GitHub Actions update `index.html`
3. ❌ **DON'T**: Manually edit or commit `index.html`
4. ❌ **DON'T**: Push `.backup`, `.log`, or `*_summary.md` files
5. ❌ **DON'T**: Commit secrets or tokens
