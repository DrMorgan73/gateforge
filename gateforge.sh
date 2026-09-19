#!/bin/zsh
clear
echo ""
echo "⚡ Welcome to GateForge!"
echo "   I'll make your Mac ready for AI in 2 minutes"
echo ""

# Fix zsh error with empty Trash
setopt +o nomatch

# 1. Check macOS version FIRST
OS_VER=$(sw_vers -productVersion)
MAJOR=$(echo $OS_VER | cut -d. -f1)
echo "🔍 Your macOS: $OS_VER"

if [ "$MAJOR" -lt 27 ]; then
  echo ""
  echo "⚠️  You have macOS $OS_VER, but GateForge needs 27.0"
  echo ""
  echo "   Please update first:"
  echo "   1. Click  top left"
  echo "   2. System Settings → General → Software Update"
  echo ""
  echo -n "Want to continue anyway? (y/n): "
  read a
  [[ "$a" != "y" ]] && exit 0
else
  echo "✅ Great! macOS $OS_VER is perfect"
fi

echo ""
echo "🔧 Setting up... (might ask for password, it's safe)"
sudo tmutil thinlocalsnapshots / 999999999 4 2>&1 | grep Thinned || echo "Cleaning..."
rm -rf ~/Library/Caches 2>/dev/null; mkdir -p ~/Library/Caches
rm -rf ~/.Trash 2>/dev/null; mkdir -p ~/.Trash

# Homebrew + Python (fixed)
if [ ! -f /opt/homebrew/bin/brew ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ ! -d ~/ai-env ]; then
  echo "   Creating AI environment (first time takes 2 min) ☕"
  /opt/homebrew/bin/brew install python@3.11 2>/dev/null || true
  /opt/homebrew/bin/python3.11 -m venv ~/ai-env 2>/dev/null || /opt/homebrew/bin/python3 -m venv ~/ai-env || python3 -m venv ~/ai-env
fi

source ~/ai-env/bin/activate
pip install --quiet --upgrade pip torch torchaudio torchvision mlx

echo ""
echo "🧪 Testing..."
python3 -c "import torch, mlx.core as mx; print('✅ GPU works!' if torch.backends.mps.is_available() else '✅ CPU works'); print(f'✅ AI chip: {mx.default_device()}')"

echo ""
echo "🎉 Done! Your Mac is AI Ready!"
echo ""
echo "To start AI, run:"
echo "   source ~/ai-env/bin/activate"
echo ""
