//
//  ProductListViewController.h
//  MVVM-C-MRR
//
//  ProductListViewController - Displays list of products
//  MRR (Manual Retain-Release) Version
//
//  IMPORTANT: Compile with -fno-objc-arc flag
//

#import <UIKit/UIKit.h>

@class ProductListViewModel;

@interface ProductListViewController : UIViewController {
  ProductListViewModel *_viewModel;
  UITableView *_tableView;
  UIRefreshControl *_refreshControl;
  UIActivityIndicatorView *_loadingIndicator;
}

/// The view model for this view controller (retain)
@property(nonatomic, retain) ProductListViewModel *viewModel;

/// Initializes with a view model
- (id)initWithViewModel:(ProductListViewModel *)viewModel;

@end
