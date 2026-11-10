# Prompt: Script update chat (script-draft v0.1 → v0.2)

Copy everything below the line into a new chat opened in this repo.

---

You're joining **Chip Heist**, a Roblox co-op (2–4 players) comedy
stealth-horror heist parody. Your job in this chat is to **update the story
script** so it matches the world and design decisions made since it was
written. You don't touch code, Studio or Blender.

## Read first
1. `CLAUDE.md` (repo rules)
2. `SESSION_LOG.md` (history; the newest entries matter most)
3. `story/story-bible.md` (**source of truth**: only decided things)
4. `story/script-draft.md` (v0.1, the file you'll edit)
5. `docs/world-plan.md` §1 (map) and `tools/blockout/README.md` (what's
   actually built)

## Repo rules (must follow)
- **Small commits**, one logical change each (e.g. one scene per commit),
  with the `docs:` prefix. No Claude co-author or attribution lines.
- **Ask before deciding.** If a change needs a story choice the bible
  doesn't cover, ask me with a list of options. Don't invent decisions.
- **Append an entry to `SESSION_LOG.md`** at the end: what was asked, what
  was done (with commit hashes), decisions and who made them, open questions.
- Push to `origin main` when done.

## Summary of what changed since script v0.1

| Topic | v0.1 script says | Now decided (by the user) |
|---|---|---|
| Setting | Abilené Heights, Texas; the data center is next door | **Appalachia**, an unknown territory in the **year 2221**. Misty mountain forest |
| Year / cold open | Present-day news report + a podcast clip | The RAMpocalypse is happening **in 2221**, same joke. Scam is **still ClosedAI's CEO in 2221** (running gag: he "never leaves", maybe uploaded). The podcast becomes a **2221 hologram podcast** |
| House | A suburban house in a cul-de-sac | A **lone modern cabin on a hillside**: dark metal gable roof, timber cladding, big warm glass front, deck on a stone wall. **Hillside walk-out**: the basement opens downhill under the deck, and the attic sits in the steep roof with the **escape roof window**. Garage on the east side, gravel drive up from the road. Rooms are listed below |
| Scene 03 arrival | Cul-de-sac at night, data-center cranes on the skyline | **Factory glow reveal**: open on the ClosedAI hall glowing through the trees far away, pan across the foggy valley to the tiny lit cabin on the hill, then the Robotaxi pulls in |
| Distance | Data center across the back fence | House and factory are **3 km apart** (about a 1.8-minute drive) |
| Chase road (scene 10) | "A night road through the data-center construction site" | A winding **two-lane mountain road** (wet, concrete barriers, guardrails, dense forest) for the first ~1.8 km, then it **merges onto a divided highway**. The **train crossing is at ~2.3 km**, and the **factory exit at ~2.9 km** |
| Chase gameplay | Marked [TBD] | Decided: the **Robotaxi autopilot drives first, then malfunctions** because it was given bad instructions. **Whichever player is in the front seat** drives manually. Suggested placement: autopilot on the two-lane road, glitch around the merge. Fast enough = the crew crosses and the train hits The Admin (cartoon). Too slow = he catches them → Fail |
| Data center (scene 11) | "Stadium-sized ClosedAI data center" | A **long translucent polycarbonate hall with climbing plants on a dark timber base, deep in a pine/birch forest clearing**. Server racks inside, and the **ceiling-to-floor containment column** for the AI-vs-AI fight. ClosedAI logo only |
| Robot workers | Not in the script | ClosedAI **robot workers** walk the racks in the background. When The Admin's AI wins, they all **freeze, turn to the column and bow** (or type "/ban"). One beat, no lines |
| Voice | — | Every line is voiced with **Kokoro** TTS in a cheerful AI-assistant voice. The Admin glitches into a distorted voice when alerted. Keep lines short and speakable |

### House rooms (as built in the blockout)
- **Basement (walk-out, downhill side):** The Admin's RGB den (his rig with
  2× GPU on a 2-person carry, RAM, CPU, his chair), storage/laundry with the
  **breaker box**, and a walk-out door under the deck.
- **Ground floor:** big glass front living room (front slider door),
  kitchen with the **fridge patrol**, **Mom's room**, a stair hall down to
  the basement, and the garage (keypad and side door). Entry points: front
  slider, back door, **doggy door**, garage side door, basement walk-out.
- **Attic:** pull-down ladder from the ground floor, the **Golden DIMM
  shrine**, and the **roof window** escape onto the front roof slope.
- There's **no upstairs bedroom floor**. Anything set "upstairs" means the
  ground floor or the attic.

## Lines in script-draft v0.1 known to conflict (check them all)
- Cast/intro and scene 01 (lines ~22–47): make it 2221. The news report
  and podcast become a 2221 hologram podcast. Same joke.
- Scene 02 (lines ~58 and ~65): "Abilené Heights, Texas. Right next to our
  new data center" and "the best GPUs in Texas" → Appalachia, the cabin on
  the mountain, 3 km from ClosedAI's forest data center.
- Scene 03 (lines ~89–90): cul-de-sac + cranes → the factory glow reveal.
- Scenes 04–08: room names and routes must match the room list above
  (e.g. the basement walk-out, Mom's room on the ground floor, the attic
  ladder).
- Scene 06 (lines ~183–185): the breaker joke "it was the data center".
  The data center is now 3 km away, so keep the joke but make it about the
  grid or the brownouts it causes. Ask me if unsure.
- Scene 09 (lines ~252–264): the roof-window jump lands near the Robotaxi
  on the gravel drive on the east side, by the garage, and the moped comes
  out of the garage.
- Scene 10 (lines ~274–300): remove [TBD]. Write the decided chase on the
  two-lane road → merge → highway → crossing.
- Scene 11 (line ~318 onward): "stadium-sized" → the forest hall, plus the
  robot-worker freeze-and-bow beat.
- Check the **Notes for rewriting** section and the open questions at the
  end of the script too.

## Don't change
- The cast, role personalities, the Ban Hammer / `#timeout` mechanic, the
  endings (Success, Fail "BANNED", Post-credits), the AI-vs-AI column idea,
  the difficulty table, and the parody guardrails (no real names on the
  title, no real logos: no Tesla, OpenAI, Discord, Nvidia or FREYR, no
  verbatim real quotes, cartoon violence only).

## Deliverable
- `story/script-draft.md` updated to **v0.2**, with a short changelog at
  the top listing what changed from v0.1.
- Small commits (one per scene or group of scenes), then
  `SESSION_LOG.md` updated and everything pushed.
- Finish with a list of any open questions you hit, each with options
  for me to pick from.
