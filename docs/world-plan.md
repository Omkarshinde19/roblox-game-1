# World Plan — Chip Heist

Status: **draft v0.1 (2026-11-08)**. Items tagged *(user)* were decided by
the user. Items tagged *(proposed)* are Claude's suggestions and need sign-off
before they're locked. Story decisions live in `story/story-bible.md`.

Scale: **1 stud ≈ 0.28 m** (1 km ≈ 3,571 studs).

---

## 1. Map layout

Setting *(user)*: **Appalachia**, unknown territory, year 2221. Misty
mountain forest. Night, fog, rain.

```
 HOUSE PLOT                  TWO-LANE MOUNTAIN ROAD                 MERGE        DIVIDED HIGHWAY             FACTORY
 (hillside cabin)            winding, downhill, barriers            ~1.8 km      straighter, median           (deep forest)
  [0 m] ─────── drive ──────────────────────────────────────────────── ▶ ═══════════════╪═══════════ exit ──▶ [3.0 km]
   0 studs                                                           6,430           8,210         10,360   10,700
                                                                                  TRAIN CROSSING  (2.9 km)
                                                                                     (2.3 km)
   |◀── autopilot (0–~1 km) ──▶|◀──────────── manual driving (malfunction → front-seat Scam) ────────────▶|
```

| Segment | Path distance | Studs (path) | Notes |
|---|---|---|---|
| House plot | — | ~400 × 400 | Cabin on a stone retaining wall over a slope. Basement walk-out faces downhill. Gravel drive to the road. *(user: hillside walk-out)* |
| Two-lane road | 0 – 1.8 km | 0 – 6,430 | ~32 studs wide (2 × 3.5 m lanes + shoulders). S-bends, 60–80 m drop, concrete blocks and guardrails, forest right at the edge. *(user)* |
| Merge | ~1.8 km | ~6,430 | On-ramp onto the highway. Good spot for the autopilot glitch beat *(proposed)* |
| Divided highway | 1.8 – 2.9 km | 6,430 – 10,360 | Two carriageways of 2 × 3.5 m (~50 studs each) and a ~14-stud median barrier. ~120 studs wide in total. *(user: mix)* |
| Train crossing | ~2.3 km | ~8,210 | Level crossing with booms, bells and lights. The track runs roughly perpendicular and vanishes into cuttings on both sides so the train appears late. *(user: position)* |
| Factory exit | ~2.9 km | ~10,360 | Off-ramp onto a short forest access road (~360 studs) |
| Factory plot | ~3.0 km | ~900 × 700 | Long translucent hall in a clearing of pine and birch. *(user: new build, photo style)* |

The route **doesn't have to be straight**. A gentle S-curve keeps the world
box at about **8,000 × 4,000 studs** and stops long sightlines (the fog hides
the rest). *(proposed)*

Forest bands: dense trees **0–300 studs** either side of the road, then
low-detail hills with tree silhouettes out to the edge of the world.
*(proposed)*

## 2. Asset list

| Asset | Approach | Source | Notes |
|---|---|---|---|
| Cabin shell (walls, roof, deck, glass) | **Build new** in Blender | Ref: `assets/source/house location.jpg` | Dark metal gable roof (steeper, for the attic), vertical timber cladding, big glass front. Split into ~6 MeshParts *(user: rebuild + reuse parts)* |
| Cabin stone retaining wall / base | **Adapt** | Log house `Stone` material and base | Decimate, rebake at 1024 |
| Doors, railings, window frames | **Adapt** where they fit | Log house | Restyle to match the modern cabin. Log-specific parts are dropped |
| Interior rooms (ground, basement den, attic shrine) | **Build new** | Room list in `story/research/setting-and-scenes.md` §2 | Parts + modular wall kit first, then meshes |
| Props (GPU rig, monitors, fridge, breaker box, Golden DIMM) | **Build new** | — | Low-poly, shared texture atlas *(proposed)* |
| ClosedAI Robotaxi | **Adapt** | Tesla Roadster 2020 (CC-BY) | 609k tris → about 20–30k over 4–6 MeshParts. Remove the T badge, change nose, lights and roof shape. Driver seat, 2–4 seats (see questions) |
| The Admin's moped | **Build new** | — | Small and simple; the joke is that he barely fits |
| Data-center robot workers | **Adapt** | Tesla Bot (5k tris, rigged, animated) | Male bot works almost as-is. Female bot is 161k tris with no rig, so it needs decimation and a rig. Remove branding *(user: workers)* |
| Factory hall | **Build new** | Ref: `assets/source/factory location.jpg` | Long polycarbonate box over a dark timber/metal base, roof fins, climbing-plant cards. ClosedAI logo only *(user)* |
| Data-center interior + containment column | **Build new** | — | For scene 11 |
| Road kit (2-lane, highway, merge, barriers, guardrails, signs) | **Build new** | Ref road photos | Modular pieces snapped along a spline *(proposed)* |
| Train, track, crossing | **Build new** | — | Locomotive + repeated freight cars |
| Trees (3–4 conifers, 2 broadleaf/birch), rocks, ferns | **Build new** or Roblox-allowed free assets | — | Must be light: see §5 |
| Terrain | Roblox Terrain | — | Hills, ground cover, MaterialVariants (§4) |
| Old brick plant (archibase factory) | **Not used** | — | Kept in `assets/source/` only |

