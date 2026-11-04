# Research: Setting, House Layout & Scene List

Working title **Chip Heist**. Researched 2026-11-04. Sources are at the bottom; the numbers in brackets point to them.

---

## 0. Real-world context (for the satire)

- **RAM shortage ("RAMpocalypse").** Memory makers moved wafer capacity to HBM for AI servers, which left less consumer DDR5. TrendForce projected a 90–95% QoQ jump in DRAM contract prices for Q1 2026. One report said Stargate-linked contracts could take up to about 40% of global DRAM output. Consumer kits roughly doubled in price (example: DDR5 32 GB went from about $100 to about $450). IDC expects the shortage to last "well into 2027". [1][2][3]
- **Stargate Abilene, TX.** This is OpenAI/Oracle's flagship campus, built by Crusoe and designed for about 1.2 GW, with tens to hundreds of thousands of Nvidia GB200 chips. In March 2026, reports said OpenAI/Oracle dropped a further expansion, and Microsoft agreed to rent an adjacent site of about 700 MW. [4][5][6][7]
  - Comedy hook: the campus is huge and still "not enough", so Sam is raiding a single gamer's PC.
- **Content-policy guardrail.** Roblox Community Standards ban impersonating a real person in a way that could damage their reputation. They also restrict media of real people and depictions of political figures. Sam Altman is not a government official, but keep the parody **clearly fictional**:
  - Use a parody name (e.g. "Sam Altmode" / "Sam Ctrl-man").
  - No real OpenAI logo or real photos.
  - A generic hoodie avatar, and an obviously absurd tone.
  - Do the same for "Discord": use a fictional "Discorb" server.
  [8]

---

## 1. House location & setting

| # | Option | Pros (gameplay) | Pros (comedy) | Cons |
|---|--------|-----------------|---------------|------|
| A | **Suburban US cul-de-sac**, two-storey house with garage | Many entry points (front, back slider, garage, doggy door, attic window). Neighbours and a sprinkler give outdoor stealth. Easy to read for kids. | Classic "home invasion" parody look (Home Alone). HOA-sign gags. | Generic. The satire lives only in the props. |
| B | **Mom's basement** (the mod lives under his mum's house) | One tight vertical level that is cheap to build. Mom works as a second patrolling NPC. | Strongest Discord-mod meme. Mom yelling "DINNER!" works as a stealth timer. | Too small for a 4-player loop. Few routes. Little replay value. |
| C | **Small-town Texas house next to a data-center construction site** ("Abilene-ish": fictional town **"Abilené Heights"**, the Stargate-parody campus visible over the back fence) | Cul-de-sac layout plus a construction yard for the escape route (cranes, cable spools, forklifts). The data center is the delivery point, so the ending can be reached by driving. | Best satire: a $100B campus next door, and Sam still steals from the guy whose power keeps flickering because of it. Running gags: power brownouts and a "Data Center Coming Soon" billboard. | Bigger map to build. Must stay fictional (no real Crusoe/Oracle branding). |

**Recommendation: C, built on A's house.** It uses a suburban two-storey home with a basement, in a fictional Texas town backing onto a data-center construction site. You get A's stealth routes plus the satire. The mom from Option B becomes a light optional NPC on harder difficulties: she lives upstairs and the mod has the basement den.

- **Start:** "**ClosedAI** HQ" briefing room. This is a fake glass office with a whiteboard that reads "AGI: need 3 more RAM". It cuts to the crew sitting in a black van wrapped as "**DATA CENTER MOBILE UNIT — NOT SUSPICIOUS**", parked at the end of the cul-de-sac. The van is the in-heist spawn and the place to bank loot.
- **End:** The van drives through the construction gate to the fake Stargate campus loading dock. A forklift drops one RAM stick into a building the size of a stadium, and a progress bar ticks from 0.00001% to 0.00002%.

---

## 2. House layout (co-op stealth)

**Design rules**
- Use **4+ entry points**, so a party can split up.
- Put the mod in a **semi-fixed loop**: chair, then fridge, then bathroom, then a sleep cycle. This follows the Piggy/Doors approach of one readable antagonist with a learnable pattern. [9][10]
- Put loot value up high in risky rooms. The legendary item sits in the mod's room.

