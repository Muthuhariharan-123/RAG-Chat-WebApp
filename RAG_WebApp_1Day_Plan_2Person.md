# RAG Chat WebApp — 1-Day Build Plan

**Flutter Web + Supabase (pgvector) + LLM | 2-Person Team**

## Project Overview

A simple RAG (Retrieval-Augmented Generation) web app. The user uploads up to 10 files, the text is extracted, chunked, converted into embeddings (vectors), and stored in Supabase using the pgvector extension. When the user asks a question, the query is embedded, matched against stored chunks, and the relevant context is passed to an LLM to generate an answer. This is a proof-of-concept — accuracy of results is not the priority, getting the full pipeline working end-to-end in one day is.

## Pipeline Flow

```
Upload files → extract text → chunk text → generate embeddings → store vectors in Supabase

Ask question → embed question → similarity search in Supabase → send matched chunks + question to LLM → show answer in Flutter UI
```

## Tech Stack

| Layer | Choice |
|---|---|
| Frontend | Flutter Web |
| Database / Vector Store | Supabase (Postgres + pgvector extension) |
| File Storage | Supabase Storage |
| Embeddings | OpenAI text-embedding-3-small (or free alternative) |
| LLM (Answer Generation) | OpenAI gpt-4o-mini (or any cheap/free-tier model) |
| File formats (MVP) | .txt and .pdf only — keep parsing simple |

## Supabase Table (Schema)

```sql
create table documents (
  id uuid default gen_random_uuid() primary key,
  content text,
  embedding vector(1536),
  file_name text,
  created_at timestamp default now()
);
```

## Team Split — 2 Persons

With 2 people, split the work as **Frontend vs Full Backend Pipeline**. Person B owns everything server-side (Supabase, embeddings, and LLM call combined) since it's one continuous pipeline. Person A owns the entire Flutter UI and connects it to Person B's endpoints. Both work independently in parallel using a shared "contract" (table schema + expected JSON request/response) agreed in the first 15 minutes, so nobody is blocked waiting on the other.

### Person A — Flutter Frontend

- Build Upload screen (pick files, list up to 10, upload progress)
- Build Chat/Question screen (input box, answer display, loading state)
- State management (keep simple — setState or Provider)
- Connect UI to Supabase Storage for file uploads
- Call Person B's endpoints for 'process file' and 'ask question'
- Handle loading/error states in UI
- Polish UI + prep demo screens

### Person B — Backend & AI Pipeline

- Set up Supabase project, enable pgvector, create documents table
- Write 'process-file' function: extract text → chunk → embed → insert into DB
- Write 'match_documents' SQL function (similarity search)
- Write 'ask-question' function: embed query → retrieve chunks → build prompt → call LLM
- Test all functions using Postman / curl / SQL editor (no UI needed)
- Prep 10 sample files for the demo

> **Note:** Person B's work has no visual UI at all — it's tested entirely with Postman/curl/SQL editor. Person A builds against dummy/mock JSON data first, then swaps in Person B's real endpoint URLs once they're ready (around the midpoint of the day).

## Hour-by-Hour Schedule (1 Day, ~8 hours)

| Time | Person A — Flutter | Person B — Backend/AI |
|---|---|---|
| 0:00–0:30 | Setup Flutter project, add supabase_flutter dependency | Create Supabase project, enable pgvector, create documents table, share keys with A |
| 0:30–1:30 | Build Upload screen UI (dummy data, no real logic yet) | Write 'process-file' function skeleton: extract text + chunk (no embedding yet) |
| 1:30–2:30 | Build Chat/Question screen UI (input, answer bubble, loading state) | Finish process-file: hook in embeddings, insert real rows into documents table |
| 2:30–3:30 | Connect Upload screen to real Supabase Storage for file upload | Write match_documents SQL function + test manually in SQL editor |
| 3:30–4:15 | Lunch / Break | Lunch / Break |
| 4:15–5:15 | Connect Chat screen to Person B's ask-question endpoint (still testing with mock JSON if not ready) | Write ask-question function: embed query → match → build prompt → call LLM |
| 5:15–6:15 | Both together: wire real end-to-end flow — upload real files, ask real questions | Both together: wire real end-to-end flow — upload real files, ask real questions |
| 6:15–7:15 | Fix bugs found during integration | Fix bugs found during integration |
| 7:15–8:00 | Polish UI, prep demo | Prep demo data (10 files ready), prep short pipeline explanation |

## Why This Split Works

- Both people start immediately — nobody waits idle. Person A builds UI against mock/dummy data while Person B builds the real pipeline underneath.
- Person B owns the entire server-side chain as one continuous piece of work (Supabase setup, embeddings, LLM call) since splitting it further across 2 people would create unnecessary handoffs.
- Integration happens once, around hour 5, when Person A swaps mock data for Person B's real endpoint URLs.
- Last ~2.5 hours are reserved for bug-fixing and polish — this always takes longer than expected in a 1-day build, so the buffer is built in on purpose.
- Keep it simple: fixed-size chunks, top-3 similarity match, and a basic 'answer only using this context' prompt is enough for a working demo — no reranking or advanced retrieval needed.

**Goal for the day:** a working end-to-end demo (upload files → ask a question → get an answer). Polish and accuracy are secondary — the pipeline working is the win.
