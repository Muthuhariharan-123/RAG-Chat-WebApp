# Frontend Engineer — Flutter Frontend (Mock-First)

## Why

The 2-person RAG demo plan splits work as **Frontend Engineer = Flutter frontend** and **Backend Engineer = Supabase backend/AI pipeline**. The frontend must be buildable **today without waiting on the Backend Engineer** — the backend (Supabase project, Edge Functions, pgvector, LLM) doesn't exist yet. We need a mock-first Flutter web app that runs fully on hardcoded data first, then swaps to the Backend Engineer's real Supabase endpoints via a single flag when integration begins.

## What Changes

- Create a new Flutter web app in this repo (`flutter_app/`) with an Upload screen and a Chat screen connected by tabs.
- Build the entire UI against a **mock API** (`MockRagApi`) with canned, file-grounded Q&A data — no Supabase dependency required to run.
- Define a clean `RagApi` interface as the contract with the Backend Engineer; ship a `SupabaseRagApi` implementation (SDK-based) that activates on a flag flip.
- Upload screen: pick `.txt`/`.pdf` files (max 10), per-file status (queued → uploading → processing → processed/failed), **auto-process** on upload.
- Chat screen: question input, message list (user/bot bubbles), loading indicator, answer with source file names.
- Supabase wiring (SDK init, storage upload, `process-file`, `ask-question`) prepared but only activated in Phase 2.
- **BREAKING**: none — this is a greenfield build.

## Capabilities

### New Capabilities
- `app-shell`: Flutter web app scaffolding, tab navigation (Upload / Chat), theme, mock↔real runtime switch, Supabase initialization.
- `file-upload`: Upload screen — file picking with type/count limits, per-file status lifecycle, auto-process behavior, upload to Supabase Storage.
- `rag-chat`: Chat screen — message list, input box, loading/typing indicator, answer rendering with sources.
- `rag-api-client`: The `RagApi` contract (interface + models), `MockRagApi` implementation, and `SupabaseRagApi` implementation calling the Backend Engineer's Edge Functions.

### Modified Capabilities
- None (no existing specs).

## Impact

- **New code**: `flutter_app/` directory (Flutter web project).
- **Dependencies**: `supabase_flutter`, `file_picker` (added to `pubspec.yaml`).
- **External contract** (agreed with the Backend Engineer): Supabase bucket `uploads`, Edge Functions `process-file` and `ask-question`, JSON request/response shapes defined in specs.
- **No impact** on existing code — the repo currently contains only planning docs.
