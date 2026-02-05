# Container Gym 🏋️

Interactive hands-on exercises for learning Docker and Kubernetes through practice.

**What makes Container Gym different?**
- 🎯 **Scenario-based learning** - Fix real problems, not toy examples
- 🔄 **Automatic environment setup** - Start coding immediately, no manual configuration
- ✅ **Instant validation** - Check your solutions with `gymctl check`
- 💡 **Built-in hints** - Get unstuck without spoiling the solution
- 📦 **Docker-in-Docker enabled** - Run real Docker commands in a safe environment
- 🚀 **Interactive shell workflow** - Automatically drops you into the exercise workspace

## Quick Start

### Using GitHub Codespaces or VS Code Dev Container (Recommended)

1. **Open in Codespaces** or open this folder in VS Code
2. When prompted, click "Reopen in Container" (VS Code) or wait for Codespace to start
3. Wait for the environment to initialize (installs gymctl automatically)
4. You're ready! Run `gymctl list` to see available exercises

**The Interactive Experience:**

When you start an exercise, `gymctl` automatically puts you into an interactive shell at the exercise work directory:

```bash
# In your Codespace terminal:
$ gymctl list
Available exercises...

$ gymctl start container-lifecycle

# Exercise setup runs...
# Then automatically:
==========================================
Entering interactive gym environment...
You are now in the work directory for: container-lifecycle
Type 'exit' to return to your Codespace
==========================================

# Now you're IN the gym container!
gymuser@abc123:/home/gymuser/.gym/workdir/container-lifecycle$ ls
Dockerfile  app.py  README.md

# Work on your exercise files here
gymuser@abc123:...$ vim Dockerfile
gymuser@abc123:...$ docker build -t myapp .
gymuser@abc123:...$ gymctl check

# When done, exit back to Codespace
gymuser@abc123:...$ exit
$
```

**Key Points:**
- Your files persist in `~/.gym/workdir/<exercise>` even after exiting the container
- Docker-in-Docker is enabled - you can run `docker` commands inside exercises
- All `gymctl` commands work from inside the interactive shell
- Type `exit` to return to your Codespace terminal

### Using Docker Compose

```bash
# Start the environment (automatically pulls image)
make up

# Connect to the gym
make shell

# Inside the container
gymctl list
gymctl start jerry-root-container
gymctl check
gymctl hint
```

### Using Make Commands

```bash
# Show available commands
make help

# Start environment (pulls image automatically)
make up

# Connect to container
make shell

# Check status
make status

# View logs
make logs

# Stop environment
make down

# Clean everything
make clean
```

## Exercise Tracks

### Docker Fundamentals

1. **jerry-root-container** - Fix container running as root
2. **jerry-fat-image** - Optimize bloated Docker image
3. **jerry-broken-layers** - Fix inefficient layer caching
4. **jerry-no-healthcheck** - Add health checks
5. **jerry-lost-connection** - Debug networking issues
6. **jerry-broken-syntax** - Fix Dockerfile syntax errors

### Kubernetes Basics

1. **jerry-forgot-resources** - Add resource limits
2. **jerry-broken-service** - Fix service configuration
3. **jerry-missing-configmap** - Add ConfigMap mounting
4. **jerry-probe-failures** - Fix liveness/readiness probes
5. **jerry-wrong-namespace** - Fix namespace issues

## Working with Exercises

### Start an Exercise

```bash
# From your Codespace terminal, list available exercises
$ gymctl list

# Start a specific exercise (enters interactive mode automatically)
$ gymctl start container-lifecycle

# Now you're in the gym container at the exercise work directory!
gymuser@abc123:/home/gymuser/.gym/workdir/container-lifecycle$

# Work on your solution
gymuser@abc123:...$ vim Dockerfile
gymuser@abc123:...$ docker build -t myapp .

# Check your progress (from inside the gym container)
gymuser@abc123:...$ gymctl check

# Get hints if stuck
gymuser@abc123:...$ gymctl hint

# Reset if needed
gymuser@abc123:...$ gymctl reset

# Exit when done (returns to Codespace)
gymuser@abc123:...$ exit
```

### Exercise Workflow

1. **Start**: `gymctl start <exercise-name>` (automatically enters interactive shell)
2. **Work**: Edit files, run Docker commands, test your solution
3. **Check**: `gymctl check` to validate your solution
4. **Hint**: `gymctl hint` if you need help
5. **Exit**: Type `exit` to return to Codespace
6. **Resume**: Run `gymctl shell` to re-enter the gym environment anytime

