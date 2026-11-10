# Session Log

Running log of everything done on this project, across all chats/sessions.
Newest entry at the bottom. Each entry: date, what was asked, what was done,
decisions made (and who made them), open questions.

---

## 2026-11-04 — Session 1: Story kickoff

**Asked:** Build an end-to-end co-op (2–4 players) Roblox heist parody:
players are "Sam Altman" stealing RAM/GPU chips from a Discord mod's house
(meme: mod sits, sleeps, eats). Inspired by an Altman interview about
people's chips going to data centers. Needs cutscenes / scene cuts. Create a
folder for all scripts (scenes, dialogue). Research first with separate agents.

**Done:**
- Created `story/` with `research/`, `scenes/`, `dialogue/` and a scene
  template in `story/README.md` (commit `a4d568b`).
- Launched 3 research agents in parallel:
  - Sam Altman: verify the quote + RAM shortage context, persona, gags,
    Roblox policy on real people → `story/research/sam-altman.md`
  - Discord mod meme: tropes, NPC design, barks, stealth AI ideas
    → `story/research/discord-mod.md`
  - Setting & scenes: house location options, layout, full scene list,
    co-op roles, Roblox cutscene tech → `story/research/setting-and-scenes.md`
- Added this session log + a CLAUDE.md rule to keep it updated.

- Research finished and committed by the agents:
  `557ea5c` discord-mod.md, `65aac2f` setting-and-scenes.md,
  `6bb0782` sam-altman.md.
  - The quote is real but stretched: on the *Cheeky Pint* podcast (viral
    late Oct 2026) Altman called it "quite terrible" for everyone to hold
    scarce DRAM in home PCs. He never said to take people's RAM.
  - Roblox policy: use a parody name, no real face/photos, no real logos
    (OpenAI, Discord, Nvidia), add a "parody, not affiliated" line.

**Decisions (user):**
- Rule: Claude must ask with a list of options before any design decision.
- Tone: **comedy stealth-horror** (the mod is a real threat, jump scares).
- Scope: **one house, 3 floors**, ~20 min, a cutscene between stages.
- Art style: **semi-realistic** (PBR materials, realistic lighting).

- Sam's name: **Scam Altman** (user chose this over the recommended
  "Sam Altmann" after being told it carries the highest report risk).
- Location: **Abilené Heights, Texas**, a fictional town next to an AI
  data-center construction site (escape route + delivery point).
- Mod NPC name: **The Admin** (horror-monster framing).
- Sam's look: **fully semi-realistic** (user chose this after being told it
  carries the highest moderation risk).

**Risk noted:** the name and look together raise the chance of a Roblox
impersonation report. Mitigations still open: "parody, not affiliated"
disclaimer, no real logos or photos, and keep his real name out of the
title, thumbnail and tags.

- Stage order: **Ground → Basement → Attic** (the run ends in the attic and
  the crew escapes through the roof window).