### Rooms

| Room | Floor | Entry / purpose | Loot (value) |
|------|-------|-----------------|--------------|
| Front yard & porch | G | Front door (lockpick, loud). Ring-doorbell camera that the hacker must loop. | — |
| Backyard | G | Back sliding door (quiet if unlocked). Doggy door (only one Sam fits, who then opens the slider from inside). Shed. | Shed: old DDR3 sticks (low) |
| Garage | G | Side door, or a code keypad from the hacker. Holds the escape vehicle path. | Old tower PCs that must be stripped (CPUs, med). Box of "spare" RAM (med). |
| Living room | G | Hub with sightlines to the kitchen and stairs. | Console (med) and a smart TV with a chip to pry out (low) |
| Kitchen | G | **Fridge patrol.** The mod walks here every N minutes for snacks. A microwave "ding" warns that he is coming. | Air fryer "AI chip" (gag, low). Energy-drink fridge is a distraction tool. |
| Mod's den / "SERVER ROOM" | B (basement) | Main objective room. The mod sits here: chair, 3 monitors, RGB everything. Lit by RGB only. | His rig: **2× GPU (high, heavy, 2-person carry)**, 4× RAM (high), CPU (high). A shelf of boxed GPUs he scalped. |
| Basement storage / laundry | B | Breaker box, which a lookout can flip to cut power (and his stream). Second stairs. | Mining-rig crate (very high, 2–3 carriers) |
| Upstairs hallway | 1 | Creaky floorboards (noise mechanic) | — |
| Mom's room (Hard+) | 1 | Optional second NPC who sleeps lightly | Jewellery box with a "RAM-shaped" pendant (gag, med) |
| Mod's bedroom | 1 | Locked; key is in the den | Gaming laptop (high). Backup drive with the server-password, needed for the secret ending. |
| Attic | 2 | Entry via the roof window (reach it by climbing the garage roof). Pull-down ladder. | **LEGENDARY: "The Golden DIMM"**, a 1 TB stick in a shrine labelled "DO NOT SELL EVEN FOR $10K". Also unopened 2023 GPU stock. |

### ASCII map (not to scale)

```
            ATTIC  [LEGENDARY Golden DIMM]  <- roof window (from garage roof)
   +--------------------------------------------------+
 1 | Mom's Rm (Hard+) |  Hallway (creaky)  | Mod Bedroom |
   |   [pendant]      |       ^ stairs     | [laptop,key]|
   +------------------+-------|------------+-------------+
 G | GARAGE  [towers]| LIVING  [console] | KITCHEN [fridge]|
   | keypad  door ---+-- hub ---- stairs--+-- patrol loop |
   | [roof climb]    |  front door (cam)  | back slider    |
   +-------|---------+--------v-----------+--------|-------+
           | driveway                         doggy door
   =====VAN (spawn/bank)=====          BACKYARD [shed]  --> fence --> DATA CENTER SITE
   +--------------------------------------------------+
 B | MOD'S DEN / "SERVER ROOM"   | STORAGE / LAUNDRY   |
   | [2 GPU heavy, 4 RAM, CPU]   | [mining crate x3]   |
   | chair <-> fridge loop start | [breaker box]       |
   +--------------------------------------------------+
```

### Mod (AI) states
1. **Sitting/Gaming.** He faces the monitors, so his vision cone is narrow and points away from the door. Headset on means hearing is reduced.
2. **Snack run.** He walks the den, stairs, kitchen route with a wide vision cone.
3. **Sleeping in chair.** Snoring, low detection. Loud noise wakes him.
4. **Suspicious.** "Who pinged me?" He investigates the last noise.
5. **Alerted.** He chases with a ban-hammer. "You've been BANNED from this server!" Being caught knocks a Sam out (a teammate can revive), not instant fail.

---

## 3. Full scene list (end to end)

