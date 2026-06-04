## Repository Map

A full codemap is available at `codemap.md` in the project root.

Before working on any task, read `codemap.md` to understand:
- Project architecture and entry points
- Directory responsibilities and design patterns
- Data flow and integration points between modules

For deep work on a specific folder, also read that folder's `codemap.md`.

## Cloned Dependency Source

Read-only dependency source repositories are available under
`.slim/clonedeps/repos/` for inspection. Do not edit these clones.

- `.slim/clonedeps/repos/cfug__dio/` — `cfug/dio` at `dio_v5.9.2`; inspect `dio/` for HTTP client internals.
- `.slim/clonedeps/repos/mobxjs__mobx.dart/` — `mobxjs/mobx.dart` at `mobx-2.6.0`; inspect `mobx/`, `flutter_mobx/`, and `mobx_codegen/` for store/runtime/codegen behavior.
- `.slim/clonedeps/repos/flutter-it__get_it/` — `flutter-it/get_it` pinned to `f4396cc0f23d84ddb4b07f656a10d661862f7349`; inspect the repo root for DI/service-locator internals.
- `.slim/clonedeps/repos/tekartik__sembast.dart/` — `tekartik/sembast.dart` at `sembast/v3.8.8`; inspect `sembast/` and `sembast_web/` for local persistence internals.
- `.slim/clonedeps/repos/flutter__packages/` — `flutter/packages` at `shared_preferences-v2.5.5`; sparse checkout includes `packages/shared_preferences/shared_preferences/` for settings persistence internals.
