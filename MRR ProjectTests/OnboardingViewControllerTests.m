#import <XCTest/XCTest.h>

#import "../MRR Project/Features/Onboarding/Data/OnboardingStateController.h"
#import "../MRR Project/Features/Onboarding/Presentation/ViewControllers/OnboardingViewController.h"

@interface OnboardingViewController (Testing) <UICollectionViewDelegate>

@property(nonatomic, readonly) UICollectionView *carouselCollectionView;
@property(nonatomic, readonly) UIStackView *contentStackView;
@property(nonatomic, readonly) UIScrollView *scrollView;
@property(nonatomic, readonly, getter=isCompactLayoutActive) BOOL compactLayoutActive;

@end

@interface OnboardingViewControllerDelegateSpy : NSObject <OnboardingViewControllerDelegate>

@property(nonatomic, assign) BOOL didFinishOnboarding;

@end

@implementation OnboardingViewControllerDelegateSpy

- (void)onboardingViewControllerDidFinish:(OnboardingViewController *)viewController {
  self.didFinishOnboarding = YES;
}

@end

@interface OnboardingViewControllerTests : XCTestCase

@property(nonatomic, copy) NSString *defaultsSuiteName;
@property(nonatomic, strong) NSUserDefaults *userDefaults;
@property(nonatomic, strong) OnboardingStateController *stateController;
@property(nonatomic, strong) OnboardingViewController *viewController;
@property(nonatomic, strong) OnboardingViewControllerDelegateSpy *delegateSpy;
@property(nonatomic, strong) UIWindow *window;

- (UIView *)findViewWithAccessibilityIdentifier:(NSString *)identifier inView:(UIView *)view;
- (UIView *)findViewWithAccessibilitySuffix:(NSString *)suffix inView:(UIView *)view;
- (void)layoutOnboardingForWindowSize:(CGSize)size;
- (CGRect)frameForAccessibilityIdentifier:(NSString *)identifier;
- (CGFloat)fontSizeForAccessibilityIdentifier:(NSString *)identifier;
- (NSDictionary<NSString *, NSNumber *> *)currentAdaptiveOnboardingMetrics;
- (CGFloat)visibleCarouselLabelFontSizeWithSuffix:(NSString *)suffix;
- (void)assertAuthButtonsMeetMinimumTapTarget;
- (void)assertPrimaryOnboardingContentFitsCurrentViewport;
- (NSDictionary<NSString *, NSNumber *> *)adaptiveMetricsForLayoutScalingMode:(MRRLayoutScalingMode)layoutScalingMode
                                                                  windowSize:(CGSize)size;
- (void)spinMainRunLoop;

@end

@implementation OnboardingViewControllerTests

- (void)setUp {
  [super setUp];

  self.defaultsSuiteName = [NSString stringWithFormat:@"OnboardingViewControllerTests.%@", [NSUUID UUID].UUIDString];
  self.userDefaults = [[NSUserDefaults alloc] initWithSuiteName:self.defaultsSuiteName];
  [self.userDefaults removePersistentDomainForName:self.defaultsSuiteName];
  self.stateController = [[OnboardingStateController alloc] initWithUserDefaults:self.userDefaults];
  self.viewController = [[OnboardingViewController alloc] initWithStateController:self.stateController];
  self.delegateSpy = [[OnboardingViewControllerDelegateSpy alloc] init];
  self.viewController.delegate = self.delegateSpy;
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  self.window.rootViewController = self.viewController;
  [self.window makeKeyAndVisible];
  [self.viewController loadViewIfNeeded];
  [self.viewController.view layoutIfNeeded];
  [self spinMainRunLoop];
}

- (void)tearDown {
  [self.viewController dismissViewControllerAnimated:NO completion:nil];
  [self spinMainRunLoop];
  [self.userDefaults removePersistentDomainForName:self.defaultsSuiteName];
  self.window.hidden = YES;
  self.window = nil;
  self.delegateSpy = nil;
  self.viewController = nil;
  self.stateController = nil;
  self.userDefaults = nil;
  self.defaultsSuiteName = nil;

  [super tearDown];
}

