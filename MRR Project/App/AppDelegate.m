//
//  AppDelegate.m
//  MRR Project
//
//  Created for MRR Learning
//

#import "AppDelegate.h"
#import "MainMenuViewController.h"
#import "../Features/Onboarding/Data/OnboardingStateController.h"
#import "../Features/Onboarding/Presentation/ViewControllers/OnboardingViewController.h"

@interface AppDelegate () <OnboardingViewControllerDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, retain) OnboardingStateController *onboardingStateController;
@property(nonatomic, retain) NSUserDefaults *userDefaults;
@property(nonatomic, retain) UITapGestureRecognizer *debugScalingModeGestureRecognizer;
@property(nonatomic, assign) MRRLayoutScalingMode layoutScalingMode;

- (void)installDebugScalingModeGestureIfNeeded;
- (void)handleDebugScalingModeGesture:(UITapGestureRecognizer *)recognizer;
- (void)presentDebugScalingModePicker;
- (void)applyLayoutScalingMode:(MRRLayoutScalingMode)layoutScalingMode;

@end

@implementation AppDelegate

- (instancetype)init {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  OnboardingStateController *onboardingStateController =
      [[[OnboardingStateController alloc] initWithUserDefaults:userDefaults] autorelease];
  MRRLayoutScalingMode launchArgumentMode = MRRLayoutScalingModeFromArguments([NSProcessInfo processInfo].arguments);
  MRRLayoutScalingMode initialMode = launchArgumentMode;
  if (launchArgumentMode == MRRLayoutScalingModeGuardedFluidScaling) {
    initialMode = MRRStoredLayoutScalingMode(userDefaults);
  }

  return [self initWithOnboardingStateController:onboardingStateController userDefaults:userDefaults layoutScalingMode:initialMode];
}

- (instancetype)initWithOnboardingStateController:(OnboardingStateController *)onboardingStateController {
  return [self initWithOnboardingStateController:onboardingStateController
                                     userDefaults:[NSUserDefaults standardUserDefaults]
                                layoutScalingMode:MRRLayoutScalingModeGuardedFluidScaling];
}

- (instancetype)initWithOnboardingStateController:(OnboardingStateController *)onboardingStateController
                                layoutScalingMode:(MRRLayoutScalingMode)layoutScalingMode {
  return [self initWithOnboardingStateController:onboardingStateController
                                     userDefaults:[NSUserDefaults standardUserDefaults]
                                layoutScalingMode:layoutScalingMode];
}

- (instancetype)initWithOnboardingStateController:(OnboardingStateController *)onboardingStateController
                                     userDefaults:(NSUserDefaults *)userDefaults
                                layoutScalingMode:(MRRLayoutScalingMode)layoutScalingMode {
  NSParameterAssert(onboardingStateController != nil);
  NSParameterAssert(userDefaults != nil);

  self = [super init];
  if (self) {
    _onboardingStateController = [onboardingStateController retain];
    _userDefaults = [userDefaults retain];
    _layoutScalingMode = layoutScalingMode;
  }

  return self;
}

#pragma mark - Memory Management

- (void)dealloc {
  _debugScalingModeGestureRecognizer.delegate = nil;
  [_debugScalingModeGestureRecognizer release];
  [_userDefaults release];
  [_onboardingStateController release];
  [_window release];
  [super dealloc];
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  [self installDebugScalingModeGestureIfNeeded];
  [self setRootViewController:[self buildInitialRootViewController] animated:NO];
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

#pragma mark - Root View Controller Builders

- (UIViewController *)buildInitialRootViewController {
  if ([self.onboardingStateController hasCompletedOnboarding]) {
    return [self buildMainMenuViewController];
  }

  return [self buildOnboardingViewController];
}

- (UIViewController *)buildOnboardingViewController {
  OnboardingViewController *viewController = [[[OnboardingViewController alloc] initWithStateController:self.onboardingStateController
                                                                                      layoutScalingMode:self.layoutScalingMode]
      autorelease];
  viewController.delegate = self;
  return viewController;
}

- (UIViewController *)buildMainMenuViewController {
  return [[[MainMenuViewController alloc] initWithLayoutScalingMode:self.layoutScalingMode] autorelease];
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

#pragma mark - Internal Debug Scaling Switch

- (void)installDebugScalingModeGestureIfNeeded {
  if (![self shouldMakeWindowKeyAndVisible] || self.window == nil || self.debugScalingModeGestureRecognizer != nil) {
    return;
  }

  UITapGestureRecognizer *recognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleDebugScalingModeGesture:)]
      autorelease];
  recognizer.numberOfTapsRequired = 3;
  recognizer.cancelsTouchesInView = NO;
  recognizer.delegate = self;
  [self.window addGestureRecognizer:recognizer];
  self.debugScalingModeGestureRecognizer = recognizer;
}

- (void)handleDebugScalingModeGesture:(UITapGestureRecognizer *)recognizer {
  if (recognizer.state != UIGestureRecognizerStateRecognized) {
    return;
  }

  [self presentDebugScalingModePicker];
}

- (void)presentDebugScalingModePicker {
  UIViewController *presentingViewController = self.window.rootViewController;
  if (presentingViewController == nil || presentingViewController.presentedViewController != nil) {
    return;
  }

  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Layout Scaling"
                                                                           message:@"Choose the active global scaling engine."
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
  NSArray<NSNumber *> *modes = @[ @(MRRLayoutScalingModeGuardedFluidScaling), @(MRRLayoutScalingModePureScreenScaling) ];
  for (NSNumber *modeNumber in modes) {
    MRRLayoutScalingMode mode = (MRRLayoutScalingMode)modeNumber.integerValue;
    NSString *title = MRRLayoutScalingModeDisplayName(mode);
    if (mode == self.layoutScalingMode) {
      title = [title stringByAppendingString:@" Active"];
    }

    UIAlertAction *modeAction = [UIAlertAction actionWithTitle:title
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(__unused UIAlertAction *action) {
                                                         [self applyLayoutScalingMode:mode];
                                                       }];
    [alertController addAction:modeAction];
  }

  [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

  UIPopoverPresentationController *popoverPresentationController = alertController.popoverPresentationController;
  if (popoverPresentationController != nil) {
    popoverPresentationController.sourceView = self.window;
    popoverPresentationController.sourceRect = CGRectMake(CGRectGetMidX(self.window.bounds), 80.0, 1.0, 1.0);
  }

  [presentingViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)applyLayoutScalingMode:(MRRLayoutScalingMode)layoutScalingMode {
  if (self.layoutScalingMode == layoutScalingMode && self.window.rootViewController != nil) {
    return;
  }

  self.layoutScalingMode = layoutScalingMode;
  MRRStoreLayoutScalingMode(self.userDefaults, layoutScalingMode);
  [self setRootViewController:[self buildInitialRootViewController] animated:[self shouldAnimateRootTransitions]];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
  return gestureRecognizer == self.debugScalingModeGestureRecognizer && touch.view != nil;
}

@end