## 3. Blender → Roblox pipeline *(proposed)*

Blender 5.2 is installed. Note: its **3DS importer isn't bundled**. Get the
"Import-Export: 3DS" extension, or use the OBJ files.

1. **Import & clean.** Apply transforms, merge by distance, delete hidden or
   interior faces, fix normals. Set the size in metres (archibase files are
   in millimetres).
2. **Split.** One MeshPart per logical piece and per material. Keep each one
   **under 20k triangles** (aim for 5–10k on props).
3. **Decimate / retopo.** Decimate (collapse) on organic parts, and
   rebuild hard-surface parts by hand when decimation breaks them.
4. **UV.** Keep good existing UVs. Otherwise Smart UV Project, one
   0–1 set per mesh, and trim sheets for repeated surfaces (timber, metal).
5. **Bake.** High → low normal map, plus AO multiplied into the colour.
   Output **1024 × 1024** maps: Color, Normal, Roughness, Metalness.
6. **Export.** FBX, one file per asset into `assets/export/<asset>/`, with
   textures beside it. Check the size against a 5-stud dummy character in
   the importer preview.
7. **Import into Roblox.** Use the 3D Importer. Apply `SurfaceAppearance`
   with the four maps. `CollisionFidelity = Box/Hull` on everything except
   walkable floors, and `RenderFidelity = Automatic`.
8. **Version.** Save the `.blend` and the export into `assets/` (Git LFS),
   and export finished Studio models as `.rbxm` (LFS).
   `.gitignore` currently ignores all `*.rbxm`, so it needs an
   `!assets/**/*.rbxm` exception.

## 4. Lighting & atmosphere recipe *(proposed starting values)*

| Setting | Value | Why |
|---|---|---|
| `Lighting.Technology` | Future | Real-time shadows from lamps and headlights *(user: Future)* |
| `ClockTime` | 22.5 | Night heist |
| `Brightness` / `ExposureCompensation` | 1 / −0.3 | Moody but readable |
| `Ambient` / `OutdoorAmbient` | (20,22,26) / (60,66,72) | Cold blue-grey night |
| `EnvironmentDiffuseScale` / `EnvironmentSpecularScale` | 1 / 1 | PBR reflections on wet surfaces |
| `Atmosphere` | Density 0.42, Offset 0.2, Haze 2.4, Glare 0, Color (170,180,185), Decay (90,100,105) | Valley fog like the cabin photo |
| `ColorCorrection` | Saturation −0.15, Contrast 0.1, TintColor (225,235,240) | Desaturated, damp look |
| `Bloom` | Intensity 0.6, Size 24, Threshold 1.6 | Warm windows and headlights glow |
| `DepthOfField` | Off in gameplay, on in cutscenes | Cinematic shots |
| Cabin interior | Warm PointLights / SurfaceLights (2700 K) | The glass-front glow from the photo |
| Basement den | RGB SurfaceLights cycling colour | Story: lit by RGB only |
| Road | Sparse sodium lamps on the highway only; two-lane is dark (headlights) | Contrast between the sections |
| Rain | Client-side ParticleEmitter on a part that follows the camera, plus rain sound | Cheap; no server cost |
| Terrain MaterialVariants | `WetAsphalt` (Asphalt, low roughness), `Moss`, `ForestFloor` (Ground), `MountainRock` (Rock), `Gravel` | Realism without extra meshes |