### Additional Commands

```bash
# Enter interactive gym shell anytime (from Codespace)
$ gymctl shell

# Run any gymctl command without entering interactive mode
$ gymctl status         # Check your overall progress
$ gymctl describe <ex>  # See exercise details
$ gymctl clean          # Clean up Docker resources
```

## Common Workflows

### Typical Exercise Session

```bash
# 1. Start in Codespace terminal
$ gymctl list
$ gymctl start container-lifecycle

# 2. Now in gym container - work on exercise
gymuser@abc123:...$ cat README.md
gymuser@abc123:...$ vim Dockerfile
gymuser@abc123:...$ docker build -t myapp .
gymuser@abc123:...$ docker run -d myapp
gymuser@abc123:...$ docker ps
gymuser@abc123:...$ gymctl check
✅ All checks passed!

# 3. Exit and start next exercise
gymuser@abc123:...$ exit
$ gymctl start next-exercise
```

### Editing Files

You have two options for editing exercise files:

**Option 1: Edit inside the gym container**
```bash
# From inside the gym container
gymuser@abc123:...$ vim Dockerfile
gymuser@abc123:...$ nano app.py
```

**Option 2: Edit from VS Code in Codespace**
```bash
# Open another terminal in VS Code, then:
$ code ~/.gym/workdir/container-lifecycle/Dockerfile

# Files are shared via the volume mount!
# Changes appear immediately in the gym container
```

### Resuming Work

```bash
# If you exited and want to continue working
$ gymctl shell

# This puts you back in the gym environment
# Your work directory persists
gymuser@abc123:/workspace$ cd ~/.gym/workdir/container-lifecycle
gymuser@abc123:...$ gymctl check
```

### Getting Unstuck

```bash
# Inside the gym container
gymuser@abc123:...$ gymctl hint        # Get a hint
gymuser@abc123:...$ gymctl hint        # Get another hint
gymuser@abc123:...$ gymctl describe    # Re-read exercise description
gymuser@abc123:...$ gymctl reset       # Start over (clears work dir)
```

## Workspace Structure

When you start an exercise, files are copied to your work directory:

```
~/.gym/
├── workdir/
│   ├── container-lifecycle/      # Exercise 1 work directory
│   │   ├── Dockerfile
│   │   ├── app.py
│   │   └── README.md
│   ├── jerry-root-container/     # Exercise 2 work directory
│   │   ├── Dockerfile
│   │   └── app/
│   └── ...
├── progress.yaml                 # Your progress tracking
└── current                       # Currently active exercise
```

**Important Notes:**
- Work directories are mounted from your Codespace to the gym container
- Files persist even when you exit the container
- Each exercise has its own isolated work directory
- You can access these files from VS Code in your Codespace at `~/.gym/workdir/`

## Progress Tracking

Your progress is automatically saved in `~/.gym/progress.yaml`. To check:

```bash
# From Codespace or inside gym container
gymctl status
```

## How It Works

Understanding the architecture helps you troubleshoot and get the most out of the gym:

```
┌─────────────────────────────────────────┐
│  GitHub Codespace / Dev Container       │
│  (Your VS Code environment)             │
│                                         │
│  $ gymctl start container-lifecycle     │
│         ↓                               │
│  ┌───────────────────────────────────┐ │
│  │  gymctl Wrapper Script            │ │
│  │  - Runs Docker container          │ │
│  │  - Mounts ~/.gym volume           │ │
│  │  - Enables Docker-in-Docker       │ │
│  └───────────────────────────────────┘ │
│         ↓                               │
│  ┌───────────────────────────────────┐ │
│  │  GymCTL Container                 │ │
│  │  (ghcr.io/shart-cloud/gymctl)     │ │
│  │                                   │ │
│  │  1. Sets up exercise environment  │ │
│  │  2. Copies files to work dir      │ │
│  │  3. Enters interactive bash       │ │
│  │                                   │ │
│  │  You work here! →                 │ │
│  │  - Edit Dockerfiles               │ │
│  │  - Run docker commands            │ │
│  │  - Test solutions                 │ │
│  └───────────────────────────────────┘ │
│                                         │
│  ~/.gym/workdir/ ← Files persist here  │
└─────────────────────────────────────────┘
```

