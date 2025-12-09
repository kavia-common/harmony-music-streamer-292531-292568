# Harmony Music - Native (Flutter)

This is the Flutter-based native client for the Harmony Music streaming application.
It includes an initial app shell with Ocean Professional theme, tab navigation, and mock services.

## Features in this seed
- Ocean Professional theme (blue primary, amber accents, minimalist surfaces)
- Bottom navigation with four tabs:
  - Discover (Trending tracks, Recommended albums - mock data)
  - Search (query mock data)
  - Library (mock playlists)
  - Now Playing (PlaybackService stub with play/pause/seek)
- Shared UI components: GradientHeader, TrackListTile, AlbumCard
- DataService (mock) and PlaybackService (stateful stub only)
- No external services or APIs integrated

## Run Instructions

Prerequisites:
- Flutter SDK (3.4 or compatible with Dart SDK ">=3.4.0 <4.0.0")
- Android/iOS tooling as per Flutter setup guides

Steps:
1. From the project root of this container:
   ```
   flutter pub get
   flutter run
   ```
2. If platform folders are missing (android/ios/macos/windows/web), you can generate them:
   ```
   flutter create .
   ```
3. Container startup (CI/Preview):
   - Use the provided script which avoids complex bash constructs:
     ```
     bash scripts/start.sh
     ```
   - The script will:
     - Run flutter pub get
     - Generate missing platform folders via flutter create .
     - Run a non-fatal flutter analyze
     - Keep the container alive (override with KEEP_ALIVE=0)

Notes:
- The included `scripts/android-build.sh` expects a full Android setup with Gradle wrapper (`android/gradlew`) which is created by `flutter create .`.
- For CI environments without SDKs, you can still run Dart/Flutter analyzer and unit tests if added later.
- If your orchestrator previously used a multi-line or heredoc bash -c start command, point it to scripts/start.sh to avoid "bash: -c: line 2: syntax error: unexpected end of file".

## TODOs (Future Integration)
- Integrate actual audio playback engine (e.g., just_audio) in `PlaybackService`
- Wire DataService to backend API once available
- Add authentication flow
- Playlist management (create, edit, reorder)
- Offline caching and downloads
- Deep linking and media notification controls
- Add widget tests and golden tests

## Style Guide
The app follows the "Ocean Professional" theme:
- primary: #2563EB
- secondary: #F59E0B
- error: #EF4444
- background: #F9FAFB
- surface: #FFFFFF
- text: #111827

Design principles:
- Modern, clean UI
- Rounded corners (12–20 radius)
- Subtle shadows
- Smooth transitions and minimal visual noise
