#import <XCTest/XCTest.h>
#import "../MRR Project/Core/Data/StaticMRRDemoRepository.h"
#import "../MRR Project/Core/Domain/Models/MRRDemoCategory.h"
#import "../MRR Project/Core/Domain/Models/MRRDemoDetail.h"
#import "../MRR Project/Core/Domain/UseCases/LoadDemoDetailUseCase.h"
#import "../MRR Project/Core/Domain/UseCases/LoadDemoListUseCase.h"
#import "../MRR Project/Core/Presentation/Presenters/DemoDetailPresenter.h"
#import "../MRR Project/Core/Presentation/Presenters/DemoListPresenter.h"
#import "../MRR Project/Core/Presentation/Protocols/DemoDetailView.h"
#import "../MRR Project/Core/Presentation/Protocols/DemoListView.h"

@interface DemoListViewSpy : NSObject <DemoListView>
@property (nonatomic, strong) MRRDemoCategory *displayedCategory;
@property (nonatomic, copy) NSArray *displayedDemos;
@property (nonatomic, copy) NSString *errorMessage;
@end

@implementation DemoListViewSpy
- (void)displayCategory:(MRRDemoCategory *)category demos:(NSArray *)demos {
    self.displayedCategory = category;
    self.displayedDemos = demos;
}
- (void)displayListErrorMessage:(NSString *)message {
    self.errorMessage = message;
}
@end

@interface DemoDetailViewSpy : NSObject <DemoDetailView>
@property (nonatomic, strong) MRRDemoDetail *displayedDetail;
@property (nonatomic, copy) NSString *errorMessage;
@end

@implementation DemoDetailViewSpy
- (void)displayDemoDetail:(MRRDemoDetail *)detail {
    self.displayedDetail = detail;
}
- (void)displayDetailErrorMessage:(NSString *)message {
    self.errorMessage = message;
}
@end

@interface PresenterTests : XCTestCase
@end

@implementation PresenterTests

- (void)testListPresenterDisplaysMatchedCategory {
    StaticMRRDemoRepository *repository = [[StaticMRRDemoRepository alloc] init];
    LoadDemoListUseCase *useCase = [[LoadDemoListUseCase alloc] initWithRepository:repository];
    DemoListPresenter *presenter = [[DemoListPresenter alloc] initWithUseCase:useCase categoryIdentifier:MRRDemoCategoryIdentifierBasics];
    DemoListViewSpy *viewSpy = [[DemoListViewSpy alloc] init];

    [presenter attachView:viewSpy];
    [presenter viewDidLoad];

    XCTAssertNil(viewSpy.errorMessage);
    XCTAssertEqualObjects(viewSpy.displayedCategory.identifier, MRRDemoCategoryIdentifierBasics);
    XCTAssertEqual(viewSpy.displayedDemos.count, 3U);
}

- (void)testDetailPresenterDisplaysRequestedDetail {
    StaticMRRDemoRepository *repository = [[StaticMRRDemoRepository alloc] init];
    LoadDemoDetailUseCase *useCase = [[LoadDemoDetailUseCase alloc] initWithRepository:repository];
    DemoDetailPresenter *presenter = [[DemoDetailPresenter alloc] initWithUseCase:useCase demoIdentifier:@"relationships.delegate-ownership"];
    DemoDetailViewSpy *viewSpy = [[DemoDetailViewSpy alloc] init];

    [presenter attachView:viewSpy];
    [presenter viewDidLoad];

    XCTAssertNil(viewSpy.errorMessage);
    XCTAssertEqualObjects(viewSpy.displayedDetail.title, @"Delegate Ownership");
}

@end
