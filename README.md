# iOS MRR Learning Project

A hands-on learning project for understanding **Manual Retain-Release (MRR)** memory management in Objective-C, the predecessor to ARC (Automatic Reference Counting).

> ⚠️ **Educational Purpose Only**: This project uses pre-ARC memory management patterns for learning. Apple requires iOS 15+ for new App Store submissions, so this is not intended for production use.

## 📚 What You'll Learn

### Memory Management Fundamentals
- **Reference Counting**: How iOS tracks object ownership
- **`retain`**: Claiming ownership of an object
- **`release`**: Relinquishing ownership
- **`autorelease`**: Delayed release mechanism
- **`dealloc`**: Object cleanup before deallocation

### Property Attributes
| MRR Attribute | Purpose |
|---------------|---------|
| `retain` | Object ownership (increases retain count) |
| `assign` | Primitives or weak references |
| `copy` | Create owned copy of object |

### Design Patterns
- **MVC** (Model-View-Controller)
- **Delegate Pattern** with proper memory management
- **Singleton Pattern** in MRR
- **Notification Center** usage and cleanup

## 🛠 Project Setup

### Requirements
- Xcode 15+ (or latest version)
- macOS Sonoma or later
- iOS Simulator

### Building
1. Open `MRR Project.xcodeproj` in Xcode
2. Select iOS Simulator target
3. Build and Run (⌘R)

### ARC is Disabled
This project has **Objective-C Automatic Reference Counting** set to **NO** in Build Settings, enabling manual memory management.

## 📖 Code Examples

### Basic Retain/Release
```objc
// Creating an object (retain count = 1)
NSString *name = [[NSString alloc] initWithString:@"Hello"];

// Retaining (retain count = 2)
[name retain];

// Releasing (retain count = 1)
[name release];

// Final release (retain count = 0 → deallocated)
[name release];
```

### Property Declaration
```objc
@interface Person : NSObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) NSInteger age;
@end

@implementation Person
- (void)dealloc {
    [_name release];  // Must release retained properties!
    [super dealloc];  // Must call super
}
@end
```

### Autorelease
```objc
- (NSString *)fullName {
    NSString *result = [[NSString alloc] initWithFormat:@"%@ %@", 
                        self.firstName, self.lastName];
    return [result autorelease];  // Caller doesn't need to release
}
```

## 📁 Project Structure

```
MRR Project/
├── AppDelegate.h/m      # Application lifecycle
├── ViewController.h/m   # Main view controller
├── Models/              # Data models with MRR
├── Services/            # Service classes with delegate patterns
└── Supporting Files/    # Resources and configuration
```

## 🔍 Memory Management Rules

### The Golden Rules
1. **If you `alloc`, `new`, `copy`, or `mutableCopy`** → you must `release`
2. **If you `retain`** → you must `release`
3. **If you receive from other methods** → don't release (unless you retained)

### Common Pitfalls
- ❌ Forgetting to release in `dealloc`
- ❌ Over-releasing (double release → crash)
- ❌ Using `retain` for delegates (causes retain cycles)
- ❌ Forgetting to call `[super dealloc]`

## 📝 License

This project is for educational purposes. Feel free to use and modify for learning.

## 🙏 Acknowledgments

- Apple's [Memory Management Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/MemoryMgmt/Articles/MemoryMgmt.html)
- The iOS development community for preserving MRR knowledge
