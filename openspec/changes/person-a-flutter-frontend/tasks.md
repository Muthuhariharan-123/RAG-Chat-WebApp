# Frontend Engineer — Flutter Frontend: Tasks

## 1. Project Setup

- [x] 1.1 Create Flutter web project `flutter_app/` (e.g., `flutter create --platforms=web flutter_app`)
- [x] 1.2 Add dependencies `supabase_flutter`, `file_picker` to `pubspec.yaml` and run `flutter pub get`
- [x] 1.3 Define the `useMock` runtime switch (`--dart-define` + const default) in `main.dart`
- [x] 1.4 Create the `lib/` structure (models, services, screens, widgets, change_notifiers per design)

## 2. Core Models & RagApi Contract

- [x] 2.1 Implement `FileItem` model with name, bytes, and status enum (`queued/uploading/processing/processed/failed`)
- [x] 2.2 Implement `AskResponse` model (`answer`, `sources`) and `ProcessResult` model (`chunksCreated`)
- [x] 2.3 Define abstract `RagApi` interface with `ask()` and `processFile()`
- [x] 2.4 Add JSON (de)serialization helpers matching the frozen contract shapes from design.md

## 3. MockRagApi (Phase 1 — default)

- [x] 3.1 Implement `MockRagApi` with hardcoded Q&A pairs grounded in the demo files
- [x] 3.2 Add fallback answer for questions not in the canned set
- [x] 3.3 Add ~1s simulated delay to `ask` and `processFile`
- [x] 3.4 Add debug toggle to force an upload/process failure for exercising the error UI

## 4. App Shell

- [x] 4.1 Implement `HomeScreen` with bottom navigation tabs (Upload / Chat) and state preservation
- [x] 4.2 Wire the `useMock` switch to select `MockRagApi` (or `SupabaseRagApi` in Phase 2) at startup
- [x] 4.3 Add minimal theming (Material 3, title, colors)

## 5. Upload Screen

- [x] 5.1 Implement `UploadScreen` with an "Add files" action using `file_picker` for `.txt`/`.pdf`
- [x] 5.2 Enforce the 10-file session limit and reject unsupported types with visible messages
- [x] 5.3 Implement `UploadStore` (ChangeNotifier) tracking file list and per-file status
- [x] 5.4 Implement `FileTile` widget showing name + status + progress indicator
- [x] 5.5 Implement the auto-process flow: upload completes → immediately call `processFile()`
- [x] 5.6 Show `failed` status + error message on upload/process errors
- [x] 5.7 Verify mock upload flow: queued → uploading → processing → processed (and forced-failure path)

## 6. Chat Screen

- [x] 6.1 Implement `ChatScreen` with scrollable message list, input field, and send action
- [x] 6.2 Ignore empty/whitespace-only sends
- [x] 6.3 Implement `MessageBubble` widget for user and bot messages
- [x] 6.4 Show loading/typing indicator while an answer is pending
- [x] 6.5 Render answer sources under the bot message when present
- [x] 6.6 Display a user-visible error message in the conversation when `ask()` throws
- [x] 6.7 Verify mock chat: canned Q&A returns, unknown questions return the fallback

## 7. SupabaseRagApi (Phase 2 — integration)

- [x] 7.1 Implement `SupabaseService` initializing the Supabase client from URL + anon key (fail-fast without credentials)
- [x] 7.2 Implement `SupabaseRagApi.processFile()`: upload bytes to the `uploads` bucket, then invoke `process-file` with `{fileName, storagePath}`
- [x] 7.3 Implement `SupabaseRagApi.ask()`: invoke `ask-question` with `{question}`, map response to `AskResponse`
- [x] 7.4 Map Edge Function errors to typed errors rendered by the UI
- [ ] 7.5 Flip the app to real mode (`useMock=false`) and verify full upload → process → ask round-trip against the Backend Engineer's functions

## 8. Demo Prep

- [ ] 8.1 Confirm canned mock Q&A aligns with the Backend Engineer's 10 sample files
- [x] 8.2 Run `flutter analyze` and `flutter test` (if any tests exist) and fix all issues
- [x] 8.3 `flutter build web` and verify the release build runs in a browser
- [x] 8.4 Prepare a short demo script (upload files → ask question → show sources)
