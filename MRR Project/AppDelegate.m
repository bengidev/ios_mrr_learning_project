//
//  AppDelegate.m
//  MRR Project
//
//  Created for MRR Learning
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

#pragma mark - Memory Management

- (void)dealloc {
    [_window release];
    _window = nil;

    [_viewController release];
    _viewController = nil;

    [super dealloc];
}

#pragma mark - UIApplicationDelegate

- (BOOL)              application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Create the main window programmatically
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]
                   autorelease];

    // Create the root view controller
    self.viewController = [[[ViewController alloc] init] autorelease];

    // Set as root view controller
    self.window.rootViewController = self.viewController;

    // Make visible
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
