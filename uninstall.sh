#!/usr/bin/env bash

IMAGE_NAME="${IRONIC_IMAGE:-ghcr.io/mattcburns/ironic-cli:latest}"
BIN_DIR="$HOME/.local/bin"
COMMAND_NAME="ironic"

echo "Uninstalling Ironic CLI..."

# Remove the docker image if it exists
if docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
    echo "Removing Docker image $IMAGE_NAME..."
    docker rmi "$IMAGE_NAME"
else
    echo "Docker image $IMAGE_NAME not found, skipping."
fi

# Remove the executable symlink
if [ -L "$BIN_DIR/$COMMAND_NAME" ] || [ -f "$BIN_DIR/$COMMAND_NAME" ]; then
    echo "Removing executable at $BIN_DIR/$COMMAND_NAME..."
    rm "$BIN_DIR/$COMMAND_NAME"
else
    echo "Executable at $BIN_DIR/$COMMAND_NAME not found, skipping."
fi

echo "Uninstallation complete!"
