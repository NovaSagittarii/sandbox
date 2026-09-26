#!/usr/bin/env bash
set -euo pipefail

echo "alias drop='su - node'" >> ~/.bashrc

HOME="/home/node"

setup_tmpfs_links() {
    local persistent_dir="$1"
    local tmpfs_dir="$2"
    shift 2

    if [[ $# -eq 0 ]]; then
        echo "Usage: setup_tmpfs_links <persistent-dir> <tmpfs-dir> <path>..." >&2
        return 1
    fi

    mkdir -p "$persistent_dir"
    mkdir -p "$tmpfs_dir"

    local path persistent_path tmpfs_path

    for path in "$@"; do
        persistent_path="$persistent_dir/$path"
        tmpfs_path="$tmpfs_dir/$path"

        if [[ "$path" == */ ]]; then
            # Directory
            path="${path%/}"
            persistent_path="$persistent_dir/$path"
            tmpfs_path="$tmpfs_dir/$path"

            mkdir -p "$tmpfs_path"
        else
            # File
            mkdir -p "$(dirname "$tmpfs_path")"
        fi

        # Already the desired symlink.
        if [[ -L "$persistent_path" ]]; then
            local target
            target="$(readlink "$persistent_path")"

            if [[ "$target" == "$tmpfs_path" ]]; then
                continue
            fi

            echo "ERROR: $persistent_path already points to $target" >&2
            return 1
        fi

        # Don't overwrite persistent data.
        if [[ -e "$persistent_path" ]]; then
            echo "ERROR: $persistent_path already exists" >&2
            return 1
        fi

        ln -s "$tmpfs_path" "$persistent_path"

        echo "tmpfs: $persistent_path -> $tmpfs_path"
    done
}

CLAUDE_TMPFS_PATHS=(
    # .last-cleanup
    # CLAUDE.md
    # RTK.md
    # backups/
    cache/
    daemon/
    daemon.lock
    daemon.log
    daemon.status.json
    downloads/
    file-history/
    # history.jsonl
    # jobs/  # mounted separately
    # plugins/
    # projects/
    session-env/
    # sessions/
    # settings.json
    shell-snapshots/
    tasks/
)
setup_tmpfs_links ~/.claude ~/.tmp/.claude "${CLAUDE_TMPFS_PATHS[@]}"
setup_tmpfs_links ~/.claude ~/.tmp/.claude-jobs jobs/

chown -R -h node:node /workspace
chown -R -h node:node ~
# chown -R node:node ~/.tmp
# chown -R -h node:node ~/.claude

exec "$@"
