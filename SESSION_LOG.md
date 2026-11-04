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
