# Start from the Python 3.x image
FROM python:3.12-slim AS base

# Update the list of available packages
RUN apt-get update -y
RUN apt update

# Install Zsh, curl and git
RUN apt-get install -y zsh curl git sudo

# only if you need to install packages that require compilation - jupyter notebook
# RUN apk add gcc musl-dev python3-dev linux-headers

# Create a new user "alx" and switch to that user
RUN useradd -m alx && echo "alx:alx" | chpasswd && adduser alx sudo

# Change the default shell for "alx" to Zsh
RUN chsh -s /bin/zsh alx

# set 'admin' as password for alx
RUN echo 'alx:admin' | chpasswd

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

# Install virtualenv
RUN pip install virtualenv

# Make port 8000 available to the world outside this container
EXPOSE 8000

CMD ["tail", "-f", "/dev/null"]