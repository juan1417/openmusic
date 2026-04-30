# Openmusic Agent Guide

Use this repo as a minimal Flutter scaffold for a Spotify-like prototype.

## Project shape
- Main app shell: `lib/main.dart`, `lib/app/app.dart`, `lib/app/theme.dart`
- Feature-first structure: `lib/features/`
- Mock/demo data lives in feature data files, not in the widget tree
- Keep generated folders like `build/` and `.dart_tool/` out of source changes

## Conventions
- Prefer Flutter and Material 3 patterns already used in the repo
- Keep UI dark-themed unless explicitly requested otherwise
- Preserve the feature-first split between presentation, domain, and data
- Use small composable widgets over large mixed files
- Follow `analysis_options.yaml`: const constructors, final locals, single quotes, explicit return types
- Keep architectural changes incremental and consistent with `.agent/instructions/architecture.instructions.md`

## Product & Audio Rules
- YouTube: Catalog/source integration point only; NOT for downloadable FLAC/AAC/WAV
- High Quality (FLAC/AAC/WAV): Only for owned/licensed audio or server-transcoded assets
- Search: By title, artist, and source; prefer fast local filtering
- Recommendations: Simple signals (saved, recent, source); fallback to popular
- Downloads: Owned/licensed only; track states (pending, downloading, completed, failed)
- Playlists: Support CRUD + reorder; keep order stable and deterministic

## Commands to assume
- `flutter test`
- `flutter analyze`
- `flutter run`
- `flutter pub run build_runner build` (for codegen/json_serializable)

## Before changing code
- Read `README.md` for the current scope
- Prefer the smallest change that solves the task
- Validate the touched area with the narrowest useful check

## Related customization files
- Architecture guidance: `.agent/instructions/architecture.instructions.md`
- Core features: `.agent/instructions/core-features.instructions.md`
- UI/component agent files: `.agent/agents/`
- Prompt and skill files: `.agent/prompts/` and `.agent/skills/`
