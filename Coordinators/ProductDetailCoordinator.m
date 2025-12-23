//
//  ProductDetailCoordinator.m
//  MVVM-C-MRR
//
//  ProductDetailCoordinator Implementation
//  MRR (Manual Retain-Release) Version
//
//  IMPORTANT: Compile with -fno-objc-arc flag
//

#import "ProductDetailCoordinator.h"
#import "DeepLinkRoute.h"
#import "Product.h"
#import "ProductDetailViewController.h"
#import "ProductDetailViewModel.h"

@interface ProductDetailCoordinator () <ProductDetailViewModelDelegate> {
  ProductDetailViewModel *_viewModel;
  ProductDetailViewController
      *_detailViewController; // assign, nav controller owns it
}
@end

@implementation ProductDetailCoordinator

@synthesize product = _product;

#pragma mark - Initialization

- (id)initWithNavigationController:
          (UINavigationController *)navigationController
                           product:(Product *)product {
  self = [super initWithNavigationController:navigationController];
  if (self) {
    _product = [product retain];
  }
  return self;
}

#pragma mark - Memory Management

- (void)dealloc {
  NSLog(@"[ProductDetailCoordinator] dealloc - product: %@",
        _product.productId);

  [_product release];
  [_viewModel release];
  // Do NOT release _detailViewController (assign - nav controller owns it)

  [super dealloc];
}

#pragma mark - Property Setters

- (void)setProduct:(Product *)product {
  if (_product != product) {
    [_product release];
    _product = [product retain];
  }
}

#pragma mark - Lifecycle

- (void)start {
  if (!_product) {
    NSLog(@"[ProductDetailCoordinator] ERROR: No product set");
    return;
  }

  NSLog(@"[ProductDetailCoordinator] Starting detail flow for: %@",
        _product.productId);

  // Create ViewModel
  _viewModel = [[ProductDetailViewModel alloc] initWithProduct:_product];
  _viewModel.delegate = self; // Assign, no retain cycle

  // Create ViewController (autoreleased)
  ProductDetailViewController *detailVC = [[[ProductDetailViewController alloc]
      initWithViewModel:_viewModel] autorelease];
  _detailViewController = detailVC; // assign

  // Push to navigation
  [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Navigation

- (void)showReviews {
  NSLog(@"[ProductDetailCoordinator] Showing reviews for product: %@",
        _product.productId);

  // Create a simple reviews view controller (autoreleased)
  UIViewController *reviewsVC = [[[UIViewController alloc] init] autorelease];
  reviewsVC.view.backgroundColor = [UIColor whiteColor];
  reviewsVC.title =
      [NSString stringWithFormat:@"Reviews for %@", _product.name];

  // Add a label with review info (autoreleased)
  UILabel *label = [[[UILabel alloc] init] autorelease];
  label.text =
      [NSString stringWithFormat:@"%ld reviews\n⭐️ %.1f average rating",
                                 (long)_product.reviewCount, _product.rating];
  label.numberOfLines = 0;
  label.textAlignment = NSTextAlignmentCenter;
  label.font = [UIFont systemFontOfSize:20];
  label.translatesAutoresizingMaskIntoConstraints = NO;
  [reviewsVC.view addSubview:label];

  [NSLayoutConstraint activateConstraints:@[
    [label.centerXAnchor constraintEqualToAnchor:reviewsVC.view.centerXAnchor],
    [label.centerYAnchor constraintEqualToAnchor:reviewsVC.view.centerYAnchor]
  ]];

  [self.navigationController pushViewController:reviewsVC animated:YES];
}

- (void)showAddToCartConfirmation {
  UIAlertController *alert = [UIAlertController
      alertControllerWithTitle:@"Added to Cart"
                       message:[NSString stringWithFormat:
                                             @"%@ has been added to your cart.",
                                             _product.name]
                preferredStyle:UIAlertControllerStyleAlert];

  [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                            style:UIAlertActionStyleDefault
                                          handler:nil]];
  [alert
      addAction:
          [UIAlertAction
              actionWithTitle:@"View Cart"
                        style:UIAlertActionStyleDefault
                      handler:^(UIAlertAction *action) {
                        NSLog(@"[ProductDetailCoordinator] Navigate to cart");
                      }]];

  [self.navigationController presentViewController:alert
                                          animated:YES
                                        completion:nil];
}

#pragma mark - ProductDetailViewModelDelegate

- (void)viewModelDidRequestReviews:(ProductDetailViewModel *)viewModel {
  [self showReviews];
}

- (void)viewModelDidRequestAddToCart:(ProductDetailViewModel *)viewModel {
  [self showAddToCartConfirmation];
}

- (void)viewModelDidRequestDismiss:(ProductDetailViewModel *)viewModel {
  [self.navigationController popViewControllerAnimated:YES];
  [self finish];
}

#pragma mark - DeepLinkable

- (BOOL)canHandleRoute:(DeepLinkRoute *)route {
  switch (route.type) {
  case DeepLinkRouteTypeProductReviews:
    return YES;
  default:
    return NO;
  }
}

- (void)handleRoute:(DeepLinkRoute *)route {
  NSLog(@"[ProductDetailCoordinator] Handling route: %@", route);

  switch (route.type) {
  case DeepLinkRouteTypeProductReviews:
    [self showReviews];
    break;

  default:
    break;
  }
}

@end
