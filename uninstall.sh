#!/bin/zsh
# GateForge Uninstall - Frontend only, no backend
set -e
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
echo "${CYAN}🧹 GateForge Uninstall (Frontend Only)${NC}"
[ -d ~/ai-env ] && rm -rf ~/ai-env && echo "${GREEN}✅ Removed ~/ai-env${NC}" || echo "ℹ️ ~/ai-env not found"
rm -rf ~/Library/Caches/Homebrew 2>/dev/null || true
echo "${GREEN}✅ Uninstall complete! Your Mac is clean.${NC}"
echo "To also remove Python 3.11: brew uninstall python@3.11"