- (void)testCarouselProvidesLoopingCopiesOfAllRecipeItems {
  NSInteger expectedCount = [self.stateController onboardingRecipes].count;
  NSInteger actualCount = [self.viewController.carouselCollectionView numberOfItemsInSection:0];

  XCTAssertGreaterThan(actualCount, expectedCount);
  XCTAssertEqual(actualCount % expectedCount, 0);
}

- (void)testSelectingRecipePresentsDetailModal {
  NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];

  [self.viewController collectionView:self.viewController.carouselCollectionView didSelectItemAtIndexPath:indexPath];
  [self spinMainRunLoop];

  XCTAssertNotNil(self.viewController.presentedViewController);
  XCTAssertEqualObjects(self.viewController.presentedViewController.view.accessibilityIdentifier, @"onboarding.recipeDetail.view");
}

- (void)testSelectingLoopedRecipeCopyPresentsDetailModal {
  NSInteger recipeCount = [self.stateController onboardingRecipes].count;
  NSIndexPath *indexPath = [NSIndexPath indexPathForItem:recipeCount inSection:0];

  [self.viewController collectionView:self.viewController.carouselCollectionView didSelectItemAtIndexPath:indexPath];
  [self spinMainRunLoop];

  XCTAssertNotNil(self.viewController.presentedViewController);
  XCTAssertEqualObjects(self.viewController.presentedViewController.view.accessibilityIdentifier, @"onboarding.recipeDetail.view");
}

- (void)testOnboardingExposesCoreAccessibilityIdentifiers {
  NSArray<NSString *> *identifiers = @[
    @"onboarding.logoImageView", @"onboarding.titleLabel", @"onboarding.subtitleLabel", @"onboarding.carouselCaptionLabel",
    @"onboarding.carouselHelperLabel", @"onboarding.carouselCollectionView", @"onboarding.pageControl", @"onboarding.footerLabel",
    @"onboarding.benefitTitleLabel", @"onboarding.benefitBodyLabel", @"onboarding.signinLabel"
  ];

  for (NSString *identifier in identifiers) {
    XCTAssertNotNil([self findViewWithAccessibilityIdentifier:identifier inView:self.viewController.view], @"Missing %@", identifier);
  }

  OnboardingRecipe *firstRecipe = [self.stateController onboardingRecipes].firstObject;
  NSString *carouselTitleIdentifier = [NSString stringWithFormat:@"onboarding.carouselCell.%@.titleLabel", firstRecipe.assetName];
  XCTAssertNotNil([self findViewWithAccessibilityIdentifier:carouselTitleIdentifier inView:self.viewController.view]);
}

- (void)testOnboardingLogoViewLoadsBrandAsset {
  UIImageView *logoImageView = (UIImageView *)[self findViewWithAccessibilityIdentifier:@"onboarding.logoImageView" inView:self.viewController.view];

  XCTAssertNotNil(logoImageView);
  XCTAssertNotNil(logoImageView.image);
}

- (void)testAuthButtonsAppearWithinInitialViewport {
  NSArray<NSString *> *buttonIdentifiers = @[ @"onboarding.emailButton", @"onboarding.googleButton", @"onboarding.appleButton" ];
  CGFloat viewportBottom = CGRectGetHeight(self.viewController.view.bounds) + 1.0;

  for (NSString *identifier in buttonIdentifiers) {
    UIView *button = [self findViewWithAccessibilityIdentifier:identifier inView:self.viewController.view];
    XCTAssertNotNil(button, @"Missing %@", identifier);

    CGRect buttonFrame = [button convertRect:button.bounds toView:self.viewController.view];
    XCTAssertGreaterThanOrEqual(CGRectGetMinY(buttonFrame), 0.0, @"%@ should start on screen", identifier);
    XCTAssertLessThanOrEqual(CGRectGetMaxY(buttonFrame), viewportBottom, @"%@ should be visible without scrolling", identifier);
  }
}

