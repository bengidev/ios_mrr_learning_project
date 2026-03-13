# Architecture Analysis

## Scope

This document reflects the current application after the old demo-learning stack has been fully removed from both the runtime flow and the repository.

The app now contains only two user-facing screens:

- `OnboardingViewController` on first launch
- `MainMenuViewController` after onboarding has been completed

The onboarding flow also contains a modal recipe-detail step inside the first-launch experience:

- `OnboardingRecipeDetailViewController` for inspecting a recipe and completing onboarding through `Start Cooking`

The app shell also owns one asset catalog for shared visual resources:

- `Resources/Assets.xcassets` for `AppIcon`, `OnboardingAppIcon`, named colors, and onboarding recipe imagery

## Executive Summary

The application is a small state-driven iOS app centered on one persisted boolean: whether onboarding has already been completed.

`AppDelegate` is the composition root. It reads onboarding state at launch and decides which root controller should be installed in the window. `OnboardingViewController` owns the branded onboarding UI, looping carousel, and auth CTA placeholders. It presents `OnboardingRecipeDetailViewController` when a recipe card is selected. Completion still flows upward through a delegate callback, and `OnboardingStateController` persists that event to `NSUserDefaults`. Once the flag is stored, future launches go directly to `MainMenuViewController`.

## Top-Level Module Map

```mermaid
flowchart TB
  main["App/main.m<br/>manual NSAutoreleasePool + UIApplicationMain"]
  plist["Resources/Info.plist"]
  assets["Resources/Assets.xcassets"]
  app["App/AppDelegate<br/>composition root + root flow"]
  onboardingState["Features/Onboarding/Data/OnboardingStateController"]
  onboardingVC["Features/Onboarding/Presentation/OnboardingViewController"]
  onboardingDetailVC["Features/Onboarding/Presentation/OnboardingRecipeDetailViewController"]
  carouselCell["Features/Onboarding/Presentation/OnboardingRecipeCarouselCell"]
  mainMenuVC["App/MainMenuViewController"]
  tests["MRR ProjectTests/AppLaunchFlowTests + OnboardingViewControllerTests"]

  main --> app
  plist --> app
  assets --> onboardingVC
  assets --> onboardingDetailVC
  assets --> carouselCell
  assets --> mainMenuVC
  app --> onboardingState
  app --> onboardingVC
  onboardingVC --> onboardingDetailVC
  onboardingVC --> carouselCell
  onboardingVC -.delegate callback.-> app
  app --> mainMenuVC
  tests -.verifies.-> app
  tests -.verifies.-> onboardingVC
  tests -.verifies.-> onboardingDetailVC
```

## Runtime Flow

```mermaid
sequenceDiagram
  participant main as main.m
  participant app as AppDelegate
  participant state as OnboardingStateController
  participant onboarding as OnboardingViewController
  participant detail as OnboardingRecipeDetailViewController
  participant menu as MainMenuViewController

  main->>app: UIApplicationMain(...)
  app->>state: hasCompletedOnboarding()

  alt First launch
    app->>onboarding: buildOnboardingViewController()
    onboarding->>detail: present recipe detail
    detail-->>onboarding: Start Cooking
    onboarding-->>app: onboardingViewControllerDidFinish(...)
    app->>state: markOnboardingCompleted()
    app->>menu: buildMainMenuViewController()
  else Returning user
    app->>menu: buildMainMenuViewController()
  end
```

## Root Composition Graph

```mermaid
flowchart TB
  app["AppDelegate"]
  window["UIWindow"]
  state["OnboardingStateController"]
  onboarding["OnboardingViewController"]
  detail["OnboardingRecipeDetailViewController"]
  menu["MainMenuViewController"]
  defaults["NSUserDefaults"]

  app --> window
  app --> state
  state --> defaults
  app --> onboarding
  onboarding -.delegate.-> app
  onboarding --> detail
  app --> menu
```

## Persistence ERD

```mermaid
erDiagram
  USER_DEFAULTS {
    string suite_name
    bool has_completed_onboarding
  }

  ONBOARDING_STATE_CONTROLLER {
    bool hasCompletedOnboarding
  }

  APP_DELEGATE {
    UIWindow window
  }

  USER_DEFAULTS ||--|| ONBOARDING_STATE_CONTROLLER : backs
  ONBOARDING_STATE_CONTROLLER ||--|| APP_DELEGATE : injects_state
```

## Object Relationship Diagram

```mermaid
classDiagram
  class AppDelegate {
    +window
    +application:didFinishLaunchingWithOptions:
    +onboardingViewControllerDidFinish:
  }

  class OnboardingStateController {
    +hasCompletedOnboarding()
    +markOnboardingCompleted()
  }

  class OnboardingViewController {
    +delegate
  }

  class OnboardingRecipeDetailViewController

  class OnboardingViewControllerDelegate {
    <<protocol>>
    +onboardingViewControllerDidFinish()
  }

  class MainMenuViewController

  AppDelegate ..|> OnboardingViewControllerDelegate
  AppDelegate --> OnboardingStateController
  AppDelegate --> OnboardingViewController
  AppDelegate --> MainMenuViewController
  OnboardingViewController --> OnboardingViewControllerDelegate
  OnboardingViewController --> OnboardingRecipeDetailViewController
```

