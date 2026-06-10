# QuickSlot

A venue slot-booking app built with Flutter and Firebase. Users browse venues,
pick a date, see a live slot grid, and book a slot — with a hard guarantee that
**a slot can never be double booked**, enforced by a Firestore transaction.

---

## 1. Project Overview

QuickSlot lets a signed-in user:

- Browse available venues from a dashboard.
- Open a venue, choose a date, and view that day's slot grid (Available / Booked).
- Book a free slot. Booking is atomic: concurrent attempts on the same slot are
  serialized and only one succeeds.
- View their bookings and cancel them, which frees the slot for others.

The app uses anonymous Firebase Authentication so there is no sign-up friction —
every device gets a stable user id that scopes its bookings.

---

## 2. Features

- Dashboard home: welcome header, next upcoming booking, quick stats, venue list.
- Venue list and venue details.
- Horizontal date picker (next 14 days).
- Slot grid showing Available vs Booked.
- Transactional booking with success animation and clear failure feedback.
- My Bookings with cancellation.
- Every screen has explicit loading (shimmer skeletons), error (with retry), and
  empty states — no blank screens.
- Material 3 design system, pull-to-refresh, reusable components.

---

## 3. Architecture

Feature-first **Clean Architecture** with three layers:

```
UI (Provider + Widgets)  ->  Repositories  ->  Firebase (Firestore / Auth)
```

- **Models** — immutable data classes (Freezed + json_serializable).
- **Repositories** — the only types that talk to Firebase; they translate
  Firestore documents to models and own the booking transaction.
- **Providers** (ChangeNotifier) — hold screen state and call repositories.
- **Views / Widgets** — render state; reusable widgets live in `shared/widgets`.

State is managed with **Provider**, not Bloc (see section 6).

---

## 4. Folder Structure

```
lib/
  main.dart                     App bootstrap + Firebase init
  firebase_options.dart         FlutterFire generated config

  core/
    constants/                  Firestore collection/field names
    error/                      Typed booking exceptions
    theme/                      Colors, spacing, Material 3 theme
    utils/                      Date helpers, JSON converters

  data/
    models/                     Venue, Slot, Booking, AppUser (+ generated)
    repositories/               Auth, Venue, Booking repositories

  features/
    auth/                       Anonymous sign-in + auth gate
    splash/                     Branded splash view
    home/                       Dashboard (providers compose here)
    venues/                     Venue list + venue card
    venue_details/              Date picker + slot grid + booking
    bookings/                   My bookings + cancel

  shared/
    widgets/                    Loader, error, empty, shimmer, dialogs, logo
```

Each feature owns its `providers/`, `view/`, and `widgets/`.

---

## 5. Firestore Schema

```
venues/{venueId}
  name, description, address, imageUrl: string
  openHour, closeHour, slotDurationMins: number
  isActive: bool

bookings/{venueId}_{dayKey}_{slotIndex}      <- deterministic document ID
  bookingId, venueId, venueName, userId: string
  dayKey: string ("yyyy-MM-dd")
  slotIndex: number
  startTime, endTime, createdAt, updatedAt: timestamp
  status: "booked" | "cancelled"

users/{userId}
  userId, displayName: string
  createdAt: timestamp
```

**Slots are not stored.** A venue's slot grid for any day is derived from its
`openHour`, `closeHour`, and `slotDurationMins`. Availability is computed by
reading that day's bookings and matching `slotIndex`. This avoids a second
source of truth and keeps writes small.

Composite indexes (`firestore.indexes.json`):
- `bookings (userId ASC, createdAt DESC)` — My Bookings query.
- `bookings (venueId ASC, dayKey ASC)` — slot availability query.

---

## 6. State Management Choice

**Provider (ChangeNotifier)** over Bloc.

- The app's state is straightforward CRUD-over-Firestore; Provider expresses it
  with minimal boilerplate, which keeps the code easy to read and explain.
- Each screen has one provider with an explicit `ViewState` enum
  (initial / loading / success / error), so state transitions are obvious.
- Repositories are injected into providers, keeping providers testable and free
  of Firebase types.

---

## 7. Concurrency Handling

The core requirement is that two users can never book the same slot.

The key idea: every booking lives at a **deterministic document ID**,
`{venueId}_{dayKey}_{slotIndex}`. A physical slot maps to exactly one document.
Two users racing for the same slot therefore contend on the *same* document, and
a Firestore transaction serializes them:

1. The first transaction commits `status: booked`.
2. The second transaction re-runs, its read now sees the booked document, and it
   throws `SlotUnavailableException`.

The loser sees: **"Sorry, this slot was just booked by another user."** The grid
then refreshes to reflect reality. Firestore security rules also enforce that the
document ID matches the slot key, so a client cannot forge an ID to bypass the
collision.

---

## 8. Booking Transaction Flow

Implemented in `BookingRepository.bookSlot` using `runTransaction`:

```
1. Read   the booking doc at {venueId}_{dayKey}_{slotIndex}
2. Verify it does not already exist with status == booked
            -> if it does, throw SlotUnavailableException
3. + 4. Mark booked / create the document: set(ref, booking) with status booked
```

Steps 3 and 4 are a single atomic write — the booking document *is* the slot's
reservation, so creating it is the same act as marking the slot booked.

Cancellation is the inverse transaction: read, verify ownership, flip `status`
to `cancelled`. Because availability only counts `booked` rows, cancelling frees
the slot immediately.

---

## 9. Setup Instructions

**Prerequisites:** Flutter 3.4+, a Firebase project, the FlutterFire CLI.

1. Install dependencies:
   ```bash
   flutter pub get
   ```
2. Generate model code (Freezed / json_serializable):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
3. Connect your Firebase project (regenerates `firebase_options.dart` and adds
   native config files):
   ```bash
   flutterfire configure
   ```
4. In the Firebase console: enable **Anonymous Authentication** and create a
   **Firestore** database.
5. Deploy rules and indexes:
   ```bash
   firebase deploy --only firestore:rules,firestore:indexes
   ```
6. Seed venues — add the documents from `seed/venues.seed.json` to the `venues`
   collection (see `seed/README.md`).
7. Run:
   ```bash
   flutter run
   ```

---

## 10. Known Limitations

- **Anonymous auth only.** Bookings are tied to a device's anonymous uid; there
  is no account recovery or cross-device sync.
- **Reads are one-shot, not streamed.** The slot grid and bookings refresh on
  action / pull-to-refresh rather than live-updating, so another user's booking
  appears on next load (or when you attempt the same slot).
- **Client timestamps.** `createdAt` / `updatedAt` use device time, not server
  time.
- **No past-date guard on the grid** beyond what the date picker offers.
- **No pagination.** Fine for a small venue set; large datasets would need it.

---

## 11. Future Improvements

- Realtime slot grid via Firestore snapshots (`snapshots()` streams).
- Email / Google sign-in with account linking from the anonymous user.
- Server timestamps and Cloud Functions for booking reminders.
- Venue search, filtering, and pagination.
- Booking history filters (hide cancelled) and rebook shortcut.
- Widget and repository unit tests, including a fake Firestore for the
  transaction race.
