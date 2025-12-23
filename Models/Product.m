//
//  Product.m
//  MVVM-C-MRR
//
//  Product Model Implementation
//  MRR (Manual Retain-Release) Version
//
//  IMPORTANT: Compile with -fno-objc-arc flag
//

#import "Product.h"

@implementation Product

@synthesize productId = _productId;
@synthesize name = _name;
@synthesize productDescription = _productDescription;
@synthesize price = _price;
@synthesize imageURL = _imageURL;
@synthesize reviewCount = _reviewCount;
@synthesize rating = _rating;

#pragma mark - Memory Management

- (void)dealloc {
  [_productId release];
  [_name release];
  [_productDescription release];
  [_imageURL release];
  [super dealloc];
}

#pragma mark - Property Setters

- (void)setProductId:(NSString *)productId {
  if (_productId != productId) {
    [_productId release];
    _productId = [productId copy];
  }
}

- (void)setName:(NSString *)name {
  if (_name != name) {
    [_name release];
    _name = [name copy];
  }
}

- (void)setProductDescription:(NSString *)productDescription {
  if (_productDescription != productDescription) {
    [_productDescription release];
    _productDescription = [productDescription copy];
  }
}

- (void)setImageURL:(NSString *)imageURL {
  if (_imageURL != imageURL) {
    [_imageURL release];
    _imageURL = [imageURL copy];
  }
}

#pragma mark - Initialization

+ (id)productWithId:(NSString *)productId
               name:(NSString *)name
              price:(double)price {
  return [[[self alloc] initWithId:productId name:name
                             price:price] autorelease];
}

- (id)initWithId:(NSString *)productId
            name:(NSString *)name
           price:(double)price {
  self = [super init];
  if (self) {
    _productId = [productId copy];
    _name = [name copy];
    _price = price;
    _reviewCount = 0;
    _rating = 0.0;
  }
  return self;
}

#pragma mark - Sample Data

+ (NSArray *)sampleProducts {
  static NSArray *products = nil;
  if (products == nil) {
    Product *p1 = [Product productWithId:@"101"
                                    name:@"iPhone 15 Pro"
                                   price:999.00];
    p1.productDescription = @"The most powerful iPhone ever with A17 Pro chip";
    p1.reviewCount = 1250;
    p1.rating = 4.8;

    Product *p2 = [Product productWithId:@"102"
                                    name:@"MacBook Pro 14\""
                                   price:1999.00];
    p2.productDescription = @"M3 Pro chip, stunning Liquid Retina XDR display";
    p2.reviewCount = 890;
    p2.rating = 4.9;

    Product *p3 = [Product productWithId:@"103"
                                    name:@"AirPods Pro"
                                   price:249.00];
    p3.productDescription = @"Active Noise Cancellation, Spatial Audio";
    p3.reviewCount = 3420;
    p3.rating = 4.7;

    Product *p4 = [Product productWithId:@"104"
                                    name:@"Apple Watch Ultra 2"
                                   price:799.00];
    p4.productDescription = @"The most rugged and capable Apple Watch";
    p4.reviewCount = 567;
    p4.rating = 4.6;

    Product *p5 = [Product productWithId:@"105"
                                    name:@"iPad Pro 12.9\""
                                   price:1099.00];
    p5.productDescription = @"M2 chip, Liquid Retina XDR display, Face ID";
    p5.reviewCount = 1890;
    p5.rating = 4.8;

    products = [[NSArray alloc] initWithObjects:p1, p2, p3, p4, p5, nil];
  }
  return products;
}

+ (Product *)sampleProductWithId:(NSString *)productId {
  NSArray *products = [self sampleProducts];
  for (Product *product in products) {
    if ([product.productId isEqualToString:productId]) {
      return product;
    }
  }
  return nil;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"<Product: %@ - %@ ($%.2f)>",
                                    self.productId, self.name, self.price];
}

@end