## 5. Streaming & performance budget *(proposed)*

- `Workspace.StreamingEnabled = true`, `StreamingTargetRadius = 1024`,
  `StreamingMinRadius = 256`, `StreamOutBehavior = Opportunistic`.
- Chase speed ~100 km/h ≈ **100 studs/s**, so the target radius covers
  about 10 s ahead. The server also calls `RequestStreamAroundAsync` ahead
  of the car.
- `ModelStreamingMode`: the **house = Atomic** (loads whole while you're in
  it), road chunks = Default, the **train + crossing = Persistent** (it must
  exist when the chase scripts need it), cutscene camera markers =
  Persistent.
- Triangle budget per view (PC target, mobile at about half):

| Area | Budget |
|---|---|
| House exterior + interior in view | ≤ 250k tris |
| Robotaxi | ≤ 30k |
| Characters & NPCs (4 Scams + Admin + Mom + cat) | ≤ 70k |
| Forest in view (instanced trees, auto LOD) | ≤ 600k |
| Factory hall + clearing | ≤ 200k |

- Trees: 4–6 **reused** mesh variants. Same MeshId + same
  SurfaceAppearance batches into instanced draws. Each variant ≤ 3k tris,
  and LOD comes from `RenderFidelity = Automatic`. Collision only on trunks
  near the road (`CanCollide = false` elsewhere).
- Target density about **1 tree per 400 sq studs** within 300 studs of the
  road. Beyond that, terrain hills plus a skyline ring of tree-silhouette
  cards.
- Lights: Future lighting is expensive. Shadow-casting lights ≤ 8 in view;
  everything else `Shadows = false`.
- Mobile: a client setting drops rain particles, Bloom and DepthOfField
  and lowers Atmosphere density.

## 6. Build order *(proposed)*

1. **Greybox world (Studio parts + terrain).** House plot, 3 km road path,
   merge, crossing, factory plot. Drive it with a placeholder car to check
   the timing (~1.8 min).
2. **Greybox house.** Three floors with walls, stairs, entry points and the
   roof window. Playtest the stealth routes.
3. **Lighting & atmosphere pass** on the greybox (§4).
4. **First Blender asset: the cabin shell.** Proves the whole pipeline end
   to end.
5. **Robotaxi** (de-badge, reshape, decimate) and the drivable chassis.
6. **Road kit + forest** scattering along the road.
7. **Train crossing** set piece.
8. **Factory exterior**, then the data-center interior and the column.
9. Robot workers, props, dressing, then an optimisation pass.

## 7. Model inspection report (2026-11-08)

Measured headless in Blender 5.2 (the Blender MCP wasn't connected).

| Model | Triangles | Size (m) | Materials / textures | Match to reference |
|---|---|---|---|---|
| Log House N090324 (.obj/.3ds) | ~750k, 118 objects (largest 65k) | 19.4 × 13.9 × 9.8 (file in mm) | 9 materials (Stone, Wood_Log ×4, Roof, Glass, Brick, Plastic), 5 PNG textures | **Poor.** Ornate Russian log house with a shingle roof, porches and a turret, compared with the minimalist dark cabin. The stone base is the most reusable part |
| Building factory N190616 (.3ds) | ~172k, 495 objects (largest 10k) | 123 × 72 × 62 (file in mm) | 8 materials, 1 texture (WALL_002) | **Poor.** Old brick/concrete industrial plant with loose floating parts (roof, a door) compared with the translucent forest hall |
| Tesla Roadster 2020 (.fbx) | ~609k, 85 objects (body 118k, each wheel 27k) | 4.6 × 1.9 × 1.2 (real size) | 26 materials, tyre/fabric textures up to 4K | **Good** as a car base. Needs de-badging, reshaping and heavy decimation |
| Tesla Bot (.fbx) | ~5k, 1 mesh, **rigged + 1 animation** | 2.0 tall | 1 material, 2K colour/normal/roughness | **Good** for robot workers. Nearly Roblox-ready (downscale textures to 1K) |
| Tesla Bot Female (.fbx) | ~161k, 1 mesh, no rig | 1.4 tall (odd scale) | 3 materials, no textures | **Fair.** Needs decimation, a rig and textures |