- Company: **ClosedAI**.
- Extra NPCs: **both The Admin's mom and a cat** are in the script.
- Endings (user's own design, replacing the progress-bar gag):
  - **Main story ending:** after the attic window escape the crew jumps into
    their car (user said "Tesla"). The Admin chases them in his "helix".
    The road crosses train tracks with a train coming. If the crew is fast
    enough they cross and the train hits The Admin. If they're too slow he
    catches them. Then they reach the AI data center and find out "he uses
    our GPU better than Scam Altman".
  - Also kept: Fail "You have been BANNED", Secret "Open Source", and the
    post-credits gag.

- Clarified (user):
  - The Admin's "helix" is a **moped** he barely fits on (played for laughs).
  - The crew's car is a **ClosedAI Robotaxi**.
  - Data-center reveal: **the player plugs the stolen GPU in**, and on screen
    ClosedAI's AI gets taken down by **The Admin's own AI** that was still
    on the GPU.
  - **Secret "Open Source" ending dropped.** Endings are now: Success
    (story ending above), Fail "You have been BANNED", and Post-credits gag.
- Roles: **4 roles with personalities and their own lines**:
  Lookout = Paranoid Scam, Hacker = Lowercase Scam, Carrier = Hype Scam,
  Distraction = Calm Podcast Scam.
- Voice: **every character speaks in a cheerful AI-assistant voice**. The
  Admin is peppy until he wakes, then glitches into a distorted voice.
- Wrote `story/story-bible.md` with only the decided items, plus a
  13-scene list (01–11, Fail, Post-credits) and open questions.

**Open questions:** how the chase plays (who drives, what passengers do),
what the AI-vs-AI screen in scene 11 looks like, difficulty scaling, TTS
tool and audio pipeline, final title.

## 2026-11-04 — Session 1 (cont.): Basic script draft

**Asked:** Write a basic script in one md file; user will rewrite it by hand.

**Done:**
- Wrote `story/script-draft.md` (v0.1): all 13 scenes (01–11, Fail,
  Post-credits) with dialogue for every character, camera, SFX and
  gameplay beats. Undecided parts are marked [TBD] (chase controls,
  AI-vs-AI screen).

**Decisions:** none new. The draft only uses what's in the story bible.

**Next:** user rewrites the script manually.

## 2026-11-07 — Session 2: Voice generation research

**Asked:** Find the voice-generation GitHub repos mentioned in the story
bible. User also said they answered the open questions in detail, and that
game architecture will be planned in a separate chat, with the script
finished after that.

**Done:**
- The story bible names no repos (only "which TTS tool"), and no answers
  were found saved in the repo. Told the user.
- Researched open-source TTS repos and wrote
  `story/research/voice-generation.md` (commit `bf79c0c`):
  - Shortlist: Kokoro (Apache-2.0), Qwen3-TTS (Apache-2.0),
    Chatterbox (MIT, retired Aug 2026), Piper (now GPL-3.0).
  - Ruled out as non-commercial: F5-TTS, XTTS-v2, Fish S2 Pro, Voxtral.
  - Glitch voice: in-engine Roblox sound effects or offline ffmpeg/sox.
  - Roblox audio quota: 2,000 uploads per 30 days (ID-verified).

**Decisions:** none. TTS setup is for the user to pick.

**Open questions:** which TTS setup (Kokoro only / Qwen3-TTS only / mix),
where the glitch is made (in-engine or offline), where the user's detailed
answers to the open questions are.

## 2026-11-07 — Session 2 (cont.): User's answers saved

**Asked:** The user saved their answers to the open questions in
`story/story-bible.md` and asked to check again.

**Done:**
- Committed the answers as written (`e0d265e`), then folded them into
  the story bible's decided sections (`3adf73e`).
- Researched "GPT's free voice libraries" and added the findings to
  `story/research/voice-generation.md` (`d679995`).

**Decisions (user):**
- Chase: the Robotaxi autopilot drives at first, then malfunctions. The
  front-seat Scam (any player) drives manually.
- AI vs AI (scene 11): two minds collide in a circular containment column
  from ceiling to floor, inspired by Jarvis vs Ultron (our own visuals).
- Difficulty: Easy = cat only (knocks things over, slowly waking The
  Admin); Medium = mom + cat, mild; Hard = both at their toughest.
- Title: **Chip Heist** confirmed.

**Findings:** ChatGPT's voices aren't open source and have no GitHub
repo. They're only in the paid OpenAI TTS API. Free look-alikes either
proxy Microsoft Edge voices (openai-edge-tts) or wrap Piper/XTTS
(openedai-speech). Kokoro is the closest free sound.

**Open questions:** which TTS setup (Kokoro / Qwen3-TTS / mix / OpenAI
API). Game architecture will be planned in a separate chat; the script is
finished after that.

## 2026-11-07 — Session 2 (cont.): 3D model formats

**Asked:** Which Sketchfab download format is best for bringing models into
the game (example: "Tesla Roadster 2020" by metarex.4d, CC Attribution,
608.9k triangles).

**Answer given:**
- Editing in Blender first: **FBX (original format)**. Importing straight
  into Roblox: **GLB with 1k textures** (one file, textures embedded, and
  Roblox textures max out at 1024×1024).
- Most Sketchfab models are far too heavy for Roblox (MeshParts have a
  triangle limit, around 20k each), so decimate and split them in Blender
  first.
- CC-BY models need credit (keep a credits file). Real brands (Tesla)
  must be de-badged and reshaped to fit the parody rules (ClosedAI Robotaxi).

**Decisions:** none. The user picks a workflow.

## 2026-11-08 — Session 2 (cont.): Alternative concept pitched

**Asked:** The user pitched a different game and asked which one Claude would
rather play. In it, you're the Discord mod's son. Scam's robots pulled the
chip out of your dad's pacemaker because he owned the last piece of RAM, and
he died. AI has taken over the world. After an emotional opening, you grow
stronger, learn to shoot, fight Scam's robots, and kill Scam in his own
factory to free the world from AI.

**Claude's take:**
- Build the heist first. It's tighter (about 20 min, co-op), funnier, and
  can be finished.
- The revenge story is the stronger story but a much bigger build: a
  shooter, a progression system, enemy AI and a boss.
- Risk: killing a parody of a real, living person is much riskier under
  Roblox rules than stealing from him. Suggested making the final boss a
  machine (e.g. Scam uploaded into his factory's AI) rather than the man.
- Idea: make it the **sequel**. The Admin from the heist becomes the dad,
  so the two games share one world.

**Decisions:** none yet. Waiting on the user.

## 2026-11-08 — Session 2 (cont.): Concept decision

**Decision (user):** Continue with **Chip Heist**. The revenge story is
saved for another day in `story/ideas/revenge-sequel.md`.

**Open questions (heist):** which TTS setup. Game architecture will be
planned in a separate chat, and the script finished after that.

## 2026-11-08 — Session 2 (cont.): Voice decision, assets review, next-chat prompt

**Asked:** Save Kokoro as the voice. Look at `3d assests/` (reference
photos plus usable models) and write a prompt for a new chat that uses
Blender and Roblox Studio to plan the world and architecture.

**Decisions (user):**
- Voice: **Kokoro** (`d9b0ea6`).
- World: the house and the ClosedAI "factory" are **a few km apart**,
  joined by a **highway through forest**. The factory is in the forest
  too. **Realistic** look (`ffede13`).

**Done:**
- Reviewed `3d assests/` (untracked, ~320 MB, not committed):
  - 4 reference photos: a misty cabin, a forest factory (real FREYR logo,
    don't copy), a wet mountain road, a foggy guardrail road.
  - Models: Log House (archibase, ~750k faces), Building factory
    (archibase, .3ds/.gsm), Tesla Roadster (CC-BY), two Tesla bots.
- Wrote `prompts/world-building-chat.md` (`f6102ae`).

**Open questions (for the next chat):** single-storey cabin vs the
3-stage house, log house vs cabin look, new town name and region, highway
vs two-lane road, what to do with the `3d assests/` folder (rename,
gitignore or LFS), what the Tesla bots are for, archibase licenses.

## 2026-11-08 — Session 3: World-building & architecture planning

**Asked:** Follow `prompts/world-building-chat.md`: inspect the 3D models,
ask about the known gaps, write the world plan, propose the code
architecture, and only start the Studio blockout after approval.

**Done:**
- The Blender MCP wasn't connected, so the models were inspected headless
  with Blender 5.2 and a small 3DS parser (Blender 5.2 has no bundled 3DS
  importer). Results are in `docs/world-plan.md` §7:
  - Log house: ~750k tris, 19 × 14 × 10 m, ornate Russian log style. Poor
    match to the cabin.
  - Factory: ~172k tris, 123 × 72 × 62 m, old brick plant with floating
    parts. Poor match to the photo.
  - Roadster: ~609k tris, 85 objects, real size. Good car base.
  - Tesla Bot: 5k tris, rigged + animated. Nearly ready. Female bot:
    161k tris, no rig.
- Moved `3d assests/` → `assets/source/` and tracked the binaries with Git
  LFS (`0c0f77c`, `184a788`).
- Story bible updated with the decisions (`707c815`), plus new open
  questions (`d91dc7e`).
- `assets/CREDITS.md` license tracker (`c3cfd27`).
- `docs/world-plan.md` draft: map in studs, asset list, Blender → Roblox
  pipeline, lighting recipe, streaming budget, build order (`f1c7023`).
- `docs/architecture.md` module layout proposal (`4843c0a`) and the
  decisions (`695446e`).

**Decisions (user):**
- House: **hillside walk-out** cabin (basement opens downhill, attic in a
  steeper roof). **Rebuild in Blender + reuse log-house parts**.
- Town: just **"Appalachia"**, unknown territory, **year 2221**.
- Road: **mix**, 3 km. Two-lane 0–1.8 km, then divided highway. Crossing at
  ~2.3 km, factory exit at ~2.9 km.
- Raw assets: **rename + Git LFS**.
- Robot models: **ClosedAI data-center workers** (background).
- Factory: **build new** in the photo's style.
- Architecture: **one place for now**, **plain modules**, **raycast car**,
  **behaviour trees** for NPCs.

**Open questions:**
- Approve `docs/world-plan.md` (the *(proposed)* items) and the module
  layout in `docs/architecture.md` before the Studio blockout starts.
- The 2221 setting vs the pitch's Texas/podcast lines, and the scene 03
  "cul-de-sac" arrival.
- Licenses for the archibase models and the Tesla bots (unverified).
- Connect the Blender MCP for the asset work (headless Blender works as a
  fallback).
- `.gitignore` ignores `*.rbxm`, so it needs an `!assets/**/*.rbxm`
  exception before saving Studio models.
- Nothing is pushed yet. The LFS push is ~320 MB; GitHub's free LFS tier is
  1 GB storage + 1 GB bandwidth per month.

## 2026-11-08 — Session 3 (cont.): Push + first world blockout

**Asked:** Push everything in small commits and start the blockout.

**Done:**
- Pushed all commits, including 331 MB of LFS assets, to `origin/main`.
- `.gitignore` now allows Studio models under `assets/` (`11a7869`).
  `.rbxmx` files are tracked in LFS (`d92cdd2`).
- Built the blockout in Studio (Place1) through the Studio MCP:
  - Road: 260 path nodes over 10,360 studs. Two-lane with alternating
    concrete barriers and guardrails up to 6,430 studs, then a divided
    highway with a median.
  - Terrain: gentle rolling hills, a base band and the cut road corridor.
  - Hillside plot: plateau at y 246, walk-out yard at y 234, gravel drive,
    mountain ridge behind.
  - Greybox cabin: basement (den, storage, walk-out door), ground floor
    (glass front, kitchen, living room, Mom's room, stair hall, garage,
    back door, doggy door), attic (hatch + ladder, Golden DIMM marker),
    steep metal gable roof with the escape roof window, deck on a stone
    wall.
  - Train crossing at ~8,200 studs: booms, signals, rails through
    cuttings, placeholder train parked up the track.
  - Factory: clearing, access road, 536 × 64 × 143-stud translucent hall
    on a dark timber base, roof fins, vine markers, side block, server
    racks, containment column.
  - Lighting: night fog recipe from the plan.
- The lighting and streaming settings are in `default.project.json`
  (`0b3cfa5`), because the MCP can't write `Lighting.Technology` or the
  streaming radius.
- The blockout is saved as rebuild scripts in `tools/blockout/`
  (`cf82151`, `a8f4824`, `8274ecd`, `f60c25d`, `b35b53b`, `232fb2e`,
  `670251e`). Rojo doesn't sync terrain or parts, so the place can be
  rebuilt from git. Claude chose this; the user can change it.
- Playtest: the player spawns in the yard on grass. No script errors. One
  unrelated asset warning: `rbxassetid://203785492` has the wrong asset
  type.

**Decisions:** none new from the user. Claude's choices, open to change:
the exact road curve, the house layout dimensions, the factory position
(south-east of the highway end), and keeping the blockout as scripts in
`tools/blockout/`.

**Open questions / next:**
- The user should save the place file (File → Save to File). `*.rbxl` is
  git-ignored.
- Next in the build order: drive the road with a placeholder car to check
  the ~1.8 min timing, playtest the stealth routes in the greybox house,
  then bring in the first Blender asset (the cabin shell).
- No trees yet. The forest scatter comes with the road kit (build step 6).
- The highway dead-ends at the factory exit (no onward road).

## 2026-11-10 — Session 3 (cont.): Next steps + script-update handoff

**Asked:** What the next steps are, then a summary and a prompt for a
separate "script" Claude chat to update the story script. Ask the script
questions first.

**Done:**
- Listed the next steps (save the place, test-drive the road, playtest
  the house, cabin in Blender, Robotaxi, forest, crossing, factory, plus
  the code base layer).
- Recorded the script direction in the story bible (`5f202f1`).
- Wrote `prompts/script-update-chat.md`: a summary of every world/design
  change since script v0.1, the list of conflicting lines, the house room
  list and the deliverable (`script-draft.md` v0.2).

**Decisions (user):**
- Year 2221: the RAMpocalypse happens in 2221, same joke. Scam is still
  CEO, and the podcast is a 2221 hologram podcast.
- Scene 03: factory glow reveal across the valley to the cabin.
- Robot workers: background plus one freeze-and-bow gag in scene 11.
- The script agent edits `script-draft.md` directly as v0.2.

**Open questions:** none new. The script chat may raise its own.

## 2026-11-10 — Session 4: Script update (v0.1 → v0.2)

**Asked:** Follow `prompts/script-update-chat.md`: bring
`story/script-draft.md` in line with the world and design decisions made
since v0.1. No code, Studio or Blender.

**Done:**
- Recorded the four new decisions in the story bible and fixed its stale
  Texas / cul-de-sac lines (`6e330f8`).
- Scenes 01–03: 2221 hologram news and podcast, the briefing on the cabin
  3 km from the forest data center, the factory glow reveal (`911fa2b`).
- Scenes 04–08: entry points, rooms and routes match the built cabin; the
  breaker joke is about the grid; new server lockdown in 07 (`efffd1e`).
- Scenes 09–11: roof slide to the Robotaxi by the garage, the full chase
  route, the forest hall, the containment-column fight and the robots'
  freeze-and-bow (`9103caf`).
- Header set to v0.2 with a changelog, updated cast, notes and open
  questions; the post-credits phone became a hologram store (`bad11f0`,
  `fa2ccd2`).

**Decisions (user):**
- Scene 01 keeps both parts: hologram news report, then hologram podcast.
- Scam in 2221: he uploaded himself, and the player Scams are his copies.
- Scene 07: The Admin triggers a **server lockdown**. Shutters close the
  walk-out and every ground-floor door; the attic roof window is the only
  exit off his system.
- Autopilot fails **mid two-lane, at about 1 km**. The front-seat Scam
  drives the rest.

**Claude's choices, open to change:** a hologram of the original Scam
runs the briefing; the robots bow (not "/ban"); the crew slides down the
front roof to the east end; the autopilot breaks after Hype and Podcast
give it conflicting orders; a tiny shutter on the doggy door.

**Open questions (also at the end of the script):**
1. Is the basement walk-out an entry in Stage 1? It skips the stage.
2. What passengers do during the chase.
3. Whether any shutter can be reopened in Stage 3.
4. Who briefs the crew in scene 02.

## 2026-11-10 — Session 4 (cont.): v0.2 open questions answered

**Asked:** Ask the four open script questions.

**Decisions (user):**
- Basement walk-out: **open, hardest entry**.
- Chase passengers: **throw energy drinks, and can throw loot** for a
  bigger slowdown at the cost of score.
- Shutters: the **Hacker can reopen one door**.
- Briefing: the **hologram of the original Scam** stays.

**Done:** written into the script (scenes 04–05, 08–09, 10) and the
story bible. See the commits after `e618481`.

**Claude's choices, open to change:** entering by the walk-out makes
scene 05 start at the walk-out door; leaving by the Hacker's door skips
the attic, the Golden DIMM and the roof-window jump; three new short
lines (Lowercase, Podcast, Hype) and one Admin line in the chase.

**Open questions:** none for the script.
