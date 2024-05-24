# Start from the Python 3.10 image
FROM python:3.12-alpine AS base

# Update the list of available packages
RUN apk update

# Install Zsh, curl, git, and sudo
RUN apk add zsh curl git sudo

# Create a new user "alx" and switch to that user
RUN adduser -D alx && echo "alx:alx" | chpasswd && addgroup alx wheel

# Change the default shell for "alx" to Zsh
RUN sed -i -e "s/bin\/ash/bin\/zsh/" /etc/passwd

# set 'admin' as password for alx
RUN echo 'alx:admin' | chpasswd

# Give alx sudo privileges
RUN echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel

USER root
RUN mkdir -p /home/alx/.vscode-server/extensions && chown -R alx:alx /home/alx/.vscode-server
USER alx

USER alx
WORKDIR /home/alx

# Create a directory for Zsh history and the history file
RUN mkdir /home/alx/zsh_history && touch /home/alx/zsh_history/.zsh_history

# Install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true

# Define ZSH_CUSTOM
ENV ZSH_CUSTOM /home/alx/.oh-my-zsh/custom

# Clone zsh-completions repository and copy completions to the right directory
RUN git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# Add git to the list of oh-my-zsh plugins
RUN echo "plugins=(git)" >> /home/alx/.zshrc

# Enable zsh-completions
RUN echo "plugins=(git zsh-autosuggestions zsh-syntax-highlighting)" >> /home/alx/.zshrc
RUN echo "source \$ZSH/oh-my-zsh.sh" >> /home/alx/.zshrc

# Ensure Zsh history is saved correctly
RUN echo "setopt INC_APPEND_HISTORY" >> /home/alx/.zshrc
RUN echo "HISTFILE=/home/alx/zsh_history/.zsh_history" >> /home/alx/.zshrc

# Set the working directory in the container to /code
WORKDIR /code

# Add the current directory contents into the container at /code
ADD . /code

# Make port 8000 available to the world outside this container
EXPOSE 8000

CMD ["tail", "-f", "/dev/null"]