- (void)testOnboardingFitsWithinInitialViewportWithoutVerticalScroll {
  [self assertPrimaryOnboardingContentFitsCurrentViewport];
  XCTAssertFalse(self.viewController.scrollView.scrollEnabled);
  XCTAssertFalse(self.viewController.scrollView.alwaysBounceVertical);
}

- (void)testRecipeDetailExposesCoreAccessibilityIdentifiers {
  [self presentFirstRecipe];

  NSArray<NSString *> *identifiers = @[
    @"onboarding.recipeDetail.heroImageView", @"onboarding.recipeDetail.closeButton", @"onboarding.recipeDetail.subtitleLabel",
    @"onboarding.recipeDetail.titleLabel", @"onboarding.recipeDetail.durationChip", @"onboarding.recipeDetail.calorieChip",
    @"onboarding.recipeDetail.servingsChip", @"onboarding.recipeDetail.summaryLabel", @"onboarding.recipeDetail.ingredientsTitleLabel",
    @"onboarding.recipeDetail.ingredientChip.1", @"onboarding.recipeDetail.instructionsTitleLabel",
    @"onboarding.recipeDetail.instructionRow.1.indexLabel", @"onboarding.recipeDetail.instructionRow.1.titleLabel",
    @"onboarding.recipeDetail.instructionRow.1.bodyLabel", @"onboarding.recipeDetail.startCookingButton"
  ];

  for (NSString *identifier in identifiers) {
    XCTAssertNotNil([self findViewWithAccessibilityIdentifier:identifier inView:self.viewController.presentedViewController.view], @"Missing %@",
                    identifier);
  }
}

- (void)testStartCookingInvokesFinishDelegate {
  [self presentFirstRecipe];

  UIButton *startButton = (UIButton *)[self findViewWithAccessibilityIdentifier:@"onboarding.recipeDetail.startCookingButton"
                                                                         inView:self.viewController.presentedViewController.view];
  XCTAssertNotNil(startButton);

  [startButton sendActionsForControlEvents:UIControlEventTouchUpInside];
  [self spinMainRunLoop];

  XCTAssertTrue(self.delegateSpy.didFinishOnboarding);
}

- (void)testClosingDetailDoesNotInvokeFinishDelegate {
  [self presentFirstRecipe];

  UIButton *closeButton = (UIButton *)[self findViewWithAccessibilityIdentifier:@"onboarding.recipeDetail.closeButton"
                                                                         inView:self.viewController.presentedViewController.view];
  XCTAssertNotNil(closeButton);

  [closeButton sendActionsForControlEvents:UIControlEventTouchUpInside];
  [self spinMainRunLoop];

  XCTAssertFalse(self.delegateSpy.didFinishOnboarding);
  XCTAssertNil(self.viewController.presentedViewController);
}

- (void)presentFirstRecipe {
  NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
  [self.viewController collectionView:self.viewController.carouselCollectionView didSelectItemAtIndexPath:indexPath];
  [self spinMainRunLoop];
}

- (void)testIPhone11ViewportFitsWithoutVerticalScroll {
  [self layoutOnboardingForWindowSize:CGSizeMake(414.0, 896.0)];

  [self assertPrimaryOnboardingContentFitsCurrentViewport];
  [self assertAuthButtonsMeetMinimumTapTarget];
}

