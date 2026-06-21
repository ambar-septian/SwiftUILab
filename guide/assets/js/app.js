// Shared front-end for the SwiftUILab learning guide.
// No build step, no framework: open index.html directly or serve statically.

const MODULES = [
  { num: "01", id: "state-system", title: "SwiftUI State System", implemented: true,
    concepts: ["@State vs @Binding value semantics", "Custom Binding(get:set:)",
      "@StateObject vs @ObservedObject ownership", "@Observable vs ObservableObject",
      "@Bindable", "Minimizing view invalidations"] },
  { num: "02", id: "layout", title: "Layout & Rendering",
    concepts: ["Layout protocol vs GeometryReader", "PreferenceKey child-to-parent",
      "alignmentGuide & custom alignments", "Structural vs explicit identity",
      "@ViewBuilder & AnyView trade-offs"] },
  { num: "03", id: "navigation", title: "Navigation",
    concepts: ["NavigationStack + NavigationPath", "Type-safe routes",
      "Programmatic deep linking", "Coordinator pattern",
      "Sheet / fullScreenCover / popover state"] },
  { num: "04", id: "async-await", title: "Async / Await",
    concepts: ["Continuations & suspension points", "Task lifecycle & priorities",
      "Cooperative cancellation", "AsyncSequence / AsyncStream",
      "withCheckedContinuation bridging", ".task vs Task { } in views"] },
  { num: "05", id: "concurrency", title: "Structured Concurrency & Actors",
    concepts: ["TaskGroup vs async let", "Actor reentrancy", "@MainActor isolation",
      "Global actors", "Sendable & @unchecked Sendable", "Swift 6 strict concurrency"] },
  { num: "06", id: "uikit-interop", title: "UIKit Interop",
    concepts: ["UIViewRepresentable + Coordinator", "Avoiding infinite update loops",
      "UIViewControllerRepresentable lifecycle", "UIHostingController sizing",
      "Migration strategies"] },
  { num: "07", id: "swiftdata", title: "SwiftData & Persistence",
    concepts: ["@Model & relationships", "@Query fetching", "ModelContext / ModelContainer DI",
      "Migrations & schema versions", "Batch ops & predicate cost"] },
  { num: "08", id: "testing", title: "Unit Testing",
    concepts: ["Swift Testing: @Test, #expect, traits", "Testing async/await",
      "Testing actors & @MainActor", "Testing @Observable",
      "Protocol-based test doubles", "Testing AsyncStream"] },
  { num: "09", id: "architecture", title: "Architecture Patterns",
    concepts: ["MVVM: fit vs overhead", "TCA overview", "SPM feature modules",
      "DI without a framework", "Unidirectional data flow"] },
  { num: "10", id: "performance", title: "Performance & Debugging",
    concepts: ["SwiftUI Instruments template", "Self._printChanges()",
      "Task & closure leaks", "Hitches & hang detection", "Launch time"] },
];

const base = document.body.dataset.base || "";
const currentId = document.body.dataset.module || "";

function isDone(id) { return localStorage.getItem("swiftuilab:done:" + id) === "1"; }
function setDone(id, done) { localStorage.setItem("swiftuilab:done:" + id, done ? "1" : "0"); }

function buildSidebar() {
  const nav = document.getElementById("sidebar-nav");
  if (!nav) return;

  const doneCount = MODULES.filter(m => isDone(m.id)).length;
  const header = document.createElement("div");
  header.className = "progress-summary";
  header.textContent = `${doneCount} / ${MODULES.length} complete`;
  nav.appendChild(header);

  MODULES.forEach(m => {
    const row = document.createElement("div");
    row.className = "nav-row" + (m.id === currentId ? " active" : "");

    const check = document.createElement("input");
    check.type = "checkbox";
    check.checked = isDone(m.id);
    check.title = "Mark complete";
    check.addEventListener("change", () => {
      setDone(m.id, check.checked);
      header.textContent = `${MODULES.filter(x => isDone(x.id)).length} / ${MODULES.length} complete`;
      row.classList.toggle("done", check.checked);
    });
    if (check.checked) row.classList.add("done");

    const link = document.createElement("a");
    link.href = `${base}modules/${m.num}-${m.id}.html`;
    link.innerHTML = `<span class="num">${m.num}</span> ${m.title}`;

    row.appendChild(check);
    row.appendChild(link);
    nav.appendChild(row);
  });
}

// Renders the body for not-yet-implemented module stub pages.
function buildStub() {
  const host = document.getElementById("module-stub");
  if (!host) return;
  const m = MODULES.find(x => x.id === currentId);
  if (!m) return;

  document.title = `${m.num}. ${m.title} — SwiftUILab`;
  host.innerHTML = `
    <p class="eyebrow">Module ${m.num}</p>
    <h1>${m.title}</h1>
    <div class="callout">
      <strong>Not written yet.</strong> This page fills in during a focused
      session, following the same structure as
      <a href="${base}modules/01-state-system.html">Module 1</a>:
      Concept → Pitfalls → Reference → Challenge → Solution → Further reading.
    </div>
    <h2>Concepts this module will cover</h2>
    <ul class="concept-list">
      ${m.concepts.map(c => `<li>${c}</li>`).join("")}
    </ul>`;
}

document.addEventListener("DOMContentLoaded", () => {
  buildSidebar();
  buildStub();
  if (window.hljs) window.hljs.highlightAll();
});
