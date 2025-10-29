#!/bin/bash

# Make all scripts executable

chmod +x scripts/*.sh
chmod +x terraform/*.sh 2>/dev/null || true

echo "✅ All scripts are now executable!"

