#!/bin/zsh
# Golden Gate 27.0 AI Enabler for M1/M2/M3
# Built by Mohammed Morgan - Medford, MA
# Does everything we did today automatically

echo "╔══════════════════════════════════════════╗"
echo "║  GOLDEN GATE 27.0 AI ENABLER v1.0      ║"
echo "║  M1/M2/M3 + PyTorch MPS + MLX          ║"
echo "╚══════════════════════════════════════════╝"

echo "\n[1/6] Checking Mac..."
if [[ $(uname -m) != "arm64" ]]; then echo "❌ Need Apple Silicon M1/M2/M3"; exit 1; fi
sw_vers | grep ProductVersion

echo "\n[2/6] Freeing space (snapshots + caches)..."
tmutil listlocalsnapshots /
sudo tmutil thinlocalsnapshots / 10000000000 4 2>/dev/null
rm -rf ~/.Trash/* 2>/dev/null
echo "y" | rm -rf ~/Library/Caches/* 2>/dev/null
df -h /System/Volumes/Data | tail -1

echo "\n[3/6] Checking Xcode..."
xcode-select -p || xcode-select --install

echo "\n[4/6] Checking Homebrew ARM..."
if [[ ! -f /opt/homebrew/bin/brew ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
brew --version

echo "\n[5/6] Creating ai-env..."
python3 -m venv ~/ai-env 2>/dev/null || python3.11 -m venv ~/ai-env
source ~/ai-env/bin/activate
pip install --upgrade pip -q
pip install torch torchvision torchaudio mlx mlx-lm transformers huggingface_hub accelerate -q

echo "\n[6/6] TESTING..."
python -c "
import torch, mlx.core as mx
print(f'✅ PyTorch MPS: {torch.backends.mps.is_available()}')
print(f'✅ MLX Device: {mx.default_device()}')
a=torch.randn(500,500,device='mps'); b=torch.randn(500,500,device='mps'); c=a@b
print(f'✅ M1 GPU: {c.device} works')
print('')
print('🎉 GOLDEN GATE 27.0 AI READY!')
"

echo "\nDone! Run: source ~/ai-env/bin/activate"
