#import <XCTest/XCTest.h>
#import "../MRR Project/App/AppDelegate.h"
#import "../MRR Project/App/MainMenuViewController.h"
#import "../MRR Project/Features/Onboarding/Data/OnboardingStateController.h"
#import "../MRR Project/Features/Onboarding/Presentation/ViewControllers/OnboardingViewController.h"

@interface AppDelegate (Testing)

- (void)onboardingViewControllerDidFinish:(OnboardingViewController *)viewController;
- (void)applyLayoutScalingMode:(MRRLayoutScalingMode)layoutScalingMode;

@end

@interface AppLaunchFlowTests : XCTestCase

@property(nonatomic, copy) NSString *defaultsSuiteName;
@property(nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation AppLaunchFlowTests

- (void)setUp {
  [super setUp];

  self.defaultsSuiteName = [NSString stringWithFormat:@"AppLaunchFlowTests.%@", [NSUUID UUID].UUIDString];
  self.userDefaults = [[NSUserDefaults alloc] initWithSuiteName:self.defaultsSuiteName];
  [self.userDefaults removePersistentDomainForName:self.defaultsSuiteName];
}

- (void)tearDown {
  [self.userDefaults removePersistentDomainForName:self.defaultsSuiteName];
  self.userDefaults = nil;
  self.defaultsSuiteName = nil;

  [super tearDown];
}

- (void)testFirstLaunchShowsOnboarding {
  AppDelegate *appDelegate = [self makeAppDelegate];

  XCTAssertTrue([appDelegate application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:nil]);
  XCTAssertTrue([appDelegate.window.rootViewController isKindOfClass:[OnboardingViewController class]]);
}

- (void)testCompletingOnboardingShowsMainMenuAndPersistsFlag {
  AppDelegate *appDelegate = [self makeAppDelegate];
  XCTAssertTrue([appDelegate application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:nil]);

  OnboardingViewController *onboardingViewController = (OnboardingViewController *)appDelegate.window.rootViewController;
  [appDelegate onboardingViewControllerDidFinish:onboardingViewController];

  XCTAssertTrue([appDelegate.window.rootViewController isKindOfClass:[MainMenuViewController class]]);
  XCTAssertTrue([self.userDefaults boolForKey:MRRHasCompletedOnboardingDefaultsKey]);
}

- (void)testReturningUserShowsMainMenu {
  OnboardingStateController *stateController = [[OnboardingStateController alloc] initWithUserDefaults:self.userDefaults];
  [stateController markOnboardingCompleted];

  AppDelegate *appDelegate = [self makeAppDelegate];
  XCTAssertTrue([appDelegate application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:nil]);

  XCTAssertTrue([appDelegate.window.rootViewController isKindOfClass:[MainMenuViewController class]]);
}

- (void)testReturningUserDoesNotSeeTabBarController {
  OnboardingStateController *stateController = [[OnboardingStateController alloc] initWithUserDefaults:self.userDefaults];
  [stateController markOnboardingCompleted];

  AppDelegate *appDelegate = [self makeAppDelegate];
  XCTAssertTrue([appDelegate application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:nil]);

  XCTAssertFalse([appDelegate.window.rootViewController isKindOfClass:[UITabBarController class]]);
}

- (void)testAppDelegateAppliesStoredLayoutScalingModeWhenNoLaunchArgumentOverridesIt {
  MRRStoreLayoutScalingMode(self.userDefaults, MRRLayoutScalingModePureScreenScaling);
  OnboardingStateController *stateController = [[OnboardingStateController alloc] initWithUserDefaults:self.userDefaults];
  AppDelegate *appDelegate = [[AppDelegate alloc] initWithOnboardingStateController:stateController
                                                                        userDefaults:self.userDefaults
                                                                   layoutScalingMode:MRRStoredLayoutScalingMode(self.userDefaults)];

  XCTAssertTrue([appDelegate application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:nil]);

  OnboardingViewController *onboardingViewController = (OnboardingViewController *)appDelegate.window.rootViewController;
  XCTAssertTrue([onboardingViewController isKindOfClass:[OnboardingViewController class]]);
}

- (void)testApplyingLayoutScalingModePersistsAndRebuildsRootFlow {
  AppDelegate *appDelegate = [self makeAppDelegate];
  XCTAssertTrue([appDelegate application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:nil]);

  UIViewController *initialRootViewController = appDelegate.window.rootViewController;
  [appDelegate applyLayoutScalingMode:MRRLayoutScalingModePureScreenScaling];

  XCTAssertEqual(MRRStoredLayoutScalingMode(self.userDefaults), MRRLayoutScalingModePureScreenScaling);
  XCTAssertNotEqual(appDelegate.window.rootViewController, initialRootViewController);
  XCTAssertTrue([appDelegate.window.rootViewController isKindOfClass:[OnboardingViewController class]]);
}

- (AppDelegate *)makeAppDelegate {
  OnboardingStateController *stateController = [[OnboardingStateController alloc] initWithUserDefaults:self.userDefaults];
  AppDelegate *appDelegate = [[AppDelegate alloc] initWithOnboardingStateController:stateController
                                                                        userDefaults:self.userDefaults
                                                                   layoutScalingMode:MRRLayoutScalingModeGuardedFluidScaling];
  return appDelegate;
}

@end
