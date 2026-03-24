#!/bin/bash
# TokenSaver AI - One-Line Installer
# Usage: curl -sSL https://raw.githubusercontent.com/Jellybean-Systems/tokensaver/main/install.sh | bash

set -e

TOKENSAVER_VERSION="1.0.0"
INSTALL_DIR="${HOME}/.openclaw/workspace"
REPO_URL="https://raw.githubusercontent.com/Jellybean-Systems/tokensaver/main"

echo "═══════════════════════════════════════════════════════════"
echo "  TokenSaver AI Installer v${TOKENSAVER_VERSION}"
echo "  Intelligent Context Management for LLMs"
echo "═══════════════════════════════════════════════════════════"
echo ""

# Check Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Error: Python 3 is required but not installed"
    exit 1
fi

PYTHON_VERSION=$(python3 --version 2>&1 | grep -oP '\d+\.\d+' | head -1)
echo "✓ Python ${PYTHON_VERSION} found"

# Create directories
echo ""
echo "📁 Creating directories..."
mkdir -p "${INSTALL_DIR}/memory"
mkdir -p "${INSTALL_DIR}/scripts"
mkdir -p "${INSTALL_DIR}/data"
echo "✓ Directories created"

# Download files
echo ""
echo "⬇️  Downloading TokenSaver components..."

files=(
    "memory/qmd_database.py"
    "memory/intent_detector.py"
    "memory/context_retriever.py"
    "memory/tokensaver_wrapper.py"
    "scripts/chunk_files.py"
)

for file in "${files[@]}"; do
    echo "  → Downloading ${file}..."
    curl -sSL "${REPO_URL}/${file}" -o "${INSTALL_DIR}/${file}" || {
        echo "❌ Failed to download ${file}"
        exit 1
    }
done
echo "✓ All files downloaded"

# Make scripts executable
echo ""
echo "🔧 Setting permissions..."
chmod +x "${INSTALL_DIR}/scripts/chunk_files.py"
echo "✓ Permissions set"

# Initialize database
echo ""
echo "🗄️  Initializing QMD database..."
cd "${INSTALL_DIR}"
python3 memory/qmd_database.py > /dev/null 2>&1 || true
echo "✓ Database initialized"

# Run chunker if workspace has markdown files
echo ""
echo "📚 Processing existing files..."
MD_COUNT=$(find "${INSTALL_DIR}" -name "*.md" -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null | wc -l)

if [ "$MD_COUNT" -gt 0 ]; then
    echo "  Found ${MD_COUNT} markdown files"
    python3 scripts/chunk_files.py 2>&1 | grep -E "(Processed|Created|Database)" || true
else
    echo "  No markdown files found (that's OK)"
fi
echo "✓ File processing complete"

# Verify installation
echo ""
echo "🔍 Verifying installation..."
python3 -c "
import sys
sys.path.insert(0, '${INSTALL_DIR}')
from memory.tokensaver_wrapper import TokenSaver
ts = TokenSaver()
report = ts.get_savings_report()
print(f'✓ TokenSaver loaded successfully')
print(f\"  - Database chunks: {report.get('total_chunks', 0)}\")
print(f\"  - Queries processed: {report.get('queries_processed', 0)}\")
" || {
    echo "❌ Verification failed"
    exit 1
}

# Create quick test
echo ""
echo "🧪 Running quick test..."
python3 -c "
import sys
sys.path.insert(0, '${INSTALL_DIR}')
from memory.tokensaver_wrapper import tokensaver

# Test query
test_query = 'What is the current status?'
enhanced = tokensaver.enhance_prompt(test_query)
tokens = len(enhanced.split())

print(f'✓ Test query processed')
print(f'  Original: {len(test_query.split())} tokens')
print(f'  Enhanced: {tokens} tokens')
print(f'  Method: Intent-Augmented Semantic Retrieval')
"

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "  ✅ TokenSaver AI Installed Successfully!"
echo "═══════════════════════════════════════════════════════════"
echo ""
echo "📖 Quick Start:"
echo ""
echo "  from memory.tokensaver_wrapper import tokensaver"
echo ""
echo "  # Enhance any prompt"
echo "  enhanced = tokensaver.enhance_prompt('Your query here')"
echo ""
echo "  # Get savings report"
echo "  report = tokensaver.get_savings_report()"
echo "  print(f\"Saved: \${report['estimated_cost_saved_usd']}\")"
echo ""
echo "📁 Installation directory: ${INSTALL_DIR}"
echo "📊 Database location: ${INSTALL_DIR}/data/qmd.db"
echo ""
echo "For help: https://github.com/Jellybean-Systems/tokensaver"
echo ""

# Optional: Add to shell profile
echo "💡 Tip: Add this to your ~/.bashrc or ~/.zshrc:"
echo "  export PYTHONPATH=\"\${HOME}/.openclaw/workspace:\${PYTHONPATH}\""