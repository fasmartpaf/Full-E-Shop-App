# Firebase setup — Ara Store

The app is **already linked** to a real Firebase project. Code, config, and rules
are committed. Two switches live in the Firebase console (they can't be flipped
from the CLI on this machine) — do those and the backend is fully live.

| Item | Status |
|------|--------|
| Firebase project | ✅ `ara-store-32144` (created) |
| App registrations | ✅ Web + Android + iOS (`flutterfire configure`) |
| `ios/Runner/GoogleService-Info.plist` | ✅ generated + added to Xcode target |
| iOS deployment target | ✅ 15.0 (required by Firebase SDKs) |
| `lib/firebase_options.dart` | ✅ generated with real keys |
| Packages | ✅ `firebase_core`, `firebase_auth`, `cloud_firestore` |
| Dart wiring | ✅ Auth + Firestore orders (with local fallback) |
| Firestore API | ✅ enabled |
| Firestore `(default)` database | ✅ created |
| Firestore rules | ✅ **deployed** (`firestore.rules`) |
| **Enable Email/Password sign-in** | ⛳ **you — one toggle (below)** |

Console: https://console.firebase.google.com/project/ara-store-32144/overview

> The app runs **right now**. Firestore is live, so orders save once you're
> signed in. The only remaining switch is turning on Email/Password auth — until
> then the app browses fine as a guest and shows a clear message if you try to
> sign in.

---

## The one remaining step — Enable Email/Password sign-in

1. Open **Build → Authentication** →
   https://console.firebase.google.com/project/ara-store-32144/authentication/providers
2. Click **Get started** (first time) → **Sign-in method** →
   **Email/Password** → **Enable** → **Save**.

That's it. Sign-in / create-account in the app's **Account** tab now works, and
placed orders are saved to Firestore under `users/{uid}/orders` and shown in
**My orders** across sessions/devices.

---

## What's wired in the code

- `lib/main.dart` — `Firebase.initializeApp(...)` guarded by try/catch
  (`firebaseReadyProvider` reflects success).
- `lib/state/auth_provider.dart` — `authStateProvider` stream, `AuthController`
  (sign in / register / sign out) with friendly error messages.
- `lib/features/auth/auth_screen.dart` — combined login / register UI.
- `lib/features/profile/profile_screen.dart` — shows the signed-in user, sign-in
  CTA when signed out, real sign-out.
- `lib/data/orders_repository.dart` — Firestore read/write for orders.
- `lib/state/orders_provider.dart` — `placeOrder()` persists to Firestore when
  signed in; `orderHistoryProvider` reads Firestore (signed-in) or local (guest).

## Catalog is in Firestore ✅

The `products` collection is **seeded with all 12 items** and the app reads it
live:

- `lib/data/catalog_repository.dart` — `catalogStreamProvider` streams
  `products` (ordered by `sortOrder`); `catalogProvider` returns Firestore data
  or the mock list on loading/error, so the UI always has products.
- `lib/state/catalog_providers.dart` — search, category, sort, featured, deals
  and new-arrivals all derive from `catalogProvider`.
- Edit products in the **Firestore console** and they update in the app
  instantly. Rules keep the catalog read-only from clients (writes via console /
  admin only).

To re-seed or add products later, write documents to `products/{id}` with the
fields: `id, name, brand, categoryId, price, compareAt, rating, reviewCount,
description, tintIndex, iconKey, colors[], sizes[], badge, inStock, sortOrder`.
`iconKey` maps to an icon via `kProductIcons` in `catalog_repository.dart`.

## Optional next steps
- **Google sign-in.** Add `google_sign_in`, enable the Google provider, and (for
  Android release) register the SHA-1/256 fingerprints.
- **Storage for product images.** Enable Firebase Storage and replace the
  gradient `ProductImage` tiles with real uploads.
- **Android release builds** need `android/app/google-services.json` — already
  written by `flutterfire configure`.
