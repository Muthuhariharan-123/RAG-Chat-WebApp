# File Upload

## ADDED Requirements

### Requirement: Pick files with type and count limits
The system SHALL allow the user to pick files limited to `.txt` and `.pdf`, up to a maximum of 10 files in the current session. Files outside these limits SHALL be rejected with a user-visible message.

#### Scenario: Valid file selection
- **WHEN** the user picks one or more `.txt` or `.pdf` files totaling 10 or fewer
- **THEN** each file is added to the upload list with status `queued`

#### Scenario: Unsupported file type
- **WHEN** the user picks a file that is not `.txt` or `.pdf` (e.g., a `.png`)
- **THEN** the file is rejected and an error message is shown

#### Scenario: Exceeding file count limit
- **WHEN** the user attempts to add a file that would bring the session count above 10
- **THEN** the addition is rejected and a message explains the 10-file limit

### Requirement: Per-file status lifecycle
Each file in the upload list SHALL transition through the statuses `queued → uploading → processing → processed | failed`. The list SHALL display the current status of every file.

#### Scenario: Successful upload and process
- **WHEN** a file finishes uploading and the Backend Engineer's process call succeeds
- **THEN** the file's status becomes `processed`

#### Scenario: Failed upload or process
- **WHEN** a file's upload or process call throws an error
- **THEN** the file's status becomes `failed` with an error message shown

### Requirement: Auto-process on upload
The system SHALL automatically trigger processing of a file as soon as its upload completes, without any additional user action.

#### Scenario: Automatic processing after upload
- **WHEN** a file's upload completes
- **THEN** the system immediately calls the process step for that file

### Requirement: Upload progress feedback
The system SHALL show progress feedback during upload and processing. Because the Supabase SDK exposes no byte-level progress on web, an indeterminate or simulated progress indicator SHALL be displayed.

#### Scenario: Progress indicator visible during upload
- **WHEN** a file is in the `uploading` or `processing` state
- **THEN** a progress indicator is shown on that file's row

### Requirement: Mock upload simulates success and failure
In mock mode, the system SHALL simulate uploads with a delay, succeed by default, and provide a debug toggle to force a failure so the error UI is demonstrable.

#### Scenario: Mock upload succeeds
- **WHEN** the user uploads a file in mock mode without the failure toggle
- **THEN** after the simulated delay the file reaches `processed`

#### Scenario: Mock upload failure toggle
- **WHEN** the failure toggle is enabled and the user uploads a file in mock mode
- **THEN** the file reaches `failed` with an error message
