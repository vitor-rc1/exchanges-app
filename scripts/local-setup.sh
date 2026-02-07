#!/bin/sh

echo "✅ Local setup started."

if command -v brew >/dev/null 2>&1; then
    echo "✅ Homebrew found."
else
    echo "⚠️ Homebrew not found. Please install manually following:"
    echo "https://brew.sh/"
    exit 1
fi

if command -v gem >/dev/null 2>&1; then
    echo "✅ RubyGems found."
else
    echo "⚠️ RubyGems not found. Please install manually."
    exit 1
fi

echo "Installing Brew dependencies..."
brew bundle install
echo "✅ Brew dependencies installed."

echo "Installing Bundles..."
bundle install --with danger
echo "✅ Bundles installed."

echo "✅ Local setup completed."