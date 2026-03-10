#import "OnboardingViewController.h"

@interface OnboardingViewController ()

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIStackView *stackView;

@end

@implementation OnboardingViewController

- (void)dealloc {
    [_scrollView release];
    [_contentView release];
    [_stackView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.view.accessibilityIdentifier = @"onboarding.view";

    UIScrollView *scrollView = [[[UIScrollView alloc] init] autorelease];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;

    UIView *contentView = [[[UIView alloc] init] autorelease];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [scrollView addSubview:contentView];
    self.contentView = contentView;

    UIStackView *stackView = [[[UIStackView alloc] init] autorelease];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 16.0;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:stackView];
    self.stackView = stackView;

    [NSLayoutConstraint activateConstraints:@[
        [scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [contentView.topAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.topAnchor],
        [contentView.leadingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.leadingAnchor],
        [contentView.trailingAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.trailingAnchor],
        [contentView.bottomAnchor constraintEqualToAnchor:scrollView.contentLayoutGuide.bottomAnchor],
        [contentView.widthAnchor constraintEqualToAnchor:scrollView.frameLayoutGuide.widthAnchor],
        [stackView.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:24.0],
        [stackView.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:20.0],
        [stackView.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-20.0],
        [stackView.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor constant:-24.0]
    ]];

    UILabel *titleLabel = [self labelWithText:@"Learn Manual Retain-Release with guided demos"
                                         font:[UIFont boldSystemFontOfSize:30.0]
                                        color:[UIColor blackColor]];
    titleLabel.accessibilityIdentifier = @"onboarding.titleLabel";
    [self.stackView addArrangedSubview:titleLabel];

    UILabel *summaryLabel = [self labelWithText:@"This project walks through ownership rules, cleanup patterns, and review prompts so you can reason about MRR with confidence."
                                           font:[UIFont systemFontOfSize:17.0]
                                          color:[UIColor darkGrayColor]];
    [self.stackView addArrangedSubview:summaryLabel];

    UILabel *areasHeadingLabel = [self labelWithText:@"What you'll cover"
                                                font:[UIFont boldSystemFontOfSize:20.0]
                                               color:[UIColor blackColor]];
    [self.stackView addArrangedSubview:areasHeadingLabel];

    [self.stackView addArrangedSubview:[self learningAreaCardWithTitle:@"Basics"
                                                                  body:@"Start with retain / release balance, autorelease pools, and property semantics."]];
    [self.stackView addArrangedSubview:[self learningAreaCardWithTitle:@"Relationships"
                                                                  body:@"Review delegates, parent-child ownership, and how collections retain objects."]];
    [self.stackView addArrangedSubview:[self learningAreaCardWithTitle:@"Lifecycle"
                                                                  body:@"Practice dealloc ordering, observer cleanup, and timer invalidation."]];

    UIButton *primaryButton = [UIButton buttonWithType:UIButtonTypeSystem];
    primaryButton.translatesAutoresizingMaskIntoConstraints = NO;
    primaryButton.backgroundColor = [UIColor blackColor];
    primaryButton.layer.cornerRadius = 12.0;
    primaryButton.contentEdgeInsets = UIEdgeInsetsMake(16.0, 20.0, 16.0, 20.0);
    primaryButton.accessibilityIdentifier = @"onboarding.primaryButton";
    primaryButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [primaryButton setTitle:@"Open Main Menu" forState:UIControlStateNormal];
    [primaryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [primaryButton addTarget:self
                      action:@selector(didTapPrimaryButton)
            forControlEvents:UIControlEventTouchUpInside];
    [self.stackView addArrangedSubview:primaryButton];
    [NSLayoutConstraint activateConstraints:@[
        [primaryButton.heightAnchor constraintGreaterThanOrEqualToConstant:56.0]
    ]];

    UILabel *footerLabel = [self labelWithText:@"You'll only see this onboarding screen on first launch unless the stored flag is reset."
                                          font:[UIFont systemFontOfSize:14.0]
                                         color:[UIColor darkGrayColor]];
    [self.stackView addArrangedSubview:footerLabel];
}

- (void)didTapPrimaryButton {
    [self.delegate onboardingViewControllerDidFinish:self];
}

- (UIView *)learningAreaCardWithTitle:(NSString *)title body:(NSString *)body {
    UIStackView *cardView = [[[UIStackView alloc] init] autorelease];
    cardView.axis = UILayoutConstraintAxisVertical;
    cardView.spacing = 8.0;
    cardView.layoutMargins = UIEdgeInsetsMake(16.0, 16.0, 16.0, 16.0);
    cardView.layoutMarginsRelativeArrangement = YES;
    cardView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    cardView.layer.cornerRadius = 12.0;

    UILabel *titleLabel = [self labelWithText:title
                                         font:[UIFont boldSystemFontOfSize:18.0]
                                        color:[UIColor blackColor]];
    [cardView addArrangedSubview:titleLabel];

    UILabel *bodyLabel = [self labelWithText:body
                                        font:[UIFont systemFontOfSize:15.0]
                                       color:[UIColor darkGrayColor]];
    [cardView addArrangedSubview:bodyLabel];

    return cardView;
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
