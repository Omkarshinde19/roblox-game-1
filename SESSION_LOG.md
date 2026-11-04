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

**Decisions:**
- User rule: Claude must ask questions with a list of options before
  setting any design decision.

**Open questions:** (pending research results) character naming, art style,
house location, game length, tone.
