#!/bin/bash

# TradeBlocks Code Quality Check Script
# Simple, practical code checks

set -e

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

echo "🧱 TradeBlocks - Quick Code Check"
echo "================================="

# 1. Import check (essential)
echo "🔍 Checking imports..."
if python -c "from app.main import app; print('App imports successfully')" 2>/dev/null; then
    print_success "Imports working"
else
    print_error "Import errors found!"
    python -c "from app.main import app"
    exit 1
fi

# 2. Basic syntax check (essential)
echo "🔧 Checking syntax..."
if python -m py_compile app/main.py 2>/dev/null; then
    print_success "Main syntax OK"
else
    print_error "Syntax errors in main.py"
    exit 1
fi

# 3. Code formatting (advisory only)
if command -v black &> /dev/null; then
    echo "🎨 Checking formatting..."
    if black --check app/ -q 2>/dev/null; then
        print_success "Code formatted"
    else
        print_warning "Code formatting could be improved (run: black app/)"
    fi
fi

print_success "TradeBlocks ready to go! 🚀"
