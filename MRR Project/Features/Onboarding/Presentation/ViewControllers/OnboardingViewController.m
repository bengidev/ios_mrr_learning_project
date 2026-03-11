#import "OnboardingViewController.h"
#include <Foundation/NSObjCRuntime.h>
#include <UIKit/UIKit.h>

@implementation OnboardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Onboarding";
    self.view.backgroundColor = [self namedColor:@"CanvasBackground" fallback:[UIColor whiteColor]];
    self.view.tintColor = [self namedColor:@"AccentColor" fallback:self.view.tintColor];
    self.view.accessibilityIdentifier = @"onboarding.view";

    UIStackView* stackView = [[[UIStackView alloc] init] autorelease];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 18.0;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stackView];

    [NSLayoutConstraint activateConstraints:@[
        [stackView.centerYAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerYAnchor],
        [stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:24.0],
        [stackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-24.0]
    ]];

    UIImageView* illustrationView =
        [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OnboardingIllustration"]] autorelease];
    illustrationView.translatesAutoresizingMaskIntoConstraints = NO;
    illustrationView.backgroundColor = [self namedColor:@"CardBackground" fallback:[UIColor clearColor]];
    illustrationView.layer.cornerRadius = 28.0;
    illustrationView.clipsToBounds = YES;
    illustrationView.contentMode = UIViewContentModeScaleAspectFit;
    illustrationView.accessibilityIdentifier = @"onboarding.illustrationView";
    [stackView addArrangedSubview:illustrationView];
    [NSLayoutConstraint activateConstraints:@[ [illustrationView.heightAnchor constraintEqualToConstant:220.0] ]];

    UILabel* titleLabel = [self labelWithText:@"Welcome"
                                         font:[UIFont boldSystemFontOfSize:30.0]
                                        color:[self namedColor:@"PrimaryText" fallback:[UIColor blackColor]]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.accessibilityIdentifier = @"onboarding.titleLabel";
    [stackView addArrangedSubview:titleLabel];

    UILabel* summaryLabel = [self
        labelWithText:@"This is the first-launch onboarding screen. Tap the button below to continue into the app."
                 font:[UIFont systemFontOfSize:17.0]
                color:[self namedColor:@"SecondaryText" fallback:[UIColor darkGrayColor]]];
    summaryLabel.textAlignment = NSTextAlignmentCenter;
    [stackView addArrangedSubview:summaryLabel];

    UIButton* primaryButton = [UIButton buttonWithType:UIButtonTypeSystem];
    primaryButton.translatesAutoresizingMaskIntoConstraints = NO;
    primaryButton.backgroundColor = [self namedColor:@"PrimaryAction" fallback:[UIColor blackColor]];
    primaryButton.layer.cornerRadius = 12.0;
    primaryButton.contentEdgeInsets = UIEdgeInsetsMake(16.0, 20.0, 16.0, 20.0);
    primaryButton.accessibilityIdentifier = @"onboarding.primaryButton";
    primaryButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [primaryButton setTitle:@"Continue" forState:UIControlStateNormal];
    [primaryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [primaryButton addTarget:self action:@selector(didTapPrimaryButton) forControlEvents:UIControlEventTouchUpInside];
    [stackView addArrangedSubview:primaryButton];
    [NSLayoutConstraint
        activateConstraints:@[ [primaryButton.heightAnchor constraintGreaterThanOrEqualToConstant:56.0] ]];
}

- (void)didTapPrimaryButton {
    [self.delegate onboardingViewControllerDidFinish:self];
}

- (UIColor*)namedColor:(NSString*)name fallback:(UIColor*)fallbackColor {
    UIColor* namedColor = [UIColor colorNamed:name];
    return namedColor ?: fallbackColor;
}

- (UILabel*)labelWithText:(NSString*)text font:(UIFont*)font color:(UIColor*)color {
    UILabel* label = [[[UILabel alloc] init] autorelease];
    label.text = text;
    label.font = font;
    label.textColor = color;
    label.numberOfLines = 0;
    return label;
}

@end
