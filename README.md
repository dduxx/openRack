# openRack

A collection of OpenSCAD assemblies and libraries for 3D-printing rack-mountable
homelab accessories. Supports both 19-inch and 10-inch racks.

## Assemblies

### Faceplate

| Assembly | 19" | 10" | Description |
|---|---|---|---|
| **Patch Panel** | 3 sections (L/M/R, 6 jacks/section) | 2 sections (L/R, 5 jacks/section) | Keystone jack faceplate for network/AV keystones |
| **Join Key** | ✓ | ✓ | Connector key for securing faceplate sections together |

### Power

| Assembly | 19" | 10" | Description |
|---|---|---|---|
| **Powerbar Mount** | 3 sections (L/M/R) | 2 sections (L/R) | Front-mounted bracket for securing a power bar |
| **Retention Nut** | ✓ | ✓ | Threaded nut for securing power bar to the mount |

### HDD / JBOD

| Assembly | 19" | 10" | Description |
|---|---|---|---|
| **JBOD Enclosure** | 3 sections (L/M/R, 3 drives/section) | 2 sections (L/R, 2 drives/section) | JBOD enclosure for 3.5" drives |
| **HDD Sled** | ✓ (default) | ✓ | 3.5" drive sled |
| **HDD Sled (2.5")** | ✓ (adapter) | ✓ | 2.5" drive adapter sled |

### Rack Studs

| Assembly | 19" | 10" | Description |
|---|---|---|---|
| **Bracket** | ✓ | ✓ | Tool-less rack stud bracket |
| **Nut** | ✓ | ✓ | Threaded nut for rack stud bracket |

## Build

This project uses [buildscad](https://github.com/dduxx/buildscad) to compile
`.scad` sources into STL, PNG, and 3MF outputs.

```bash
buildscad build
```

Requires an OpenSCAD binary (`openscad-nightly` by default).

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
