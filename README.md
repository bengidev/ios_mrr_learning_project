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
- **MVVM** (Model-View-ViewModel)
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

Learn concurrent programming patterns using GCD with both MRR and ARC implementations.

### Key Concepts

| Concept | Description |
|---------|-------------|
| **Serial Queue** | Tasks execute one at a time, in order |
| **Concurrent Queue** | Tasks execute in parallel (simultaneously) |
| **Dispatch Group** | Wait for multiple tasks to complete |
| **Main Queue** | Serial queue for UI updates |

### Sequential vs Parallel Execution

```objc
// SEQUENTIAL - Tasks run one after another (~1.0s for 10 tasks)
dispatch_queue_t serial = dispatch_queue_create("com.app.serial", DISPATCH_QUEUE_SERIAL);
for (int i = 0; i < 10; i++) {
    dispatch_async(serial, ^{
        sleep(0.1);  // Total: ~1.0s
    });
}

// PARALLEL - Tasks run simultaneously (~0.1s for 10 tasks)
dispatch_queue_t concurrent = dispatch_queue_create("com.app.concurrent", DISPATCH_QUEUE_CONCURRENT);
for (int i = 0; i < 10; i++) {
    dispatch_async(concurrent, ^{
        sleep(0.1);  // Total: ~0.1s
    });
}
```

### MRR vs ARC Memory in GCD

| Aspect | MRR | ARC |
|--------|-----|-----|
| `dispatch_queue_create` | Returns retained queue (must `dispatch_release`) | Auto-released |
| `dispatch_group_create` | Returns retained group (must `dispatch_release`) | Auto-released |
| Blocks with objects | Need `Block_copy`/`Block_release` | Auto-managed |
| Captured objects | Must `retain` for async blocks | Auto-retained |

### MRR Example: Parallel Execution

```objc
dispatch_queue_t queue = dispatch_queue_create("com.app.concurrent", DISPATCH_QUEUE_CONCURRENT);
dispatch_group_t group = dispatch_group_create();

// Task 1
dispatch_group_enter(group);
dispatch_async(queue, ^{
    // Do work...
    dispatch_group_leave(group);
});

// Task 2
dispatch_group_enter(group);
dispatch_async(queue, ^{
    // Do work...
    dispatch_group_leave(group);
});

// Called when ALL tasks complete
dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    // All done!
});

// Release resources (MRR only)
dispatch_release(group);
dispatch_release(queue);
```

### ARC Example: Same Pattern (Simpler)

```objc
dispatch_queue_t queue = dispatch_queue_create("com.app.concurrent", DISPATCH_QUEUE_CONCURRENT);
dispatch_group_t group = dispatch_group_create();

// Same tasks... but NO need to release queue/group
dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    // All done!
});
// ARC handles cleanup automatically
```

### Practical Pattern: Parallel Data Fetch

```objc
// Fetch user, posts, and friends simultaneously
- (void)fetchUserDataWithCompletion:(void (^)(NSDictionary *))completion {
    dispatch_group_t group = dispatch_group_create();
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    NSLock *lock = [[NSLock alloc] init];

    // Fetch user (MRR: data and lock retained by blocks)
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Simulate network...
        [lock lock];
        data[@"user"] = userInfo;
        [lock unlock];
        dispatch_group_leave(group);
    });

    // Fetch posts...
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Simulate network...
        [lock lock];
        data[@"posts"] = posts;
        [lock unlock];
        dispatch_group_leave(group);
    });

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        completion([data copy]);  // Return immutable copy
        // MRR: [data release]; [lock release];
    });
}
```

### Thread Safety with Locks

```objc
NSLock *lock = [[NSLock alloc] init];
NSMutableArray *results = [NSMutableArray array];

dispatch_async(concurrentQueue, ^{
    [lock lock];
    [results addObject:@(result)];
    [lock unlock];
});

// MRR: [lock release];
```

### When to Use Each

| Pattern | Use Case |
|---------|----------|
| **Serial Queue** | Ordered operations, UI updates, consistency |
| **Concurrent Queue** | Independent tasks, parallel computations |
| **dispatch_get_main_queue()** | UI updates only |
| **dispatch_get_global_queue()** | Background work, parallel operations |

### Files Reference

```
MRR Project/Threading/
├── ARC/                    # Automatic Reference Counting
│   ├── ParallelThreadManager_ARC
│   ├── SequentialThreadManager_ARC
│   └── PerformanceComparison_ARC
└── MRR/                    # Manual Retain Release
    ├── ParallelThreadManager_MRR
    ├── SequentialThreadManager_MRR
    └── PerformanceComparison_MRR
```

---

