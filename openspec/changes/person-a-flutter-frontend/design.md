# Frontend Engineer — Flutter Frontend: Design

## Context

This is a greenfield build — the repo contains only planning docs. The 2-person plan splits the RAG demo into **Frontend Engineer = Flutter web frontend** and **Backend Engineer = Supabase backend/AI pipeline** (pgvector, Edge Functions, LLM). the Backend Engineer's stack is confirmed as Supabase. The frontend must be fully buildable and demoable before the Backend Engineer's endpoints exist, then integrate via a single switch.

## Goals / Non-Goals

**Goals:**
- Flutter web app with Upload and Chat screens that runs end-to-end against hardcoded mock data with zero backend dependencies.
- One interface (`RagApi`) as the shared contract; both mock and real implementations conform to it.
- Flip one flag to swap mock → real (Supabase SDK), enabling integration in minutes.
- Per-file upload status lifecycle with auto-process; chat with loading state and source citations.
- Supabase wiring (init, storage upload, Edge Function calls) present but inactive until Phase 2.

**Non-Goals:**
- No backend implementation (that's the Backend Engineer's responsibility). We only define the request/response contract.
- No streaming/SSE answers — synchronous request/response only.
- No true byte-level upload progress (SDK doesn't expose it on web); fake/indeterminate progress instead.
- No auth system — anonymous access using anon key + RLS policies set up by the Backend Engineer.
- No PDF/text parsing in the frontend — that's the Backend Engineer's pipeline.

## Decisions

### D1. Mock-first via dependency inversion
UI depends on an abstract `RagApi`; two implementations:

```dart
abstract class RagApi {
  Future<AskResponse> ask(String question);
  Future<ProcessResult> processFile(FileItem file);
}

class MockRagApi       implements RagApi { /* canned JSON + ~1s delay */ }
class SupabaseRagApi   implements RagApi { /* SDK calls to Edge Functions */ }
```

A single compile-time switch (`const bool useMock` or `--dart-define=USE_MOCK`) selects the implementation at app startup. Screens never reference concrete implementations.
*Alternative considered:* feature-flag at each call site → rejected, duplicates logic and risks missing a swap point.

### D2. Supabase via the official SDK
`supabase_flutter` handles init, Storage upload, and `functions.invoke(...)`. The SDK carries auth headers and Edge Function CORS is handled by Supabase's template, removing the raw-HTTP/CORS problem.
*Alternative considered:* raw `http` calls to Edge Function URLs → rejected, more CORS/header code for zero benefit.

### D3. Contract with the Backend Engineer (shared, frozen in Phase 1)
- **Bucket**: `uploads`, with an anon RLS insert policy (the Backend Engineer creates this — otherwise uploads 403).
- **`process-file`** (Edge Function, synchronous):
  ```json
  POST body: { "fileName": "2023-report.pdf", "storagePath": "uploads/<uuid>.pdf" }
  → 200: { "chunksCreated": 42 }
  ```
- **`ask-question`** (Edge Function, synchronous):
  ```json
  POST body: { "question": "What was revenue in 2023?" }
  → 200: { "answer": "...", "sources": ["2023-report.pdf"] }
  ```
- App uses the **anon key** only; never the service-role key.

### D4. Auto-process upload flow
Each selected file flows: `queued → uploading → processing → processed | failed`. Upload triggers `process-file` immediately. No intermediate "uploaded, not processed" state — fewer states, smoother demo.
*Alternative considered:* manual "Process files" button → rejected; adds a step and a state for no demo benefit.

### D5. State management: setState + one ChangeNotifier
Plain `setState` per screen; a single `ChangeNotifier` holds the shared uploaded-files list and question/answer history. No Provider/Bloc/Riverpod — a 1-day demo doesn't need it.
*Alternative considered:* Provider/Riverpod → rejected as over-engineering for this scope.

### D6. Fake upload progress
`storage.upload()` has no progress callback on web. Show indeterminate or simulated progress, then flip to `processed`/`failed`. True percentages are out of scope.

### D7. Mock is slow and fallible on purpose
`MockRagApi` adds a ~1s artificial delay so loading states are visible, and a debug toggle to simulate an upload failure so the error UI is exercised before demo day.

## Architecture

```
lib/
  main.dart                 # useMock switch + Supabase.initialize
  models/
    file_item.dart          # name, bytes, status enum
    ask_response.dart       # answer, sources
    process_result.dart     # chunksCreated
  services/
    rag_api.dart            # RagApi interface + AskResponse/ProcessResult
    mock_rag_api.dart
    supabase_rag_api.dart
    supabase_service.dart   # SDK init wrapper
  screens/
    home_screen.dart        # bottom tabs: Upload / Chat
    upload_screen.dart
    chat_screen.dart
  widgets/
    file_tile.dart
    message_bubble.dart
  change_notifiers/
    upload_store.dart
```

Phase 2 wiring: `supabase_flutter` init (`url`, `anonKey` via `--dart-define` or `.env`), `storage.from('uploads').upload(...)`, `functions.invoke('process-file'|'ask-question', ...)`.

## Risks / Trade-offs

- **[the Backend Engineer's bucket/RLS not ready] → Mitigation:** Upload stays mockable in Phase 1; only the flag flip requires the Backend Engineer's bucket. Add "create bucket + anon policy" to the Backend Engineer's checklist.
- **[Contract drift with the Backend Engineer]** → Frozen JSON shapes in D3; mock mirrors them byte-for-byte; integration is a flag flip.
- **[CORS on Edge Functions]** → SDK + Supabase template CORS handles it; verify early in Phase 2.
- **[No real upload progress]** → Accepted; fake progress is indistinguishable in a demo.
- **[Flutter web file picker returns bytes only]** → `file_picker` handles `.txt`/`.pdf`; no path metadata on web — upload always sends bytes.

## Migration Plan

Phase 1 (now): build app + mock, demoable standalone. Phase 2 (integration): flip `useMock=false`, supply real URL/anonKey, verify upload → process → ask round-trip. Rollback: flip flag back to `true`.

## Open Questions

- Exact sample file names + canned Q&A to match the Backend Engineer's demo files (deferred to integration hour).
- Whether the Backend Engineer wants `process-file` to also handle the case where an upload must be re-processed (same storagePath re-invoked). Not blocking.
