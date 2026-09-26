FROM node:24-trixie-slim

RUN apt update
RUN apt install -y bash curl vim
RUN apt install -y git fish openssh-client openssl
RUN apt install -y python3

RUN chsh -s /usr/bin/fish node
RUN npm install -g gsd-pi@latest

WORKDIR /workspace

RUN chown node:node /workspace

USER node
ENV PATH="~/.local/bin:$PATH"

RUN bash -o pipefail -c "curl -LsSf https://astral.sh/uv/install.sh | sh"
RUN mkdir -p ~/.config/fish && touch ~/.config/fish/config.fish
RUN echo "fish_add_path $HOME/.local/bin" >> ~/.config/fish/config.fish

RUN bash -o pipefail -c "curl -fsSL https://opencode.ai/install | bash"
RUN bash -o pipefail -c "curl -fsSL https://chatgpt.com/codex/install.sh | sh"
RUN bash -o pipefail -c "curl -fsSL https://claude.ai/install.sh | bash"

RUN bash -o pipefail -c "curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh"
RUN bash -c "rtk init -g"

USER root
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
