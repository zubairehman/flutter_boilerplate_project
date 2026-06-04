# android/app/src/

## Responsibility
Android source set root, partitioned into build-type directories (`main/`, `debug/`, `profile/`) that follow the standard Android Gradle source-set merge convention.

## Design Patterns
- **Build-type source sets**: `main/` contains production code and the primary manifest; `debug/` and `profile/` overlay additional manifests for development permissions. Gradle merges these at build time.

## Data & Control Flow
1. Gradle resolves the active build variant (debug, profile, release).
2. Sources from `main/` are always included; `debug/` or `profile/` overlays are merged for their respective variants.
3. Manifest merger combines `debug/AndroidManifest.xml` permissions into the merged manifest.

## Integration Points
- **android/app/build.gradle**: Declares which source sets exist implicitly via the standard `src/<buildType>` convention.
- **main/**: Full app definition — manifest, Kotlin code, resources.
- **debug/**: Internet permission overlay for Flutter dev tooling.
- **profile/**: Internet permission overlay for Flutter profiling builds.