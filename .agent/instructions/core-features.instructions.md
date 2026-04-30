---
description: "Use when implementing or reviewing the core app functions: search, recommendations, downloads, and playlist creation in a single-piece Flutter project."
---
# Core Feature Guidelines

## Project shape
- Keep the app as one coherent codebase; do not split into extra packages or layers unless a task truly needs it.
- Prefer the existing feature-first structure already in the repo.
- Keep changes small, local, and easy to revert.

## Search function
- Search must work by track title, artist, and source.
- Prefer fast local filtering when the data is already loaded.
- Keep the search result order stable and predictable.
- If search is expanded later, keep the current local behavior as a fallback.

## Recommendation function
- Recommendations should be simple and explainable.
- Prefer signals like saved tracks, recent activity, repeated searches, and source type.
- Do not overengineer with heavy ML or complex ranking unless the project explicitly needs it.
- If there is no user history yet, fall back to curated or popular tracks.

## Download function
- Downloads are only for owned or licensed audio.
- Never treat YouTube content as downloadable audio unless a license or separate source explicitly allows it.
- Track download states clearly: pending, downloading, completed, failed, unavailable.
- Keep offline logic separate from playback logic.

## Playlist creator function
- Allow create, rename, delete, add, remove, and reorder actions when supported by the UI.
- Keep playlist order stable and deterministic.
- Prevent duplicate or invalid playlist names if the task asks for validation.
- Preserve track identity and playlist ownership when editing.

## Implementation rules
- Define the contract of each function before coding it.
- Keep each function focused on one job.
- Reuse existing models and state if they already express the behavior.
- Add or update tests for search, recommendation, downloads, and playlists when behavior changes.
- Validate with the narrowest useful check: targeted tests, lint, typecheck, or build.

## Source-specific rules
- YouTube is a catalog/source integration point, not the source of downloadable FLAC/AAC/WAV files.
- FLAC, AAC, and WAV apply only to owned or licensed audio or server-transcoded assets.
- If a feature depends on source permissions, make that rule explicit in code and UI.
