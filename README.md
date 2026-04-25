<p><a target="_blank" href="https://app.eraser.io/workspace/e8OVReUtHGpt7FF7fif9" id="edit-in-eraser-github-link"><img alt="Edit in Eraser" src="https://firebasestorage.googleapis.com/v0/b/second-petal-295822.appspot.com/o/images%2Fgithub%2FOpen%20in%20Eraser.svg?alt=media&amp;token=968381c8-a7e7-472a-8ed6-4a6626da5501"></a></p>

# Expense tracker
LLM-agnostic expense tracking engine built with Ruby on Rails, using automated data extraction from receipt images. Features a robust background processing pipeline with Sidekiq, dry-struct contract validation, and an automated self-correction loop for high-accuracy parsing.

## Architecture
![View on Eraser](/.eraser/e8OVReUtHGpt7FF7fif9___LQGxdMVPuaVCCeDK7pQdnsPtYqb2___---diagram---NCY8kS98nJz9Qb0iFdOA3---id---1PpAgb1rbQLr8KhjGpbX3.png "View on Eraser")



_Architecture visualized using _[﻿C4 model](https://c4model.com/)_ methodology to ensure clear separation between interface, application logic, and data persistence layers._

## How it works
1. Client uploads a receipt image via the API.
2. A background job sends the image to a Vision LLM (Gemini/OpenAI/Claude).
3. The system validates the LLM's JSON structured output against a strict dry-struct defined contract.
4. If validation fails, the system automatically triggers a [﻿Reflexion-based](https://arxiv.org/abs/2303.11366)  rescue loop, feeding the error report back to the LLM and forcing an explicit reasoning step before its next attempt.
5. Successfully parsed and validated data is stored in PostgreSQL.
## Roadmap
### Proof-of-concept
- [x] Configure Rails 7.2 API, Sidekiq, Redis, and PostgreSQL
- [x] Create `Receipt`  model with `photo_base64`  column (text) and `status`  management (pending, processing, success, failed)
- [x] Implement `POST /receipts`  endpoint to save raw Base64 data and trigger background processing
- [x] Build `AnalyzeJob`  to retrieve `Receipt`  records by ID and prepare images for LLM processing
- [x] Migrate storing photos from base64 to ActiveStorage (Local storage)
- [x] Integrate `RubyLLM`  for image to JSON extraction using structured output
- [ ] Persist final extracted data into a JSONB column and update `status`  to success
- [ ] Define data contracts with `dry-struct`  and generate corresponding JSON Schemas
- [ ] Create `LlmAttempt`  model to log full request/response history for observability
- [ ] Implement a self-correction loop to retry extraction with error feedback if validation fails (max 1 retry)
- [ ] Implement `GET /receipts`  endpoint to list records and monitor extraction results
### Pre-MVP
- [ ] Setup RSpec, FactoryBot, and DatabaseCleaner
- [ ] Configure VCR for mocking LLM API responses
- [ ] Write unit and integration tests
- [ ] Configure lograge for structured JSON logging
### MVP
- [ ] Implement authentication using Devise
- [ ] Establish multi-tenant architecture (`User`  -> `Household`  -> `Receipt`)
- [ ] Implement Bring-your-own-key with `LlmCredentials`  scoped to `User` /`Household`  for customizable API keys
- [ ] Add multi-provider support with Adapters for OpenAI and Anthropic
- [ ] Scope `GET /receipts`  strictly to `current_user.household` 
- [ ] Develop mobile-friendly frontend using React and Tailwind CSS (with ActionCable for real-time updates)
- [ ] Build Human-in-the-loop UI with manual correction interface at `GET /receipts/:id` 
- [ ] Implement change tracking system (diffing LLM output vs. human edits) for model evaluation
- [ ] Build security guardrail (secondary LLM request) to detect Prompt Injection and non-receipt images
- [ ] Implement partial ban logic. Block `POST /receipts`  for 24h or permanently based on guardrail flags
### Future Improvements
- [ ] Setup `Household`  invitation system and membership management
- [ ] Add pagination for receipt lists to optimize performance
- [ ] Implement automated thumbnail generation for receipt previews
- [ ] Develop advanced expense reports (by category, date range, merchant, etc.)
- [ ] Integrate Global Product Classification (GPC) for standardized item categorization
- [ ] Migrate file storage to Amazon S3
- [ ] Implement image hash-based caching to prevent redundant LLM processing
- [ ] Add image pre-processing pipeline (grayscale, resizing, noise reduction)
- [ ] Implement full-text search for items and merchants
- [ ] Support batch uploads for multiple receipt processing
- [ ] Develop native mobile applications using React Native




<!--- Eraser file: https://app.eraser.io/workspace/e8OVReUtHGpt7FF7fif9 --->
