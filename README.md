# iOS MRR Learning Project

An Objective-C iOS project for studying Manual Retain-Release (MRR) with a minimal first-launch flow.

## Current Flow

- First launch: show `OnboardingViewController`
- After onboarding is completed: persist a flag in `NSUserDefaults`
- Next launches: show `MainMenuViewController`

Both screens are intentionally simple placeholders for now.

## Project Structure

- `MRR Project/App`
  Root app wiring, `AppDelegate`, `main.m`, and the simple `MainMenuViewController`
- `MRR Project/Resources`
  Shared application resources, including `Info.plist` and `Assets.xcassets`
- `MRR Project/Features/Onboarding`
  First-launch state persistence and onboarding UI
- `MRR ProjectTests`
  Launch-flow tests for onboarding and persisted state behavior

## Requirements

- Xcode 15+
- macOS with an iOS Simulator runtime

## Build

1. Open [MRR Project.xcodeproj](/Users/beng/Documents/iOS%20Projects/iOS%20MRR%20Learning%20Project/ios_mrr_learning_project/MRR%20Project.xcodeproj).
2. Select the `MRR Project` scheme.
3. Run on an iOS Simulator.

## Tests

The repository currently has no UI test target. Automated coverage lives in `MRR ProjectTests` and focuses on the root flow:

- first launch shows onboarding
- finishing onboarding persists the completion flag
- returning users go directly to the main menu
- the app no longer routes into a tab-bar-based learning flow

Run the unit tests on the installed `iPhone 16e` simulator with:

```bash
xcodebuild -project "MRR Project.xcodeproj" \
  -scheme "MRR Project" \
  -destination 'platform=iOS Simulator,id=75072AB6-FDCA-416A-AC8E-91345CD0CC01' \
  -derivedDataPath ".derivedData/test-iphone-16e" \
  CODE_SIGNING_ALLOWED=NO \
  -only-testing:"MRR ProjectTests" \
  test
```

## VSCode Save Behavior

- Objective-C and Objective-C++ files format automatically on `Save` and `Save All` through `clangd` and the tracked [.clang-format](/Users/beng/Documents/iOS%20Projects/iOS%20MRR%20Learning%20Project/ios_mrr_learning_project/.clang-format) file.
- Syntax diagnostics come from `clangd` directly in the editor and `Problems` panel.
- The heavier project-wide static analyzer remains manual through `./scripts/lint-objc.sh`; it is intentionally not bound to every save.

## Assets

- `MRR Project/Resources/Assets.xcassets` is the active asset catalog for the app icon, named colors, and the onboarding illustration.
- `swift scripts/generate-assets.swift` regenerates the current placeholder assets if they need to be refreshed.

## Notes

- The app target intentionally keeps `CLANG_ENABLE_OBJC_ARC = NO`.
- The test target may use ARC-backed XCTest conveniences.
- UI is programmatic; there are no storyboards or xibs.
