# RAG API Client

## ADDED Requirements

### Requirement: RagApi contract interface
The system SHALL define an abstract `RagApi` interface with `ask(question)` and `processFile(file)` methods, plus typed response models (`AskResponse`, `ProcessResult`, `FileItem`). All screens and services SHALL depend on this interface only.

#### Scenario: Screens depend on interface
- **WHEN** any screen or service invokes upload processing or question answering
- **THEN** it calls the active `RagApi` implementation through the interface, never a concrete class

### Requirement: MockRagApi implementation
The system SHALL provide a `MockRagApi` that returns hardcoded responses with a simulated delay, requires no network or Supabase connectivity, and is the default when the mock switch is enabled.

#### Scenario: Mock answers a question
- **WHEN** `ask` is called on `MockRagApi`
- **THEN** after the simulated delay a canned `AskResponse` is returned

#### Scenario: Mock processes a file
- **WHEN** `processFile` is called on `MockRagApi`
- **THEN** a successful `ProcessResult` is returned, unless the debug failure toggle is active

### Requirement: SupabaseRagApi implementation
The system SHALL provide a `SupabaseRagApi` that calls the Backend Engineer's Supabase Storage and Edge Functions using the `supabase_flutter` SDK. It SHALL use the anon key only and SHALL match the frozen JSON contract.

#### Scenario: Process file via Edge Function
- **WHEN** `processFile` is called on `SupabaseRagApi`
- **THEN** the file is uploaded to the `uploads` bucket and the `process-file` Edge Function is invoked with `{fileName, storagePath}`

#### Scenario: Ask question via Edge Function
- **WHEN** `ask` is called on `SupabaseRagApi`
- **THEN** the `ask-question` Edge Function is invoked with `{question}` and its `{answer, sources}` response is mapped to `AskResponse`

#### Scenario: Edge Function error
- **WHEN** an Edge Function call fails or returns an error status
- **THEN** `SupabaseRagApi` throws a typed error that the UI renders as a user-visible message
