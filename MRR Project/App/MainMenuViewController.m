#import "MainMenuViewController.h"

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Main Menu";
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.accessibilityIdentifier = @"mainMenu.view";

    UIStackView *stackView = [[[UIStackView alloc] init] autorelease];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.spacing = 12.0;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stackView];

    UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
    titleLabel.text = @"Main Menu";
    titleLabel.font = [UIFont boldSystemFontOfSize:28.0];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.accessibilityIdentifier = @"mainMenu.titleLabel";
    [stackView addArrangedSubview:titleLabel];

    UILabel *summaryLabel = [[[UILabel alloc] init] autorelease];
    summaryLabel.text = @"Onboarding is complete. This screen is a simple placeholder for the next app flow.";
    summaryLabel.font = [UIFont systemFontOfSize:17.0];
    summaryLabel.textColor = [UIColor darkGrayColor];
    summaryLabel.numberOfLines = 0;
    summaryLabel.textAlignment = NSTextAlignmentCenter;
    summaryLabel.accessibilityIdentifier = @"mainMenu.summaryLabel";
    [stackView addArrangedSubview:summaryLabel];

    [NSLayoutConstraint activateConstraints:@[
        [stackView.centerYAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerYAnchor],
        [stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:24.0],
        [stackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-24.0]
    ]];
}

@end
