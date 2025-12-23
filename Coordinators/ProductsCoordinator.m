//
//  ProductsCoordinator.m
//  MVVM-C-MRR
//
//  ProductsCoordinator Implementation
//  MRR (Manual Retain-Release) Version
//
//  IMPORTANT: Compile with -fno-objc-arc flag
//

#import "ProductsCoordinator.h"
#import "DeepLinkRoute.h"
#import "Product.h"
#import "ProductDetailCoordinator.h"
#import "ProductListViewController.h"
#import "ProductListViewModel.h"

@interface ProductsCoordinator () <ProductListViewModelDelegate> {
  ProductListViewModel *_viewModel;
  ProductListViewController
      *_listViewController; // assign, not retained (nav controller owns it)
}
@end

@implementation ProductsCoordinator

#pragma mark - Memory Management

- (void)dealloc {
  NSLog(@"[ProductsCoordinator] dealloc");

  [_viewModel release];
  // Do NOT release _listViewController (assign - nav controller owns it)

  [super dealloc];
}

#pragma mark - Lifecycle

- (void)start {
  NSLog(@"[ProductsCoordinator] Starting products flow");

  // Create ViewModel
  _viewModel = [[ProductListViewModel alloc] init];
  _viewModel.delegate = self; // Assign, no retain cycle

  // Create ViewController (autoreleased)
  ProductListViewController *listVC = [[[ProductListViewController alloc]
      initWithViewModel:_viewModel] autorelease];
  _listViewController = listVC; // assign, nav controller will retain

  // Push to navigation
  [self.navigationController pushViewController:listVC animated:YES];

  // Load products
  [_viewModel loadProducts];
}

#pragma mark - Navigation

- (void)showProductDetail:(Product *)product {
  NSLog(@"[ProductsCoordinator] Showing detail for product: %@",
        product.productId);

  // Create child coordinator
  ProductDetailCoordinator *detailCoordinator =
      [[[ProductDetailCoordinator alloc]
          initWithNavigationController:self.navigationController] autorelease];
  detailCoordinator.product = product;

  // Add and start child (addChildCoordinator retains it)
  [self addChildCoordinator:detailCoordinator];
  [detailCoordinator start];
}

- (void)showProductDetailWithId:(NSString *)productId {
  // Try to find product in current list
  Product *product = nil;
  for (Product *p in _viewModel.products) {
    if ([p.productId isEqualToString:productId]) {
      product = p;
      break;
    }
  }

  // If not found, try sample data
  if (!product) {
    product = [Product sampleProductWithId:productId];
  }

  if (product) {
    [self showProductDetail:product];
  } else {
    NSLog(@"[ProductsCoordinator] Product not found: %@", productId);
  }
}

#pragma mark - ProductListViewModelDelegate

- (void)viewModel:(ProductListViewModel *)viewModel
    didSelectProduct:(Product *)product {
  [self showProductDetail:product];
}

- (void)viewModelDidRefreshProducts:(ProductListViewModel *)viewModel {
  NSLog(@"[ProductsCoordinator] Products refreshed, count: %ld",
        (long)[viewModel.products count]);
  [_listViewController reloadData];
}

#pragma mark - DeepLinkable

- (BOOL)canHandleRoute:(DeepLinkRoute *)route {
  switch (route.type) {
  case DeepLinkRouteTypeProductList:
  case DeepLinkRouteTypeProductDetail:
  case DeepLinkRouteTypeProductReviews:
    return YES;
  default:
    return NO;
  }
}

- (void)handleRoute:(DeepLinkRoute *)route {
  NSLog(@"[ProductsCoordinator] Handling route: %@", route);

  switch (route.type) {
  case DeepLinkRouteTypeProductList:
    // Already showing list, check for child routes
    if (route.childRoute) {
      [self handleRoute:route.childRoute];
    }
    break;

  case DeepLinkRouteTypeProductDetail:
    if (route.productId) {
      [self showProductDetailWithId:route.productId];

      // Forward child routes to detail coordinator
      if (route.childRoute && [self.childCoordinators count] > 0) {
        id<Coordinator> child = [self.childCoordinators lastObject];
        if ([child conformsToProtocol:@protocol(DeepLinkable)]) {
          [(id<DeepLinkable>)child handleRoute:route.childRoute];
        }
      }
    }
    break;

  case DeepLinkRouteTypeProductReviews:
    // First show product detail, then reviews
    if (route.productId) {
      [self showProductDetailWithId:route.productId];

      // Forward reviews route to detail coordinator
      if ([self.childCoordinators count] > 0) {
        id<Coordinator> child = [self.childCoordinators lastObject];
        if ([child conformsToProtocol:@protocol(DeepLinkable)]) {
          [(id<DeepLinkable>)child handleRoute:route];
        }
      }
    }
    break;

  default:
    break;
  }
}

@end
