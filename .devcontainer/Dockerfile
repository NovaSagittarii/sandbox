FROM node:24-trixie-slim

RUN apt update
RUN apt install -y bash curl
RUN apt install -y git fish openssh-client openssl
RUN apt install -y python3

RUN chsh -s /usr/bin/fish node
RUN npm install -g gsd-pi@latest

WORKDIR /workspace

RUN chown node:node /workspace

USER node

RUN mkdir -p ~/.config/fish && touch ~/.config/fish/config.fish
ENV PATH="~/.local/bin:$PATH"

RUN bash -o pipefail -c "curl -fsSL https://opencode.ai/install | bash"

RUN bash -o pipefail -c "curl -fsSL https://claude.ai/install.sh | bash"
RUN bash -o pipefail -c "curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh"
RUN bash -c "rtk init -g"
RUN bash -o pipefail -c "curl -LsSf https://astral.sh/uv/install.sh | sh"
# RUN bash -c "uvx mempalace"
# RUN claude plugin marketplace add milla-jovovich/mempalace
# RUN claude plugin install --scope user mempalace
