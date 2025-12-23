//
//  ProductListViewModel.h
//  MVVM-C-MRR
//
//  ProductListViewModel - ViewModel for product list screen
//  MRR (Manual Retain-Release) Version
//
//  IMPORTANT: Compile with -fno-objc-arc flag
//

#import <Foundation/Foundation.h>

@class Product;
@class ProductListViewModel;

#pragma mark - Delegate Protocol

@protocol ProductListViewModelDelegate <NSObject>
@required
/// Called when a product is selected
- (void)viewModel:(ProductListViewModel *)viewModel
    didSelectProduct:(Product *)product;

@optional
/// Called when the product list is refreshed
- (void)viewModelDidRefreshProducts:(ProductListViewModel *)viewModel;
@end

#pragma mark - ViewModel Interface

@interface ProductListViewModel : NSObject {
  id<ProductListViewModelDelegate> _delegate; // assign, NOT retained
  NSArray *_products;
  BOOL _loading;
  NSString *_errorMessage;
}

/// Delegate for navigation events (ASSIGN - not retained to avoid cycles)
@property(nonatomic, assign) id<ProductListViewModelDelegate> delegate;

/// The list of products to display (copy)
@property(nonatomic, copy) NSArray *products;

/// Whether the view model is currently loading
@property(nonatomic, assign, getter=isLoading) BOOL loading;

/// Error message if loading failed
@property(nonatomic, copy) NSString *errorMessage;

#pragma mark - Data Access

/// Number of products
- (NSInteger)numberOfProducts;

/// Product at index
- (Product *)productAtIndex:(NSInteger)index;

#pragma mark - Actions

/// Loads/refreshes the product list
- (void)loadProducts;

/// Selects a product at the given index
- (void)selectProductAtIndex:(NSInteger)index;

/// Selects a product by ID
- (void)selectProductWithId:(NSString *)productId;

@end
