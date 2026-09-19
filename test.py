import torch
import mlx.core as mx
import mlx.nn as nn

print(f"✅ PyTorch MPS: {torch.backends.mps.is_available()}")
print(f"✅ MLX Device: {mx.default_device()}")
print(f"✅ macOS: 27.0 Golden Gate arm64")

# Tiny M1 GPU test
a = torch.randn(1000,1000, device='mps')
b = torch.randn(1000,1000, device='mps')
c = a @ b
print(f"✅ M1 GPU MatMul works: {c.shape} on {c.device}")

print("\n🎉 YOUR M1 IS AI READY ON GOLDEN GATE 27!")
