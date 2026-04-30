# OpenMusic Evolution Plan: From Prototype to Power-App

This document outlines the strategic roadmap to transform OpenMusic into a versatile, high-fidelity music application similar to YouTube Music, following Clean Architecture principles and professional audio processing.

## 🎯 Vision
Transform the current search prototype into a robust, open-source music management system that supports local storage, audio optimization (decoding/transcoding), and a professional user experience.

## 🏗️ Architectural Shift: Clean Architecture
The project will move from a simple layered structure to Clean Architecture to ensure scalability and independence from data sources.

### Layers:
- **Domain (Core Logic):**
  - **Entities:** Pure data models (e.g., `Track`, `Playlist`).
  - **Use Cases:** Business rules (e.g., `PlayTrackUseCase`, `DownloadAndOptimizeUseCase`).
  - **Repository Interfaces:** Contracts defining data operations.
- **Data (Implementation):**
  - **Repositories:** Implementation of domain interfaces.
  - **Data Sources:** 
    - `RemoteDataSource` (YouTube API).
    - `LocalDataSource` (File system, Isar DB).
    - `AudioProcessor` (FFmpeg for transcoding).
- **Presentation (UI):**
  - **State Management:** Riverpod or BLoC for complex states (playback queue, download progress).
  - **UI Components:** Material 3, YouTube Music style.

---

## 🗺️ Implementation Roadmap

### Phase 1: Infrastructure & Core (The Foundation)
- [ ] **Folder Restructuring:** Migrating to `core/`, `features/[feature]/domain|data|presentation`.
- [ ] **Local Database Migration:** Replace `shared_preferences` with **Isar** (NoSQL) for high-performance local catalog management.
- [ ] **Environment Management:** Implement strict `--dart-define` for all API keys to ensure Open Source safety.

### Phase 2: Audio Engine & Optimization (The "Power" Layer)
- [ ] **FFmpeg Integration:** Implement `ffmpeg_kit_flutter` for:
  - **Transcoding:** Converting YouTube streams to high-quality local formats (FLAC/AAC 320kbps).
  - **Normalization:** Consistent volume across all tracks.
  - **Metadata Extraction:** Proper ID3 tag handling.
- [ ] **Professional Download System:**
  - Implement `dio` and `path_provider` for physical file management.
  - Create a `DownloadManager` with states: `Pending` $\rightarrow$ `Downloading` $\rightarrow$ `Completed` $\rightarrow$ `Failed`.
- [ ] **Hybrid Playback Logic:** Implement priority: `Local File` $\rightarrow$ `High-Quality Stream` $\rightarrow$ `Standard Stream`.

### Phase 3: Business Logic & State (Domain & State)
- [ ] **UseCase Implementation:** 
  - `PlayTrackUseCase`: Intelligent source selection.
  - `DownloadTrackUseCase`: End-to-end process (Download $\rightarrow$ Optimize $\rightarrow$ Store).
- [ ] **Advanced State Management:** Integrate **Riverpod** to manage the global playback state and audio queue across screens.

### Phase 4: UI/UX Overhaul (The "YouTube Music" Experience)
- [ ] **Main Navigation:** Implement BottomNavigationBar (Home, Explore, Library).
- [ ] **Advanced Player:**
  - **Mini-Player:** Persistent bottom bar.
  - **Full-Screen Player:** Expanded view with advanced controls and quality settings.
- [ ] **Library Management:** Screens for managing downloads and offline playlists.

### Phase 5: Open Source Readiness & Quality
- [ ] **Technical Documentation:** `CONTRIBUTING.md` and enhanced `README.md`.
- [ ] **Automated Testing:** Unit tests for Use Cases and Integration tests for the Audio Engine.
- [ ] **Performance Profiling:** Optimizing memory usage during audio decoding.

---

## 🛠️ Target Tech Stack
- **Architecture:** Clean Architecture.
- **State Management:** Riverpod.
- **Local DB:** Isar.
- **Audio Engine:** `just_audio` + `ffmpeg_kit_flutter`.
- **Networking/Storage:** `dio` + `path_provider` + `youtube_explode_dart`.
