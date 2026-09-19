#!/bin/zsh
clear
echo ""
echo "⚡ Welcome to GateForge!"
echo "   I'll make your Mac ready for AI in 2 minutes"
echo ""

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
sudo tmutil thinlocalsnapshots / 999999999 4 2>&1 | tail -1
rm -rf ~/Library/Caches/* ~/.Trash/* 2>/dev/null; true

# Homebrew
[ -f /opt/homebrew/bin/brew ] || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
[ -d ~/ai-env ] || /opt/homebrew/bin/python3.11 -m venv ~/ai-env 2>/dev/null || /opt/homebrew/bin/brew install python@3.11 && /opt/homebrew/bin/python3.11 -m venv ~/ai-env

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