# 🎓 Threading Learning Guide: MRR vs ARC

## Table of Contents
1. [Sequential vs Parallel Execution](#sequential-vs-parallel-execution)
2. [GCD Basics](#gcd-basics)
3. [Memory Management Comparison](#memory-management-comparison)
4. [Performance Comparison](#performance-comparison)
5. [Practical Patterns](#practical-patterns)
6. [Quick Reference Card](#quick-reference-card)

---

## 1️⃣ Sequential vs Parallel Execution

### What's the Difference?

| Sequential | Parallel |
|------------|----------|
| Tasks run **one after another** | Tasks run **at the same time** |
| Task 1 → Task 2 → Task 3 | All tasks start together |
| Slower but predictable | Faster but requires thread safety |

### Simple Example

```objc
// SEQUENTIAL: Each task waits for the previous one
- (void)sequentialExample {
    NSLog(@"Start Task 1");
    [self doTask1];  // Takes 1 second
    NSLog(@"Start Task 2");
    [self doTask2];  // Takes 1 second
    NSLog(@"Start Task 3");
    [self doTask3];  // Takes 1 second
    // Total: ~3 seconds
}

// PARALLEL: All tasks run at once
- (void)parallelExample {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self doTask1];  // Takes 1 second
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self doTask2];  // Takes 1 second
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self doTask3];  // Takes 1 second
    });
    // Total: ~1 second
}
```

---

## 2️⃣ GCD Basics

### Key Terms You Need to Know

| Term | Meaning |
|------|---------|
| **Queue** | A line where tasks wait to run |
| **Dispatch** | Sending a task to a queue |
| **Async** | "Don't wait, run this later" |
| **Sync** | "Wait here until this finishes" |

### Queue Types with Examples

```objc
// 1. MAIN QUEUE - Serial, for UI updates only
dispatch_async(dispatch_get_main_queue(), ^{
    // Update UI here (always runs on main thread)
});

// 2. GLOBAL QUEUE - Concurrent, for background work
dispatch_async(dispatch_get_global_queue(0, 0), ^{
    // Heavy computation here
});

// 3. CUSTOM SERIAL QUEUE - Tasks run in order (one at a time)
dispatch_queue_t myQueue = dispatch_queue_create("com.myapp.queue", DISPATCH_QUEUE_SERIAL);
dispatch_async(myQueue, ^{
    NSLog(@"Task 1");  // Runs first
});
dispatch_async(myQueue, ^{
    NSLog(@"Task 2");  // Waits for Task 1
});

// 4. CUSTOM CONCURRENT QUEUE - Tasks run together
dispatch_queue_t concurrentQueue = dispatch_queue_create("com.myapp.concurrent", 
                                                         DISPATCH_QUEUE_CONCURRENT);
```

---

## 3️⃣ Memory Management Comparison

### MRR (Manual Retain-Release) - You Control Memory

```objc
// MRR: Manual memory management - YOU must manage everything
- (void)mrExample {
    // Step 1: Create object (retain count = 1)
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    // Step 2: Copy block for async use (required in MRR)
    void (^completion)(NSArray *) = ^(NSArray *arr) {
        NSLog(@"Results: %@", arr);
    };
    void (^copiedBlock)(NSArray *) = Block_copy(completion);
    
    // Use in async
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        copiedBlock(@[@1, @2, @3]);
    });
    
    // Step 3: RELEASE everything when done
    Block_release(copiedBlock);
    [results release];
}
```

### ARC (Automatic Reference Counting) - Compiler Controls Memory

```objc
// ARC: Automatic memory management - compiler handles everything
- (void)arcExample {
    // Step 1: Create object normally
    NSMutableArray *results = [NSMutableArray array];
    
    // Step 2: Use block directly (compiler handles copying)
    void (^completion)(NSArray *) = ^(NSArray *arr) {
        NSLog(@"Results: %@", arr);
    };
    
    // Use in async
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        completion(@[@1, @2, @3]);
    });
    
    // Step 3: NO manual release needed!
}
```

### Side-by-Side Comparison Table

| Action | MRR | ARC |
|--------|-----|-----|
| Create object | `[[Class alloc] init]` | `[Class array]` |
| Create queue | `create` + `release` | `create` only |
| Copy block for async | `Block_copy()` | automatic |
| Release block | `Block_release()` | automatic |
| Release object | `[obj release]` | automatic |

### Common MRR Mistakes to Avoid

```objc
// ❌ WRONG in MRR - Forgetting to release queue (MEMORY LEAK!)
- (void)badMrExample {
    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
    // ... use queue ...
    // FORGOT: dispatch_release(queue);
}

// ❌ WRONG in MRR - Block may be deallocated before execution
- (void)badMrExample2 {
    void (^myBlock)(void) = ^{ NSLog(@"Test"); };
    dispatch_async(dispatch_get_global_queue(0, 0), myBlock);
    // FORGOT: Block_copy() - block is on stack, may die!
}

// ✅ CORRECT in MRR
- (void)correctMrExample {
    dispatch_queue_t queue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
    void (^myBlock)(void) = Block_copy(^{ NSLog(@"Test"); });
    dispatch_async(queue, myBlock);
    dispatch_release(queue);     // Safe: queue lives until blocks complete
    Block_release(myBlock);      // Release block after dispatch
}
```

---

## 4️⃣ Performance Comparison

### Why Parallel is 10x Faster

```objc
// MEASURING PERFORMANCE
- (void)measureSpeed {
    NSDate *start = [NSDate date];
    
    // Run 10 tasks SEQUENTIALLY
    for (int i = 0; i < 10; i++) {
        [NSThread sleepForTimeInterval:0.1];  // 100ms pause each
    }
    
    NSTimeInterval sequentialTime = [[NSDate date] timeIntervalSinceDate:start];
    NSLog(@"Sequential: %.2f seconds", sequentialTime);  // ~1.0 second
    
    // Now run in PARALLEL
    start = [NSDate date];
    dispatch_group_t group = dispatch_group_create();
    
    for (int i = 0; i < 10; i++) {
        dispatch_group_enter(group);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [NSThread sleepForTimeInterval:0.1];
            dispatch_group_leave(group);
        });
    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSTimeInterval parallelTime = [[NSDate date] timeIntervalSinceDate:start];
    NSLog(@"Parallel: %.2f seconds", parallelTime);  // ~0.1 second
}
```

### When to Use Each

| Scenario | Use Sequential | Use Parallel |
|----------|:--------------:|:------------:|
| UI Updates | ✅ | ❌ |
| Database writes | ✅ | ❌ |
| File downloads | ❌ | ✅ |
| Image processing | ❌ | ✅ |
| API calls | ❌ | ✅ |
| Task with dependencies | ✅ | ❌ |

---

## 5️⃣ Practical Patterns

### Pattern 1: Parallel Data Fetching (Real-World Use Case)

**Use Case:** Fetch user info, posts, and friends all at once

```objc
// ARC VERSION (Recommended for modern code)
- (void)fetchUserDataWithCompletion:(void (^)(NSDictionary *))completion {
    dispatch_group_t group = dispatch_group_create();
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    NSLock *lock = [[NSLock alloc] init];
    
    // Fetch user info
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:0.2];  // Simulate network
        NSDictionary *user = @{@"name": @"John", @"id": @123};
        
        [lock lock];
        data[@"user"] = user;
        [lock unlock];
        
        dispatch_group_leave(group);
    });
    
    // Fetch posts (runs at same time)
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:0.15];
        NSArray *posts = @[@"Post 1", @"Post 2"];
        
        [lock lock];
        data[@"posts"] = posts;
        [lock unlock];
        
        dispatch_group_leave(group);
    });
    
    // Fetch friends (runs at same time)
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:0.1];
        NSArray *friends = @[@"Alice", @"Bob"];
        
        [lock lock];
        data[@"friends"] = friends;
        [lock unlock];
        
        dispatch_group_leave(group);
    });
    
    // Called when ALL tasks complete
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        completion([data copy]);  // Return immutable copy
        // ARC: lock auto-released
    });
}

// Usage
[self fetchUserDataWithCompletion:^(NSDictionary *userData) {
    NSLog(@"Got all data: %@", userData);
}];
```

### Pattern 2: Sequential Operations (Must Run in Order)

**Use Case:** Login → Load Data → Process (order matters)

```objc
// ARC VERSION
- (void)runSequentialTasksWithCompletion:(void (^)(void))completion {
    dispatch_queue_t serialQueue = dispatch_queue_create("com.app.tasks", 
                                                         DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(serialQueue, ^{
        NSLog(@"Task 1: Login");
        [NSThread sleepForTimeInterval:0.1];
    });
    
    dispatch_async(serialQueue, ^{
        NSLog(@"Task 2: Load Data");
        [NSThread sleepForTimeInterval:0.1];
    });
    
    dispatch_async(serialQueue, ^{
        NSLog(@"Task 3: Process Data");
        [NSThread sleepForTimeInterval:0.1];
        
        // Call completion on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            completion();
        });
    });
}
```

### Pattern 3: Parallel Calculations with Results

**Use Case:** Calculate values and collect them all

```objc
// ARC VERSION
- (void)calculateInParallelWithCompletion:(void (^)(NSArray *))completion {
    dispatch_queue_t queue = dispatch_queue_create("com.app.calc", 
                                                   DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *results = [NSMutableArray array];
    NSLock *lock = [[NSLock alloc] init];
    
    for (int i = 1; i <= 5; i++) {
        dispatch_group_enter(group);
        dispatch_async(queue, ^{
            NSInteger result = i * i;  // Square the number
            
            [lock lock];
            [results addObject:@(result)];
            [lock unlock];
            
            dispatch_group_leave(group);
        });
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSArray *sorted = [results sortedArrayUsingSelector:@selector(compare:)];
        completion(sorted);  // Returns [1, 4, 9, 16, 25]
    });
}
```

---

## 6️⃣ Quick Reference Card

### Essential GCD Functions

| Function | Meaning | Example |
|----------|---------|---------|
| `dispatch_async(queue, block)` | Run block asynchronously | `dispatch_async(q, ^{})` |
| `dispatch_sync(queue, block)` | Run block and wait | `dispatch_sync(q, ^{})` |
| `dispatch_group_create()` | Create a group | `dispatch_group_t g = ...` |
| `dispatch_group_enter(group)` | Task started | `enter(group)` |
| `dispatch_group_leave(group)` | Task finished | `leave(group)` |
| `dispatch_group_wait(group, time)` | Wait for all | `wait(group, FOREVER)` |
| `dispatch_group_notify(group, queue, block)` | Run when all done | `notify(g, q, ^{})` |
| `dispatch_get_main_queue()` | Main thread | For UI updates |
| `dispatch_get_global_queue(0, 0)` | Background queue | For parallel work |
| `dispatch_queue_create(name, type)` | Create custom queue | Serial or Concurrent |

### Memory Management Rules

```
┌─────────────────────────────────────────────────────────────────┐
│                         MRR RULES                                │
├─────────────────────────────────────────────────────────────────┤
│  • alloc/new/copy → RETAIN count +1 → YOU must release          │
│  • retain → RETAIN count +1 → YOU must release                  │
│  • release → RETAIN count -1 → dealloc when 0                   │
│  • Block_copy() → YOU must Block_release()                      │
│  • dispatch_queue_create → YOU must dispatch_release()          │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                         ARC RULES                                │
├─────────────────────────────────────────────────────────────────┤
│  • DON'T call retain, release, autorelease                      │
│  • DON'T call Block_copy/Block_release                          │
│  • DON'T call [super dealloc]                                   │
│  • DON'T manage dispatch objects manually                       │
│  • Compiler handles everything automatically                     │
└─────────────────────────────────────────────────────────────────┘
```

### Quick Decision Tree

```
START
  │
  ├─ Need UI update?
  │    └─ YES → dispatch_get_main_queue()
  │
  ├─ Tasks depend on each other?
  │    └─ YES → Serial queue (DISPATCH_QUEUE_SERIAL)
  │
  ├─ Tasks are independent?
  │    └─ YES → Concurrent queue (DISPATCH_QUEUE_CONCURRENT)
  │
  └─ Need to wait for multiple tasks?
       └─ YES → Use dispatch_group
```

---

## 📝 Summary

| Aspect | MRR | ARC |
|--------|-----|-----|
| Code complexity | Higher | Lower |
| Error-prone | Yes (memory leaks, crashes) | No |
| Boilerplate | More | Less |
| Performance | Same | Same |
| Learning value | Great for understanding | Production standard |

### 🎯 Key Takeaways

1. **Use Main Queue** for UI updates only
2. **Use Serial Queues** when order matters
3. **Use Concurrent Queues** for independent parallel tasks
4. **Use Dispatch Groups** to track multiple async operations
5. **Always use locks** when multiple threads access shared data
6. **Prefer ARC** for modern iOS development
7. **Learn MRR** to understand memory management fundamentals

### ✅ Recommended Pattern (Modern iOS)

```objc
// RECOMMENDED: Modern ARC approach
- (void)recommendedPattern {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // Background work here
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI here
        });
    });
}
```

---

## 🙏 Acknowledgments

- Apple's [Memory Management Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/MemoryMgmt/Articles/MemoryMgmt.html)
- The iOS development community for preserving MRR knowledge

---

# 📋 ARC & MRR Comprehensive Cheat Sheet

A complete reference guide for Objective-C memory management covering both **Automatic Reference Counting (ARC)** and **Manual Retain Release (MRR)**.

---

## 📑 Table of Contents

1. [Core Concepts](#-core-concepts-1)
2. [Reference Counting Basics](#-reference-counting-basics)
3. [MRR (Manual Retain Release)](#-mrr-manual-retain-release)
4. [ARC (Automatic Reference Counting)](#-arc-automatic-reference-counting)
5. [Property Attributes](#-property-attributes)
6. [Memory Management Patterns](#-memory-management-patterns)
7. [Common Pitfalls & Solutions](#-common-pitfalls--solutions)
8. [Best Practices](#-best-practices)
9. [Quick Reference Tables](#-quick-reference-tables)
10. [Debugging Tools](#-debugging-tools)
11. [Migration Tips](#-migration-tips)

---

## 🎯 Core Concepts

### Object Lifecycle

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   alloc     │ ──▶ │    init     │ ──▶ │    use      │ ──▶ │   dealloc   │
│ (refCount=1)│     │ (refCount=1)│     │ (refCount≥1)│     │ (refCount=0)│
└─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
```

### Reference Count Rules

| Operation | Effect on Reference Count |
|-----------|---------------------------|
| `alloc`   | Sets to 1 |
| `new`     | Sets to 1 (alloc + init) |
| `copy`    | Sets to 1 (new object) |
| `mutableCopy` | Sets to 1 (new object) |
| `retain`  | Increments by 1 |
| `release` | Decrements by 1 |
| `autorelease` | Decrements by 1 (later) |

---

## 🔢 Reference Counting Basics

### The Golden Rule

> **If you create or retain an object, you are responsible for releasing it.**

Objects are created using methods beginning with:
- `alloc`
- `new`
- `copy`
- `mutableCopy`

### Ownership Transfer

```objc
// You OWN this object (must release)
NSString *owned = [[NSString alloc] initWithFormat:@"Hello %@", name];

// You DO NOT own this object (don't release)
NSString *notOwned = [NSString stringWithFormat:@"Hello %@", name];
```

---

## 🔧 MRR (Manual Retain Release)

### Basic Operations

```objc
// Creating objects (you own them)
MyClass *obj1 = [[MyClass alloc] init];      // refCount = 1
MyClass *obj2 = [obj1 copy];                  // refCount = 1 (new object)
MyClass *obj3 = [obj1 mutableCopy];           // refCount = 1 (new object)

// Retaining (increment refCount)
[obj1 retain];                                // refCount = 2

// Releasing (decrement refCount)
[obj1 release];                               // refCount = 1
[obj1 release];                               // refCount = 0 → dealloc called

// Autorelease (delayed release)
MyClass *obj4 = [[[MyClass alloc] init] autorelease];
```

### Dealloc Implementation (MRR)

```objc
- (void)dealloc {
    // Release all owned objects
    [_name release];
    _name = nil;
    
    [_delegate release];  // Only if retained!
    _delegate = nil;
    
    // Remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Call super LAST
    [super dealloc];
}
```

### Property Accessors (MRR)

#### Retain Property

```objc
// Header
@property (nonatomic, retain) NSString *name;

// Implementation - Setter
- (void)setName:(NSString *)name {
    if (_name != name) {
        [_name release];
        _name = [name retain];
    }
}

// Implementation - Getter
- (NSString *)name {
    return _name;
}
```

#### Copy Property

```objc
// Header
@property (nonatomic, copy) NSString *name;

// Implementation - Setter
- (void)setName:(NSString *)name {
    if (_name != name) {
        [_name release];
        _name = [name copy];
    }
}
```

#### Assign Property (for primitives and delegates)

```objc
// Header
@property (nonatomic, assign) id<MyDelegate> delegate;
@property (nonatomic, assign) NSInteger count;

// Implementation - Setter
- (void)setDelegate:(id<MyDelegate>)delegate {
    _delegate = delegate;  // No retain!
}

- (void)setCount:(NSInteger)count {
    _count = count;
}
```

### Autorelease Pool

```objc
// Creating an autorelease pool
NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

// Do work that creates autoreleased objects
for (int i = 0; i < 10000; i++) {
    NSString *str = [NSString stringWithFormat:@"Item %d", i];
    // str is autoreleased, will be released when pool drains
}

// Drain the pool (releases all autoreleased objects)
[pool drain];  // or [pool release]
```

### Factory Methods (MRR)

```objc
// Class method returning autoreleased object
+ (instancetype)personWithName:(NSString *)name {
    return [[[self alloc] initWithName:name] autorelease];
}

// Instance init method
- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = [name copy];  // Take ownership
    }
    return self;
}
```

---

## ⚡ ARC (Automatic Reference Counting)

### Key Differences from MRR

| Aspect | MRR | ARC |
|--------|-----|-----|
| `retain` | Manual | ❌ Forbidden |
| `release` | Manual | ❌ Forbidden |
| `autorelease` | Manual | ❌ Forbidden |
| `dealloc` | Call `[super dealloc]` | ❌ Don't call super |
| Memory management | Developer | Compiler |

### Ownership Qualifiers

#### `__strong` (Default)

```objc
// These are equivalent
NSString *name = @"John";
__strong NSString *name = @"John";

// Object is retained, released when goes out of scope
- (void)example {
    NSString *str = [[NSString alloc] init];  // retained
}  // released here
```

#### `__weak`

```objc
// Weak reference - does NOT retain
// Automatically set to nil when object is deallocated
__weak NSString *weakName = strongName;

// Common use: delegates, avoiding retain cycles
@property (nonatomic, weak) id<MyDelegate> delegate;
```

#### `__unsafe_unretained`

```objc
// Does NOT retain, NOT set to nil on dealloc
// Use only for backward compatibility (iOS 4)
__unsafe_unretained NSString *unsafeName = strongName;

// ⚠️ Dangerous: can become dangling pointer
```

#### `__autoreleasing`

```objc
// Used for objects passed by reference (error parameters)
- (BOOL)doSomethingWithError:(NSError * __autoreleasing *)error {
    if (somethingWentWrong) {
        *error = [NSError errorWithDomain:@"MyDomain" code:1 userInfo:nil];
        return NO;
    }
    return YES;
}

// Calling
NSError *error;  // implicitly __autoreleasing for out params
[self doSomethingWithError:&error];
```

### Dealloc Implementation (ARC)

```objc
- (void)dealloc {
    // Release non-object resources
    CFRelease(_cfObject);
    
    // Remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Cancel timers
    [_timer invalidate];
    
    // ❌ DO NOT call [super dealloc]
    // ❌ DO NOT release instance variables
}
```

### Bridging (ARC ↔ Core Foundation)

```objc
// __bridge - No ownership transfer
CFStringRef cfStr = (__bridge CFStringRef)nsString;
NSString *nsStr = (__bridge NSString *)cfString;

// __bridge_retained (or CFBridgingRetain) - ARC → CF (ARC releases ownership)
CFStringRef cfStr = (__bridge_retained CFStringRef)nsString;
// or
CFStringRef cfStr = CFBridgingRetain(nsString);
// You must CFRelease(cfStr) later

// __bridge_transfer (or CFBridgingRelease) - CF → ARC (ARC takes ownership)
NSString *nsStr = (__bridge_transfer NSString *)cfString;
// or
NSString *nsStr = CFBridgingRelease(cfString);
// No need to CFRelease, ARC manages it
```

---

## 🏷️ Property Attributes

### Memory Management Attributes

| Attribute | ARC | MRR | Description |
|-----------|-----|-----|-------------|
| `strong` | ✅ | ❌ | Retains the object (default for objects) |
| `retain` | ⚠️ | ✅ | Same as strong (legacy) |
| `weak` | ✅ | ❌ | Weak reference, zeroing |
| `assign` | ✅ | ✅ | Direct assignment (primitives, unsafe for objects) |
| `unsafe_unretained` | ✅ | ❌ | Like assign, for objects |
| `copy` | ✅ | ✅ | Copies the object |

### Atomicity Attributes

| Attribute | Description | Performance |
|-----------|-------------|-------------|
| `atomic` | Thread-safe accessors (default) | Slower |
| `nonatomic` | Not thread-safe | Faster |

### Accessor Attributes

| Attribute | Description |
|-----------|-------------|
| `readonly` | Only getter |
| `readwrite` | Getter and setter (default) |
| `getter=name` | Custom getter name |
| `setter=name:` | Custom setter name |

### Complete Property Examples

```objc
// ARC
@property (nonatomic, strong) NSArray *items;           // Strong reference
@property (nonatomic, weak) id<Delegate> delegate;      // Weak to avoid cycles
@property (nonatomic, copy) NSString *name;             // Copy for value semantics
@property (nonatomic, copy) void (^callback)(void);     // Always copy blocks
@property (nonatomic, assign) NSInteger count;          // Primitive
@property (nonatomic, assign) CGRect frame;             // Struct

// MRR
@property (nonatomic, retain) NSArray *items;
@property (nonatomic, assign) id<Delegate> delegate;    // assign for delegates
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) void (^callback)(void);
@property (nonatomic, assign) NSInteger count;
```

---

## 🔄 Memory Management Patterns

### Retain Cycles

#### The Problem

```objc
@interface Parent : NSObject
@property (nonatomic, strong) Child *child;  // Strong
@end

@interface Child : NSObject
@property (nonatomic, strong) Parent *parent;  // Strong → RETAIN CYCLE!
@end

// Neither can be deallocated!
```

#### The Solution

```objc
@interface Parent : NSObject
@property (nonatomic, strong) Child *child;
@end

@interface Child : NSObject
@property (nonatomic, weak) Parent *parent;  // Weak → No cycle
@end
```

### Block Retain Cycles

#### The Problem

```objc
// self → block → self (RETAIN CYCLE!)
self.completionBlock = ^{
    [self doSomething];
};
```

#### ARC Solution

```objc
__weak typeof(self) weakSelf = self;
self.completionBlock = ^{
    __strong typeof(weakSelf) strongSelf = weakSelf;
    if (strongSelf) {
        [strongSelf doSomething];
    }
};
```

#### MRR Solution

```objc
__block typeof(self) blockSelf = self;  // __block prevents retain in MRR
self.completionBlock = ^{
    [blockSelf doSomething];
};
```

### Delegate Pattern

#### ARC

```objc
// Delegate should be weak to prevent cycles
@property (nonatomic, weak) id<MyDelegate> delegate;
```

#### MRR

```objc
// Delegate should be assign (unsafe_unretained equivalent)
@property (nonatomic, assign) id<MyDelegate> delegate;

// Must nil out delegate in dealloc of delegate object
- (void)dealloc {
    _observedObject.delegate = nil;  // Prevent dangling pointer
    [super dealloc];
}
```

### Singleton Pattern

#### ARC

```objc
+ (instancetype)sharedInstance {
    static MyClass *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}
```

#### MRR

```objc
+ (instancetype)sharedInstance {
    static MyClass *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
        // Don't autorelease - singleton lives forever
    });
    return shared;
}

// Override to prevent deallocation
- (oneway void)release { }
- (instancetype)retain { return self; }
- (NSUInteger)retainCount { return UINT_MAX; }
```

---

## ⚠️ Common Pitfalls & Solutions

### 1. Over-releasing

```objc
// ❌ WRONG - Double release
NSString *str = [[NSString alloc] init];
[str release];
[str release];  // CRASH!

// ✅ CORRECT - Set to nil after release
NSString *str = [[NSString alloc] init];
[str release];
str = nil;
```

### 2. Using Autoreleased Object After Pool Drain

```objc
// ❌ WRONG
NSString *result;
@autoreleasepool {
    result = [NSString stringWithFormat:@"Hello"];
}
NSLog(@"%@", result);  // CRASH - object deallocated!

// ✅ CORRECT
NSString *result;
@autoreleasepool {
    result = [[NSString stringWithFormat:@"Hello"] retain];  // MRR
    // or just move usage inside the pool
}
NSLog(@"%@", result);
[result release];  // MRR
```

### 3. Collection Ownership

```objc
// Collections retain their contents
NSMutableArray *array = [[NSMutableArray alloc] init];

// MRR - array retains object, so release your ownership
MyObject *obj = [[MyObject alloc] init];
[array addObject:obj];
[obj release];  // Array now owns it

// Object removed - array releases it
[array removeObject:obj];  // obj may be deallocated

// In ARC - just add, no manual release needed
[array addObject:[[MyObject alloc] init]];
```

### 4. Premature Deallocation in Accessors

```objc
// ❌ WRONG - Dangerous if name == _name
- (void)setName:(NSString *)name {
    [_name release];
    _name = [name retain];  // CRASH if name was _name!
}

// ✅ CORRECT - Check for self-assignment
- (void)setName:(NSString *)name {
    if (_name != name) {
        [_name release];
        _name = [name retain];
    }
}

// ✅ ALSO CORRECT - Retain before release
- (void)setName:(NSString *)name {
    [name retain];
    [_name release];
    _name = name;
}
```

### 5. Not Removing Observers

```objc
// ❌ WRONG - Observer may be called on deallocated object
- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:@"SomeNotification"
                                               object:nil];
}

// ✅ CORRECT - Remove in dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];  // MRR only
}
```

### 6. Timer Retain Cycles

```objc
// ❌ PROBLEM - Timer retains its target
self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                              target:self
                                            selector:@selector(tick)
                                            userInfo:nil
                                             repeats:YES];
// self → timer → self (RETAIN CYCLE)

// ✅ SOLUTION - Invalidate timer before deallocation
- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

// Or use a weak proxy target (iOS 10+)
self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             repeats:YES
                                               block:^(NSTimer *timer) {
    // Use weakSelf pattern here
}];
```

---

## ✅ Best Practices

### General Rules

1. **Follow naming conventions** - Methods starting with `alloc`, `new`, `copy`, `mutableCopy` transfer ownership
2. **Use `copy` for value objects** - NSString, NSArray, NSDictionary as properties
3. **Use `weak`/`assign` for delegates** - Prevents retain cycles
4. **Always copy blocks** - Blocks on the stack need to be copied to heap
5. **Remove observers in dealloc** - NSNotificationCenter, KVO observers

### MRR-Specific

1. **Always nil after release** - Prevents dangling pointers
2. **Check self-assignment in setters** - Avoid premature deallocation
3. **Autorelease for returned objects** - Unless method name implies ownership
4. **Use `@autoreleasepool` in loops** - Prevent memory buildup
5. **Call `[super dealloc]` last** - After releasing all ivars

### ARC-Specific

1. **Never call retain/release/autorelease** - Compiler handles this
2. **Never call `[super dealloc]`** - Compiler handles this
3. **Use `__weak` for delegates** - Zeroing weak references
4. **Use `__bridge` carefully** - Understand ownership implications
5. **Profile with Instruments** - Leaks and Allocations tools

---

## 📊 Quick Reference Tables

### Method Naming & Ownership

| Method Prefix | Ownership | Caller Responsibility |
|---------------|-----------|----------------------|
| `alloc...` | Owned | Release |
| `new...` | Owned | Release |
| `copy...` | Owned | Release |
| `mutableCopy...` | Owned | Release |
| Everything else | Not owned | Don't release |

### Property Attribute Quick Reference

| Use Case | ARC | MRR |
|----------|-----|-----|
| Object ownership | `strong` | `retain` |
| Weak reference | `weak` | `assign` (+ nil in dealloc) |
| Value copy | `copy` | `copy` |
| Primitive | `assign` | `assign` |
| Block | `copy` | `copy` |
| Delegate | `weak` | `assign` |

### Common Memory Issues

| Issue | Symptom | Solution |
|-------|---------|----------|
| Retain cycle | Memory never freed | Use weak/assign appropriately |
| Over-release | EXC_BAD_ACCESS crash | Balance retain/release |
| Use after free | Garbage data/crash | Nil after release |
| Memory leak | Growing memory usage | Release owned objects |

### Dealloc Checklist

| Task | ARC | MRR |
|------|-----|-----|
| Release ivars | ❌ Auto | ✅ Manual |
| Remove observers | ✅ | ✅ |
| Invalidate timers | ✅ | ✅ |
| Nil delegates | ⚠️ Weak auto-nils | ✅ Critical |
| Release CF objects | ✅ | ✅ |
| Call super | ❌ Never | ✅ Last |

---

## 🔍 Debugging Tools

### Instruments Profiles

- **Leaks** - Detect memory not being freed
- **Allocations** - Track all memory allocations
- **Zombies** - Detect messages to deallocated objects

### Compiler Flags

```bash
# Enable Zombies (debug only)
NSZombieEnabled=YES

# Enable Malloc debugging
MallocStackLogging=YES

# Detect over-release
MallocScribble=YES
```

### Static Analyzer

```bash
# Run Xcode Static Analyzer
Product → Analyze (⇧⌘B)

# Clang command line
clang --analyze MyFile.m
```

---

## 🔄 Migration Tips

### MRR → ARC

1. Use Xcode's "Convert to ARC" tool (Edit → Refactor → Convert to Objective-C ARC)
2. Replace `retain` properties with `strong`
3. Replace `assign` object properties with `weak` or `unsafe_unretained`
4. Remove all `retain`, `release`, `autorelease` calls
5. Remove `[super dealloc]` calls
6. Add `__bridge` casts for Core Foundation

### Per-File ARC Control

```objc
// In Build Phases → Compile Sources
// Add compiler flag for specific files:
-fno-objc-arc    // Disable ARC for this file
-fobjc-arc       // Enable ARC for this file
```

---

## 📈 Summary Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    MEMORY MANAGEMENT                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   MRR (Manual)              │    ARC (Automatic)                │
│   ─────────────             │    ────────────────               │
│                             │                                    │
│   alloc/init ──┐            │    alloc/init ──┐                 │
│                │            │                 │                  │
│   retain ──────┼─→ refCount │    strong ──────┼─→ Compiler      │
│                │    ↑ ↓     │                 │    manages      │
│   release ─────┘    └───────│    weak ────────┘                 │
│                             │                                    │
│   autorelease → Pool drains │    Automatic release at scope end │
│                             │                                    │
│   dealloc:                  │    dealloc:                       │
│   - release ivars           │    - CF objects only              │
│   - nil delegates           │    - observers                    │
│   - [super dealloc]         │    - NO super call                │
│                             │                                    │
└─────────────────────────────────────────────────────────────────┘
```

---

> [!TIP]
> **Quick Memory Rule**: In MRR, think "I create, I destroy." In ARC, think "The compiler handles it, but I must avoid cycles."

---

*Last updated: December 2024*