- (void)testAdaptiveMetricsStayWithinReadableRangesAcrossDifferentIPhoneSizes {
  [self layoutOnboardingForWindowSize:CGSizeMake(375.0, 812.0)];
  NSDictionary<NSString *, NSNumber *> *baseMetrics = [self currentAdaptiveOnboardingMetrics];

  [self layoutOnboardingForWindowSize:CGSizeMake(414.0, 812.0)];
  NSDictionary<NSString *, NSNumber *> *widerMetrics = [self currentAdaptiveOnboardingMetrics];

  [self layoutOnboardingForWindowSize:CGSizeMake(375.0, 896.0)];
  NSDictionary<NSString *, NSNumber *> *tallerMetrics = [self currentAdaptiveOnboardingMetrics];

  XCTAssertGreaterThanOrEqual(baseMetrics[@"titleFontSize"].doubleValue, 40.0);
  XCTAssertLessThanOrEqual(widerMetrics[@"titleFontSize"].doubleValue, 44.5);
  XCTAssertGreaterThanOrEqual(baseMetrics[@"buttonHeight"].doubleValue, 44.0);
  XCTAssertLessThanOrEqual(tallerMetrics[@"buttonHeight"].doubleValue, 52.5);
  XCTAssertGreaterThanOrEqual(baseMetrics[@"carouselItemWidth"].doubleValue, 148.0);
  XCTAssertLessThanOrEqual(widerMetrics[@"carouselItemWidth"].doubleValue, 188.0);

  XCTAssertGreaterThan(widerMetrics[@"titleFontSize"].doubleValue, baseMetrics[@"titleFontSize"].doubleValue);
  XCTAssertGreaterThan(widerMetrics[@"horizontalInset"].doubleValue, baseMetrics[@"horizontalInset"].doubleValue);
  XCTAssertGreaterThan(widerMetrics[@"carouselItemWidth"].doubleValue, baseMetrics[@"carouselItemWidth"].doubleValue);
  XCTAssertEqualWithAccuracy(tallerMetrics[@"titleFontSize"].doubleValue, baseMetrics[@"titleFontSize"].doubleValue, 0.2);
  XCTAssertEqualWithAccuracy(tallerMetrics[@"carouselItemWidth"].doubleValue, baseMetrics[@"carouselItemWidth"].doubleValue, 0.5);

  XCTAssertGreaterThan(tallerMetrics[@"stackSpacing"].doubleValue, baseMetrics[@"stackSpacing"].doubleValue);
  XCTAssertGreaterThan(tallerMetrics[@"buttonHeight"].doubleValue, baseMetrics[@"buttonHeight"].doubleValue);
  XCTAssertEqualWithAccuracy(widerMetrics[@"stackSpacing"].doubleValue, baseMetrics[@"stackSpacing"].doubleValue, 0.2);
  XCTAssertEqualWithAccuracy(widerMetrics[@"buttonHeight"].doubleValue, baseMetrics[@"buttonHeight"].doubleValue, 0.2);
}

- (void)testOnboardingFitsAcrossCommonIPhoneViewportSizes {
  NSArray<NSValue *> *viewportSizes = @[
    [NSValue valueWithCGSize:CGSizeMake(375.0, 812.0)],
    [NSValue valueWithCGSize:CGSizeMake(390.0, 844.0)],
    [NSValue valueWithCGSize:CGSizeMake(393.0, 852.0)],
    [NSValue valueWithCGSize:CGSizeMake(414.0, 896.0)],
    [NSValue valueWithCGSize:CGSizeMake(430.0, 932.0)]
  ];

  for (NSValue *viewportSizeValue in viewportSizes) {
    CGSize viewportSize = viewportSizeValue.CGSizeValue;
    [self layoutOnboardingForWindowSize:viewportSize];
    [self assertPrimaryOnboardingContentFitsCurrentViewport];
    [self assertAuthButtonsMeetMinimumTapTarget];
  }
}

