# Tailor Lessons

A personal Flutter app for scheduling tailoring lessons, tracking which ones
you actually attended, handling reschedules, and reminding you to pay once
you've used up a round of lessons.

## About the Figma design

The Figma content pasted into the request didn't come through as a usable
design — it was Figma's internal clipboard binary format (`(figmeta)` /
`(figma)` blobs), not an image or a link I can open. So there was no layout,
color palette, or component spec I could actually read from it.

This build implements all the described *behavior* with a clean default
Material 3 UI (dynamic color scheme, standard bottom navigation, cards,
bottom sheets). If you want the UI to visually match the original Figma file,
share either:
- exported PNG/JPG screenshots of the frames, or
- a Figma **share link** with "anyone with the link can view" access (not a
  copy/paste of the canvas), or
- the design tokens (colors, fonts, spacing) if you don't need pixel-perfect
  matching.

I'll restyle the existing screens to match without touching the underlying
logic.

## What it does

- **Schedule lessons** on a calendar (from Home or the Calendar tab), with an
  optional note.
- **Mark a lesson as visited** — it counts toward the current round's
  progress.
- **Mark a lesson as missed**, then either:
  - **Reschedule** it to a new date/time, or
  - **Replace an upcoming session with it** — folds the missed lesson into
    an already-scheduled one instead of creating a second, redundant slot.
- **Configurable threshold**: set "lessons per round" in Settings. It only
  affects rounds that start *after* you change it, so past rounds keep their
  original count — safe to change when your tailor's pricing changes.
- **Payment reminder**: once a round's completed-lesson count reaches its
  threshold, a banner appears on Home: "Time to pay for the next round of
  lessons." Tapping "Mark as paid & start new round" closes that round out
  and opens the next one using the current threshold.
- **Rounds history** in Settings, with a manual paid/unpaid toggle in case
  you need to correct something.

Everything is stored locally on-device (`shared_preferences`, JSON-encoded) —
no account, no backend, no network calls.

## Important: this was written without a Flutter SDK available

This environment doesn't have Flutter/Dart installed, so I could not run
`flutter pub get`, `flutter analyze`, `flutter test`, or `flutter run` to
verify the code compiles. I've written it carefully against APIs I'm
confident about (`shared_preferences`, `table_calendar` ^3.x, Material 3
widgets), but you should treat the first build as unverified until you run
it.

## Setup

1. Install the [Flutter SDK](https://docs.flutter.dev/get-started/install) if
   you haven't already, and make sure `flutter doctor` is happy.
2. From this directory, fetch packages:
   ```sh
   flutter pub get
   ```
3. Generate the platform runner folders (android/ios/etc. don't exist yet —
   this only adds them, it won't touch `lib/` or `pubspec.yaml`):
   ```sh
   flutter create .
   ```
4. Run static analysis and the smoke test:
   ```sh
   flutter analyze
   flutter test
   ```
5. Run the app:
   ```sh
   flutter run
   ```

If `flutter analyze` or `flutter pub get` surface anything (e.g. a
`table_calendar` version bump, an SDK constraint mismatch), paste the output
back and I'll fix it — that feedback loop is the part I can't do myself here.

## Project structure

```
lib/
  main.dart                     App entry point
  models/                       Lesson, Round, AppSettings (plain data + JSON)
  services/storage_service.dart Persistence (shared_preferences)
  stores/lesson_store.dart      App state + business rules (ChangeNotifier)
  screens/                      Home, Calendar, Settings, schedule dialog
  widgets/                      Lesson list tile, lesson action sheet
  utils/                        Date formatting, date/time picker helper
test/widget_test.dart           Smoke test (app launches, home renders)
```

## Notes on the data model

- A **Round** is one paid batch of lessons. It snapshots the
  "lessons per round" setting at the moment it's created, so changing the
  setting later never rewrites history for a round already in progress.
- A **Lesson** belongs to exactly one round and has a status: `scheduled`,
  `completed`, or `missed`. Only `completed` lessons count toward a round's
  progress.
- At most one round is "active" (unpaid) at a time; new lessons attach to it
  automatically. Marking a round paid opens the next one.
