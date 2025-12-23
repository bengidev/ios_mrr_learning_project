//
//  ProductDetailViewModel.m
//  MVVM-C-MRR
//
//  ProductDetailViewModel Implementation
//  MRR (Manual Retain-Release) Version
//
//  IMPORTANT: Compile with -fno-objc-arc flag
//

#import "ProductDetailViewModel.h"
#import "Product.h"

@implementation ProductDetailViewModel

@synthesize delegate = _delegate;
@synthesize product = _product;

#pragma mark - Initialization

- (id)initWithProduct:(Product *)product {
  self = [super init];
  if (self) {
    _product = [product retain];
  }
  return self;
}

+ (id)viewModelWithProduct:(Product *)product {
  return [[[self alloc] initWithProduct:product] autorelease];
}

#pragma mark - Memory Management

- (void)dealloc {
  NSLog(@"[ProductDetailViewModel] dealloc - product: %@", _product.productId);

  [_product release];
  // Do NOT release _delegate (assign property)

  [super dealloc];
}

#pragma mark - Property Setters

- (void)setProduct:(Product *)product {
  if (_product != product) {
    [_product release];
    _product = [product retain];
  }
}

#pragma mark - Display Properties

- (NSString *)productName {
  return _product.name ? _product.name : @"Unknown Product";
}

- (NSString *)formattedPrice {
  NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
  [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
  [formatter setCurrencyCode:@"USD"];
  NSString *result =
      [formatter stringFromNumber:[NSNumber numberWithDouble:_product.price]];
  return result ? result : @"$0.00";
}

- (NSString *)productDescription {
  return _product.productDescription;
}

- (NSString *)reviewCountString {
  NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
  [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
  NSString *countString = [formatter
      stringFromNumber:[NSNumber numberWithInteger:_product.reviewCount]];
  return [NSString
      stringWithFormat:@"%@ reviews", countString ? countString : @"0"];
}

- (NSString *)ratingString {
  return [NSString stringWithFormat:@"%.1f ★", _product.rating];
}

#pragma mark - Actions

- (void)showReviews {
  NSLog(@"[ProductDetailViewModel] Show reviews requested for: %@",
        _product.productId);

  if ([_delegate respondsToSelector:@selector(viewModelDidRequestReviews:)]) {
    [_delegate viewModelDidRequestReviews:self];
  }
}

- (void)addToCart {
  NSLog(@"[ProductDetailViewModel] Add to cart requested for: %@",
        _product.productId);

  if ([_delegate respondsToSelector:@selector(viewModelDidRequestAddToCart:)]) {
    [_delegate viewModelDidRequestAddToCart:self];
  }
}

- (void)dismiss {
  NSLog(@"[ProductDetailViewModel] Dismiss requested");

  if ([_delegate respondsToSelector:@selector(viewModelDidRequestDismiss:)]) {
    [_delegate viewModelDidRequestDismiss:self];
  }
}

@end
