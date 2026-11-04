# Game 1 — Roblox project

## Repo rules
- **Commit everything in small commits.** One logical change per commit
  (e.g. one module, one config file, one fix). Use conventional prefixes:
  `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`.
- **Keep `SESSION_LOG.md` updated in every chat.** Append an entry for each
  session: what was asked, what was done (with commit hashes), decisions and
  who made them, open questions.
- **Ask before deciding.** Before setting any design/story/tech decision,
  ask the user with a list of options to choose from. Don't pick silently.
- Files in `src/` are the source of truth. Never edit scripts only inside
  Studio — they will be overwritten by Rojo sync and lost from git.

## Workflow (Claude + Roblox Studio)
- Code lives on disk and syncs into Studio with **Rojo** (`rojo serve`
  + the Rojo Studio plugin → Connect).
- Claude uses the **Roblox Studio MCP** to inspect the live place, run
  playtests, read console output, and build/adjust world geometry.
- World/building work done in Studio (parts, terrain, models) is not synced
  back by Rojo. Save the place file (`*.rbxl`, git-ignored) or export models
  into `assets/` as `.rbxm` when they need to be versioned.

## Layout
| Path          | Syncs to                                         |
|---------------|--------------------------------------------------|
| `src/shared`  | `ReplicatedStorage.Shared` (ModuleScripts)       |
| `src/server`  | `ServerScriptService.Server`                     |
| `src/client`  | `StarterPlayer.StarterPlayerScripts.Client`      |

File naming (Rojo): `*.server.luau` = Script, `*.client.luau` = LocalScript,
`*.luau` = ModuleScript, `init.*.luau` makes the folder itself that script.

## Code style
- Luau with `--!strict` at the top of every file.
- Format with StyLua (`stylua src`), lint with Selene (`selene src`).
- Server is authoritative; never trust client input.