## File Responsibilities

| File | Responsibility | Key relationship |
| --- | --- | --- |
| `MRR Project/App/main.m` | Application bootstrap with manual autorelease pool | Starts UIKit lifecycle |
| `MRR Project/App/AppDelegate.h` | Public app delegate contract | Exposes injectable initializer for tests |
| `MRR Project/App/AppDelegate.m` | Composition root and root-controller switching | Depends on onboarding state and onboarding delegate callback |
| `MRR Project/Resources/Info.plist` | Application metadata and launch configuration | Referenced directly by build settings |
| `MRR Project/Resources/Assets.xcassets` | Shared app icon, named colors, and onboarding illustration | Used by the current programmatic UI |
| `MRR Project/App/MainMenuViewController.h` | Declares simple post-onboarding screen | No navigation responsibilities |
| `MRR Project/App/MainMenuViewController.m` | Renders simple placeholder main menu | Installed directly as root controller |
| `MRR Project/Features/Onboarding/Data/OnboardingStateController.h` | Declares onboarding persistence API | Used by `AppDelegate` |
| `MRR Project/Features/Onboarding/Data/OnboardingStateController.m` | Stores onboarding completion in `NSUserDefaults` | Single source of persisted launch state |
| `MRR Project/Features/Onboarding/Presentation/ViewControllers/OnboardingViewController.h` | Declares delegate-based onboarding contract | Reports completion upward |
| `MRR Project/Features/Onboarding/Presentation/ViewControllers/OnboardingViewController.m` | Builds branded onboarding layout, looping carousel, and modal presentation flow | Owns auto-scroll and launch centering safeguards |
| `MRR Project/Features/Onboarding/Presentation/ViewControllers/OnboardingRecipeDetailViewController.h` | Declares recipe-detail delegate callbacks | Reports close and `Start Cooking` actions |
| `MRR Project/Features/Onboarding/Presentation/ViewControllers/OnboardingRecipeDetailViewController.m` | Renders modal recipe detail content | Triggers onboarding completion through delegate |
| `MRR Project/Features/Onboarding/Presentation/Views/OnboardingRecipeCarouselCell.h` | Declares the onboarding carousel cell | Used by `OnboardingViewController` collection view |
| `MRR Project/Features/Onboarding/Presentation/Views/OnboardingRecipeCarouselCell.m` | Renders adaptive recipe cards, shared backdrop styling, and fade mask blending | Provides stable accessibility identifiers per recipe |
| `MRR ProjectTests/AppLaunchFlowTests.m` | Verifies launch-state behavior | Covers onboarding, persistence, and main-menu routing |
| `MRR ProjectTests/OnboardingViewControllerTests.m` | Verifies onboarding layout, carousel behavior, detail presentation, and accessibility | Covers centering, recentering, backdrop styling, and completion flow |

## Active Dependencies

The runtime dependency chain is intentionally small:

`AppDelegate -> OnboardingStateController -> NSUserDefaults`

`AppDelegate -> OnboardingViewController -> delegate callback -> AppDelegate`

`OnboardingViewController -> UICollectionView -> OnboardingRecipeCarouselCell`

`OnboardingViewController -> OnboardingRecipeDetailViewController`

`AppDelegate -> MainMenuViewController`

`Assets.xcassets -> OnboardingViewController / OnboardingRecipeDetailViewController / OnboardingRecipeCarouselCell / MainMenuViewController`

There is no tab bar, no feature repository graph, and no shared demo infrastructure anymore.

## Testing Coverage

```mermaid
flowchart LR
  tests["AppLaunchFlowTests"]
  first["first launch -> onboarding"]
  detail["recipe tap -> recipe detail modal"]
  finish["Start Cooking -> persist flag + show main menu"]
  returning["returning user -> main menu"]
  noTabs["no tab bar flow"]
  carousel["carousel centering + recentering + autoscroll"]
  a11y["accessibility identifiers + backdrop styling"]

  tests --> first
  tests --> detail
  tests --> finish
  tests --> returning
  tests --> noTabs
  tests --> carousel
  tests --> a11y
```

## Architectural Notes

- The app target uses Manual Retain-Release. Application code must continue balancing retained objects explicitly.
- Navigation is state-based, not coordinator-based. This keeps the app small and direct.
- `MainMenuViewController` is an app-level screen, not a feature module.
- The onboarding carousel uses virtual looping plus guarded initial positioning so auto-scroll does not jump on launch.
- Light and dark appearance rely on named colors from the shared asset catalog.
- Accessibility identifiers are a maintained part of the onboarding debug and UI-test contract.
- The current repository is intentionally narrow: app shell, onboarding state, onboarding UI, and focused launch/onboarding tests.

## Conclusion

The current architecture is a minimal two-state application: onboarding for first launch and a simple main menu for all subsequent launches. Within the onboarding state, the app now supports a richer interaction model through a looping carousel, modal recipe detail, themed adaptive UI, and a stable accessibility/test surface, while still keeping `AppDelegate` as the single orchestration point and onboarding completion as the only persisted state transition.
