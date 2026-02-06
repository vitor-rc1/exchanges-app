#!/bin/sh
set -e

echo "CI setup Started"

echo "Installing Brew dependencies..."
brew bundle install
echo "✅ Brew dependencies installed."

echo "Checking for Tuist..."
if command -v tuist >/dev/null 2>&1; then
    echo "✅ Tuist found."
else
    echo "⚠️ Tuist not found. Installing Tuist..."
fi

echo "Installing Bundles..."
bundle install
echo "✅ Bundles installed."

echo "Selecting Xcode..."
xcodes select 26.2.0
echo "✅ Xcode selected."

echo "Installing Project dependecies..."
tuist install
echo "✅ Project dependencies installed."

echo "✅ CI setup completed."