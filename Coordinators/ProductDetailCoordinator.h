//
//  ProductDetailCoordinator.h
//  MVVM-C-MRR
//
//  ProductDetailCoordinator - Manages the product detail flow
//  MRR (Manual Retain-Release) Version
//
//  IMPORTANT: Compile with -fno-objc-arc flag
//

#import "BaseCoordinator.h"
#import "DeepLinkable.h"

@class Product;

@interface ProductDetailCoordinator : BaseCoordinator <DeepLinkable> {
  Product *_product;
}

/// The product to display (retain)
@property(nonatomic, retain) Product *product;

/// Initialize with a product
- (id)initWithNavigationController:
          (UINavigationController *)navigationController
                           product:(Product *)product;

@end
