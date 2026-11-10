# World blockout scripts

Rojo doesn't sync terrain or parts built in Studio, so the world lives here
as scripts. Rojo syncs this folder to `ServerStorage.WorldTools` (see
`default.project.json`); the scripts only run when you call them.

## How to run

With Rojo connected, run a step from the Studio **command bar**:

```lua
require(game.ServerStorage.WorldTools["04-house"]:Clone())()
```

To run a step that needs the shared `Kit` or `furniture` modules after
editing them, clone the whole folder so nothing is cached:

```lua
local t = game.ServerStorage.WorldTools:Clone(); require(t["07-furnish-ground"])()
```

| Step | Module | Builds |
|---|---|---|
| 1 | `01-road` | `Blockout.RoadPath` (260 nodes, every 40 studs) + road, barriers, guardrails |
| 2 | `02-terrain` | **Clears all terrain**, then hills, base band, road corridor (~1 min) |
| 3 | `03-house-plot` | Plateau, walk-out yard, garage forecourt, drive. `({ skipRidge = true })` skips the slow mountainside |
| 4 | `04-house` | Cabin shell (`Blockout.House`): walls, floors, roof, doors, stairs, lights. Carves the basement. Keeps `House.Furnishings` |
| 5 | `05-train-crossing` | Crossing at ~8,200 studs, cuttings, parked train |
| 6 | `06-factory` | Clearing, access road, factory hall, containment column |
| 7 | `07-furnish-ground` | `Furnishings.Ground`: living, dining, Mom's room, old bedroom, bathroom, hall, kitchen, pantry, mud room, deck |
| 8 | `08-furnish-basement` | `Furnishings.Basement`: den, spare room, storage, laundry |
| 9 | `09-furnish-attic-garage` | `Furnishings.Attic` and `Furnishings.Garage` |

Steps 4–9 each replace only their own model. Step 2 wipes the terrain, so
re-run 3, 4, 5 and 6 after it.

`Kit.luau` holds the shared helpers. `furniture/` is the catalogue:
`Storage` (cabinets, drawers, shelves, trunks), `Appliances` (fridge, stove,
battlestation, moped…), `Seating` (sofas, beds, tables, decoration).

Lighting, atmosphere and streaming are set in `default.project.json`.

## The cabin (1 stud ≈ 0.28 m, front faces +Z)

Main cabin x -52..52, z -104..-40. Garage x 52..92, z -88..-40. Deck z -40..-20.

| Floor | y | Rooms (x range, z range) |
|---|---|---|
| Basement | 232 | Den -52..12, -76..-40 · Spare room -52..-10, -104..-76 · Stairs -9..-2 · Storage 12..52, -76..-40 · Laundry -1..52, -104..-76 |
| Ground | 246 | Living -52..-4 and Dining -4..28 (open plan), -72..-40 · Mom's room 28..52, -72..-40 · Old bedroom -52..-26 · Bathroom -26..-10 · Stair hall -10..8 · Kitchen 8..36 (all -104..-72) · Pantry 36..52, -104..-88 · Mud room 36..52, -88..-72 |
| Attic | 260 | One space; ridge at y 282 along z = -72; ladder hatch at x 3..8, z -90..-84; roof window x 34..44 on the front slope |

Entry points: front slider (deck), back door and doggy door (kitchen),
garage side door (keypad), basement walk-out (under the deck).

## Tags and attributes the game code reads

| Tag | On | Attributes |
|---|---|---|
| `Openable` | Model with a `Moving` child model | `Kind` (Hinge/Slide), `OpenAngle`, `Axis`, `SlideOffset`, `DisplayName`; the server sets `Open` |
| `Inspectable` | Part | `DisplayName`, `Line` |
| `Loot` | Part | `DisplayName`, `Value`, `Line` |
| `HidingSpot` | Openable with a `HideSeat` | — |
| `Shutter` | Hidden part at each exterior door | for the scene 07 lockdown |

Markers for later systems: `Marker_GPU1/2`, `Marker_RAM`,
`Marker_LockdownButton`, `Marker_AdminChair`, `Marker_BreakerSwitch`,
`Marker_MiningRigCrate`, `Marker_GoldenDIMM`, `Marker_Keypad`,
`Marker_DoorbellCam`, plus attributes `EscapeExit` (roof window), `TV`,
`AdminPC`, `Moped`, `GarageDoor`, `Knockable` (vase).

## Other key numbers (see `docs/world-plan.md`)

- Road: 10,360 studs. Two-lane until 6,430, then divided highway.
- Crossing: `RoadPath.Node206`, about (7583, 21, 81).
- Factory hall centre: about (10184, 18, -651).
