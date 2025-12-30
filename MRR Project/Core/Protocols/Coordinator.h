//
//  Coordinator.h
//  MRR Project
//
//  Created by ENB Mac Mini on 29/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol Coordinator <NSObject>

@required
/// Array of child coordinators managed by this coordinator
@property (nonatomic, retain) NSMutableArray<id<Coordinator> > *childCoordinators;

/// The navigation controller used for pushing view controllers
@property (nonatomic, retain) UINavigationController *navigationController;

/// Starts the coordinator flow
- (void)start;

/// Ends the coordinator flow
- (void)finish;

@optional
/// Reference to parent coordinator (should be weak to avoid retain cycles)
@property (nonatomic, assign, nullable) id<Coordinator> parentCoordinator;

/// Called when this coordinator's flow is complete
- (void)coordinatorDidFinish:(id<Coordinator>)coordinator;

@end

NS_ASSUME_NONNULL_END