**Key Points:**
- `gymctl` is a wrapper script that runs a Docker container
- Docker-in-Docker (dind) is enabled, so you can run `docker` commands
- Your work directory (`~/.gym/`) is mounted from Codespace into the container
- Files persist on your Codespace even when the container exits
- When you run `gymctl start`, it automatically enters an interactive shell

## Troubleshooting

### "I ran `gymctl start` but I'm not in the exercise directory"

This happens if you're using an older version of the wrapper script. Solutions:

```bash
# Option 1: Rebuild the devcontainer (Codespaces/Dev Container)
# Command Palette → "Rebuild Container"

# Option 2: Manually re-run postCreate script
$ bash .devcontainer/postCreate.sh

# Option 3: Use gymctl shell to enter manually
$ gymctl shell
gymuser@abc123:/workspace$ cd ~/.gym/workdir/exercise-name
```

### "Docker command not found" inside gym container

The Docker daemon might not be ready yet. Wait a few seconds and try again:

```bash
# Inside gym container
gymuser@abc123:...$ docker ps
Cannot connect to the Docker daemon...

# Wait a moment, then try again
gymuser@abc123:...$ sleep 5 && docker ps
# Should work now
```

### "Permission denied" when accessing Docker socket

From inside the gym container:

```bash
gymuser@abc123:...$ ls -l /var/run/docker.sock
# If permissions are wrong, exit and fix from Codespace:
$ sudo chmod 666 /var/run/docker.sock
$ gymctl shell  # Re-enter
```

### Devcontainer Fails to Create (GHCR Image)

If Codespaces/Dev Containers fails with an error like `docker inspect --type image ghcr.io/shart-cloud/gymctl:...`, Docker couldn't fetch the `gymctl` image.

- Verify the tag exists (this repo defaults to `ghcr.io/shart-cloud/gymctl:latest`)
- If the GHCR package is private, grant the Codespace/repository read access to the package (or make the package public), then rebuild the devcontainer

### "I want to start over on an exercise"

```bash
# From inside the gym container
gymuser@abc123:...$ gymctl reset

# This clears the work directory and resets the exercise
```

### "My files disappeared!"

Files are stored in `~/.gym/workdir/` on your Codespace. They persist even when containers are removed. Check:

```bash
# From Codespace terminal
$ ls ~/.gym/workdir/
container-lifecycle/  jerry-root-container/  ...

# If truly missing, the exercise can be reset:
$ gymctl start exercise-name  # Copies files again
```

### View Logs (Docker Compose mode only)

```bash
make logs
```

## Requirements

- Docker 20.10+
- Docker Compose 2.0+
- Make (optional, for convenience commands)
- VS Code with Dev Containers extension (for devcontainer workflow)

---

## Quick Reference Card

### Essential Commands

| Command | Where to Run | Description |
|---------|-------------|-------------|
| `gymctl list` | Codespace | List all available exercises |
| `gymctl start <name>` | Codespace | Start exercise (enters interactive shell) |
| `gymctl shell` | Codespace | Enter interactive gym environment |
| `gymctl check` | Inside gym | Validate your solution |
| `gymctl hint` | Inside gym | Get a hint |
| `gymctl reset` | Inside gym | Reset current exercise |
| `gymctl status` | Anywhere | View your progress |
| `exit` | Inside gym | Return to Codespace |

### Typical Workflow

```
Codespace → gymctl start → Gym Container → Work → Check → Exit → Repeat
    ↓           ↓              ↓             ↓       ↓       ↓
  Terminal   Interactive    Edit Files   docker    gymctl  Back to
             Shell Mode     & Code       commands  check   Codespace
```

### File Locations

- **Exercise files**: `~/.gym/workdir/<exercise-name>/`
- **Progress tracking**: `~/.gym/progress.yaml`
- **Current exercise**: `~/.gym/current`

### Tips

- 💡 Files persist even when you exit containers
- 💡 You can edit files from VS Code in Codespace AND from inside the gym container
- 💡 Docker commands work inside the gym (Docker-in-Docker)
- 💡 Use `gymctl describe <exercise>` to re-read instructions
- 💡 Use multiple hints if you're stuck - they get progressively more detailed

---

## Contributing

Want to add more exercises? See [CONTRIBUTING.md](CONTRIBUTING.md) for details on creating new scenarios.

## License

MIT License - See [LICENSE](LICENSE) for details.