- (void)testCarouselSizingIsWidthDrivenAndBoundedAcrossCommonIPhoneViewportSizes {
  NSArray<NSValue *> *viewportSizes = @[
    [NSValue valueWithCGSize:CGSizeMake(375.0, 812.0)],
    [NSValue valueWithCGSize:CGSizeMake(390.0, 844.0)],
    [NSValue valueWithCGSize:CGSizeMake(393.0, 852.0)],
    [NSValue valueWithCGSize:CGSizeMake(414.0, 896.0)],
    [NSValue valueWithCGSize:CGSizeMake(430.0, 932.0)]
  ];
  CGFloat previousItemWidth = 0.0;

  for (NSValue *viewportSizeValue in viewportSizes) {
    CGSize viewportSize = viewportSizeValue.CGSizeValue;
    [self layoutOnboardingForWindowSize:viewportSize];
    [self.viewController.carouselCollectionView layoutIfNeeded];

    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.viewController.carouselCollectionView.collectionViewLayout;
    CGFloat carouselWidth = CGRectGetWidth(self.viewController.carouselCollectionView.bounds);
    CGFloat carouselHeight = CGRectGetHeight(self.viewController.carouselCollectionView.bounds);

    XCTAssertGreaterThanOrEqual(layout.itemSize.width, 148.0, @"%.0fx%.0f should keep a readable card width", viewportSize.width,
                                viewportSize.height);
    XCTAssertLessThanOrEqual(layout.itemSize.width, 188.0, @"%.0fx%.0f should bound card width growth", viewportSize.width,
                             viewportSize.height);
    XCTAssertLessThanOrEqual(layout.itemSize.width, ((carouselWidth - layout.minimumLineSpacing) / 2.0) + 0.5,
                             @"%.0fx%.0f should size cards from carousel width", viewportSize.width, viewportSize.height);
    XCTAssertLessThanOrEqual(layout.itemSize.height, carouselHeight + 0.5, @"%.0fx%.0f should keep card height within the carousel",
                             viewportSize.width, viewportSize.height);

    if (previousItemWidth > 0.0) {
      XCTAssertGreaterThanOrEqual(layout.itemSize.width, previousItemWidth - 0.5,
                                  @"Wider common viewports should not shrink carousel cards");
    }
    previousItemWidth = layout.itemSize.width;
  }
}

- (void)testCarouselCardsAdaptInternalTypographyAcrossViewportSizes {
  [self layoutOnboardingForWindowSize:CGSizeMake(375.0, 812.0)];
  NSDictionary<NSString *, NSNumber *> *compactMetrics = [self currentAdaptiveOnboardingMetrics];

  [self layoutOnboardingForWindowSize:CGSizeMake(414.0, 896.0)];
  NSDictionary<NSString *, NSNumber *> *expandedMetrics = [self currentAdaptiveOnboardingMetrics];

  XCTAssertGreaterThanOrEqual(compactMetrics[@"carouselCellTitleFontSize"].doubleValue, 17.0);
  XCTAssertLessThanOrEqual(compactMetrics[@"carouselCellTitleFontSize"].doubleValue, 20.0);
  XCTAssertGreaterThanOrEqual(expandedMetrics[@"carouselCellTitleFontSize"].doubleValue, 17.0);
  XCTAssertLessThanOrEqual(expandedMetrics[@"carouselCellTitleFontSize"].doubleValue, 20.0);
  XCTAssertGreaterThanOrEqual(compactMetrics[@"carouselCellMetadataFontSize"].doubleValue, 11.0);
  XCTAssertLessThanOrEqual(compactMetrics[@"carouselCellMetadataFontSize"].doubleValue, 13.0);
  XCTAssertGreaterThanOrEqual(expandedMetrics[@"carouselCellMetadataFontSize"].doubleValue, 11.0);
  XCTAssertLessThanOrEqual(expandedMetrics[@"carouselCellMetadataFontSize"].doubleValue, 13.0);
  XCTAssertGreaterThanOrEqual(expandedMetrics[@"carouselCellTitleFontSize"].doubleValue,
                              expandedMetrics[@"carouselCellMetadataFontSize"].doubleValue);
}

