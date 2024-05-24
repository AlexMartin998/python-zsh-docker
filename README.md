# Python-Zsh Docker Environment

This repository contains a Dockerfile that sets up a Python 3.10 environment with Zsh shell, curl, git, and a user named 'alx'. It's a great starting point for Python development with the convenience of Zsh and its plugins.

## Features

- Python 3.10: Latest Python version for your development needs.
- Zsh: A powerful shell that's both interactive and scriptable.
- User 'alx': A dedicated user for your development activities.
- VS Code Server: Ready for remote development with VS Code.
- oh-my-zsh: A community-driven framework for managing your Zsh configuration.

## How to Build

To build and run the Docker environment, navigate to the directory containing the `docker-compose.yml` file and run:

```sh
docker-compose up --build
```

# Usage

Once the container is running, you can start developing with Python, use git for version control, and enjoy the features of Zsh shell. The 'alx' user has sudo privileges, so you can install any additional packages you might need.

The Docker Compose configuration also sets up volumes for persisting your Zsh history and VS Code extensions between container runs.
