//
//  ProductDetailViewController.h
//  MVVM-C-MRR
//
//  ProductDetailViewController - Displays product details
//  MRR (Manual Retain-Release) Version
//
//  IMPORTANT: Compile with -fno-objc-arc flag
//

#import <UIKit/UIKit.h>

@class ProductDetailViewModel;

@interface ProductDetailViewController : UIViewController {
  ProductDetailViewModel *_viewModel;
  UIScrollView *_scrollView;
  UIStackView *_stackView;
  UILabel *_nameLabel;
  UILabel *_priceLabel;
  UILabel *_ratingLabel;
  UILabel *_descriptionLabel;
  UIButton *_reviewsButton;
  UIButton *_addToCartButton;
}

/// The view model for this view controller (retain)
@property(nonatomic, retain) ProductDetailViewModel *viewModel;

/// Initializes with a view model
- (id)initWithViewModel:(ProductDetailViewModel *)viewModel;

@end