| # | Scene | Type | Camera / cut ideas | Length |
|---|-------|------|--------------------|--------|
| 01 | **Cold open: "The Shortage"** | Cutscene | Fake news-anchor 4:3 frame: "RAM now costs more than rent". Smash cut to Sam staring at the "AGI needs 3 more RAM" whiteboard. Push-in on his face, eyes reflect a GPU. | 30–40 s |
| 02 | **Briefing at ClosedAI HQ** | Cutscene + light interaction | Projector slideshow showing the target, the house map and the mod's Discord status "online 24/7". Players pick roles at the table. Over-the-shoulder shots per player. Skippable after the first run. | 45–60 s |
| 03 | **Van arrival** | Cutscene | Wide establishing shot of the cul-de-sac at night, the data-center cranes glowing on the horizon. Van doors open, all Sams hop out in sync, title card "CHIP HEIST". | 15 s |
| 04 | **Infiltration** | Gameplay | Free roam outside. Scout through windows. Hacker loops the doorbell cam. Small cut-in when a door/route is opened. | 2–4 min |
| 05 | **Heist loop** | Gameplay | Third-person. Short "spotted!" zoom-cuts (0.5 s) when the mod's suspicion meter fills. Optional security-cam view for the lookout. | 6–12 min |
| 05a | Micro-cutscene: **"Snack Time"** | Cutscene (in-engine, non-blocking) | Picture-in-picture of the mod getting up the first time, to teach the patrol pattern | 5 s |
| 05b | Micro-cutscene: **Legendary found** | Cutscene | Choir sting, light beam on the Golden DIMM | 5 s |
| 06 | **Alarm / chase** | Gameplay | Triggered by full detection or by grabbing the legendary item. Red lights, mom calls "the cops" (or "the mods"). Camera shake and an FOV punch. Exits get blocked one by one. | 1–3 min |
| 07 | **Escape** | Gameplay to cutscene | All carriers reach the van, then a cut to the van peeling out. Optional drive segment through the construction site (dodge forklifts) to the gate. | 1–2 min |
| 08 | **Delivery ending ("Success")** | Cutscene | Van pulls up to a gigantic data center. Slow pan up the endless facade. Loot is dropped in. Progress bar ticks 0.00001% to 0.00002%. Sam: "We need more." Score screen. | 40–60 s |
| F | **Fail ending: "Banned"** | Cutscene | If the whole crew is downed: the mod stands over them, a Discord-style "You have been banned" modal fills the screen, and the camera pulls back to show the mod already back in his chair, eating. | 15–20 s |
| S | **Secret ending: "Open Source"** | Cutscene | Condition: steal the backup drive and the Golden DIMM, and nobody is spotted. The mod wakes, then offers to "partner": he becomes the data center's head moderator and the shortage is solved by... one moderator. Alternative: the Sams realise the mod runs a local AI on his rig, and it's better than theirs. | 40 s |
| P | Post-credits gag | Cutscene | The mod orders a new GPU, and it's out of stock because of Sam. | 10 s |

Total run: about 12–20 minutes, which suits Roblox session lengths.

---

## 4. Co-op design for 2–4 players

### Roles (picked at the briefing, soft roles; anyone can do basics)
| Role | Tool / perk | Signature teamwork action |
|------|-------------|---------------------------|
| **Lookout** | Binoculars, security-cam tablet, pings | Calls out the mod's position. Flips the breaker to cause a brownout ("the data center next door drained the grid"). |
| **Hacker** | Laptop minigames | Loops the doorbell cam, opens the garage keypad, unlocks the mod's PC (wiping his "scheduled ban list" buys time). |
| **Carrier** | Faster while loaded, bigger bag | Required for GPUs and crates. Runs the shuttle between the house and the van. |
| **Distraction** | Energy drinks, a phone that sends fake Discord pings, a pizza-delivery call | Pulls the mod out of the den ("@everyone" ping makes him check his phone; a pizza at the door sends him upstairs). |

