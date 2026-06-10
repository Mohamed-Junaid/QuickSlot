# Seed Data

QuickSlot seeds only the `venues` collection. `bookings` and `users` are
created at runtime by the app, so there is nothing to seed for them.

Slots are **not** stored. Each venue's `openHour`, `closeHour`, and
`slotDurationMins` derive the slot grid for any chosen day, and availability is
computed by reading that day's bookings. This keeps Firestore small and avoids a
second source of truth.

## Loading the seed

Pick one of the two approaches.

### Option A — Manual (fastest for the hackathon)
In the Firebase console, create the `venues` collection and add one document per
entry in `venues.seed.json`. Use the `id` field as the document ID and copy the
remaining fields verbatim.

### Option B — Firebase CLI import
Convert this file to the CLI import shape (document ID as the key) and import it:

```bash
firebase firestore:delete --all-collections   # optional, clean slate
firebase firestore:import ./seed               # using a prepared export dir
```

For a one-off script, a small Node Admin SDK script that iterates `venues` and
calls `db.collection('venues').doc(v.id).set(v)` is the most reliable.

## Document shapes (reference)

### venues/{venueId}
| field            | type    | example                    |
|------------------|---------|----------------------------|
| name             | string  | "Skyline Yoga Studio"      |
| description      | string  | "Quiet rooftop studio..."  |
| address          | string  | "88 Hill Road"             |
| imageUrl         | string  | "https://..."              |
| openHour         | number  | 9                          |
| closeHour        | number  | 20                         |
| slotDurationMins | number  | 45                         |
| isActive         | bool    | true                       |

### bookings/{venueId}_{dayKey}_{slotIndex}   (created at runtime)
| field      | type      | notes                              |
|------------|-----------|------------------------------------|
| bookingId  | string    | equals the document ID             |
| venueId    | string    |                                    |
| venueName  | string    | denormalized for My Bookings       |
| userId     | string    | owner; must match auth uid         |
| dayKey     | string    | "yyyy-MM-dd"                       |
| slotIndex  | number    | index into the derived slot grid   |
| startTime  | timestamp |                                    |
| endTime    | timestamp |                                    |
| status     | string    | "booked" or "cancelled"            |
| createdAt  | timestamp |                                    |
| updatedAt  | timestamp |                                    |

### users/{userId}   (created at runtime)
| field       | type      | notes                  |
|-------------|-----------|------------------------|
| userId      | string    | equals the document ID |
| displayName | string?   | optional               |
| createdAt   | timestamp |                        |
