# Code Architecture — Chip Heist

Status: **proposal v0.1 (2026-11-08), not locked.** Open forks are listed at
the bottom. Nothing here gets built until the user approves.

Principles: the server is authoritative, clients only render and send
requests, `--!strict` everywhere, and one module per responsibility.

## Layout

```
src/
├─ shared/                      ReplicatedStorage.Shared
│  ├─ Config.luau               (exists) global tunables
│  ├─ Types.luau                shared types: StageId, RoleId, NpcState, SceneId…
│  ├─ Remotes.luau              creates/gets every RemoteEvent/Function by name
│  ├─ Roles.luau                role table: id, personality, tool, voice preset
│  ├─ Stages.luau               stage list + objectives (Ground, Basement, Attic, Chase, DataCenter)
│  ├─ Difficulty.luau           Easy/Medium/Hard × player-count scaling (story bible table)
│  ├─ Loot.luau                 loot item defs: value, weight, carriers needed
│  ├─ Dialogue/                 line tables per scene: { id, speaker, text, audioId, duration }
│  │  └─ Scene01.luau …
│  └─ Util/                     Signal, Trove/Janitor-style cleanup, Spline (road path math)
│
├─ server/                      ServerScriptService.Server
│  ├─ init.server.luau          (exists) boots the services in order
│  ├─ GameState.luau            the run's state machine: Lobby → Briefing → Stage1 → … → Ending
│  ├─ StageService.luau         loads a stage, tracks objectives, fires stage transitions
│  ├─ RoleService.luau          role pick at the briefing, hands out tools, fills empty roles
│  ├─ CutsceneService.luau      starts scenes for everyone (sceneId + server time), skip votes
│  ├─ LootService.luau          pick-up / carry / drop / bank, 2-person carries, validates distance
│  ├─ NoiseService.luau         noise events (cat knocks a pot, a player runs) → NPC hearing
│  ├─ DownedService.luau        Ban Hammer → #timeout, "appeal" revive
│  ├─ Npc/
│  │  ├─ NpcController.luau     shared base: state machine, PathfindingService, vision cone, hearing
│  │  ├─ Admin.luau             Sit/Game → Snack run → Sleep → Suspicious → Alerted (hunt)
│  │  ├─ Mom.luau               ground-floor patrol, "DINNER!" timer that calls The Admin up
│  │  └─ Cat.luau               wanders between floors, knocks props → NoiseService
│  ├─ Chase/
│  │  ├─ ChaseService.luau      autopilot phase → malfunction → manual, win/lose at the crossing
│  │  ├─ RobotaxiServer.luau    seats, network ownership to the driver, speed sanity checks
│  │  ├─ MopedAI.luau           The Admin follows the road spline with rubber-banding
│  │  └─ TrainCrossing.luau     train timing, booms/bells, crossing hit test
│  └─ VoiceService.luau         server picks a line and tells clients what to play (keeps all in sync)
│
└─ client/                      StarterPlayerScripts.Client
   ├─ init.client.luau          (exists) boots the controllers
   ├─ CutscenePlayer.luau       camera shots from Workspace.Cutscenes.<Scene> parts, letterbox, skip button
   ├─ VoicePlayer.luau          plays Kokoro clips (Sound), subtitles, The Admin's glitch effect
   ├─ Hud/                      objectives, loot meter, role tool UI, detection meter, #timeout screen
   ├─ RoleTools/                Lookout tablet, Hacker laptop minigames, Carrier, Distraction phone
   ├─ RobotaxiClient.luau       driver input (only when you own the car), camera, autopilot glitch FX
   ├─ Atmosphere.luau           rain emitter on the camera, quality settings (mobile drops effects)
   └─ StreamingHelper.luau      waits for streamed parts before using them
```

## How the systems talk

- **Stages:** `GameState` owns the run. `StageService` reads `Stages.luau`,
  and when the objectives are met it asks `CutsceneService` for the
  in-between scene, then moves to the next stage.
- **Cutscenes:** the server fires `PlayCutscene(sceneId, startTime)` to all
  clients. Each client plays the camera locally. When the scene is over (or
  the skip vote passes), the server teleports or unfreezes characters.
  Shots are Parts in `Workspace.Cutscenes` with `Duration`, `Easing` and
  `FOV` attributes, so they're edited in Studio.
- **Voice (Kokoro):** clips are generated offline, uploaded as audio, and
  their IDs are stored in `Dialogue/*.luau`. `VoiceService` (server) chooses
  the line, and `VoicePlayer` (client) plays it with subtitles. The Admin's
  glitch is done in-engine with `DistortionSoundEffect`, `PitchShift` and
  random stutters.
- **NPCs:** all AI runs on the server. Vision is a cone and a raycast;
  hearing comes from `NoiseService`. Difficulty scales the vision range,
  hearing radius and snack-run timer.
- **Chase:** the driver's client owns the Robotaxi physics (smooth
  steering). The server checks speed and position and owns the moped, the
  train and the result.
