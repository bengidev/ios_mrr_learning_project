//
//  AppCoordinator.m
//  MVVM-C-MRR
//
//  AppCoordinator Implementation
//  MRR (Manual Retain-Release) Version
//
//  IMPORTANT: Compile with -fno-objc-arc flag
//

#import "AppCoordinator.h"
#import "DeepLinkRoute.h"
#import "ProductsCoordinator.h"
#import "URLRouter.h"

@interface AppCoordinator () {
  ProductsCoordinator
      *_productsCoordinator; // assign, managed in childCoordinators
}
@end

@implementation AppCoordinator

@synthesize window = _window;

#pragma mark - Initialization

- (id)initWithWindow:(UIWindow *)window {
  // Create the root navigation controller (autoreleased)
  UINavigationController *navController =
      [[[UINavigationController alloc] init] autorelease];
  navController.navigationBar.prefersLargeTitles = YES;

  self = [super initWithNavigationController:navController];
  if (self) {
    _window = [window retain];
    _window.rootViewController = navController;

    // Register with URL Router
    [URLRouter sharedRouter].rootCoordinator = self;
  }
  return self;
}

#pragma mark - Memory Management

- (void)dealloc {
  NSLog(@"[AppCoordinator] dealloc");

  [_window release];
  // Do NOT release _productsCoordinator (managed in childCoordinators array)

  [super dealloc];
}

#pragma mark - Property Setters

- (void)setWindow:(UIWindow *)window {
  if (_window != window) {
    [_window release];
    _window = [window retain];
  }
}

#pragma mark - Lifecycle

- (void)start {
  NSLog(@"[AppCoordinator] Starting app flow");

  // Make window visible
  [_window makeKeyAndVisible];

  // Start the main products flow
  [self showProductsFlow];
}

#pragma mark - Navigation Flows

- (void)showProductsFlow {
  ProductsCoordinator *productsCoordinator = [[[ProductsCoordinator alloc]
      initWithNavigationController:self.navigationController] autorelease];
  _productsCoordinator = productsCoordinator; // assign reference

  [self addChildCoordinator:productsCoordinator]; // This retains it
  [productsCoordinator start];
}

#pragma mark - Deep Linking

- (BOOL)handleDeepLinkURL:(NSURL *)url {
  NSLog(@"[AppCoordinator] Handling deep link: %@", url);

  // Parse the URL into a route
  DeepLinkRoute *route = [[URLRouter sharedRouter] parseURL:url];

  if (!route) {
    NSLog(@"[AppCoordinator] Could not parse URL: %@", url);
    return NO;
  }

  // Handle the route
  [self handleRoute:route];
  return YES;
}

- (BOOL)handleUserActivity:(NSUserActivity *)userActivity {
  if ([userActivity.activityType
          isEqualToString:NSUserActivityTypeBrowsingWeb]) {
    NSURL *url = userActivity.webpageURL;
    if (url) {
      return [self handleDeepLinkURL:url];
    }
  }
  return NO;
}

#pragma mark - DeepLinkable

- (BOOL)canHandleRoute:(DeepLinkRoute *)route {
  return YES;
}

- (void)handleRoute:(DeepLinkRoute *)route {
  NSLog(@"[AppCoordinator] Handling route: %@", route);

  // Reset navigation to root if needed for deep links
  [self resetNavigationForDeepLink];

  switch (route.type) {
  case DeepLinkRouteTypeHome:
    // Already at home (products list)
    break;

  case DeepLinkRouteTypeProductList:
  case DeepLinkRouteTypeProductDetail:
  case DeepLinkRouteTypeProductReviews:
    // Forward to products coordinator
    if ([_productsCoordinator conformsToProtocol:@protocol(DeepLinkable)]) {
      [(id<DeepLinkable>)_productsCoordinator handleRoute:route];
    }
    break;

  case DeepLinkRouteTypeUserProfile:
    [self showUserProfile:route.userId];
    break;

  case DeepLinkRouteTypeSettings:
    [self showSettings];
    break;

  case DeepLinkRouteTypeCart:
    [self showCart];
    break;

  default:
    NSLog(@"[AppCoordinator] Unknown route type: %ld", (long)route.type);
    break;
  }
}

- (void)resetNavigationForDeepLink {
  // Pop to root view controller
  [self.navigationController popToRootViewControllerAnimated:NO];

  // Remove child coordinators from products coordinator
  [_productsCoordinator removeAllChildCoordinators];
}

#pragma mark - Additional Navigation (Placeholder)

- (void)showUserProfile:(NSString *)userId {
  NSLog(@"[AppCoordinator] Show user profile: %@",
        userId ? userId : @"current user");

  // Placeholder (autoreleased)
  UIViewController *profileVC = [[[UIViewController alloc] init] autorelease];
  profileVC.view.backgroundColor = [UIColor whiteColor];
  profileVC.title = @"User Profile";

  UILabel *label = [[[UILabel alloc] init] autorelease];
  label.text = [NSString
      stringWithFormat:@"User: %@", userId ? userId : @"Current User"];
  label.translatesAutoresizingMaskIntoConstraints = NO;
  [profileVC.view addSubview:label];

  [NSLayoutConstraint activateConstraints:@[
    [label.centerXAnchor constraintEqualToAnchor:profileVC.view.centerXAnchor],
    [label.centerYAnchor constraintEqualToAnchor:profileVC.view.centerYAnchor]
  ]];

  [self.navigationController pushViewController:profileVC animated:YES];
}

- (void)showSettings {
  NSLog(@"[AppCoordinator] Show settings");

  UIViewController *settingsVC = [[[UIViewController alloc] init] autorelease];
  settingsVC.view.backgroundColor = [UIColor whiteColor];
  settingsVC.title = @"Settings";
  [self.navigationController pushViewController:settingsVC animated:YES];
}

- (void)showCart {
  NSLog(@"[AppCoordinator] Show cart");

  UIViewController *cartVC = [[[UIViewController alloc] init] autorelease];
  cartVC.view.backgroundColor = [UIColor whiteColor];
  cartVC.title = @"Shopping Cart";
  [self.navigationController pushViewController:cartVC animated:YES];
}

@end
