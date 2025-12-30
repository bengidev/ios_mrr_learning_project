//
//  BaseCoordinator.h
//  MRR Project
//
//  Created by ENB Mac Mini on 30/12/25.
//

#import <UIKit/UIKit.h>
#import "Coordinator.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseCoordinator : NSObject <Coordinator>

/// Child coordinators managed by this coordinator
@property (nonatomic, retain) NSMutableArray<id<Coordinator> > *childCoordinators;

/// The navigation controller for pushing view controllers
@property (nonatomic, retain) UINavigationController *navigationController;

/// Reference to parent coordinator (weak to avoid retain cycle)
@property (nonatomic, assign, nullable) id<Coordinator> parentCoordinator;

#pragma mark - Initialization

/// Initializes the coordinator with a navigation controller
/// @param navigationController The navigation controller to use
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

#pragma mark - Child Coordinator Management

/// Adds a child coordinator
/// @param coordinator The coordinator to add
- (void)addChildCoordinator:(id<Coordinator>)coordinator;

/// Removes a child coordinator
/// @param coordinator The coordinator to remove
- (void)removeChildCoordinator:(id<Coordinator>)coordinator;

/// Removes all child coordinators
- (void)removeChildCoordinators;


#pragma mark - Lifecycle

/// Called when the coordinator should start its flow
/// Subclasses must override this method
- (void)start;


/// Called when the coordinator's flow is finished
/// This notifies the parent coordinator to remove this coordinator
- (void)finish;

#pragma mark - Coordinator Protocol

/// Called by a child coordinator when it finishes
- (void)coordinatorDidFinish:(id<Coordinator>)coordinator;

@end

NS_ASSUME_NONNULL_END
