# RAG Chat WebApp — Demo Script

Goal: show upload → ask → answer-with-sources in under 3 minutes.

## Setup (before demo)

1. Start the app: `cd flutter_app && flutter run -d chrome` (mock mode by default).
2. Prepare 2-3 sample files locally (`2023-financial-report.pdf`, `company-overview.pdf`, `employee-handbook.txt`).
3. If demoing the real pipeline: run with
   `flutter run -d chrome --dart-define=USE_MOCK=false --dart-define=SUPABASE_URL=<url> --dart-define=SUPABASE_ANON_KEY=<anon key>`
   and confirm Person B's Edge Functions + `uploads` bucket are live.

## Script (2.5 min)

1. **Upload (0:45)**
   - Open the Upload tab.
   - Tap "Add files" and pick 2-3 files.
   - Point out each row's lifecycle: queued → uploading → processing → processed ✓.
   - Note: processing happens automatically — no extra clicks.

2. **Ask (0:45)**
   - Switch to the Chat tab.
   - Ask: "What was the revenue in 2023?"
   - Point out the "Thinking…" indicator while the answer streams back.
   - Answer shows with the source: `Sources: 2023-financial-report.pdf`.

3. **Fallback (0:30)**
   - Ask something out of scope, e.g. "What is the capital of France?"
   - Shows the "couldn't find relevant information" fallback — proves retrieval is real, not scripted.

4. **Error handling (0:30) — optional, mock mode**
   - Upload tab → toggle "Simulate upload failure (mock)" → add a file.
   - Shows the ✗ failed state + error message, then turn the toggle off.

## Tips

- Keep the questions grounded in real uploaded files so the demo feels genuine.
- If a file fails in real mode, check: `uploads` bucket exists, RLS allows anon uploads, Edge Functions are deployed.
