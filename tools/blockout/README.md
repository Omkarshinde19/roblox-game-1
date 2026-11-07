# World blockout scripts

Rojo doesn't sync terrain or parts built in Studio, so the blockout lives
here as scripts. Running them in order rebuilds `Workspace.Blockout` and the
terrain from scratch. They aren't synced into the game (this folder is
outside `src/`).

## How to run

Open the place in Studio, then paste each file into the **command bar**
(View → Command Bar) and press Enter, in order:

| Step | File | Builds | Time |
|---|---|---|---|
| 1 | `01-road.luau` | `Blockout.RoadPath` (260 nodes, every 40 studs, attribute `Distance`) + road surface, barriers, guardrails. Deletes the Baseplate | seconds |
| 2 | `02-terrain.luau` | **Clears all terrain**, then hills, base band and the road corridor | ~1 min |
| 3 | `03-house-plot.luau` | Mountainside ridge, plateau, walk-out yard, drive | ~20 s |
| 4 | `04-house.luau` | Greybox cabin (`Blockout.House`) + blockout lights | seconds |
| 5 | `05-train-crossing.luau` | Crossing at ~8,200 studs + cuttings + parked placeholder train | ~10 s |
| 6 | `06-factory.luau` | Clearing, access road, factory hall, containment column | ~10 s |

Steps 4–6 can be re-run alone; each replaces only its own model. Step 2
wipes the terrain, so after it you must re-run 3, 5 and 6.

Lighting, atmosphere and streaming are set in `default.project.json` (Rojo),
not here.

## Key numbers (see `docs/world-plan.md`)

- Scale: 1 stud ≈ 0.28 m. Road: 10,360 studs (≈ 2.9 km) + access road.
- Two-lane (32 studs wide) until 6,430 studs, then a divided highway
  (2 × 50-stud carriageways, 14-stud median).
- House: ground floor y 246, basement walk-out y 234, attic y 258,
  ridge y 274. Front faces +Z.
- Crossing: `RoadPath.Node206` (~8,200 studs), at about (7583, 21, 81).
- Factory hall centre: about (10184, 18, -651).

## Markers for gameplay code

`Marker_*` parts (den rig, Admin chair, breaker box, fridge, Golden DIMM
shrine, Robotaxi stop) and attributes (`EscapeExit` on the roof window,
`Boom` on crossing arms, `Entrance` on the factory door, `Climbable` on
the attic ladder) are placeholders for the scripts to find.
