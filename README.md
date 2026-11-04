# Game 1

Roblox game built with [Rojo](https://rojo.space) and Roblox Studio.

## Setup (once)
1. Install [Rokit](https://github.com/rojo-rbx/rokit):
   `curl -sSf https://raw.githubusercontent.com/rojo-rbx/rokit/main/scripts/install.sh | bash`
2. In this folder: `rokit install` (installs rojo, stylua, selene).
3. Install the Rojo Studio plugin: `rojo plugin install`.

## Develop
1. `rojo serve`
2. Open Roblox Studio → new Baseplate → Plugins → Rojo → **Connect**.
3. Edit files in `src/`; changes appear in Studio live.

Build a place file: `rojo build -o game-1.rbxl`
