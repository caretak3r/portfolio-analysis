#!/usr/bin/env node
// Sync portfolio status from portfolio_tickers.json to index.html
const fs = require('fs');
const path = require('path');

// Read the source of truth
const tickersPath = path.join(process.env.HOME, 'clawd', 'portfolio_tickers.json');
const tickers = JSON.parse(fs.readFileSync(tickersPath, 'utf8'));

// Build portfolio object for index.html
const portfolio = {};
Object.entries(tickers).forEach(([ticker, data]) => {
  portfolio[ticker] = {
    name: data.name,
    symbol: data.symbol,
    sector: data.sector || getSectorForTicker(ticker),
  };
  
  // Add status if completed
  if (data.status === 'completed') {
    portfolio[ticker].status = 'completed';
  }
});

// Read current index.html
let html = fs.readFileSync('index.html', 'utf8');

// Replace the portfolio object (find it even if multi-line/nested)
const portfolioStr = JSON.stringify(portfolio, null, 12).replace(/^/gm, '        ');
html = html.replace(
  /const portfolio = \{[\s\S]*?\n        \};/,
  `const portfolio = ${portfolioStr};`
);

// Write back
fs.writeFileSync('index.html', html);

// Count completed
const completed = Object.values(tickers).filter(t => t.status === 'completed').length;
const total = Object.keys(tickers).length;

console.log(`✅ Updated index.html from portfolio_tickers.json`);
console.log(`   Completed: ${completed}/${total}`);
console.log(`   Tickers: ${Object.keys(portfolio).join(', ')}`);

function getSectorForTicker(ticker) {
  const sectors = {
    IOT: 'IoT SaaS',
    SNPS: 'Software',
    AVGO: 'Semiconductors',
    TER: 'Test Equipment',
    TSLA: 'Auto/Energy',
    LDOS: 'Defense/IT',
    PANW: 'Cybersecurity',
    NOC: 'Aerospace/Defense',
    LLY: 'Pharmaceuticals',
    COF: 'Financial Services',
    CNSWF: 'Software',
    MSFT: 'Software/Cloud',
    ORLY: 'Retail',
    CBOE: 'Exchanges',
    GOOGL: 'Tech/Advertising',
    AMZN: 'E-commerce/Cloud',
    COST: 'Retail',
    TSM: 'Semiconductors',
    CRWD: 'Cybersecurity',
    ISRG: 'Medical Devices',
    ASML: 'Semiconductor Equipment'
  };
  return sectors[ticker] || 'Unknown';
}
