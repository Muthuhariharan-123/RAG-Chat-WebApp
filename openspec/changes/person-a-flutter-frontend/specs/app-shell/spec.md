# App Shell

## ADDED Requirements

### Requirement: App boots into a tabbed shell
The system SHALL start as a Flutter web app with two tabs: **Upload** and **Chat**. The app SHALL render without any backend connectivity, using mock data by default.

#### Scenario: Launch with mock data
- **WHEN** the user opens the app with the mock flag enabled
- **THEN** the app shows the tabbed shell and both tabs are usable without any network or Supabase dependency

#### Scenario: Tab switching
- **WHEN** the user taps the Chat tab
- **THEN** the app shows the Chat screen, preserving the Upload screen's state in the background

### Requirement: Single mock/real switch
The system SHALL expose one switch that selects the `RagApi` implementation at startup (mock vs real Supabase). Screens SHALL NOT reference concrete implementations.

#### Scenario: Mock mode active
- **WHEN** the switch is set to mock
- **THEN** all upload and chat operations resolve against hardcoded data with simulated delay

#### Scenario: Real mode active
- **WHEN** the switch is set to real with a valid Supabase URL and anon key
- **THEN** upload and chat operations call the Backend Engineer's Supabase Storage and Edge Functions

### Requirement: Supabase initialization
The system SHALL initialize the Supabase client from a URL and anon key supplied via build-time configuration. The service-role key SHALL NOT be embedded in the client.

#### Scenario: Real mode without credentials
- **WHEN** the app runs in real mode without a configured Supabase URL or anon key
- **THEN** the app fails fast with a clear startup error message
