//
//  BaseCoordinator.h
//  MVVM-C-MRR
//
//  BaseCoordinator - Base class for all coordinators
//  MRR (Manual Retain-Release) Version
//
//  IMPORTANT: Compile with -fno-objc-arc flag
//

#import "Coordinator.h"
#import <UIKit/UIKit.h>

@interface BaseCoordinator : NSObject <Coordinator> {
  NSMutableArray *_childCoordinators;
  UINavigationController *_navigationController;
  id<Coordinator> _parentCoordinator; // NOT retained to avoid cycles
}

/// Child coordinators managed by this coordinator (retained)
@property(nonatomic, retain) NSMutableArray *childCoordinators;

/// The navigation controller for pushing view controllers (retained)
@property(nonatomic, retain) UINavigationController *navigationController;

/// Reference to parent coordinator (assign - NOT retained to avoid retain
/// cycles)
@property(nonatomic, assign) id<Coordinator> parentCoordinator;

#pragma mark - Initialization

/// Initializes the coordinator with a navigation controller
- (id)initWithNavigationController:
    (UINavigationController *)navigationController;

#pragma mark - Child Coordinator Management

/// Adds a child coordinator (retains it)
- (void)addChildCoordinator:(id<Coordinator>)coordinator;

/// Removes a child coordinator (releases it)
- (void)removeChildCoordinator:(id<Coordinator>)coordinator;

/// Removes all child coordinators
- (void)removeAllChildCoordinators;

#pragma mark - Lifecycle

/// Called when the coordinator should start its flow
/// Subclasses must override this method
- (void)start;

/// Called when the coordinator's flow is finished
- (void)finish;

#pragma mark - Coordinator Protocol

/// Called by a child coordinator when it finishes
- (void)coordinatorDidFinish:(id<Coordinator>)coordinator;

@end
