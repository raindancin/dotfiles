#!/bin/bash
# ============================================================
# Personal macOS setup (Apple Silicon). Safe to re-run.
#
# Fresh Mac, only Terminal.app, nothing installed yet:
#   curl -fsSLO https://raw.githubusercontent.com/raindancin/dotfiles/main/setup.sh
#   bash setup.sh
# (swap "main" for your branch name if it differs)
#
# WHERE TO ADD THINGS
#   a program or app          -> Brewfile
#   a config to link          -> the link lines in step 6
#   a Rust component         -> RUST_COMPONENTS below
#
# A failed step does not stop the script. Failures are listed at the end.
# ============================================================

set -u

DOTFILES_REPO="https://github.com/raindancin/dotfiles"
DOTFILES="$HOME/dotfiles"
RUST_COMPONENTS="rustfmt clippy rust-analyzer"

FAILED=()

# run <command...>: if it fails, remember it and keep going.
run() { "$@" || FAILED+=("$*"); }

# link <path in the repo> <where it should appear>
link() {
    mkdir -p "$(dirname "$2")"
    # A real file or folder already there gets moved aside, not overwritten.
    if [ -e "$2" ] && [ ! -L "$2" ]; then mv "$2" "$2.bak"; fi
    ln -sfn "$DOTFILES/$1" "$2"
}

# ---- 1. Command Line Tools (gives you git, clang, make) ----
echo "==> 1. Command Line Tools"
if ! xcode-select -p >/dev/null 2>&1; then
    xcode-select --install
    echo "Finish the install popup. Waiting..."
    until xcode-select -p >/dev/null 2>&1; do sleep 5; done
fi

# ---- 2. Dotfiles ----
echo "==> 2. Dotfiles"
if [ -d "$DOTFILES/.git" ]; then
    git -C "$DOTFILES" pull --ff-only || echo "Could not update dotfiles, using what is there."
else
    git clone "$DOTFILES_REPO" "$DOTFILES" || { echo "Clone failed. Nothing to set up from."; exit 1; }
fi

# ---- 3. Homebrew ----
echo "==> 3. Homebrew"
if [ ! -x /opt/homebrew/bin/brew ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
[ -x /opt/homebrew/bin/brew ] || { echo "Homebrew is not installed. Stopping."; exit 1; }
eval "$(/opt/homebrew/bin/brew shellenv)"   # puts brew on PATH for this script
brew analytics off

# ---- 4. Programs and apps (the Brewfile is the list) ----
# brew bundle keeps going past a bad entry and reports it at the end.
echo "==> 4. Brewfile"
run brew bundle --file="$DOTFILES/Brewfile"

# ---- 5. Rust ----
echo "==> 5. Rust"
RUSTUP_BIN="$(brew --prefix rustup)/bin"
export PATH="$RUSTUP_BIN:$PATH"
run rustup default stable
for c in $RUST_COMPONENTS; do
    run rustup component add "$c"
done

# ---- 5b. Node (fnm manages versions; this installs the first one) ----
eval "$(fnm env --shell bash)"
if ! fnm list | grep -q 'v[0-9]'; then
    run fnm install --lts
    run fnm default lts-latest
fi

# ---- 6. Configs and fonts ----
echo "==> 6. Configs and fonts"
link fish/config.fish          "$HOME/.config/fish/config.fish"
link starship/starship.toml    "$HOME/.config/starship.toml"
link kitty                     "$HOME/.config/kitty"
link nvim                      "$HOME/.config/nvim"
link aerospace/aerospace.toml  "$HOME/.config/aerospace/aerospace.toml"

mkdir -p "$HOME/Library/Fonts"
for f in "$DOTFILES"/fonts/*.ttf; do
    [ -e "$f" ] || continue
    [ -f "$HOME/Library/Fonts/$(basename "$f")" ] || run cp "$f" "$HOME/Library/Fonts/"
done

# ---- 7. Fish as the login shell ----
echo "==> 7. Login shell"
FISH=/opt/homebrew/bin/fish
grep -qxF "$FISH" /etc/shells || echo "$FISH" | sudo tee -a /etc/shells >/dev/null
[ "$SHELL" = "$FISH" ] || run chsh -s "$FISH"

# ---- Done ----
echo
if [ "${#FAILED[@]}" -gt 0 ]; then
    echo "These failed (fix the cause, then re-run this script):"
    for f in "${FAILED[@]}"; do echo "  - $f"; done
else
    echo "Done. Nothing failed."
fi
echo
echo "Next: open kitty, then nvim once (it installs plugins and LSPs)."
echo "Grant Accessibility to AeroSpace and AltTab (plus Screen Recording for AltTab)."