### Mechanics that force teamwork
- **Heavy GPU / mining crate needs 2+ carriers.** Movement slows and both players must stay close (as Notoriety and PAYDAY do with heavy bags).
- **Doggy-door entry.** Only one Sam fits, so they must open the slider for the others.
- **Hold-the-door / hold-the-ladder** for the attic: one player holds while another climbs.
- **Revive** downed Sams. Being banned is a knockout, and a teammate can "appeal" (revive) you.
- **Distract + grab:** the den loot can only be safely grabbed while the mod is out of his chair.
- **Shared loot bank at the van** with a team score, and a bonus for all members escaping.

### Scaling by player count
| Players | Mod | Extras | Loot quota | Heavy items |
|---------|-----|--------|------------|-------------|
| 2 | Slower snack loop, shorter vision | No mom | $X | GPUs count as 2-person carry; crate disabled |
| 3 | Normal | Mom on Hard | 1.4× | +1 crate |
| 4 | Faster loop, hears better | Mom plus a cat (a noise source) | 1.8× | 2 crates (3-person carry) |

Use difficulty tiers (Easy/Normal/Hard/"Mod Abuse") that layer on top of the player-count scaling, as Notoriety does.

### What to borrow from successful Roblox games
- **Notoriety (PAYDAY experience):** stealth-first with a loud fallback, bags you carry to a van, public or hosted heist lobbies, voice/text coordination. Stealth is forgiving, so new players aren't instantly punished. [11][12][13]
- **Entry Point:** a stealth/loud split per mission, plus classes/perks that suit stealth. Borrow the idea that being detected **changes the mission** rather than ending it. [14]
- **Piggy:** one readable antagonist chasing a group, a key-and-door puzzle loop, short rounds, a cartoony tone. [9]
- **Doors:** a lobby/elevator that gathers the party and drops it into a run, sound cues and limited vision for tension, frequent updates and a strong meme community. [10][15]
- **Jailbreak:** robberies as short repeatable objectives with a visible "robbery open/closed" state, and a vehicle getaway. Use this for the van escape and a future "multiple houses" mode. (Not cited, general knowledge; verify before relying on it.)

---

## 5. Roblox implementation notes (cutscenes & party)

**Cutscene camera (client)**
- Use `workspace.CurrentCamera`. Set `CameraType = Enum.CameraType.Scriptable` to take full control, then drive `Camera.CFrame` (and `Focus`, updated every frame for LOD). `FieldOfView` ranges from 1 to 120, default 70. [16]
- Tween `CFrame` and `FieldOfView` with `TweenService:Create(camera, TweenInfo.new(t, Enum.EasingStyle.Sine), {CFrame = shotCF})`, then `:Play()` / `:Cancel()`. Chain shots with the Tween `Completed` event. [17]
- Afterwards, restore `CameraType = Enum.CameraType.Custom` and set `CameraSubject` back to the Humanoid.
- Author shots as **Parts in a `Workspace.Cutscenes.<SceneName>` folder** (shot1, shot2, ...) with attributes `Duration`, `Easing` and `FOV`. Designers can then move cameras in Studio and a shared module plays them.
- **Letterbox bars:** a ScreenGui with two black Frames that tween `Size` from height 0 to about 12% at the top and bottom. Also hide the PlayerGui HUD and disable controls during the cutscene (PlayerModule `GetControls():Disable()`).

**Syncing across the party (server-authoritative)**
- The server owns the scene state. It calls `CutsceneEvent:FireAllClients(sceneId, serverStartTime)`, and each client plays its local camera. Pass `workspace:GetServerTimeNow()` so late or laggy clients can skip ahead to the right offset. [18]
- RemoteEvents are one-way and reliable/ordered. The client handler does not get a player argument. Never trust client data: validate everything on `OnServerEvent`. [18]
- **Skipping:** a client sends `SkipVote:FireServer()`, and the server counts votes from unique players (it uses the `player` parameter, never an ID sent by the client). Majority or all players skip, then the server fires `CutsceneEnd` to everyone. Replays of seen scenes can be skipped locally. Gameplay state changes, such as teleporting characters to the van, happen **only on the server** when the scene ends.
- Freeze or anchor characters server-side during blocking cutscenes, or move them to the scene end position so nobody gets a head start.

