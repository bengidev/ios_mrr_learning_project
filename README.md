# MVVM-C Pattern with Deep Linking - MRR Version

A complete implementation of the MVVM-C (Model-View-ViewModel-Coordinator) pattern with deep linking support for **MRR (Manual Retain-Release)** Objective-C projects.

## ⚠️ Important: Compiler Flag Required

All source files in this project **MUST** be compiled with the `-fno-objc-arc` flag to disable ARC.

### Xcode Configuration

1. Select target → Build Phases → Compile Sources
2. For each `.m` file, add compiler flag: `-fno-objc-arc`

Or for the entire target:
- Build Settings → Other C Flags → Add `-fno-objc-arc`

## Project Structure

```
MVVM-C-MRR/
├── Protocols/
│   ├── Coordinator.h          # Base coordinator protocol (retain/assign)
│   └── DeepLinkable.h         # Deep link handling protocol
├── Routing/
│   ├── DeepLinkRoute.h/m      # Parsed URL route model
│   └── URLRouter.h/m          # URL parsing and routing
├── Coordinators/
│   ├── BaseCoordinator.h/m    # Base coordinator class
│   ├── AppCoordinator.h/m     # Root app coordinator
│   ├── ProductsCoordinator.h/m
│   └── ProductDetailCoordinator.h/m
├── ViewModels/
│   ├── ProductListViewModel.h/m
│   └── ProductDetailViewModel.h/m
├── ViewControllers/
│   ├── ProductListViewController.h/m
│   └── ProductDetailViewController.h/m
└── Models/
    └── Product.h/m
```

## Integration

### AppDelegate Setup

```objc
// AppDelegate.m - Compile with -fno-objc-arc
#import "AppCoordinator.h"

@interface AppDelegate () {
    AppCoordinator *_appCoordinator;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application 
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    _appCoordinator = [[AppCoordinator alloc] initWithWindow:window];
    [_appCoordinator start];
    
    [window release]; // AppCoordinator retained it
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    return [_appCoordinator handleDeepLinkURL:url];
}

- (void)dealloc {
    [_appCoordinator release];
    [super dealloc];
}

@end
```

## MRR Memory Management Rules

### Property Attributes

| Relationship | ARC | MRR |
|-------------|-----|-----|
| Parent → Child | `strong` | `retain` |
| Child → Parent | `weak` | `assign` |
| Delegate | `weak` | `assign` |
| Strings | `copy` | `copy` |

### Critical MRR Patterns

```objc
// 1. Always implement dealloc
- (void)dealloc {
    [_myRetainedProperty release];
    // Do NOT release assign properties
    [super dealloc];
}

// 2. Setter pattern for retain properties
- (void)setMyProperty:(MyClass *)value {
    if (_myProperty != value) {
        [_myProperty release];
        _myProperty = [value retain];
    }
}

// 3. Setter pattern for copy properties
- (void)setMyString:(NSString *)value {
    if (_myString != value) {
        [_myString release];
        _myString = [value copy];
    }
}

// 4. Factory methods return autoreleased objects
+ (id)objectWithValue:(id)value {
    return [[[self alloc] initWithValue:value] autorelease];
}

// 5. Async block survival
- (void)asyncOperation {
    [self retain]; // Keep alive during async
    dispatch_async(queue, ^{
        // ... work ...
        [self release]; // Balance the retain
    });
}
```

### Avoid Blocks for Cross-Component Communication

In MRR, prefer **delegates** over blocks for coordinator-viewmodel communication. Blocks capture variables and complicate memory management.

## Supported Deep Links

| URL | Action |
|-----|--------|
| `myapp://products` | Shows product list |
| `myapp://products/123` | Shows product 123 |
| `myapp://products/123/reviews` | Shows reviews |
| `myapp://profile` | Shows user profile |
| `myapp://settings` | Shows settings |

## Testing

```bash
xcrun simctl openurl booted "myapp://products/101/reviews"
```
