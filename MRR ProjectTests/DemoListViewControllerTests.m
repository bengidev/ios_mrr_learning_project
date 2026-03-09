#import <XCTest/XCTest.h>
#import "../MRR Project/Core/Data/StaticMRRDemoRepository.h"
#import "../MRR Project/Core/Domain/UseCases/LoadDemoDetailUseCase.h"
#import "../MRR Project/Core/Domain/UseCases/LoadDemoListUseCase.h"
#import "../MRR Project/Core/Presentation/Factories/DemoScreenFactory.h"
#import "../MRR Project/Core/Presentation/ViewControllers/DemoDetailViewController.h"
#import "../MRR Project/Features/Basics/Presentation/BasicsListViewController.h"

@interface DemoListViewControllerTests : XCTestCase
@end

@implementation DemoListViewControllerTests

- (void)testSelectingDemoPushesDetailController {
    StaticMRRDemoRepository *repository = [[StaticMRRDemoRepository alloc] init];
    LoadDemoListUseCase *listUseCase = [[LoadDemoListUseCase alloc] initWithRepository:repository];
    LoadDemoDetailUseCase *detailUseCase = [[LoadDemoDetailUseCase alloc] initWithRepository:repository];
    DemoScreenFactory *factory = [[DemoScreenFactory alloc] initWithDetailUseCase:detailUseCase];
    BasicsListViewController *viewController = [[BasicsListViewController alloc] initWithListUseCase:listUseCase screenFactory:factory];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];

    [viewController view];
    [viewController selectDemoAtIndex:0];

    XCTAssertEqual(navigationController.viewControllers.count, 2U);
    XCTAssertTrue([navigationController.topViewController isKindOfClass:[DemoDetailViewController class]]);
}

@end