- (void)testPureScreenScalingShrinksMoreAggressivelyThanGuardedFluidScalingOnSmallViewport {
  CGSize compactViewport = CGSizeMake(320.0, 568.0);
  NSDictionary<NSString *, NSNumber *> *guardedMetrics =
      [self adaptiveMetricsForLayoutScalingMode:MRRLayoutScalingModeGuardedFluidScaling windowSize:compactViewport];
  NSDictionary<NSString *, NSNumber *> *pureMetrics =
      [self adaptiveMetricsForLayoutScalingMode:MRRLayoutScalingModePureScreenScaling windowSize:compactViewport];

  XCTAssertLessThan(pureMetrics[@"titleFontSize"].doubleValue, guardedMetrics[@"titleFontSize"].doubleValue);
  XCTAssertLessThan(pureMetrics[@"buttonHeight"].doubleValue, guardedMetrics[@"buttonHeight"].doubleValue);
  XCTAssertLessThan(pureMetrics[@"carouselItemWidth"].doubleValue, guardedMetrics[@"carouselItemWidth"].doubleValue);
}

- (UIView *)findViewWithAccessibilityIdentifier:(NSString *)identifier inView:(UIView *)view {
  if ([view.accessibilityIdentifier isEqualToString:identifier]) {
    return view;
  }

  for (UIView *subview in view.subviews) {
    UIView *matchingView = [self findViewWithAccessibilityIdentifier:identifier inView:subview];
    if (matchingView != nil) {
      return matchingView;
    }
  }

  return nil;
}

- (UIView *)findViewWithAccessibilitySuffix:(NSString *)suffix inView:(UIView *)view {
  if ([view.accessibilityIdentifier hasSuffix:suffix]) {
    return view;
  }

  for (UIView *subview in view.subviews) {
    UIView *matchingView = [self findViewWithAccessibilitySuffix:suffix inView:subview];
    if (matchingView != nil) {
      return matchingView;
    }
  }

  return nil;
}

- (void)layoutOnboardingForWindowSize:(CGSize)size {
  self.window.frame = CGRectMake(0.0, 0.0, size.width, size.height);
  self.window.bounds = CGRectMake(0.0, 0.0, size.width, size.height);
  [self.window setNeedsLayout];
  [self.window layoutIfNeeded];
  [self.viewController.view setNeedsLayout];
  [self.viewController.view layoutIfNeeded];
  [self spinMainRunLoop];
  [self.window layoutIfNeeded];
  [self.viewController.view layoutIfNeeded];
  [self spinMainRunLoop];
  [self.viewController.view layoutIfNeeded];
}

- (CGRect)frameForAccessibilityIdentifier:(NSString *)identifier {
  UIView *view = [self findViewWithAccessibilityIdentifier:identifier inView:self.viewController.view];
  XCTAssertNotNil(view, @"Missing %@", identifier);
  return [view convertRect:view.bounds toView:self.viewController.view];
}

