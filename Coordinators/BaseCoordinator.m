//
//  BaseCoordinator.m
//  MVVM-C-MRR
//
//  BaseCoordinator Implementation
//  MRR (Manual Retain-Release) Version
//
//  IMPORTANT: Compile with -fno-objc-arc flag
//

#import "BaseCoordinator.h"

@implementation BaseCoordinator

@synthesize childCoordinators = _childCoordinators;
@synthesize navigationController = _navigationController;
@synthesize parentCoordinator = _parentCoordinator;

#pragma mark - Initialization

- (id)init {
  self = [super init];
  if (self) {
    _childCoordinators = [[NSMutableArray alloc] init];
  }
  return self;
}

- (id)initWithNavigationController:
    (UINavigationController *)navigationController {
  self = [self init];
  if (self) {
    _navigationController = [navigationController retain];
  }
  return self;
}

#pragma mark - Memory Management

- (void)dealloc {
  NSLog(@"[%@] dealloc", NSStringFromClass([self class]));

  [_childCoordinators release];
  [_navigationController release];
  // Do NOT release _parentCoordinator (assign property)

  [super dealloc];
}

#pragma mark - Property Setters

- (void)setNavigationController:(UINavigationController *)navigationController {
  if (_navigationController != navigationController) {
    [_navigationController release];
    _navigationController = [navigationController retain];
  }
}

- (void)setChildCoordinators:(NSMutableArray *)childCoordinators {
  if (_childCoordinators != childCoordinators) {
    [_childCoordinators release];
    _childCoordinators = [childCoordinators retain];
  }
}

#pragma mark - Child Coordinator Management

- (void)addChildCoordinator:(id<Coordinator>)coordinator {
  if (![_childCoordinators containsObject:coordinator]) {
    [_childCoordinators addObject:coordinator]; // Array retains the coordinator

    // Set parent if the coordinator supports it
    if ([coordinator respondsToSelector:@selector(setParentCoordinator:)]) {
      coordinator.parentCoordinator = self;
    }

    NSLog(@"[%@] Added child coordinator: %@", NSStringFromClass([self class]),
          NSStringFromClass([coordinator class]));
  }
}

- (void)removeChildCoordinator:(id<Coordinator>)coordinator {
  if ([_childCoordinators containsObject:coordinator]) {
    // Clear parent reference
    if ([coordinator respondsToSelector:@selector(setParentCoordinator:)]) {
      coordinator.parentCoordinator = nil;
    }

    [_childCoordinators
        removeObject:coordinator]; // Array releases the coordinator

    NSLog(@"[%@] Removed child coordinator: %@",
          NSStringFromClass([self class]),
          NSStringFromClass([coordinator class]));
  }
}

- (void)removeAllChildCoordinators {
  // Make a copy to iterate while modifying
  NSArray *coordinatorsCopy = [[_childCoordinators copy] autorelease];
  for (id<Coordinator> coordinator in coordinatorsCopy) {
    [self removeChildCoordinator:coordinator];
  }
}

#pragma mark - Lifecycle

- (void)start {
  // Subclasses must override this method
  NSAssert(NO, @"Subclasses must override the start method");
}

- (void)finish {
  // Notify parent to remove this coordinator
  if ([_parentCoordinator
          respondsToSelector:@selector(coordinatorDidFinish:)]) {
    [_parentCoordinator coordinatorDidFinish:self];
  }
}

#pragma mark - Coordinator Protocol

- (void)coordinatorDidFinish:(id<Coordinator>)coordinator {
  [self removeChildCoordinator:coordinator];
}

@end
