#!/usr/bin/env bash
set -euo pipefail

GYMCTL_IMAGE="${GYMCTL_IMAGE:-ghcr.io/shart-cloud/gymctl:latest}"
GYMCTL_HOME="${GYMCTL_HOME:-$HOME/.gym}"

mkdir -p "$GYMCTL_HOME"

echo "Installing gymctl wrapper (runs ${GYMCTL_IMAGE})..."
sudo tee /usr/local/bin/gymctl >/dev/null <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

image="${GYMCTL_IMAGE:-ghcr.io/shart-cloud/gymctl:latest}"
gym_home="${GYMCTL_HOME:-$HOME/.gym}"

mkdir -p "$gym_home"

workspace="${GYMCTL_WORKSPACE:-$PWD}"
workspace="$(cd "$workspace" && pwd)"
gym_home="$(cd "$gym_home" && pwd)"

docker_args=(--rm)
if [[ -t 0 ]]; then docker_args+=(-i); fi
if [[ -t 1 ]]; then docker_args+=(-t); fi

exec docker run "${docker_args[@]}" \
  -e GYMCTL_HOME="/home/gymuser/.gym" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$workspace:/workspace" \
  -w /workspace \
  -v "$gym_home:/home/gymuser/.gym" \
  "$image" "$@"
EOF
sudo chmod +x /usr/local/bin/gymctl

echo "Waiting for Docker-in-Docker daemon to be ready..."
for _ in $(seq 1 30); do
  if docker info >/dev/null 2>&1; then
    break
  fi
  sleep 1
done
docker info >/dev/null

echo "Pulling ${GYMCTL_IMAGE} into the Docker-in-Docker daemon..."
docker pull "$GYMCTL_IMAGE"

gymctl list
echo "Welcome to Container Gym! Run \"gymctl list\" to see available exercises."
