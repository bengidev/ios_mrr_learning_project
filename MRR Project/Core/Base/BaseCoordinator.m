//
//  BaseCoordinator.m
//  MRR Project
//
//  Created by ENB Mac Mini on 30/12/25.
//

#import <os/log.h>
#import "BaseCoordinator.h"

static os_log_t BaseCoordinatorLog(void) {
    static os_log_t log = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        log = os_log_create("com.bengidev.mvvmc", "BaseCoordinator");
    });

    return log;
}

@implementation BaseCoordinator

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {
    NSParameterAssert(navigationController != nil);

    if (self = [super init]) {
        self.navigationController = navigationController;
        self.childCoordinators = [NSMutableArray new];

        os_log_debug(BaseCoordinatorLog(), "Initialized with navigation controller");
    }

    return self;
}

- (instancetype)init {
    UINavigationController *navController = [UINavigationController new];

    return [self initWithNavigationController:navController];
}

#pragma mark - Child Coordinator Management

- (void)addChildCoordinator:(id<Coordinator>)coordinator {
    NSParameterAssert(coordinator != nil);

    if (![self.childCoordinators containsObject:coordinator]) {
        [self.childCoordinators addObject:coordinator];

        // Set parent if coordinator supports it
        if ([coordinator respondsToSelector:@selector(setParentCoordinator:)]) {
            [coordinator setParentCoordinator:self];
        }

        os_log_debug(
            BaseCoordinatorLog(),
            "Added child coordinator: %{public}@",
            NSStringFromClass([coordinator class])
            );
    }
}

- (void)removeChildCoordinator:(id<Coordinator>)coordinator {
    if (coordinator == nil) {
        return;
    }

    if ([self.childCoordinators containsObject:coordinator]) {
        coordinator.parentCoordinator = nil;
    }

    [self.childCoordinators removeObject:coordinator];

    os_log_debug(
        BaseCoordinatorLog(),
        "Removed child coordinator: %{public}@",
        NSStringFromClass([coordinator class])
        );
}

- (void)removeChildCoordinators {
    for (id<Coordinator> coordinator in [self.childCoordinators copy]) {
        [self removeChildCoordinator:coordinator];
    }

    os_log_debug(BaseCoordinatorLog(), "Removed all child coordinators");
}

#pragma mark - Lifecycle

- (void)start {
    // Subclasses must override this method
    os_log_info(BaseCoordinatorLog(), "start - Subclass must override");
}

- (void)finish {
    os_log_info(BaseCoordinatorLog(), "Coordinator finishing");

    // Notify parent to remove this coordinator
    if ([self.parentCoordinator respondsToSelector:@selector(coordinatorDidFinish:)]) {
        [self.parentCoordinator coordinatorDidFinish:self];
    }
}

#pragma mark - Coordinator Protocol

- (void)coordinatorDidFinish:(id<Coordinator>)coordinator {
    os_log_info(
        BaseCoordinatorLog(),
        "coordinatorDidFinish from %@",
        NSStringFromClass([coordinator class])
        );

    [self removeChildCoordinator:coordinator];
}

#pragma mark - Debug

- (void)dealloc
{
    os_log_debug(
        BaseCoordinatorLog(),
        "dealloc: %{public}@",
        NSStringFromClass([self class])
        );

    [super dealloc];
}

@end
