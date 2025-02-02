# Set the shell to use

set shell := ["nu", "-c"]

# Set path to virtual environment's python

venv_dir := ".venv"
python := venv_dir + if os_family() == "windows" { "/Scripts/python.exe" } else { "/bin/python3" }

# Display system information
system-info:
    @echo "CPU architecture: {{ arch() }}"
    @echo "Operating system type: {{ os_family() }}"
    @echo "Operating system: {{ os() }}"

# Clean venv
clean:
    rm -rf .venv

# Setup environment
get-started: pre-install venv

# Update project software versions in requirements
update-reqs:
    uv lock
    uv run pre-commit autoupdate

# create virtual environment
venv:
    uv sync
    uv tool install pre-commit
    uv run pre-commit install

activate-venv:
    uv shell

# launch jupyter lab
lab:
    uv run jupyter lab

# Preview the handbook
preview-docs:
    quarto preview

# Build the handbook
build-docs:
    quarto render

publish:
    quarto publish netlify

# Lint python code
lint-py:
    uv run ruff check

# Format python code
fmt-python:
    uv run ruff format

# Format a single python file, "f"
fmt-py f:
    uv run ruff format {{ f }}

# Format all markdown and config files
fmt-markdown:
    uv run mdformat .

# Format a single markdown file, "f"
fmt-md f:
    uv run mdformat {{ f }}

# Check format of all markdown files
fmt-check-markdown:
    uv run mdformat --check .

fmt-all: lint-py fmt-python fmt-markdown

# Run pre-commit hooks
pre-commit-run:
    pre-commit run

[windows]
pre-install:
    winget install Casey.Just astral-sh.uv GitHub.cli Posit.Quarto errata-ai.Vale

[linux]
pre-install:
    brew install just uv gh vale
    curl -sfL https://github.com/quarto-dev/quarto-cli/releases/download/v1.5.54/quarto-1.5.54-linux-amd64.deb  | sudo apt install ./quarto-1.5.54-linux-amd64.deb
    rm quarto-1.5.54-linux-amd64.deb

[macos]
pre-install:
    brew install just uv gh vale
    brew install --cask quarto
