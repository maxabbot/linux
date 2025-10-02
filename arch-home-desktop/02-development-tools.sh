#!/bin/bash
# Development tools for data/software engineering
# Includes programming languages, databases, containers, and development tools

set -e

echo "=========================================="
echo "Installing Development Tools"
echo "=========================================="

# Programming Languages & Runtimes
echo "Installing programming languages and runtimes..."
sudo pacman -S --noconfirm --needed \
    python \
    python-pip \
    python-virtualenv \
    python-numpy \
    python-pandas \
    python-matplotlib \
    python-scipy \
    python-scikit-learn \
    jupyter-notebook \
    nodejs \
    npm \
    go \
    rust \
    jdk-openjdk \
    gcc \
    clang \
    cmake \
    make

# Data Engineering & Analytics Tools
echo "Installing data engineering tools..."
sudo pacman -S --noconfirm --needed \
    postgresql \
    mariadb \
    redis \
    sqlite

# Install Python data science packages
echo "Installing Python data science packages..."
pip install --user \
    pandas \
    numpy \
    matplotlib \
    seaborn \
    scikit-learn \
    tensorflow \
    pytorch \
    jupyter \
    jupyterlab \
    sqlalchemy \
    psycopg2-binary

# Container & Virtualization Tools
echo "Installing Docker and container tools..."
sudo pacman -S --noconfirm --needed \
    docker \
    docker-compose \
    kubectl

# Enable Docker service
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

# Development IDEs & Editors
echo "Installing IDEs and code editors..."
yay -S --noconfirm --needed \
    visual-studio-code-bin \
    pycharm-community-edition \
    intellij-idea-community-edition

# Version Control & Git Tools
echo "Installing Git tools..."
sudo pacman -S --noconfirm --needed \
    git \
    git-lfs \
    github-cli \
    tig

# API Testing & Development Tools
echo "Installing API and development tools..."
yay -S --noconfirm --needed \
    postman-bin \
    dbeaver

echo "Development tools installation complete!"
echo "Note: You may need to log out and back in for Docker group changes to take effect."
