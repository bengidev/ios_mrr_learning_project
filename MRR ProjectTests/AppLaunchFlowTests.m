#import <XCTest/XCTest.h>
#import "../MRR Project/App/AppDelegate.h"
#import "../MRR Project/App/MainMenuViewController.h"
#import "../MRR Project/App/OnboardingStateController.h"
#import "../MRR Project/App/OnboardingViewController.h"

@interface AppDelegate (Testing)

- (void)onboardingViewControllerDidFinish:(OnboardingViewController *)viewController;
- (void)mainMenuViewController:(MainMenuViewController *)viewController didSelectTabIndex:(NSUInteger)tabIndex;

@end

@interface AppLaunchFlowTests : XCTestCase

@property (nonatomic, copy) NSString *defaultsSuiteName;
@property (nonatomic, strong) NSUserDefaults *userDefaults;

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

- (void)testMainMenuSelectionShowsLearningTabsWithMatchingSelectedIndex {
    OnboardingStateController *stateController = [[OnboardingStateController alloc] initWithUserDefaults:self.userDefaults];
    [stateController markOnboardingCompleted];

    AppDelegate *appDelegate = [self makeAppDelegate];
    XCTAssertTrue([appDelegate application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:nil]);

    MainMenuViewController *mainMenuViewController = (MainMenuViewController *)appDelegate.window.rootViewController;
    [appDelegate mainMenuViewController:mainMenuViewController didSelectTabIndex:2];

    XCTAssertTrue([appDelegate.window.rootViewController isKindOfClass:[UITabBarController class]]);

    UITabBarController *tabBarController = (UITabBarController *)appDelegate.window.rootViewController;
    XCTAssertEqual(tabBarController.selectedIndex, 2U);
    XCTAssertEqual(tabBarController.viewControllers.count, 3U);
}

- (AppDelegate *)makeAppDelegate {
    OnboardingStateController *stateController = [[OnboardingStateController alloc] initWithUserDefaults:self.userDefaults];
    AppDelegate *appDelegate = [[AppDelegate alloc] initWithOnboardingStateController:stateController];
    return appDelegate;
}

@end
