# SwiftUILab

A monorepo for going from deep UIKit fluency to fluent **SwiftUI + modern concurrency**, structured as *one screen, one concept* per session.

## Layout

```
.
├── SwiftUILab/        # Part 1 — the Xcode app (the practice ground)
└── guide/             # Part 2 — the local learning guide (static site)
```

## Part 1 — the app

Open `SwiftUILab/SwiftUILab.xcodeproj` in **Xcode 26+** and run on an **iOS 26** simulator.

- **App/** — `@main`, `RootView` (a `TabView` of *Modules* + *Progress*), and the DI composition root (`AppContainer`).
- **Core/** — `Router` (type-safe routes), `CatalogService` (protocol + live/mock), `ProgressStore` (`@Observable`, `UserDefaults`-backed).
- **DesignSystem/** — tokens and reusable components.
- **Models/** — `LearningModule`, `ModuleTopic` (the syllabus, single source of truth), `ScratchNote` (SwiftData; the `ModelContainer` is wired from day one).
- **Modules/** — one folder per topic. Each implemented module has `Reference/` (the complete code) and `Challenge/` (boilerplate with `// TODO:` only). Reference and Challenge use distinct type names so both compile and you can run them side by side.

All ten modules are built: each has a `Reference/` (complete code), a `Challenge/` (boilerplate with `// TODO:` only), and a test suite.

### Tests

The test target uses **Swift Testing**. To wire it up once in Xcode:

1. **File ▸ New ▸ Target… ▸ Unit Testing Bundle**, choose **Swift Testing**, name it **`SwiftUILabTests`**.
2. Xcode creates a `SwiftUILabTests` group synchronized to the existing `SwiftUILabTests/` folder, so the test files already on disk (`CatalogServiceTests`, `ProgressStoreTests`, and one suite per module under `Modules/`) are picked up automatically. Delete the boilerplate test file Xcode generates if it adds one.
3. Run with **⌘U**.

> The app target builds and runs without the test target; this step only enables the tests.

## Part 2 — the guide

A dependency-free static site (HTML/CSS/JS + highlight.js via CDN).

```bash
# from the repo root
open guide/index.html          # simplest

# or serve it
cd guide && npm run dev         # http://localhost:5173
```

Each module page follows: **Concept → Pitfalls → Reference → Challenge → Solution reveal → Further reading**. Sidebar progress is stored in `localStorage`. All ten module pages are written.

## Workflow

1. Read the module's guide page.
2. Type the reference into Xcode (`Reference/`), run it, watch the behavior.
3. Attempt the `Challenge/` from the TODO markers.
4. Compare against the solution reveal and the reference.
5. Check the box in the sidebar.
