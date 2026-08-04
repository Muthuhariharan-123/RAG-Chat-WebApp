# RAG Chat

## ADDED Requirements

### Requirement: Question input and send
The system SHALL provide a text input and send action on the Chat screen. Sending a question appends it to the conversation as a user message and requests an answer from the active `RagApi` implementation.

#### Scenario: Sending a question
- **WHEN** the user types a non-empty question and sends it
- **THEN** the question appears as a user message and an answer is requested

#### Scenario: Empty input
- **WHEN** the user attempts to send an empty or whitespace-only message
- **THEN** the send is ignored and no message is appended

### Requirement: Message list with loading state
The system SHALL display the conversation as a scrollable list of messages and SHALL show a loading/typing indicator while an answer is pending.

#### Scenario: Answer pending
- **WHEN** a question has been sent but no answer has returned
- **THEN** a loading indicator is visible and the input remains usable

#### Scenario: Answer received
- **WHEN** an answer returns
- **THEN** the loading indicator disappears and the answer renders as a bot message

### Requirement: Answer with sources
The system SHALL render each answer together with the source file names that the answer is based on, when sources are present.

#### Scenario: Answer includes sources
- **WHEN** an answer response includes one or more source file names
- **THEN** the source names are displayed under the answer

#### Scenario: Answer without sources
- **WHEN** an answer response includes no sources
- **THEN** the answer renders without a source list

### Requirement: Answer error handling
The system SHALL display a user-visible error message in the conversation when an answer request fails, instead of silently dropping the question.

#### Scenario: Failed answer request
- **WHEN** the active `RagApi` throws an error while answering
- **THEN** an error message appears in the conversation and the loading indicator clears

### Requirement: Mock chat with grounded canned Q&A
In mock mode, the system SHALL answer questions from a hardcoded set of Q&A pairs grounded in the demo files, with a simulated delay.

#### Scenario: Known mock question
- **WHEN** the user asks a question matching a canned mock pair
- **THEN** after a simulated delay the app returns the matching canned answer with its source file

#### Scenario: Unknown mock question
- **WHEN** the user asks a question not in the canned set
- **THEN** the app returns a canned fallback answer explaining no relevant context was found
