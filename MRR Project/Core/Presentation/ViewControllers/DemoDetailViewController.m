#import "DemoDetailViewController.h"
#import "../../Domain/Models/MRRDemoDetail.h"
#import "../../Domain/Models/MRRDemoSection.h"
#import "../Presenters/DemoDetailPresenter.h"
#import "../Protocols/DemoDetailView.h"

@interface DemoDetailViewController () <DemoDetailView>

@property (nonatomic, retain) DemoDetailPresenter *presenter;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIStackView *stackView;

@end

@implementation DemoDetailViewController

- (instancetype)initWithPresenter:(DemoDetailPresenter *)presenter {
    NSParameterAssert(presenter != nil);

    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _presenter = [presenter retain];
    }

    return self;
}

- (void)dealloc {
    [_presenter release];
    [_scrollView release];
    [_contentView release];
    [_stackView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

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

    [self.presenter attachView:self];
    [self.presenter viewDidLoad];
}

- (void)displayDemoDetail:(MRRDemoDetail *)detail {
    self.title = detail.title;
    [self resetStackContents];

    UILabel *subtitleLabel = [self labelWithText:detail.subtitleText
                                            font:[UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium]
                                           color:[UIColor darkGrayColor]];
    subtitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.stackView addArrangedSubview:subtitleLabel];

    for (MRRDemoSection *section in detail.sections) {
        [self.stackView addArrangedSubview:[self sectionViewForSection:section]];
    }
}

- (void)displayDetailErrorMessage:(NSString *)message {
    self.title = @"Unavailable";
    [self resetStackContents];

    UILabel *messageLabel = [self labelWithText:message
                                           font:[UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium]
                                          color:[UIColor darkGrayColor]];
    [self.stackView addArrangedSubview:messageLabel];
}

- (void)resetStackContents {
    NSArray *arrangedSubviews = [self.stackView.arrangedSubviews copy];

    for (UIView *view in arrangedSubviews) {
        [self.stackView removeArrangedSubview:view];
        [view removeFromSuperview];
    }

    [arrangedSubviews release];
}

- (UIView *)sectionViewForSection:(MRRDemoSection *)section {
    UIStackView *sectionStack = [[[UIStackView alloc] init] autorelease];
    sectionStack.axis = UILayoutConstraintAxisVertical;
    sectionStack.spacing = 10.0;
    sectionStack.layoutMargins = UIEdgeInsetsMake(16.0, 16.0, 16.0, 16.0);
    sectionStack.layoutMarginsRelativeArrangement = YES;
    sectionStack.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    sectionStack.layer.cornerRadius = 12.0;

    UILabel *titleLabel = [self labelWithText:section.title
                                         font:[UIFont boldSystemFontOfSize:20.0]
                                        color:[UIColor blackColor]];
    [sectionStack addArrangedSubview:titleLabel];

    UILabel *bodyLabel = [self labelWithText:section.bodyText
                                        font:[UIFont systemFontOfSize:16.0]
                                       color:[UIColor darkGrayColor]];
    [sectionStack addArrangedSubview:bodyLabel];

    if (section.checklistItems.count > 0) {
        UILabel *checklistHeadingLabel = [self labelWithText:@"Checklist"
                                                        font:[UIFont boldSystemFontOfSize:15.0]
                                                       color:[UIColor blackColor]];
        [sectionStack addArrangedSubview:checklistHeadingLabel];

        for (NSString *item in section.checklistItems) {
            UILabel *itemLabel = [self labelWithText:[NSString stringWithFormat:@"- %@", item]
                                                font:[UIFont systemFontOfSize:15.0]
                                               color:[UIColor darkGrayColor]];
            [sectionStack addArrangedSubview:itemLabel];
        }
    }

    return sectionStack;
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
