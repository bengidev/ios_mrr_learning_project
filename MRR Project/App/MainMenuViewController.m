#import "MainMenuViewController.h"

@interface MainMenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UILabel *headingLabel;
@property (nonatomic, retain) UILabel *summaryLabel;
@property (nonatomic, retain) UITableView *tableView;

@end

@implementation MainMenuViewController

- (void)dealloc {
    _tableView.dataSource = nil;
    _tableView.delegate = nil;

    [_headingLabel release];
    [_summaryLabel release];
    [_tableView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.view.accessibilityIdentifier = @"mainMenu.view";
    self.title = @"Main Menu";

    UILabel *headingLabel = [[[UILabel alloc] init] autorelease];
    headingLabel.font = [UIFont boldSystemFontOfSize:28.0];
    headingLabel.textColor = [UIColor blackColor];
    headingLabel.text = @"Main Menu";
    headingLabel.numberOfLines = 0;
    headingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:headingLabel];
    self.headingLabel = headingLabel;

    UILabel *summaryLabel = [[[UILabel alloc] init] autorelease];
    summaryLabel.font = [UIFont systemFontOfSize:16.0];
    summaryLabel.textColor = [UIColor darkGrayColor];
    summaryLabel.text = @"Choose a learning area. The full tab bar opens with your selected topic already focused.";
    summaryLabel.numberOfLines = 0;
    summaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:summaryLabel];
    self.summaryLabel = summaryLabel;

    UITableView *tableView = [[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped] autorelease];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 88.0;
    tableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    tableView.accessibilityIdentifier = @"mainMenu.tableView";
    [self.view addSubview:tableView];
    self.tableView = tableView;

    [NSLayoutConstraint activateConstraints:@[
        [headingLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:24.0],
        [headingLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20.0],
        [headingLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20.0],
        [summaryLabel.topAnchor constraintEqualToAnchor:headingLabel.bottomAnchor constant:8.0],
        [summaryLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20.0],
        [summaryLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20.0],
        [tableView.topAnchor constraintEqualToAnchor:summaryLabel.bottomAnchor constant:16.0],
        [tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const CellIdentifier = @"MainMenuOptionCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    }

    cell.textLabel.text = [self titleForMenuItemAtIndex:(NSUInteger)indexPath.row];
    cell.detailTextLabel.text = [self summaryForMenuItemAtIndex:(NSUInteger)indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate mainMenuViewController:self didSelectTabIndex:(NSUInteger)indexPath.row];
}

- (NSString *)titleForMenuItemAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            return @"Basics";
        case 1:
            return @"Relationships";
        case 2:
            return @"Lifecycle";
        default:
            return @"Unavailable";
    }
}

- (NSString *)summaryForMenuItemAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            return @"Review retain / release balance, autorelease pools, and property semantics.";
        case 1:
            return @"Study delegates, parent-child ownership, and collection retention behavior.";
        case 2:
            return @"Practice dealloc ordering, observer cleanup, and timer invalidation.";
        default:
            return @"";
    }
}

@end
