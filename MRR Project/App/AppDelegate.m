//
//  AppDelegate.m
//  MRR Project
//
//  Created for MRR Learning
//

#import "AppDelegate.h"
#import "../Core/Data/StaticMRRDemoRepository.h"
#import "../Core/Domain/UseCases/LoadDemoDetailUseCase.h"
#import "../Core/Domain/UseCases/LoadDemoListUseCase.h"
#import "../Core/Presentation/Factories/DemoScreenFactory.h"
#import "../Features/Basics/Presentation/BasicsListViewController.h"
#import "../Features/Lifecycle/Presentation/LifecycleListViewController.h"
#import "../Features/Relationships/Presentation/RelationshipsListViewController.h"

@implementation AppDelegate

#pragma mark - Memory Management

- (void)dealloc {
    [_window release];
    [super dealloc];
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    StaticMRRDemoRepository *repository = [[[StaticMRRDemoRepository alloc] init] autorelease];
    LoadDemoListUseCase *listUseCase = [[[LoadDemoListUseCase alloc] initWithRepository:repository] autorelease];
    LoadDemoDetailUseCase *detailUseCase = [[[LoadDemoDetailUseCase alloc] initWithRepository:repository] autorelease];
    DemoScreenFactory *screenFactory = [[[DemoScreenFactory alloc] initWithDetailUseCase:detailUseCase] autorelease];

    BasicsListViewController *basicsController = [[[BasicsListViewController alloc] initWithListUseCase:listUseCase
                                                                                            screenFactory:screenFactory] autorelease];
    RelationshipsListViewController *relationshipsController = [[[RelationshipsListViewController alloc] initWithListUseCase:listUseCase
                                                                                                                 screenFactory:screenFactory] autorelease];
    LifecycleListViewController *lifecycleController = [[[LifecycleListViewController alloc] initWithListUseCase:listUseCase
                                                                                                      screenFactory:screenFactory] autorelease];

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

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];

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

@end
