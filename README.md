# Knovator Task – Local-first Posts App

This Flutter app demonstrates a simple local-first architecture for listing posts, viewing a post's details, and persisting data offline. It loads cached data first (if available), then performs a background sync with the API to refresh the UI and store the latest data locally.

## Overview

- Local-first data strategy using Hive to persist posts and read-status
- BLoC for presentation logic and state
- Retrofit + Dio for networking
- Offline view: app shows locally stored posts even when offline
- Read tracking: tapping a post marks it as read and updates UI

## Architecture

The project follows a layered approach with clear separation of concerns:

- `feature/` – Presentation layer (UI widgets + BLoC)
  - `feature/posts/` – Posts list screen and its BLoC
  - `feature/post_detail/` – Post detail screen and its BLoC
- `service/api_service/` – Networking layer
  - Retrofit client interfaces and generated implementations (Dio-based)
  - A thin API facade that exposes typed methods to the app
- `service/storage_service/` – Local storage (Hive) helpers and persistence utilities
- `model/` – Domain/data models (JSON-serializable)

Data flow:
1. UI dispatches a BLoC event to load posts.
2. BLoC emits cached data immediately if present.
3. BLoC fetches fresh data from API in the background.
4. Hive helper persists the fresh data, retaining per-item read flags.
5. BLoC emits the refreshed data to update the UI.

Read tracking:
- A post is marked as read on tap. The read flag is stored in Hive and used to color cards and to filter the list by read/unread.

## Key Directories & Files

- `lib/main.dart` – App entry; initializes Hive via `HiveHelper.init()` and wires BLoCs
- `lib/service/api_service/` – API client (Dio + Retrofit) and API facade
- `lib/service/storage_service/hive_helper.dart` – Hive initialization, read/save posts, read-status helpers
- `lib/model/posts_model.dart` – `PostsModel` JSON model (json_serializable)
- `lib/feature/posts/`
  - `bloc/` – `PostsBloc`, events, and states
  - `view/home_page.dart` – Posts list with read/unread filter and refresh
  - `widget/post_card.dart` – Post tile UI (read-state aware)
- `lib/feature/post_detail/` – Detail BLoC and screen

Note: If you moved or renamed storage files, ensure imports match your current structure.

## Third-party Libraries

- Dio – HTTP client
- Retrofit (retrofit + retrofit_generator) – Type-safe API client generator
- json_serializable + build_runner – Code generation for JSON models
- BLoC (bloc + flutter_bloc) – State management for presentation layer
- Hive + hive_flutter – Lightweight key-value storage for offline persistence

See `pubspec.yaml` for exact versions.

## Running the App

Prerequisites:
- Flutter SDK installed and on PATH
- A simulator/emulator or a connected device

Install dependencies:

```bash
flutter pub get
```

Run (choose one of the following):

```bash
flutter run -d chrome       # Web
flutter run -d ios          # iOS
flutter run -d android      # Android
```

If you change Retrofit/json_serializable models, regenerate code with:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Offline Strategy

- On startup or refresh, the UI asks the BLoC to load posts.
- Cached posts from Hive are displayed first, enabling instant UI and offline support.
- A background API call fetches the latest posts; once received, the cache is updated and the UI is refreshed.
- On failures, if cache exists, the UI remains usable; otherwise, an error is shown.

## Read/Unread Behavior

- Tapping any post marks it as read in Hive.
- Read status is reflected by card background color and can be used to filter the list (All/Unread/Read).

## Project Decisions

- BLoC was chosen to keep UI simple and declarative while encapsulating side effects (API, cache).
- Hive was selected for fast, simple local persistence without requiring a heavy ORM.
- Retrofit + Dio provide a clean abstraction over HTTP and generate strongly-typed clients.

## Troubleshooting

- If you see build errors from generated files, re-run build_runner:
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
  ```
- If Hive throws adapter/typeId errors, ensure adapters and typeIds are consistent with current stored boxes. Clearing app storage (or uninstalling app) can resolve legacy data conflicts during development.

