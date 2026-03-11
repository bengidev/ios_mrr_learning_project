#import "OnboardingViewController.h"

@implementation OnboardingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Onboarding";
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.accessibilityIdentifier = @"onboarding.view";

    UIStackView *stackView = [[[UIStackView alloc] init] autorelease];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 14.0;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stackView];

    [NSLayoutConstraint activateConstraints:@[
        [stackView.centerYAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerYAnchor],
        [stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:24.0],
        [stackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-24.0]
    ]];

    UILabel *titleLabel = [self labelWithText:@"Welcome"
                                         font:[UIFont boldSystemFontOfSize:30.0]
                                        color:[UIColor blackColor]];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.accessibilityIdentifier = @"onboarding.titleLabel";
    [stackView addArrangedSubview:titleLabel];

    UILabel *summaryLabel = [self labelWithText:@"This is the first-launch onboarding screen. Tap the button below to continue into the app."
                                           font:[UIFont systemFontOfSize:17.0]
                                          color:[UIColor darkGrayColor]];
    summaryLabel.textAlignment = NSTextAlignmentCenter;
    [stackView addArrangedSubview:summaryLabel];

    UIButton *primaryButton = [UIButton buttonWithType:UIButtonTypeSystem];
    primaryButton.translatesAutoresizingMaskIntoConstraints = NO;
    primaryButton.backgroundColor = [UIColor blackColor];
    primaryButton.layer.cornerRadius = 12.0;
    primaryButton.contentEdgeInsets = UIEdgeInsetsMake(16.0, 20.0, 16.0, 20.0);
    primaryButton.accessibilityIdentifier = @"onboarding.primaryButton";
    primaryButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [primaryButton setTitle:@"Continue" forState:UIControlStateNormal];
    [primaryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [primaryButton addTarget:self
                      action:@selector(didTapPrimaryButton)
            forControlEvents:UIControlEventTouchUpInside];
    [stackView addArrangedSubview:primaryButton];
    [NSLayoutConstraint activateConstraints:@[
        [primaryButton.heightAnchor constraintGreaterThanOrEqualToConstant:56.0]
    ]];
}

- (void)didTapPrimaryButton {
    [self.delegate onboardingViewControllerDidFinish:self];
}

- (UILabel *)labelWithText:(NSString *)text
                      font:(UIFont *)font
                     color:(UIColor *)color {
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.text = text;
    label.font = font;
    label.textColor = color;
    label.numberOfLines = 0;
    return label;
}

@end
