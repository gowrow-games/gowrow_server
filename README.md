# Gowrow Dedicated Server for Godot

This is an Addon for Godot that provides a simple dedicated server setup and some networking examples.

## Installation

Until I upload this plugin to Godot's AssetLib, the plugin must be downloaded from the Releases page and installed manually.

If you prefer an automated method, here is the script I use.

```cmd
@echo off
REM Configurable variables
set "REPO=gowrow-games/godot_dedicated_server"
set "ASSET_NAME=gowrow_dedicated_server.zip"
set "DEST_DIR=Godot\addons"

REM Create a temporary directory
set "tmp_dir=%TEMP%\gowrow_tmp_%RANDOM%"
mkdir "%tmp_dir%"
echo Using temp directory: %tmp_dir%

REM Get the download URL for the latest release asset
echo Fetching latest release info...

set "url=https://github.com/%REPO%/releases/download/latest/%ASSET_NAME%"

echo Downloading %url%...
curl -L "%url%" -o "%tmp_dir%\%ASSET_NAME%"

echo Unzipping to %DEST_DIR%...
mkdir "%DEST_DIR%"
powershell -Command "Expand-Archive -Force '%tmp_dir%\%ASSET_NAME%' '%DEST_DIR%'"

echo Done! Extracted to %DEST_DIR%.
```

## Planned Features

- 🧩 Clean server/client project structure
- 🖥️ Dedicated server entrypoint
- 🧠 Headless-mode optimized settings
- 📜 Launch scripts for local development
- 📁 Easy to clone and customize

