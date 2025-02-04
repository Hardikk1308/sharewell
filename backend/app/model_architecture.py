import math
import torch
import torch.nn as nn
import torchvision.models as models

class Model(nn.Module):
    def __init__(self):
        super().__init__()
        self.alpha = 0.7
        
        # Load pretrained ResNet18 as base model
        self.base = models.resnet18(pretrained=True)
        
        # Freeze early layers to prevent overfitting
        for param in list(self.base.parameters())[:-15]:
            param.requires_grad = False
        
        # Remove default classifier and fully connected layers
        self.base.fc = nn.Identity()
        
        # Custom blocks for multi-task learning
        self.block1 = nn.Sequential(
            nn.Linear(512, 256),
            nn.ReLU(),
            nn.Dropout(0.2),
            nn.Linear(256, 128),
        )
        
        self.block2 = nn.Sequential(
            nn.Linear(128, 128),
            nn.ReLU(),
            nn.Dropout(0.1),
            nn.Linear(128, 9)  # Fruit classification (9 classes)
        )
        
        self.block3 = nn.Sequential(
            nn.Linear(128, 32),
            nn.ReLU(),
            nn.Dropout(0.1),
            nn.Linear(32, 2)  # Freshness classification (2 classes)
        )

    def forward(self, x):
        x = self.base(x)
        x = self.block1(x)
        
        # Multi-task outputs: fruit classification and freshness classification
        y1 = self.block2(x)  # Fruit classification output
        y2 = self.block3(x)  # Freshness classification output
        
        return y1, y2
