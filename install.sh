#!/usr/bin/env bash
set -e

IMAGE_NAME="ironic-tools:latest"
BIN_DIR="$HOME/.local/bin"
COMMAND_NAME="ironic"

echo "Building Docker image $IMAGE_NAME..."
docker build -t "$IMAGE_NAME" .

echo "Ensuring $BIN_DIR exists..."
mkdir -p "$BIN_DIR"

echo "Installing script to $BIN_DIR/$COMMAND_NAME..."
# Get absolute path to ironic.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_PATH="$SCRIPT_DIR/ironic.sh"

# Make it executable
chmod +x "$SCRIPT_PATH"

# Create symlink
ln -sf "$SCRIPT_PATH" "$BIN_DIR/$COMMAND_NAME"

echo "Installation complete!"
echo "You can now run '$COMMAND_NAME <commands>' from anywhere (assuming $BIN_DIR is in your PATH)."
echo "For example:"
echo "  $COMMAND_NAME baremetal node list"
echo "  $COMMAND_NAME shell"
