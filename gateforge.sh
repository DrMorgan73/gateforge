#!/bin/zsh
set -e

echo "╔══════════════════════════════════════════╗"
echo "║  GateForge v1.1 - Golden Gate 27 AI    ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# [0/6] PRE-FLIGHT: Check macOS version
echo "[0/6] Checking macOS version..."
OS_VER=$(sw_vers -productVersion)
OS_MAJOR=$(echo $OS_VER | cut -d. -f1)
echo "   Found: macOS $OS_VER"

if [ "$OS_MAJOR" -lt 27 ]; then
  echo ""
  echo "⚠️  You are on macOS $OS_VER"
  echo "   GateForge needs macOS 27.0 (Golden Gate) for best M1/M2/M3 AI support"
  echo ""
  echo "   Please update first:"
  echo "   Apple Menu > System Settings > General > Software Update"
  echo ""
  echo -n "Continue anyway? [y/N]: "
  read ans
  if [[ "$ans" != "y" && "$ans" != "Y" ]]; then
    echo "Aborting. Update macOS and re-run."
    exit 1
  fi
else
  echo "   ✅ macOS $OS_VER - Ready"
fi

echo ""
echo "[1/6] Checking Mac..."
sw_vers | grep -E "ProductName|ProductVersion|BuildVersion"

echo ""
echo "[2/6] Freeing space (snapshots + caches)..."
echo "Snapshots for disk /:"
tmutil listlocalsnapshots / 2>/dev/null | head -5 || echo "No snapshots"
echo ""
sudo tmutil thinlocalsnapshots / 999999999999 4 2>&1 | tail -3 || true
sudo rm -rf ~/Library/Caches/* 2>/dev/null || true
rm -rf ~/.Trash/* 2>/dev/null || true
df -h / | tail -1

echo ""
echo "[3/6] Checking Xcode..."
xcode-select -p 2>/dev/null || sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
echo $(xcode-select -p)

echo ""
echo "[4/6] Checking Homebrew ARM..."
if [ ! -f /opt/homebrew/bin/brew ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
echo "Homebrew $(/opt/homebrew/bin/brew --version | head -1)"

echo ""
echo "[5/6] Creating ai-env..."
if [ ! -d ~/ai-env ]; then
  /opt/homebrew/bin/brew install python@3.11 2>/dev/null || true
  /opt/homebrew/bin/python3.11 -m venv ~/ai-env
fi
source ~/ai-env/bin/activate
pip install --upgrade pip --quiet
pip install torch torchvision torchaudio mlx numpy --quiet

echo ""
echo "[6/6] TESTING..."
python3 << 'PY'
import torch, mlx.core as mx
print(f"✅ PyTorch MPS: {torch.backends.mps.is_available()}")
print(f"✅ MLX Device: {mx.default_device()}")
try:
  x=torch.randn(2,2,device='mps')
  print(f"✅ M1 GPU: {x.device} works")
except Exception as e:
  print(f"❌ M1 GPU failed: {e}")
PY

echo ""
echo "🎉 GateForge Ready! macOS $OS_VER"
echo "Done! Run: source ~/ai-env/bin/activate"
