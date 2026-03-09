#import "DemoListPresenter.h"
#import "../../Domain/Models/MRRDemoCategory.h"
#import "../../Domain/UseCases/LoadDemoListUseCase.h"
#import "../Protocols/DemoListView.h"

@interface DemoListPresenter ()

@property (nonatomic, retain) LoadDemoListUseCase *useCase;
@property (nonatomic, copy) NSString *categoryIdentifier;
@property (nonatomic, assign) id<DemoListView> view;

@end

@implementation DemoListPresenter

- (instancetype)initWithUseCase:(LoadDemoListUseCase *)useCase
             categoryIdentifier:(NSString *)categoryIdentifier {
    NSParameterAssert(useCase != nil);
    NSParameterAssert(categoryIdentifier != nil);

    self = [super init];
    if (self) {
        _useCase = [useCase retain];
        _categoryIdentifier = [categoryIdentifier copy];
    }

    return self;
}

- (void)dealloc {
    [_useCase release];
    [_categoryIdentifier release];
    [super dealloc];
}

- (void)attachView:(id<DemoListView>)view {
    _view = view;
}

- (void)viewDidLoad {
    NSArray *categories = [self.useCase loadCategories];
    MRRDemoCategory *matchedCategory = nil;

    for (MRRDemoCategory *category in categories) {
        if ([category.identifier isEqualToString:self.categoryIdentifier]) {
            matchedCategory = category;
            break;
        }
    }

    if (matchedCategory == nil) {
        [self.view displayListErrorMessage:@"The requested category could not be found."];
        return;
    }

    [self.view displayCategory:matchedCategory demos:[self.useCase loadDemoSummariesForCategoryIdentifier:self.categoryIdentifier]];
}

@end
