#import <XCTest/XCTest.h>
#import "../MRR Project/Core/Data/StaticMRRDemoRepository.h"
#import "../MRR Project/Core/Domain/UseCases/LoadDemoDetailUseCase.h"
#import "../MRR Project/Core/Presentation/Factories/DemoScreenFactory.h"
#import "../MRR Project/Core/Presentation/ViewControllers/DemoDetailViewController.h"

@interface DemoScreenFactoryTests : XCTestCase
@end

@implementation DemoScreenFactoryTests

- (void)testFactoryBuildsConfiguredDetailController {
    StaticMRRDemoRepository *repository = [[StaticMRRDemoRepository alloc] init];
    LoadDemoDetailUseCase *useCase = [[LoadDemoDetailUseCase alloc] initWithRepository:repository];
    DemoScreenFactory *factory = [[DemoScreenFactory alloc] initWithDetailUseCase:useCase];

    UIViewController *viewController = [factory detailViewControllerForDemoIdentifier:@"basics.property-semantics"];
    [viewController view];

    XCTAssertTrue([viewController isKindOfClass:[DemoDetailViewController class]]);
    XCTAssertEqualObjects(viewController.title, @"Property Semantics");
}

@end
