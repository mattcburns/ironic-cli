#!/usr/bin/env bash

# Wrapper script for running openstack baremetal commands in docker.
# It automatically passes OS_* environment variables and mounts clouds.yaml.

IMAGE_NAME="ironic-tools:latest"

# Check if image exists, tell user to run install if not
if ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
    echo "Error: Docker image $IMAGE_NAME not found."
    echo "Please build the image first using the install.sh script."
    exit 1
fi

# Pass all OS_ variables that exist in the current environment
ENV_VARS=()
while IFS='=' read -r name value; do
    if [[ $name == OS_* ]]; then
        ENV_VARS+=("-e" "$name")
    fi
done < <(env)

# Volumes for clouds.yaml
VOLUMES=()
if [ -f "$HOME/.config/openstack/clouds.yaml" ]; then
    VOLUMES+=("-v" "$HOME/.config/openstack:/home/ironic_user/.config/openstack:ro")
fi
if [ -d "/etc/openstack" ]; then
    VOLUMES+=("-v" "/etc/openstack:/etc/openstack:ro")
fi

# Networking (host network is usually best for reaching local OpenStack)
NETWORK_ARGS=("--network" "host")

# Run interactively if TTY
TTY_ARGS=()
if [ -t 0 ]; then
    TTY_ARGS=("-it")
fi

# Determine if we should drop into a shell or run a command
if [ "$1" = "shell" ]; then
    shift
    exec docker run --rm "${TTY_ARGS[@]}" "${NETWORK_ARGS[@]}" "${ENV_VARS[@]}" "${VOLUMES[@]}" --entrypoint bash "$IMAGE_NAME" "$@"
else
    # The default entrypoint is `openstack`.
    # Run openstack with the provided arguments.
    exec docker run --rm "${TTY_ARGS[@]}" "${NETWORK_ARGS[@]}" "${ENV_VARS[@]}" "${VOLUMES[@]}" "$IMAGE_NAME" "$@"
fi
