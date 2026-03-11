# iOS MRR Learning Project

An Objective-C iOS project for studying Manual Retain-Release (MRR) with a minimal first-launch flow.

## Current Flow

- First launch: show `OnboardingViewController`
- After onboarding is completed: persist a flag in `NSUserDefaults`
- Next launches: show `MainMenuViewController`

Both screens are intentionally simple placeholders for now.

## Project Structure

- `MRR Project/App`
  Root app wiring, `AppDelegate`, `main.m`, `Info.plist`, and the simple `MainMenuViewController`
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

The active unit-test coverage focuses on the root flow:

- first launch shows onboarding
- finishing onboarding persists the completion flag
- returning users go directly to the main menu
- the app no longer routes into a tab-bar-based learning flow

## Notes

- The app target intentionally keeps `CLANG_ENABLE_OBJC_ARC = NO`.
- The test target may use ARC-backed XCTest conveniences.
- UI is programmatic; there are no storyboards or xibs.
