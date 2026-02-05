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

# Check if this is a "start" command
if [ "${1:-}" = "start" ] && [ -n "${2:-}" ]; then
    exercise_name="$2"

    # First, run the start command to set up the environment
    docker run "${docker_args[@]}" \
      -e GYMCTL_HOME="/home/gymuser/.gym" \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v "$workspace:/workspace" \
      -w /workspace \
      -v "$gym_home:/home/gymuser/.gym" \
      "$image" start "$exercise_name"

    start_exit_code=$?

    # If start succeeded, enter interactive shell in the exercise work directory
    if [ $start_exit_code -eq 0 ]; then
        echo ""
        echo "=========================================="
        echo "Entering interactive gym environment..."
        echo "You are now in the work directory for: $exercise_name"
        echo "Type 'exit' to return to your Codespace"
        echo "=========================================="
        echo ""

        # Enter interactive shell at the work directory
        exec docker run -it --rm \
          -e GYMCTL_HOME="/home/gymuser/.gym" \
          -v /var/run/docker.sock:/var/run/docker.sock \
          -v "$workspace:/workspace" \
          -w "/home/gymuser/.gym/workdir/$exercise_name" \
          -v "$gym_home:/home/gymuser/.gym" \
          "$image" bash
    else
        exit $start_exit_code
    fi
elif [ "${1:-}" = "shell" ]; then
    # Interactive shell mode
    exec docker run -it --rm \
      -e GYMCTL_HOME="/home/gymuser/.gym" \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v "$workspace:/workspace" \
      -w /workspace \
      -v "$gym_home:/home/gymuser/.gym" \
      "$image" bash
else
    # For all other commands, run normally
    exec docker run "${docker_args[@]}" \
      -e GYMCTL_HOME="/home/gymuser/.gym" \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v "$workspace:/workspace" \
      -w /workspace \
      -v "$gym_home:/home/gymuser/.gym" \
      "$image" "$@"
fi
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
echo ""
echo "Welcome to Container Gym!"
echo ""
echo "Commands:"
echo "  gymctl list                - List available exercises"
echo "  gymctl start <exercise>    - Start an exercise (enters interactive shell)"
echo "  gymctl shell               - Enter interactive gym shell"
echo "  gymctl <command>           - Run any other gymctl command"
