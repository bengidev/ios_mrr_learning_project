//
//  Coordinator.h
//  MVVM-C-MRR
//
//  Coordinator Protocol - Defines the interface for all coordinators
//  MRR (Manual Retain-Release) Version
//
//  IMPORTANT: Compile with -fno-objc-arc flag
//

#import <UIKit/UIKit.h>

@protocol Coordinator <NSObject>

@required
/// Array of child coordinators managed by this coordinator
/// Use 'retain' in implementation
@property(nonatomic, retain) NSMutableArray *childCoordinators;

/// The navigation controller used for pushing view controllers
/// Use 'retain' in implementation
@property(nonatomic, retain) UINavigationController *navigationController;

/// Starts the coordinator flow
- (void)start;

@optional
/// Reference to parent coordinator
/// Use 'assign' (NOT retain) to avoid retain cycles
@property(nonatomic, assign) id<Coordinator> parentCoordinator;

/// Called when this coordinator's flow is complete
- (void)coordinatorDidFinish:(id<Coordinator>)coordinator;

@end
