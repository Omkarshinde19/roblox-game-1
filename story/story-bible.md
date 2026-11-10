# Story Bible — Chip Heist

Only **decided** things go in here. Every decision below was picked by the
user (see `SESSION_LOG.md`). Anything not decided yet is under
[Open questions](#open-questions). Background research is in `research/`.

---

## Pitch

It's the year 2221, the middle of the RAMpocalypse. AI data centers have bought up the
world's memory, and a stick of RAM costs more than rent. After saying on a
podcast that it's "terrible" for regular people to own RAM, **Scam Altman**
takes matters into his own hands. He and up to three more Scams break into
the home of **The Admin**, a Discord moderator whose basement rig holds the
best GPUs left in Appalachia, and steal the chips "for the data center".

## Pillars

| Decision | Value                                                                                                                                      |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Tone     | **Comedy stealth-horror**: The Admin is a real threat, and there are jump scares when he wakes                                       |
| Scope    | **One house, 3 stages** (Ground → Basement → Attic), about 20 min, with a cutscene between stages                                  |
| Players  | 2–4 co-op, and every player is a Scam                                                                                                     |
| Art      | **Semi-realistic**: PBR materials, realistic lighting, a semi-realistic Scam                                                         |
| Voice    | Every line is voiced in a **cheerful AI-assistant voice**. The Admin's voice **glitches into a distorted voice when he wakes** |
| Mode     | Story mode: linear, with a scripted ending                                                                                                 |

## Cast

### The Scams (players)

Every player is Scam Altman. The role picked at the briefing decides the
Scam's **personality and voice lines**.

| Role        | Personality                 | Voice style                                              | Role tool / teamwork action                                         |
| ----------- | --------------------------- | -------------------------------------------------------- | ------------------------------------------------------------------- |
| Lookout     | **Paranoid Scam**     | Nervous, keeps saying "pls chill"                        | Security-cam tablet, pings, flips the breaker                       |
| Hacker      | **Lowercase Scam**    | Talks the way he tweets: flat, lowercase, no punctuation | Laptop minigames: doorbell cam, garage keypad, The Admin's PC       |
| Carrier     | **Hype Scam**         | "Feel the AGI!" energy, wants MORE                       | Bigger bag and faster while loaded. Needed for 2-person GPU carries |
| Distraction | **Calm Podcast Scam** | Soft-spoken, over-explains everything                    | Fake Dizcord pings, energy drinks, pizza call                       |

With fewer than 4 players, the unfilled roles' tools can be picked up in the house.

### The Admin (antagonist)

- A Discord moderator who sits, sleeps and eats. He's so big he barely
  fits on his moped.
- He's a real threat when alert. The joke is his priorities and
  self-importance, not his body (see `research/discord-mod.md` → tone).
- Voice: peppy AI assistant while asleep or calm ("Great question! Snack
  time!"), glitching into a distorted voice once alerted ("YOU. ARE.
  BANNED.").
- Catch mechanic: the **Ban Hammer** sends a player to `#timeout`, and a
  teammate must "appeal" (revive) them.
- Rides a **moped** in the chase.

### The Admin's Mom

- A second NPC who patrols the ground floor. Her yelling "DINNER!" works as
  a stealth timer that pulls The Admin up from the basement.
- Speaks in the peppy AI voice.

### The Cat

- Wanders between floors and knocks things over. The noise wakes The Admin.
- It isn't a threat itself. It meows in the peppy AI voice.

## World

- **World layout (user, 2026-11-08):** realistic look. The house and the
  ClosedAI "factory" (the data center where the heist ends) are **a few
  km apart**, joined by a **highway through forest** on both sides. The
  factory sits in the jungle/forest too. Reference photos are in
  `3d assests/`: a misty conifer valley, a wet mountain road with barriers,
  a foggy road with guardrails, a dark cabin on a stone wall, and a
  translucent factory wrapped in climbing plants.
- **Town (user, 2026-11-08):** ~~Abilené Heights, Texas~~ is replaced.
  The setting is simply **Appalachia**, an unknown territory in the
  **year 2221**. Misty mountain forest, Smoky-Mountains feel.
- **Road (user, 2026-11-08):** **3 km** (about 10,700 studs) from the house
  to the factory. A winding **two-lane** mountain road out of the house's
  valley (0–1.8 km), then it merges onto a **divided highway**. The train
  crossing is at about 2.3 km and the factory exit at about 2.9 km.
- **Factory (user, 2026-11-08):** a new long translucent hall with a timber
  base and climbing plants, built from scratch in the photo's style with
  ClosedAI branding (no FREYR logo). ClosedAI **robot workers** walk the
  data center as background extras.
- **House (user, 2026-11-08):** the modern cabin from the photo, built as a
  **hillside walk-out**. From the front it looks single-storey on its stone
  retaining wall. The **basement** opens downhill under the deck, and a
  steeper gable roof holds the **attic** and its roof window. The shell is
  rebuilt in Blender, reusing parts from the archibase log house where they
  fit. Rooms follow `research/setting-and-scenes.md` §2. Stages:
  1. **Ground floor**: entry points, living room, kitchen (fridge patrol), garage, Mom's area.
  2. **Basement**: The Admin's RGB den, the "server room" (2× GPU on a
     2-person carry, RAM, CPU), storage with the breaker box.
  3. **Attic**: the legendary **Golden DIMM** shrine. The roof-window escape.
- **Company:** **ClosedAI**. The HQ whiteboard reads "AGI: need 3 more RAM".
- **Brands:** all parody, no real logos. Dizcord, Mountain Doom, NVIDEO.
- **Crew car:** a **ClosedAI Robotaxi** that keeps saying "rerouting for
  optimal compute".

## Scene list (end to end)

One file per scene goes in `scenes/` as `NN-short-name.md`.

| #  | Scene                   | Type                   | Summary                                                                                                                                                                                                 |
| -- | ----------------------- | ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 01 | The Shortage            | Cutscene               | A 2221 hologram news report: RAM costs more than rent. A clip from a hologram podcast of Scam saying people owning RAM is "terrible". Smash cut to Scam staring at a GPU.                                            |
| 02 | ClosedAI Briefing       | Cutscene + role pick   | Slideshow of the target, The Admin ("online 24/7") and the house. Players pick roles, and each Scam personality gets an intro line.                                                                     |
| 03 | Arrival                 | Cutscene               | Factory glow reveal: the ClosedAI hall glows through the trees, the camera pans across the foggy valley to the lit cabin, and the Robotaxi pulls in. Title card.                                                                                                          |
| 04 | Stage 1 — Ground Floor | Gameplay               | Get in, avoid Mom and the cat, loot the garage and living room, find the way down.                                                                                                                      |
| 05 | Into the Server Room    | Cutscene               | Creeping down the stairs: RGB glow, snoring. First look at The Admin asleep in his chair.                                                                                                               |
| 06 | Stage 2 — Basement     | Gameplay               | Distract The Admin and grab his rig. The 2-person GPU carry. The breaker brownout.                                                                                                                      |
| 07 | He Wakes                | Cutscene               | Jump scare. The Admin's peppy voice glitches into the distorted one. He triggers a server lockdown, so the only way out is up.                                                                                                                |
| 08 | Stage 3 — Attic        | Gameplay (chase)       | The Admin hunts upward. Grab the Golden DIMM and reach the roof window.                                                                                                                                 |
| 09 | The Window              | Cutscene               | The crew jumps off the roof into the waiting Robotaxi. The Admin squeezes onto his moped.                                                                                                               |
| 10 | Train Crossing Chase    | Gameplay → cutscene   | The Robotaxi's autopilot malfunctions about 1 km down the two-lane road and the front-seat Scam drives. Robotaxi vs. moped. A train is coming at the crossing. **Fast enough:** the crew crosses and the train hits The Admin (cartoon, no gore). **Too slow:** he catches the crew → Fail ending. |
| 11 | The Data Center         | Cutscene + interaction | A player plugs the stolen GPU into the ClosedAI data center. Inside a ceiling-to-floor circular containment column, ClosedAI's AI is taken down by **The Admin's own AI**, which was still on the GPU. Success ending.                        |
| F  | You Have Been BANNED    | Cutscene (fail)        | If the whole crew is caught (or caught in the chase): a Dizcord ban modal, then The Admin goes back to eating.                                                                                          |
| P  | Post-credits            | Cutscene               | The Admin, bandaged, tries to order a new GPU. It's out of stock, thanks to ClosedAI.                                                                                                                   |

## Content guardrails

- Roblox Community Standards ban impersonation that damages someone's reputation.
  The user chose the name **Scam Altman** and a **fully semi-realistic look**
  knowing they carry the highest report risk. Mitigations to keep:
  - a "Parody. Not affiliated with any real person or company." line in the game description
  - no real photos or face textures, and no real logos (OpenAI, Discord, Tesla, Nvidia)
  - keep "Sam Altman" out of the title, thumbnail and tags
  - no verbatim real quotes presented as dialogue; paraphrase instead
- All ages: cartoon violence only (the train hit, the Ban Hammer). No gore.
  Nothing about anyone's private life.

## Difficulty (user, 2026-11-07)

| Mode   | Mom | Cat | Notes |
| ------ | --- | --- | ----- |
| Easy   | No  | Yes | The cat knocks over pots, frames and glass, slowly waking The Admin |
| Medium | Yes | Yes | Both are present but not a big threat |
| Hard   | Yes | Yes | Both at their toughest |

## Chase (user, 2026-11-07)

The Robotaxi autopilot starts the escape and drives for a while, then
malfunctions because it was given bad instructions. A Scam has to drive
manually: **whichever player is in the front seat** takes the wheel.

## AI vs AI screen (user, 2026-11-07)

Two minds collide inside a **closed, circular containment column** that
runs from the ceiling of the data center to the floor. ClosedAI's AI and
The Admin's AI fight inside it. Inspired by the Jarvis-vs-Ultron scene, but
our own visuals: no Marvel characters, look or music.

## Voice (user, 2026-11-08)

**Kokoro** ([hexgrad/kokoro](https://github.com/hexgrad/kokoro),
Apache-2.0) generates every voice line. Each character gets a different
preset voice and speed. See `research/voice-generation.md`.

## Title

**Chip Heist** (confirmed by the user).

## Script direction (user, 2026-11-10)

- **Year 2221:** the RAMpocalypse is happening **in 2221**, same joke as
  before. Scam is still ClosedAI's CEO in 2221 (running gag: he "never
  leaves", maybe uploaded). The podcast clip in scene 01 becomes a **2221
  hologram podcast**.
- **Scene 03 arrival:** a **factory glow reveal**. Open on the ClosedAI
  hall glowing through the trees far away, pan across the foggy valley to
  the tiny lit cabin on the hill, then the Robotaxi pulls in.
- **Robot workers (scene 11):** ClosedAI robots walk the racks in the
  background. When The Admin's AI wins, they all freeze, turn to the
  column and bow (or type "/ban"). One beat, no lines.

## Script decisions (user, 2026-11-10, script v0.2)

- **Cold open:** scene 01 keeps both parts as 2221 versions: a **hologram
  news report**, then the **hologram podcast** clip.
- **Scam in 2221:** he **uploaded himself**, and the player Scams are
  **copies of him**. That's also why every player is Scam.
- **Scene 07 lockdown:** when The Admin wakes he triggers a **server
  lockdown**. Shutters close the basement walk-out and every ground-floor
  door. The stairs stay open, and the attic roof window is the only exit
  not on his system.
- **Autopilot:** the Robotaxi's autopilot fails **mid-way down the two-lane
  road (about 1 km)**. The front-seat Scam drives the rest: the last bends,
  the merge, the highway and the crossing.

## Open questions

