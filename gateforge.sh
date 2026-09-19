#!/bin/zsh
# GateForge v2.2 - Python 3.11 Locked
set -e
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
echo "${CYAN}⚡ GateForge v2.2 - Python 3.11 Locked${NC}"
MACOS_VER=$(sw_vers -productVersion)
echo "Your macOS: $MACOS_VER ✅"
echo "\n🧹 Cleaning cache safely..."
find ~/Library/Caches -type f -atime +7 -delete 2>/dev/null || true
rm -rf ~/Library/Caches/Homebrew 2>/dev/null || true
if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
echo "\n🐍 Ensuring Python 3.11..."
brew list python@3.11 &>/dev/null || brew install python@3.11
PYTHON_311=""
[ -x /opt/homebrew/bin/python3.11 ] && PYTHON_311="/opt/homebrew/bin/python3.11"
[ -z "$PYTHON_311" ] && PYTHON_311="$(brew --prefix python@3.11)/bin/python3.11"
echo "Using: $PYTHON_311"
$PYTHON_311 --version
brew link --overwrite python@3.11 2>/dev/null || true
echo "\n📦 Creating AI env with Python 3.11..."
[ -d ~/ai-env ] && rm -rf ~/ai-env
$PYTHON_311 -m venv ~/ai-env
source ~/ai-env/bin/activate
python -m pip install --upgrade pip setuptools wheel -q
echo "${GREEN}✅ ai-env created with $(python --version)${NC}"
echo "\n🤖 Installing PyTorch + MLX..."
pip install --quiet torch torchvision torchaudio mlx -q
python << 'PYTEST'
import sys; print(f"Python: {sys.version}")
try:
 import torch; mps=torch.backends.mps.is_available(); print(f"MPS: {mps}"); print("✅ GPU works! Device: mps" if mps else "⚠️ MPS not available")
except Exception as e: print(e)
try:
 import mlx.core as mx; print(f"MLX Device: {mx.default_device()}"); print("✅ MLX works! Device(gpu,0)")
except Exception as e: print(e)
print("\n🎉 GateForge v2.2 Ready!")
PYTEST
echo "\n${GREEN}✅ DONE! source ~/ai-env/bin/activate${NC}"