- (CGFloat)fontSizeForAccessibilityIdentifier:(NSString *)identifier {
  UILabel *label = (UILabel *)[self findViewWithAccessibilityIdentifier:identifier inView:self.viewController.view];
  XCTAssertNotNil(label, @"Missing %@", identifier);
  if (label == nil) {
    return 0.0;
  }

  UIFont *font = label.font;
  if (label.attributedText.length > 0) {
    UIFont *attributedFont = [label.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    if (attributedFont != nil) {
      font = attributedFont;
    }
  }

  return font.pointSize;
}

- (NSDictionary<NSString *, NSNumber *> *)currentAdaptiveOnboardingMetrics {
  UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.viewController.carouselCollectionView.collectionViewLayout;
  return @{
    @"titleFontSize" : @([self fontSizeForAccessibilityIdentifier:@"onboarding.titleLabel"]),
    @"horizontalInset" : @(CGRectGetMinX([self frameForAccessibilityIdentifier:@"onboarding.carouselCollectionView"])),
    @"stackSpacing" : @(self.viewController.contentStackView.spacing),
    @"carouselItemWidth" : @(layout.itemSize.width),
    @"buttonHeight" : @(CGRectGetHeight([self frameForAccessibilityIdentifier:@"onboarding.emailButton"])),
    @"carouselCellTitleFontSize" : @([self visibleCarouselLabelFontSizeWithSuffix:@".titleLabel"]),
    @"carouselCellMetadataFontSize" : @([self visibleCarouselLabelFontSizeWithSuffix:@".metadataLabel"])
  };
}

- (CGFloat)visibleCarouselLabelFontSizeWithSuffix:(NSString *)suffix {
  UIView *labelView = [self findViewWithAccessibilitySuffix:suffix inView:self.viewController.carouselCollectionView];
  XCTAssertNotNil(labelView, @"Missing visible carousel label ending with %@", suffix);
  if (![labelView isKindOfClass:[UILabel class]]) {
    return 0.0;
  }

  return ((UILabel *)labelView).font.pointSize;
}

- (void)assertAuthButtonsMeetMinimumTapTarget {
  NSArray<NSString *> *buttonIdentifiers = @[ @"onboarding.emailButton", @"onboarding.googleButton", @"onboarding.appleButton" ];

  for (NSString *identifier in buttonIdentifiers) {
    CGRect frame = [self frameForAccessibilityIdentifier:identifier];
    XCTAssertGreaterThanOrEqual(CGRectGetHeight(frame), 44.0, @"%@ should preserve a 44pt tap target", identifier);
  }
}

- (void)assertPrimaryOnboardingContentFitsCurrentViewport {
  NSArray<NSString *> *identifiers = @[
    @"onboarding.benefitTitleLabel", @"onboarding.benefitBodyLabel", @"onboarding.emailButton", @"onboarding.googleButton",
    @"onboarding.appleButton", @"onboarding.signinLabel"
  ];
  CGFloat viewportBottom = CGRectGetHeight(self.viewController.view.bounds) + 1.0;

  for (NSString *identifier in identifiers) {
    UIView *view = [self findViewWithAccessibilityIdentifier:identifier inView:self.viewController.view];
    XCTAssertNotNil(view, @"Missing %@", identifier);
    XCTAssertFalse(view.hidden, @"%@ should remain visible in the adaptive layout", identifier);
    CGRect frame = [self frameForAccessibilityIdentifier:identifier];
    XCTAssertGreaterThanOrEqual(CGRectGetMinY(frame), 0.0, @"%@ should start on screen", identifier);
    XCTAssertLessThanOrEqual(CGRectGetMaxY(frame), viewportBottom, @"%@ should stay above the fold", identifier);
  }
}

- (NSDictionary<NSString *, NSNumber *> *)adaptiveMetricsForLayoutScalingMode:(MRRLayoutScalingMode)layoutScalingMode
                                                                  windowSize:(CGSize)size {
  UIWindow *previousWindow = self.window;
  OnboardingViewController *previousViewController = self.viewController;

  UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width, size.height)];
  OnboardingViewController *viewController = [[OnboardingViewController alloc] initWithStateController:self.stateController
                                                                                      layoutScalingMode:layoutScalingMode];
  viewController.delegate = self.delegateSpy;
  window.rootViewController = viewController;
  [window makeKeyAndVisible];

  self.window = window;
  self.viewController = viewController;
  [self.viewController loadViewIfNeeded];
  [self layoutOnboardingForWindowSize:size];

  NSDictionary<NSString *, NSNumber *> *metrics = [[self currentAdaptiveOnboardingMetrics] copy];

  window.hidden = YES;
  self.window = previousWindow;
  self.viewController = previousViewController;

  return metrics;
}

- (void)spinMainRunLoop {
  [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.15]];
}

@end
