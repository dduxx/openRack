# openRack

A collection of OpenSCAD assemblies and libraries for 3D-printing rack-mountable
homelab accessories. Supports both 19-inch and 10-inch racks.

## Assemblies

### Faceplate

| Assembly | 19" | 10" | Description |
|---|---|---|---|
| **Patch Panel** | 3 sections (L/M/R, 6 jacks/section) | 2 sections (L/R, 5 jacks/section) | Keystone jack faceplate for network/AV keystones |
| **Join Key** | ✓ | ✓ | Connector key for securing faceplate sections together |
| **JBOD Enclosure** | 3 sections (L/M/R, 3 drives/section) | 2 sections (L/R, 2 drives/section) | JBOD enclosure for 3.5" drives |
| **Slot Mount** | 3 sections (L/M/R) | 2 sections (L/R) | Slotted faceplate for mounting accessories with M4 hardware |
| **Fan Panel** | 3 sections (L/M/R, 40mm or 80mm fans) | 2 sections (L/R, 40mm fans) | Ventilated faceplate for rack-mount cooling; 1 RU (40mm) or 2 RU (80mm) |

### Sleds

| Assembly | 19" | 10" | Description |
|---|---|---|---|
| **HDD Sled** | ✓ (default) | ✓ | 3.5" drive sled |
| **HDD Sled (2.5")** | ✓ (adapter) | ✓ | 2.5" drive adapter sled |

### Power

| Assembly | 19" | 10" | Description |
|---|---|---|---|
| **Retention Nut** | ✓ | ✓ | Threaded nut for securing accessories to slot mount faceplates |

### Rack Studs

| Assembly | 19" | 10" | Description |
|---|---|---|---|
| **Bracket** | ✓ | ✓ | Tool-less rack stud bracket |
| **Nut** | ✓ | ✓ | Threaded nut for rack stud bracket |

## Libraries

Reusable modules, functions, and constants live in `scad/lib/` and are available
for use in assemblies or your own projects.

| Library | Path | Description |
|---|---|---|
| **Faceplate** | `scad/lib/faceplate/` | Base faceplate generators, rack ear, and vented faceplate support |
| **Fan** | `scad/lib/fan.scad` | Fan cutout (`fan_negative`) and mounting hole (`fan_mounting_holes`) modules; constants for 40mm and 120mm fans |
| **Fasteners** | `scad/lib/fasteners/` | Parametric screws, nuts, and threaded rod modules |
| **HDD** | `scad/lib/hdd/` | Drive sled geometry and mount point modules |
| **Keystone** | `scad/lib/keystone/` | Keystone jack cutout and cluster layout modules |
| **Rack Units** | `scad/lib/rack_units.scad` | Constants for 19-inch and 10-inch rack dimensions |
| **Utils** | `scad/lib/utils/` | Utility modules (`ellipse.scad`, `list.scad`) |

## Dependencies

This project requires two external OpenSCAD libraries, declared in `deps.json`:

| Dependency | URL | Version |
|---|---|---|
| **BOSL2** | [BelfrySCAD/BOSL2](https://github.com/BelfrySCAD/BOSL2) | v2.0.741 |
| **scadUnitConversionLib** | [dduxx/scadUnitConversionLib](https://github.com/dduxx/scadUnitConversionLib) | v1.0.0 |

These are automatically resolved by buildscad at build time.

## Build

This project uses [buildscad](https://github.com/dduxx/buildscad) to compile
`.scad` sources into STL, PNG, and 3MF outputs.

```bash
buildscad build
```

Requires an OpenSCAD binary (`openscad-nightly` by default).

Pre-built artifacts (STL, PNG, 3MF) are published with each
[GitHub Release](https://github.com/dduxx/openRack/releases).

## CI / CD

- **CI** (`.github/workflows/ci.yml`) — Builds all assemblies on every pull
  request to validate changes before merging.
- **Release** (`.github/workflows/release.yml`) — On merge to `main`, the
  workflow auto-determines the next semantic version from conventional commit
  messages (`feat:` → minor, `fix:` → patch, `BREAKING CHANGE` → major), bumps
  `buildscad.properties`, tags the release, builds all artifacts, and publishes
  a GitHub Release with a zip of STL/PNG/3MF outputs.

## Contributions

Contributions are welcome. To contribute a new library, part, or assembly:

1. **Reusable libraries** (modules, functions, constants that other parts may
   depend on) go in `scad/lib/`.
2. **Finished assemblies** (or parametric part generators) go in
   `scad/assemblies/`.
3. Any new assembly must include corresponding entries in the
   `BUILDSCAD_ASSEMBLIES` section of `buildscad.properties` so it gets built.
4. Open a PR with your changes.

Feel free to fork this repo, use the libraries in your own projects, and share
your assemblies on sites like Thingiverse, Printables, or MakerWorld. Linking
back to this repository in your post descriptions is appreciated (though not
required) — it helps others discover the project.
