//
//  ProductListViewModel.m
//  MVVM-C-MRR
//
//  ProductListViewModel Implementation
//  MRR (Manual Retain-Release) Version
//
//  IMPORTANT: Compile with -fno-objc-arc flag
//

#import "ProductListViewModel.h"
#import "Product.h"

@implementation ProductListViewModel

@synthesize delegate = _delegate;
@synthesize products = _products;
@synthesize loading = _loading;
@synthesize errorMessage = _errorMessage;

#pragma mark - Initialization

- (id)init {
  self = [super init];
  if (self) {
    _products = [[NSArray alloc] init];
    _loading = NO;
  }
  return self;
}

#pragma mark - Memory Management

- (void)dealloc {
  NSLog(@"[ProductListViewModel] dealloc");

  [_products release];
  [_errorMessage release];
  // Do NOT release _delegate (assign property)

  [super dealloc];
}

#pragma mark - Property Setters

- (void)setProducts:(NSArray *)products {
  if (_products != products) {
    [_products release];
    _products = [products copy];
  }
}

- (void)setErrorMessage:(NSString *)errorMessage {
  if (_errorMessage != errorMessage) {
    [_errorMessage release];
    _errorMessage = [errorMessage copy];
  }
}

#pragma mark - Data Access

- (NSInteger)numberOfProducts {
  return [_products count];
}

- (Product *)productAtIndex:(NSInteger)index {
  if (index >= 0 && index < [_products count]) {
    return [_products objectAtIndex:index];
  }
  return nil;
}

#pragma mark - Actions

- (void)loadProducts {
  if (_loading) {
    return;
  }

  _loading = YES;
  self.errorMessage = nil;

  // Simulate async loading - retain self to survive the async call
  [self retain];

  dispatch_after(
      dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
      dispatch_get_main_queue(), ^{
        // Load sample products
        self.products = [Product sampleProducts];
        _loading = NO;

        // Notify via delegate
        if ([_delegate
                respondsToSelector:@selector(viewModelDidRefreshProducts:)]) {
          [_delegate viewModelDidRefreshProducts:self];
        }

        NSLog(@"[ProductListViewModel] Loaded %ld products",
              (long)[_products count]);

        // Balance the retain
        [self release];
      });
}

- (void)selectProductAtIndex:(NSInteger)index {
  Product *product = [self productAtIndex:index];
  if (product) {
    [self notifyProductSelected:product];
  }
}

- (void)selectProductWithId:(NSString *)productId {
  for (Product *product in _products) {
    if ([product.productId isEqualToString:productId]) {
      [self notifyProductSelected:product];
      return;
    }
  }

  // Product not in list, try to find from sample data
  Product *product = [Product sampleProductWithId:productId];
  if (product) {
    [self notifyProductSelected:product];
  }
}

- (void)notifyProductSelected:(Product *)product {
  NSLog(@"[ProductListViewModel] Selected product: %@", product);

  // Notify via delegate
  [_delegate viewModel:self didSelectProduct:product];
}

@end
