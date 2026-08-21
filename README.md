# Ironic CLI Tools Container

A lightweight Docker container that bundles the OpenStack `python-openstackclient`, `python-ironicclient`, and `python-keystoneclient` packages. It allows you to run baremetal commands against an OpenStack Ironic instance without polluting your host machine's Python environment.

## Features

- **Isolated Environment**: Runs completely within a `python:3.11-slim` Docker container.
- **Seamless Authentication**: Automatically passes through your local `OS_*` environment variables and mounts your local `clouds.yaml` (from `~/.config/openstack/` or `/etc/openstack/`) into the container.
- **Native Feel**: Installed as a wrapper script, allowing you to use the `ironic` command exactly as if it were installed locally.

## Installation

To build the Docker image locally and install the CLI wrapper to `~/.local/bin/ironic`, run:

```bash
chmod +x install.sh ironic.sh uninstall.sh
./install.sh
```

*(Ensure `~/.local/bin` is in your `$PATH`)*

### Using GitHub Container Registry (GHCR)
A GitHub Actions workflow is included to build and publish a multi-architecture image (`linux/amd64` and `linux/arm64`) to `ghcr.io/mattcburns/ironic-cli:latest`. If you prefer to pull the pre-built image instead of building it locally, the `install.sh` and `ironic` wrapper scripts will default to the GHCR image. You can override the image name via the `IRONIC_IMAGE` environment variable. Docker will pull the matching architecture automatically.

## Usage

Once installed, you can interact with your OpenStack environment by passing arguments just like the native CLI.

**Run an OpenStack baremetal command:**
```bash
ironic baremetal node list
```

**Open an interactive shell inside the container:**
```bash
ironic shell
```
From the interactive shell, you can natively type `openstack baremetal node list`.

## Uninstallation

To remove the symlink from `~/.local/bin` and delete the local Docker image, simply run:

```bash
./uninstall.sh
```