**Lobbies / party matchmaking (TeleportService)**
- Structure: a **Lobby place** (HQ with a van or "elevator" zone, as in Doors) and a **Heist place** (the house) in the same experience. [15]
- Gather the group from the van zone, or with `SocialService:GetPlayersByPartyId(player.PartyId)` for Roblox parties. Then call `TeleportService:TeleportAsync(heistPlaceId, players, options)` **from the server only**. [19][20]
- For a private run, set `TeleportOptions.ReservedServerId = HttpService:GenerateGUID(false)`. The first teleport creates the reserved server.
- Pass non-secret settings (difficulty, roles) with `options:SetTeleportData()` and read them via `player:GetJoinData().TeleportData`. Clients can see this data, so the server must re-validate it. [19]
- Use `TeleportService:SetTeleportGui()` (client) for a branded loading screen, styled as the van driving. [19]
- Wrap teleports in `pcall` with retries. Handle `TeleportInitFailed` (back off on `Flooded`, retry on `Failure`). [19][20]
- **Teleports do not work in Studio playtests**, so publish to test them. During development, keep a single-place mode where the lobby and the house sit in one place.

---

## Sources
1. TrendForce figures via Windows Central, memory shortage 2026: https://www.windowscentral.com/hardware/memory-shortage-2026-tech-ai-datacenters
2. TechRadar, PC prices to rise as RAM costs soar: https://www.techradar.com/pro/experts-warn-pc-prices-could-rise-even-more-in-2026-as-ram-costs-set-to-soar-higher
3. Hardware Busters, AI datacenters consume 70% of high-end memory: https://hwbusters.com/news/ai-datacenters-will-consume-70-of-high-end-memory/
4. Epoch AI, OpenAI Stargate Abilene: https://epoch.ai/data/ai-data-centers/directory/openai-stargate-abilene
5. Bloomberg, first Stargate site to hold up to 400,000 Nvidia chips: https://www.bloomberg.com/news/articles/2025-03-18/openai-s-first-stargate-site-to-hold-up-to-400-000-nvidia-chips
6. DCD, 64,000 GB200 at Abilene by 2026: https://datacenterdynamics.com/en/news/openai-and-oracle-to-deploy-64000-gb200-gpus-at-stargate-abilene-data-center-by-2026-report
7. Bloomberg (Mar 2026), Microsoft to rent Texas site dropped by Oracle/OpenAI: https://www.bloomberg.com/news/articles/2026-03-24/microsoft-to-rent-texas-data-center-dropped-by-oracle-openai
8. Roblox Community Standards: https://about.roblox.com/community-standards
9. Piggy vs DOORS comparison (low-authority): https://earnaldo.com/blog/piggy-vs-doors
10. Dexerto, best Roblox horror games: https://www.dexerto.com/roblox/best-scary-roblox-games-horror-1494718/
11. Notoriety DevForum post: https://devforum.roblox.com/t/notoriety-a-payday%C2%AE-experience-version-395/3307537
12. Starbreeze, Notoriety relaunch as an official PAYDAY experience: https://www.starbreeze.com/news/notoriety-relaunches-on-roblox-as-an-official-payday-experience/
13. Destructoid, Notoriety stealth build: https://www.destructoid.com/roblox-notoriety-best-stealth-build/
14. Roblox Wiki, Entry Point: https://roblox.fandom.com/wiki/Player:Cishshato/Entry_Point
15. DOORS wiki, Lobby: https://breezewiki.discard.no/doors-game/wiki/Lobby
16. Roblox docs, Camera: https://create.roblox.com/docs/workspace/camera
17. Roblox docs, TweenService: https://create.roblox.com/docs/reference/engine/classes/TweenService
18. Roblox docs, Remote events and callbacks: https://create.roblox.com/docs/scripting/events/remote
19. Roblox docs, Teleport between places: https://create.roblox.com/docs/projects/teleport
20. Roblox docs, TeleportService API: https://create.roblox.com/docs/reference/engine/classes/TeleportService
