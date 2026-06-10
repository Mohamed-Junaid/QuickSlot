# AI Usage

This document is an honest record of how AI assistance was used while building
QuickSlot.

## Tools used

- **Claude Code** (Anthropic) — used inside the editor as a pair-programming
  assistant for scaffolding, code generation, and refactoring.
- **FlutterFire CLI** and **Firebase Console** — used directly by the developer,
  not the AI, to provision the project and seed data.

## What AI helped with

- Drafting the initial architecture and folder structure plan.
- Generating boilerplate-heavy layers: Freezed models, repository classes,
  Provider classes, and the reusable widget set.
- Writing the Firestore security rules and the deterministic-document-ID scheme
  for the no-double-book guarantee.
- The Material 3 design system and the dashboard polish pass.
- Documentation (this file and the README).

The AI worked incrementally — one layer or feature at a time — and the code was
reviewed and committed in small, named commits after each step.

## What was decided manually

- **Product scope and priorities** — which features to build, in what order, and
  the decision to keep the booking flow stable over adding new features.
- **State management choice** — Provider over Bloc, made deliberately and then
  applied consistently.
- **Firebase setup** — enabling Anonymous Auth, creating Firestore, deploying
  rules/indexes, and seeding venue data were all done by hand.
- **Data entry decisions** — e.g. entering venue numeric fields in the console,
  which surfaced the bug described below.
- Final acceptance of each change after reviewing it in the running app.

## An example where AI was corrected by the developer

**Context:** the venue models defined `openHour`, `closeHour`, and
`slotDurationMins` as `int`. The AI-generated `json_serializable` code parsed
them with a direct cast (`json['openHour'] as int`).

**The problem:** when seeding venues in the Firebase console, the developer
entered those values using the **"double"** field type. Firestore then returned
them as `double` (e.g. `8.0`), and `8.0 as int` throws at runtime — every venue
read would have failed and the list would have shown only the error state.

**The correction:** the developer caught this from their own data-entry choice
and flagged it. Rather than re-entering all the data, the fix was to make the
parsing tolerant of both numeric types with a small `IntConverter`
(`num -> int`) applied to those fields, then regenerate the model code.

**Takeaway:** the AI produced technically correct code against an assumed schema,
but the real Firestore data shape differed. Catching that required the developer
understanding both the data source and the failure mode — the AI's output was a
starting point, not a substitute for that judgment.
