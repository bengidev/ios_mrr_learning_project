//
//  ProductDetailViewModel.h
//  MVVM-C-MRR
//
//  ProductDetailViewModel - ViewModel for product detail screen
//  MRR (Manual Retain-Release) Version
//
//  IMPORTANT: Compile with -fno-objc-arc flag
//

#import <Foundation/Foundation.h>

@class Product;
@class ProductDetailViewModel;

#pragma mark - Delegate Protocol

@protocol ProductDetailViewModelDelegate <NSObject>
@optional
/// Called when the user wants to see reviews
- (void)viewModelDidRequestReviews:(ProductDetailViewModel *)viewModel;

/// Called when the user wants to add to cart
- (void)viewModelDidRequestAddToCart:(ProductDetailViewModel *)viewModel;

/// Called when the user wants to go back
- (void)viewModelDidRequestDismiss:(ProductDetailViewModel *)viewModel;
@end

#pragma mark - ViewModel Interface

@interface ProductDetailViewModel : NSObject {
  id<ProductDetailViewModelDelegate> _delegate; // assign, NOT retained
  Product *_product;
}

/// Delegate for navigation events (ASSIGN - not retained)
@property(nonatomic, assign) id<ProductDetailViewModelDelegate> delegate;

/// The product being displayed (retain)
@property(nonatomic, retain) Product *product;

#pragma mark - Display Properties (computed, no ivar needed)

/// Product name
- (NSString *)productName;

/// Formatted price string (e.g., "$999.00")
- (NSString *)formattedPrice;

/// Product description
- (NSString *)productDescription;

/// Review count string (e.g., "1,250 reviews")
- (NSString *)reviewCountString;

/// Rating string (e.g., "4.8 ★")
- (NSString *)ratingString;

#pragma mark - Initialization

- (id)initWithProduct:(Product *)product;
+ (id)viewModelWithProduct:(Product *)product;

#pragma mark - Actions

/// Request to show reviews
- (void)showReviews;

/// Add product to cart
- (void)addToCart;

/// Dismiss this screen
- (void)dismiss;

@end
