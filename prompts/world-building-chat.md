# Prompt: World-building & architecture chat

Copy everything below the line into a new chat opened in this repo.

---

You're joining **Chip Heist**, a realistic-looking Roblox co-op
stealth-horror heist game (2–4 players). Before doing anything, read
`CLAUDE.md`, `SESSION_LOG.md`, `story/story-bible.md`,
`story/script-draft.md` and `story/research/setting-and-scenes.md`.
Follow the repo rules: small commits, update `SESSION_LOG.md` at the end
of every chat, and **ask me with a list of options before deciding
anything**. Don't pick silently.

Blender is installed and connected through the Blender MCP. Roblox Studio
is connected through the Roblox Studio MCP.

## Goal of this chat
Plan the **world and game architecture** and build a first blockout in
Roblox Studio. Use the files in `3d assests/` both as **reference photos**
and as **source models** to adapt in Blender.

## The world (decided by me)
- **Realistic look:** Future lighting, PBR materials, fog and atmosphere.
- The Admin's **house** and the ClosedAI **"factory"** (the data center
  where the heist ends) are **a few km apart**.
- They're joined by a **highway through dense forest** on both sides,
  like the road photos. The road carries the Robotaxi-vs-moped chase
  (scenes 09–10) and needs a **train crossing** along the way.
- The **factory is also deep in the forest**, aesthetic and realistic,
  like the factory photo.

## What's in `3d assests/` (checked 2026-11-08)
**Reference photos (inspiration only, don't import):**
| File | Shows |
|---|---|
| `house location.jpg` | A modern single-storey cabin: dark metal gable roof, vertical timber cladding, big warm-lit glass front, wooden deck on a stone retaining wall, a misty conifer mountainside |
| `factory location.jpg` | A long translucent polycarbonate factory with climbing plants up the facade, a dark wood/metal base, at dusk in a pine and birch forest. It has a real company logo (FREYR), so **don't copy the logo** |
| `game environment along with the roadd.jpg` | A wet two-lane mountain road with a concrete block barrier, conifer forest and low clouds |
| `forest creation along with the roadf.jpg` | A foggy winding road with metal guardrails and dense broadleaf forest |

**3D models (can be used and adapted):**
| Folder | Contents | Notes |
|---|---|---|
| `ffd249235b0593b701908e747588d70f/` | **Log House N090324**: `.obj` (74 MB, ~750k faces), `.3ds`, `.gsm`, `.mtl`, PNG textures and a preview `.jpg` | From archibase.net. A Russian-style log house that **doesn't match the cabin reference**. Far too heavy for Roblox. Check archibase's license |
| `73d05eb6e5b5ba2d2a0d7fd8100d813a/` | **Building factory N190616**: `.3ds` (4.9 MB), `.gsm` (ArchiCAD), marble/concrete/wall texture JPGs | From archibase.net. No preview image, so open it in Blender to see it. `.3ds` needs Blender's 3DS importer (an extension in Blender 4.x). Check the license |
| `tesla-roadster-2020/` | The car: `source/tesla roadster 2020.zip` (FBX + textures) and a `textures/` folder | Sketchfab, CC-BY by metarex.4d. Credit needed. Becomes the **ClosedAI Robotaxi**: **remove all Tesla badges** and change the shape |
| `tesla-bot/`, `tesla-bot-female/` | Humanoid robot FBX + textures | Not in the heist story yet. Ask me what they're for (ClosedAI security bots? data-center workers?). Remove Tesla branding. Check the license |

## Gaps I already know about (ask me how to resolve each)
1. The cabin reference is **single storey**, but the heist needs **Ground
   + Basement + Attic** (see the story bible's stage list and the ASCII map
   in `setting-and-scenes.md`).
2. The log-house model doesn't match the cabin reference. Adapt it,
   rebuild the cabin from scratch in Blender, or mix the two?
3. The story bible's town ("Abilené Heights, Texas") no longer fits misty
   mountain forest. A new name and region are needed.
4. The road photos are **two-lane mountain roads**, not a multi-lane
   highway. Confirm which one I mean.
5. `3d assests/` is about 320 MB, untracked, and misspelled (`CLAUDE.md`
   says `assets/`). Ask whether to rename it, gitignore the raw files, or
   use Git LFS. **Don't commit the raw models to git without asking.**

## Roblox constraints to plan around
- MeshParts allow about **20k triangles each**. Decimate and split every
  model in Blender (body, roof, windows, props) and export FBX for Roblox's
  3D Importer.
- Textures max out at **1024×1024**. Use `SurfaceAppearance` for PBR
  (color, normal, roughness, metalness).
- **Scale:** 1 stud ≈ 0.28 m, so 3 km ≈ 10,700 studs. Use
  **StreamingEnabled** and low-detail distant forest (terrain grass plus
  instanced tree meshes, with impostors or LOD far away).
- The chase lasts about 1–2 minutes. At roughly 100 km/h a 3 km road takes
  about 1.8 minutes, so a few km fits. Confirm the exact length with me.
- Realism: `Lighting.Technology = Future`, `Atmosphere` (density and haze
  for the valley fog), terrain with `MaterialVariant`s for wet asphalt,
  moss and rock, plus rain and wet-road reflections.
- Real logos are banned by the story bible's parody rules (no Tesla, no
  FREYR). Keep a credits file for every CC-BY asset.

## What I want from you, in order
1. Read the files above and **open each 3D model in Blender** through the
   MCP. Report its polycount, scale, materials, and how close it is to the
   reference photos. Take viewport screenshots where useful.
2. Ask me about the gaps above, with options for each.
3. Write a plan in `docs/world-plan.md`:
   - a map layout (house → highway → train crossing → factory, with
     distances in studs)
   - an asset list: for each item, whether we reuse a model, adapt one,
     or build new
   - the Blender → Roblox pipeline (decimate, UV, bake, export)
   - a lighting and atmosphere recipe
   - a streaming/performance budget
   - build order
4. Propose the **game code architecture**: which modules go in
   `src/server`, `src/client` and `src/shared`. It needs to cover stages,
   the cutscene system, NPC AI for The Admin, Mom and the cat, the role
   system, the vehicle chase and Kokoro voice playback. Ask before
   locking anything in.
5. Only after I approve, start the **blockout** in Roblox Studio (simple
   parts and terrain for the road, house plot and factory plot), then
   bring in the first Blender-adapted model.
