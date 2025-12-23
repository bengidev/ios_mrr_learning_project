//
//  ProductListViewController.m
//  MVVM-C-MRR
//
//  ProductListViewController Implementation
//  MRR (Manual Retain-Release) Version
//
//  IMPORTANT: Compile with -fno-objc-arc flag
//

#import "ProductListViewController.h"
#import "Product.h"
#import "ProductListViewModel.h"

static NSString *const kProductCellIdentifier = @"ProductCell";

@interface ProductListViewController () <UITableViewDataSource,
                                         UITableViewDelegate>
@end

@implementation ProductListViewController

@synthesize viewModel = _viewModel;

#pragma mark - Initialization

- (id)initWithViewModel:(ProductListViewModel *)viewModel {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _viewModel = [viewModel retain];
  }
  return self;
}

#pragma mark - Memory Management

- (void)dealloc {
  NSLog(@"[ProductListViewController] dealloc");

  [_viewModel release];
  [_tableView release];
  [_refreshControl release];
  [_loadingIndicator release];

  [super dealloc];
}

#pragma mark - Property Setters

- (void)setViewModel:(ProductListViewModel *)viewModel {
  if (_viewModel != viewModel) {
    [_viewModel release];
    _viewModel = [viewModel retain];
  }
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setupUI];
  [_viewModel loadProducts];
}

- (void)setupUI {
  self.title = @"Products";
  self.view.backgroundColor = [UIColor whiteColor];

  // Setup TableView
  _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                            style:UITableViewStylePlain];
  _tableView.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  _tableView.dataSource = self;
  _tableView.delegate = self;
  [_tableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:kProductCellIdentifier];
  [self.view addSubview:_tableView];

  // Setup RefreshControl
  _refreshControl = [[UIRefreshControl alloc] init];
  [_refreshControl addTarget:self
                      action:@selector(handleRefresh)
            forControlEvents:UIControlEventValueChanged];
  _tableView.refreshControl = _refreshControl;

  // Setup Loading Indicator
  _loadingIndicator = [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
  _loadingIndicator.center = self.view.center;
  _loadingIndicator.hidesWhenStopped = YES;
  [self.view addSubview:_loadingIndicator];
}

#pragma mark - Actions

- (void)handleRefresh {
  [_viewModel loadProducts];
}

/// Called by coordinator to refresh the table
- (void)reloadData {
  [_refreshControl endRefreshing];
  [_loadingIndicator stopAnimating];
  [_tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [_viewModel numberOfProducts];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:kProductCellIdentifier
                                      forIndexPath:indexPath];

  Product *product = [_viewModel productAtIndex:indexPath.row];

  cell.textLabel.text = product.name;
  cell.detailTextLabel.text =
      [NSString stringWithFormat:@"$%.2f", product.price];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [_viewModel selectProductAtIndex:indexPath.row];
}

@end
