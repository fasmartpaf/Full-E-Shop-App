---
name: fluttergo-pipeline
description: |
  FlutterGo end-to-end pipeline: brief → DESIGN.md theme → Flutter scaffold →
  screens → navigation. Default orchestrator for building real, shippable Flutter
  mobile apps inside Open Design / FlutterGo.AI.
triggers:
  - "flutter app"
  - "fluttergo"
  - "build flutter"
  - "mobile app code"
  - "dart app"
  - "ship flutter"
od:
  mode: prototype
  platform: mobile
  category: flutter-app
  scenario: engineering
  default_for:
    - prototype
  design_system:
    requires: true
    sections: [color, typography, layout, components]
---

# FlutterGo pipeline

Turn a product brief into a **real Flutter project** the user can run with `flutter pub get` and `flutter run`.

## Conventions (never deviate)

- **Flutter:** 3.24+ with Material 3 (`useMaterial3: true`)
- **Routing:** `go_router`
- **State:** `flutter_riverpod`
- **Fonts:** `google_fonts` (theme comes from DESIGN.md)
- **Project layout:** feature-first under `lib/features/<feature>/`

## Skill order

Run these skills in sequence. Do not skip the theme step.

| Step | Skill | Output |
|---|---|---|
| 0 | `flutter-agent-rules` | Coding standards for every edit (FlutterGen-trained rules) |
| **0a** | **`flutter-stack-readiness`** | **Audit design system + media + connectors; gate until Settings ready** |
| **0b** | **`flutter-app-planning`** | **`docs/app-plan.md` + TodoWrite screen/asset list (mandatory for new apps)** |
| 1 | `flutter-scaffold` | `pubspec.yaml`, `lib/main.dart`, folder structure |
| 1b | `flutter-feature-architecture` | Feature folders, one-screen-per-file plan (mandatory for 3+ screens or auth) |
| 1c | `flutter-auth-flow` | Auth/onboarding file checklist when brief includes login/register/OTP |
| 2 | `flutter-theme-from-design` | `lib/theme/app_theme.dart` from active DESIGN.md |
| **2b** | **`flutter-app-design`** | **`docs/visual-spec.md`, asset prompts, shared widget spec (premium UI bar)** |
| 3 | `flutter-screen-builder` | **One** `lib/features/.../*_screen.dart` per invocation |
| 4 | `flutter-navigation` + `flutter-go-router-shell` | `lib/router/app_router.dart` with `go_router` |
| 5 | `flutter-state` | Riverpod providers for screen data |
| 6 | `flutter-components` | shared widgets in `lib/shared/widgets/` |
| 6b | `flutter-media-assets` | **All** logos, heroes, onboarding art, nav icons via `od media generate` |
| 7 | `dart-run-static-analysis` | zero analyzer errors before handoff |
| 8 | `flutter-store-deploy` | **Optional final step** — ship to Google Play / TestFlight via `od flutter deploy` when the user asks to publish |
| — | `flutter-fix-compile-errors` / `flutter-fix-layout` / `flutter-fix-web-preview` / `flutter-web-network-images` | when preview Build, layout, runtime, or images fail |

## Workflow

### Step 0 — Stack readiness (premium apps)

Invoke **`flutter-stack-readiness`** first. If design system, media provider, or a required connector is missing:

1. Emit `<question-form id="flutter-prerequisites">` with exact **Settings → …** paths.
2. **Stop** — no Dart until the user connects and replies **Done**.
3. Re-audit the connected services block, then continue.

### Step 0b — Scope & plan

**New app or greenfield rebuild:** invoke **`flutter-app-planning`**. Write `docs/app-plan.md`, emit TodoWrite (one line per screen file + per asset), confirm DESIGN.md is active — **no Dart until the plan exists**.

Ask at most three clarifying questions if the brief is vague:

1. Primary user and job-to-be-done
2. Must-have screens (3–5 max for v1)
3. Auth / backend needs (local-only, or pick from connected/available connectors in Settings)

### Step 1 — Scaffold

The daemon seeds `pubspec.yaml`, `lib/main.dart`, platform folders (`android/`, `ios/`, `web/`), and a default home screen when the project is created. **Edit the existing template** with Write/Edit tools. Only create missing feature files under `lib/features/`. Invoke `flutter-scaffold` when you need the layout reference, not to replace the whole tree.

**API / BYOK mode (no Write tool):** put each file path on its own line immediately before the ` ```dart ` fence, or as the first line inside the block (`// lib/features/foo/foo_screen.dart`). Open Design auto-saves those blocks into the project after each reply.

### Step 2 — Theme

Invoke `flutter-theme-from-design`. Prefer the CLI when available:

```bash
od design-systems flutter-theme <active-design-system-id> --output lib/theme/app_theme.dart
```

### Step 2b — Visual design

