//
//  AppCoordinator.h
//  MVVM-C-MRR
//
//  AppCoordinator - Root coordinator that manages the entire app flow
//  MRR (Manual Retain-Release) Version
//
//  IMPORTANT: Compile with -fno-objc-arc flag
//

#import "BaseCoordinator.h"
#import "DeepLinkable.h"

@interface AppCoordinator : BaseCoordinator <DeepLinkable> {
  UIWindow *_window;
}

/// The app's main window (retain)
@property(nonatomic, retain) UIWindow *window;

/// Initialize with the app's window
- (id)initWithWindow:(UIWindow *)window;

#pragma mark - Deep Linking

/// Handles an incoming deep link URL
- (BOOL)handleDeepLinkURL:(NSURL *)url;

/// Handles a Universal Link via NSUserActivity
- (BOOL)handleUserActivity:(NSUserActivity *)userActivity;

@end
