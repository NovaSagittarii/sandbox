FROM node:24-trixie-slim

RUN apt update
RUN apt install -y bash curl
RUN apt install -y git fish openssh-client openssl
RUN apt install -y python3

RUN chsh -s /usr/bin/fish node

WORKDIR /workspace

RUN chown node:node /workspace

USER node

RUN mkdir -p ~/.config/fish && touch ~/.config/fish/config.fish
RUN bash -o pipefail -c "curl -fsSL https://opencode.ai/install | bash"