Invoke **`flutter-app-design`**: write `docs/visual-spec.md` (logo, onboarding art, heroes, category thumbs, nav icons). Then **`flutter-media-assets`** to generate every asset via `od media generate` **before** building screens that reference them.

### Step 3 — Screens

Invoke `flutter-screen-builder` once per screen. Keep each screen in its own feature folder.

### Step 4 — Wire

Invoke `flutter-navigation` and `flutter-state` to connect routes and providers.

### Step 5 — Verify

Before finishing, ensure:

```bash
flutter analyze
flutter test
```

Report any analyzer issues and fix P0 errors before handoff.

### Step 6 — Preview build failures

When the user clicks **Build** / **Rebuild** in Design Files and the Flutter web preview fails:

1. Read the compile error list and log excerpt shown in the preview panel (or wait for Open Design to auto-queue a repair prompt).
2. Fix **every** listed error by editing real project files — not chat-only snippets.
3. Common fixes:
   - `context.go` / `context.push` → `import 'package:go_router/go_router.dart';` plus routes in `lib/router/app_router.dart`
   - Riverpod `ref` usage → correct `ConsumerWidget` / imports
   - Layout overflow → `SingleChildScrollView`, `Expanded`, or reduced padding
4. After fixing, tell the user to click **Hot reload**, **Hot restart**, or **Rebuild** depending on change scope:
   - UI/layout tweaks → Hot reload
   - New routes / providers → Hot restart
   - `pubspec.yaml` / first build → Rebuild

### Step 6b — Preview runtime failures (gray screen, console errors)

When **Build succeeds** (`✓ Built build/web`) but the phone preview is blank/gray or **Runtime errors** show in the debug panel:

1. Read **Runtime errors (browser console)** and any fix hint (`→ …`).
2. Invoke **`flutter-fix-web-preview`** — typical imported-app fixes: `PlatformNotch` instead of `IphoneHasNotch`, guard `dart:io`, fix missing assets.
3. Grep the whole project for the same anti-pattern; fix all call sites in one pass.
4. **Rebuild** after adding new helper files; **Hot restart** after editing existing Dart.

### Step 6c — Network images broken on web only

When profile/feed photos show error icons but URLs work on native:

1. Invoke **`flutter-web-network-images`** (Open Design skill under `skills/flutter-web-network-images/`).
2. Copy `references/app_network_image.dart` → `lib/utils/app_network_image.dart`; replace raw `CachedNetworkImage` project-wide.
3. Merge `references/index-head-snippet.html` into `web/index.html` `<head>`.
4. **Rebuild** preview. Configure S3/Firebase CORS for production web; OD preview can use `OD_WEB_IMAGE_PROXY` dart-define automatically.

## Preview refresh (Open Design)

| Action | When | State preserved |
|--------|------|-----------------|
| **Hot reload** | Widget/layout edits | Yes |
| **Hot restart** | Routes, providers, top-level changes | No |
| **Rebuild** | pubspec, clean compile, preview failed | No (full recompile) |

Invoke `flutter-agent-rules`, `flutter-fix-compile-errors`, `flutter-fix-layout`, and `flutter-fix-web-preview` as needed.

## Connected services (Settings → Media / Connectors / MCP)

Open Design injects a **Connected services** block into the system prompt when this pipeline runs. Always read it first.

0. **Readiness** — invoke **`flutter-stack-readiness`**: if Tier A (design system + media) or required connectors are missing, ask user to enable in Settings and **stop** until they reply Done.
1. **Check** which media providers and connectors are connected or available in Settings.
2. **Confirm stack** with `<question-form id="flutter-stack">` when any media or connector applies — user picks connectors, assets yes/no, must-have screens.
3. **Media** — if OpenAI/Fal/etc. are configured, invoke **`flutter-media-assets`**: generate logo, category icons, hero backgrounds, onboarding art via **`od media generate`**; save under `assets/` and register in `pubspec.yaml`. **Never** download from Picsum/Unsplash/curl or use IDE-only image tools.
4. **Connectors** — for each **connected** connector, wire real features via `od tools connectors execute` + Dart repositories/providers (Supabase → `flutter-supabase-backend`; **Firebase → invoke `flutter-firebase-bootstrap` first, then `od flutter firebase status/login/configure` — never skip automation for manual FlutterFire docs**; same pattern for GitHub, Notion, Airtable, Linear, etc.). For **available** connectors, suggest connecting in Settings when they fit the app. Never put OAuth/admin keys in Flutter code.
5. **Then** run the skill order table above (theme → screens → nav → state → analyze → preview).

## Hard rules

- Output **real Dart**, not pseudocode or HTML mockups.
- Never invent hex colors outside the active DESIGN.md — use `AppColors` / `Theme.of(context)`.
- One feature folder per screen; no monolithic `main.dart` with 500 lines of UI.
- Do not add packages beyond: `go_router`, `flutter_riverpod`, `google_fonts` unless the brief or a connected connector requires it (e.g. Supabase, Firebase, Stripe).
