//
//  ViewController.m
//  MRR Project
//
//  Created for MRR Learning
//

#import "ViewController.h"

@implementation ViewController

#pragma mark - Memory Management

- (void)dealloc {
    // IMPORTANT: Always release retained properties in dealloc!
    [_titleLabel release];
    _titleLabel = nil;

    [_descriptionLabel release];
    _descriptionLabel = nil;

    // Always call super dealloc LAST
    [super dealloc];
}

#pragma mark - View Lifecycle

- (void)loadView {
    // Create the main view programmatically
    UIView *mainView = [[[UIView alloc]
                         initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    mainView.backgroundColor = [UIColor whiteColor];
    self.view = mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

#pragma mark - UI Setup

- (void)setupUI {
    // Create title label
    UILabel *title = [[UILabel alloc] init];

    title.text = @"MRR Learning Project";
    title.font = [UIFont boldSystemFontOfSize:24.0];
    title.textColor = [UIColor blackColor];
    title.backgroundColor = [UIColor systemOrangeColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:title];
    self.titleLabel = title;
    [title release]; // Release after assigning to retained property

    // Create description label
    UILabel *description = [[UILabel alloc] init];
    description.text =
        @"Manual Retain-Release Memory Management\n\nThis project demonstrates "
        @"pre-ARC patterns:\n• retain / release / autorelease\n• dealloc "
        @"cleanup\n• Property memory semantics";
    description.font = [UIFont systemFontOfSize:16.0];
    description.textColor = [UIColor darkGrayColor];
    description.textAlignment = NSTextAlignmentCenter;
    description.numberOfLines = 0;
    description.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:description];
    self.descriptionLabel = description;
    [description release]; // Release after assigning to retained property

    // Setup constraints
    [self setupConstraints];
}

- (void)setupConstraints {
    // Title constraints
    [NSLayoutConstraint activateConstraints:@[
         [self.titleLabel.centerXAnchor
          constraintEqualToAnchor:self.view.centerXAnchor],
         [self.titleLabel.topAnchor
          constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor
                         constant:60.0],
         [self.titleLabel.leadingAnchor
          constraintEqualToAnchor:self.view.leadingAnchor constant:10.0],
         [self.titleLabel.trailingAnchor
          constraintEqualToAnchor:self.view.trailingAnchor constant:-10.0]
    ]];

    // Description constraints
    [NSLayoutConstraint activateConstraints:@[
         [self.descriptionLabel.centerXAnchor
          constraintEqualToAnchor:self.view.centerXAnchor],
         [self.descriptionLabel.topAnchor
          constraintEqualToAnchor:self.titleLabel.bottomAnchor
                         constant:40.0],
         [self.descriptionLabel.leadingAnchor
          constraintEqualToAnchor:self.view.leadingAnchor
                         constant:30.0],
         [self.descriptionLabel.trailingAnchor
          constraintEqualToAnchor:self.view.trailingAnchor
                         constant:-30.0]
    ]];
}

@end
