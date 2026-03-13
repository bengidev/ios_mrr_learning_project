# Repository Guidelines

## Project Structure & Module Organization
`MRR Project/App` contains bootstrap and app-shell code such as `main.m`, `AppDelegate`, and `MainMenuViewController`. Feature code lives under `MRR Project/Features/<Feature>`, with onboarding currently split into `Data/` and `Presentation/ViewControllers/`. Shared resources live in `MRR Project/Resources`, including `Info.plist` and `Assets.xcassets`. Tests belong in `MRR ProjectTests`. Treat `Packages/CocoaLumberjack` as vendored dependency code; avoid broad cleanup there unless dependency work requires it.

## Build, Test, and Development Commands
- `xcodebuild -project "MRR Project.xcodeproj" -scheme "MRR Project" -sdk iphonesimulator -configuration Debug build` builds the app.
- `xcodebuild -project "MRR Project.xcodeproj" -scheme "MRR Project" -destination 'platform=iOS Simulator,id=75072AB6-FDCA-416A-AC8E-91345CD0CC01' -derivedDataPath ".derivedData/test-iphone-16e" CODE_SIGNING_ALLOWED=NO -only-testing:"MRR ProjectTests" test` runs the unit-test target on the installed `iPhone 16e` simulator, without any UI tests.
- `./scripts/lint-objc.sh` runs the Xcode static analyzer against the app target.
- `./scripts/format-objc.sh` formats all `.h` and `.m` files under `MRR Project` and `MRR ProjectTests`.
- `swift scripts/generate-assets.swift` regenerates the placeholder asset catalog files.

## Coding Style & Naming Conventions
Objective-C formatting follows the tracked `.clang-format`: Google-based style, 2-space indentation, 150-column limit, right-aligned pointers, and no include sorting. Keep UI code programmatic; the active app flow does not use storyboards or xibs. Match the existing naming pattern: `...ViewController` for screens, `...StateController` for persistence/state wrappers, and `...Tests` for XCTest classes. Use `#pragma mark` sections in longer implementation files.

## Testing Guidelines
Use XCTest for all new coverage. This repository currently has no UI test target; keep automated coverage in `MRR ProjectTests` and run it on an iOS Simulator. Name test methods with the `test...` prefix and keep one behavior per test. For launch-flow or persistence changes, cover first launch, returning users, and persisted state transitions. Prefer isolated `NSUserDefaults` suites per test case, following the `AppLaunchFlowTests.<UUID>` pattern already used in the repository.

## Commit & Pull Request Guidelines
Recent history uses short imperative commit subjects, sometimes with prefixes such as `chore:` and `refactor:`. Follow that pattern, for example: `refactor: simplify onboarding state persistence`. Keep commits scoped to one concern. Pull requests should summarize user-visible behavior changes, call out any manual memory-management ownership updates, link related issues, and include screenshots when UI output changes.

## MRR-Specific Notes
The app target intentionally builds with ARC disabled. New app code must balance `retain`, `release`, and `autorelease` correctly, and `dealloc` must release owned objects. Do not enable ARC for files in `MRR Project` unless the project intentionally changes direction.

## Review guidelines
- Prioritize bugs that can crash the app, corrupt the launch flow, or break onboarding state persistence over style-only feedback.
- Treat manual memory-management mistakes in `MRR Project` as high-signal findings: over-release, leaks from missing `release`/`autorelease`, use-after-free risks, and owned properties or ivars not cleaned up in `dealloc`.
- For launch-flow changes, verify the intended behavior still holds: first launch shows onboarding, completing onboarding persists state, and returning users land in `MainMenuViewController`.
- Expect automated coverage in `MRR ProjectTests` when a PR changes launch routing, onboarding persistence, or `NSUserDefaults` behavior. Prefer isolated suites following the existing `AppLaunchFlowTests.<UUID>` pattern.
- Flag regressions in programmatic UIKit layout or navigation behavior when UI changes could make the onboarding or main menu unusable on iPhone simulators.
- De-emphasize formatting nits and vendored dependency churn under `Packages/CocoaLumberjack` unless the PR explicitly changes dependency behavior there.
