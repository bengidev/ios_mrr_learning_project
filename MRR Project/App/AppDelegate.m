//
//  AppDelegate.m
//  MRR Project
//
//  Created for MRR Learning
//

#import "AppDelegate.h"
#import "MainMenuViewController.h"
#import "OnboardingStateController.h"
#import "OnboardingViewController.h"
#include <UIKit/UIKit.h>
#import "../Features/Basics/Data/BasicsDemoRepository.h"
#import "../Features/Basics/Domain/UseCases/BasicsLoadDemoDetailUseCase.h"
#import "../Features/Basics/Domain/UseCases/BasicsLoadDemoListUseCase.h"
#import "../Features/Basics/Presentation/Factories/BasicsScreenFactory.h"
#import "../Features/Basics/Presentation/ViewControllers/BasicsListViewController.h"
#import "../Features/Lifecycle/Data/LifecycleDemoRepository.h"
#import "../Features/Lifecycle/Domain/UseCases/LifecycleLoadDemoDetailUseCase.h"
#import "../Features/Lifecycle/Domain/UseCases/LifecycleLoadDemoListUseCase.h"
#import "../Features/Lifecycle/Presentation/Factories/LifecycleScreenFactory.h"
#import "../Features/Lifecycle/Presentation/ViewControllers/LifecycleListViewController.h"
#import "../Features/Relationships/Data/RelationshipsDemoRepository.h"
#import "../Features/Relationships/Domain/UseCases/RelationshipsLoadDemoDetailUseCase.h"
#import "../Features/Relationships/Domain/UseCases/RelationshipsLoadDemoListUseCase.h"
#import "../Features/Relationships/Presentation/Factories/RelationshipsScreenFactory.h"
#import "../Features/Relationships/Presentation/ViewControllers/RelationshipsListViewController.h"

@interface AppDelegate () <MainMenuViewControllerDelegate, OnboardingViewControllerDelegate>

@property (nonatomic, retain) OnboardingStateController *onboardingStateController;

@end

@implementation AppDelegate

- (instancetype)init {
    OnboardingStateController *onboardingStateController = [[[OnboardingStateController alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults]] autorelease];
    return [self initWithOnboardingStateController:onboardingStateController];
}

- (instancetype)initWithOnboardingStateController:(OnboardingStateController *)onboardingStateController {
    NSParameterAssert(onboardingStateController != nil);

    self = [super init];
    if (self) {
        _onboardingStateController = [onboardingStateController retain];
    }

    return self;
}

#pragma mark - Memory Management

