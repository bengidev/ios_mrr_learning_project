//
//  ProductDetailViewController.m
//  MVVM-C-MRR
//
//  ProductDetailViewController Implementation
//  MRR (Manual Retain-Release) Version
//
//  IMPORTANT: Compile with -fno-objc-arc flag
//

#import "ProductDetailViewController.h"
#import "ProductDetailViewModel.h"

@implementation ProductDetailViewController

@synthesize viewModel = _viewModel;

#pragma mark - Initialization

- (id)initWithViewModel:(ProductDetailViewModel *)viewModel {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _viewModel = [viewModel retain];
  }
  return self;
}

#pragma mark - Memory Management

- (void)dealloc {
  NSLog(@"[ProductDetailViewController] dealloc");

  [_viewModel release];
  [_scrollView release];
  [_stackView release];
  [_nameLabel release];
  [_priceLabel release];
  [_ratingLabel release];
  [_descriptionLabel release];
  [_reviewsButton release];
  [_addToCartButton release];

  [super dealloc];
}

#pragma mark - Property Setters

- (void)setViewModel:(ProductDetailViewModel *)viewModel {
  if (_viewModel != viewModel) {
    [_viewModel release];
    _viewModel = [viewModel retain];
  }
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setupUI];
  [self bindViewModel];
}

- (void)setupUI {
  self.view.backgroundColor = [UIColor whiteColor];
  self.title = @"Product Details";

  // ScrollView for content
  _scrollView = [[UIScrollView alloc] init];
  _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_scrollView];

  // StackView for layout
  _stackView = [[UIStackView alloc] init];
  _stackView.axis = UILayoutConstraintAxisVertical;
  _stackView.spacing = 16;
  _stackView.alignment = UIStackViewAlignmentFill;
  _stackView.translatesAutoresizingMaskIntoConstraints = NO;
  [_scrollView addSubview:_stackView];

  // Name Label
  _nameLabel = [[UILabel alloc] init];
  _nameLabel.font = [UIFont boldSystemFontOfSize:24];
  _nameLabel.numberOfLines = 0;
  [_stackView addArrangedSubview:_nameLabel];

  // Price Label
  _priceLabel = [[UILabel alloc] init];
  _priceLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
  _priceLabel.textColor = [UIColor colorWithRed:0.2
                                          green:0.7
                                           blue:0.3
                                          alpha:1.0];
  [_stackView addArrangedSubview:_priceLabel];

  // Rating Label
  _ratingLabel = [[UILabel alloc] init];
  _ratingLabel.font = [UIFont systemFontOfSize:16];
  _ratingLabel.textColor = [UIColor orangeColor];
  [_stackView addArrangedSubview:_ratingLabel];

  // Description Label
  _descriptionLabel = [[UILabel alloc] init];
  _descriptionLabel.font = [UIFont systemFontOfSize:16];
  _descriptionLabel.textColor = [UIColor grayColor];
  _descriptionLabel.numberOfLines = 0;
  [_stackView addArrangedSubview:_descriptionLabel];

  // Spacer
  UIView *spacer = [[[UIView alloc] init] autorelease];
  [spacer setContentHuggingPriority:UILayoutPriorityDefaultLow
                            forAxis:UILayoutConstraintAxisVertical];
  [_stackView addArrangedSubview:spacer];

  // Reviews Button
  _reviewsButton = [[UIButton buttonWithType:UIButtonTypeSystem] retain];
  [_reviewsButton setTitle:@"See Reviews" forState:UIControlStateNormal];
  _reviewsButton.titleLabel.font = [UIFont systemFontOfSize:18
                                                     weight:UIFontWeightMedium];
  [_reviewsButton addTarget:self
                     action:@selector(reviewsButtonTapped)
           forControlEvents:UIControlEventTouchUpInside];
  [_stackView addArrangedSubview:_reviewsButton];

  // Add to Cart Button
  _addToCartButton = [[UIButton buttonWithType:UIButtonTypeSystem] retain];
  [_addToCartButton setTitle:@"Add to Cart" forState:UIControlStateNormal];
  _addToCartButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
  _addToCartButton.backgroundColor = [UIColor colorWithRed:0.0
                                                     green:0.48
                                                      blue:1.0
                                                     alpha:1.0];
  [_addToCartButton setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateNormal];
  _addToCartButton.layer.cornerRadius = 10;
  [_addToCartButton addTarget:self
                       action:@selector(addToCartButtonTapped)
             forControlEvents:UIControlEventTouchUpInside];
  [_stackView addArrangedSubview:_addToCartButton];

  // Layout constraints
  UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
  [NSLayoutConstraint activateConstraints:@[
    [_scrollView.topAnchor constraintEqualToAnchor:safeArea.topAnchor],
    [_scrollView.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor],
    [_scrollView.trailingAnchor
        constraintEqualToAnchor:safeArea.trailingAnchor],
    [_scrollView.bottomAnchor constraintEqualToAnchor:safeArea.bottomAnchor],

    [_stackView.topAnchor constraintEqualToAnchor:_scrollView.topAnchor
                                         constant:20],
    [_stackView.leadingAnchor constraintEqualToAnchor:_scrollView.leadingAnchor
                                             constant:20],
    [_stackView.trailingAnchor
        constraintEqualToAnchor:_scrollView.trailingAnchor
                       constant:-20],
    [_stackView.bottomAnchor constraintEqualToAnchor:_scrollView.bottomAnchor
                                            constant:-20],
    [_stackView.widthAnchor constraintEqualToAnchor:_scrollView.widthAnchor
                                           constant:-40],

    [_addToCartButton.heightAnchor constraintEqualToConstant:50]
  ]];
}

- (void)bindViewModel {
  _nameLabel.text = [_viewModel productName];
  _priceLabel.text = [_viewModel formattedPrice];
  _ratingLabel.text =
      [NSString stringWithFormat:@"%@ • %@", [_viewModel ratingString],
                                 [_viewModel reviewCountString]];
  _descriptionLabel.text = [_viewModel productDescription];
}

#pragma mark - Actions

- (void)reviewsButtonTapped {
  [_viewModel showReviews];
}

- (void)addToCartButtonTapped {
  [_viewModel addToCart];
}

@end