- (void)dealloc {
    [_onboardingStateController release];
    [_window release];
    [super dealloc];
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    UIViewController *initialRootViewController = nil;

    if ([self.onboardingStateController hasCompletedOnboarding]) {
        initialRootViewController = [self buildMainMenuViewController];
    } else {
        initialRootViewController = [self buildOnboardingViewController];
    }

    [self setRootViewController:initialRootViewController animated:NO];
    if ([self shouldMakeWindowKeyAndVisible]) {
        [self.window makeKeyAndVisible];
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, etc.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate
}

#pragma mark - OnboardingViewControllerDelegate

- (void)onboardingViewControllerDidFinish:(OnboardingViewController *)viewController {
    [self.onboardingStateController markOnboardingCompleted];
    [self setRootViewController:[self buildMainMenuViewController] animated:[self shouldAnimateRootTransitions]];
}

#pragma mark - MainMenuViewControllerDelegate

- (void)mainMenuViewController:(MainMenuViewController *)viewController didSelectTabIndex:(NSUInteger)tabIndex {
    [self setRootViewController:[self buildLearningExperienceTabBarControllerSelectingIndex:tabIndex] animated:[self shouldAnimateRootTransitions]];
}

#pragma mark - Root View Controller Builders

- (UIViewController *)buildOnboardingViewController {
    OnboardingViewController *viewController = [[[OnboardingViewController alloc] init] autorelease];
    viewController.delegate = self;
    return viewController;
}

- (UIViewController *)buildMainMenuViewController {
    MainMenuViewController *viewController = [[[MainMenuViewController alloc] init] autorelease];
    viewController.delegate = self;
    return viewController;
}

- (UITabBarController *)buildLearningExperienceTabBarControllerSelectingIndex:(NSUInteger)selectedIndex {
    BasicsDemoRepository *basicsRepository = [[[BasicsDemoRepository alloc] init] autorelease];
    BasicsLoadDemoListUseCase *basicsListUseCase = [[[BasicsLoadDemoListUseCase alloc] initWithRepository:basicsRepository] autorelease];
    BasicsLoadDemoDetailUseCase *basicsDetailUseCase = [[[BasicsLoadDemoDetailUseCase alloc] initWithRepository:basicsRepository] autorelease];
    BasicsScreenFactory *basicsScreenFactory = [[[BasicsScreenFactory alloc] initWithDetailUseCase:basicsDetailUseCase] autorelease];

    RelationshipsDemoRepository *relationshipsRepository = [[[RelationshipsDemoRepository alloc] init] autorelease];
    RelationshipsLoadDemoListUseCase *relationshipsListUseCase = [[[RelationshipsLoadDemoListUseCase alloc] initWithRepository:relationshipsRepository] autorelease];
    RelationshipsLoadDemoDetailUseCase *relationshipsDetailUseCase = [[[RelationshipsLoadDemoDetailUseCase alloc] initWithRepository:relationshipsRepository] autorelease];
    RelationshipsScreenFactory *relationshipsScreenFactory = [[[RelationshipsScreenFactory alloc] initWithDetailUseCase:relationshipsDetailUseCase] autorelease];

    LifecycleDemoRepository *lifecycleRepository = [[[LifecycleDemoRepository alloc] init] autorelease];
    LifecycleLoadDemoListUseCase *lifecycleListUseCase = [[[LifecycleLoadDemoListUseCase alloc] initWithRepository:lifecycleRepository] autorelease];
    LifecycleLoadDemoDetailUseCase *lifecycleDetailUseCase = [[[LifecycleLoadDemoDetailUseCase alloc] initWithRepository:lifecycleRepository] autorelease];
    LifecycleScreenFactory *lifecycleScreenFactory = [[[LifecycleScreenFactory alloc] initWithDetailUseCase:lifecycleDetailUseCase] autorelease];

    BasicsListViewController *basicsController = [[[BasicsListViewController alloc] initWithListUseCase:basicsListUseCase
                                                                                            screenFactory:basicsScreenFactory] autorelease];
    RelationshipsListViewController *relationshipsController = [[[RelationshipsListViewController alloc] initWithListUseCase:relationshipsListUseCase
                                                                                                                 screenFactory:relationshipsScreenFactory] autorelease];
    LifecycleListViewController *lifecycleController = [[[LifecycleListViewController alloc] initWithListUseCase:lifecycleListUseCase
                                                                                                      screenFactory:lifecycleScreenFactory] autorelease];

    UINavigationController *basicsNavigationController = [[[UINavigationController alloc] initWithRootViewController:basicsController] autorelease];
    UINavigationController *relationshipsNavigationController = [[[UINavigationController alloc] initWithRootViewController:relationshipsController] autorelease];
    UINavigationController *lifecycleNavigationController = [[[UINavigationController alloc] initWithRootViewController:lifecycleController] autorelease];

    basicsNavigationController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Basics" image:nil selectedImage:nil] autorelease];
    relationshipsNavigationController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Relationships" image:nil selectedImage:nil] autorelease];
    lifecycleNavigationController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Lifecycle" image:nil selectedImage:nil] autorelease];

    UITabBarController *tabBarController = [[[UITabBarController alloc] init] autorelease];
    tabBarController.viewControllers = [NSArray arrayWithObjects:
                                        basicsNavigationController,
                                        relationshipsNavigationController,
                                        lifecycleNavigationController,
                                        nil];

    if (selectedIndex < tabBarController.viewControllers.count) {
        tabBarController.selectedIndex = selectedIndex;
    }

    return tabBarController;
}

- (void)setRootViewController:(UIViewController *)rootViewController animated:(BOOL)animated {
    if (animated && self.window.rootViewController != nil) {
        [UIView transitionWithView:self.window
                          duration:0.25
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            BOOL animationsWereEnabled = [UIView areAnimationsEnabled];
                            [UIView setAnimationsEnabled:NO];
                            self.window.rootViewController = rootViewController;
                            [UIView setAnimationsEnabled:animationsWereEnabled];
                        }
                        completion:nil];
        return;
    }

    self.window.rootViewController = rootViewController;
}

- (BOOL)shouldAnimateRootTransitions {
    return NSClassFromString(@"XCTestCase") == nil;
}

- (BOOL)shouldMakeWindowKeyAndVisible {
    return NSClassFromString(@"XCTestCase") == nil;
}

@end
