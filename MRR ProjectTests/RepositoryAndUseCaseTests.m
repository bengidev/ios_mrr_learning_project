#import <XCTest/XCTest.h>
#import "../MRR Project/Core/Data/StaticMRRDemoRepository.h"
#import "../MRR Project/Core/Domain/Models/MRRDemoCategory.h"
#import "../MRR Project/Core/Domain/Models/MRRDemoDetail.h"
#import "../MRR Project/Core/Domain/UseCases/LoadDemoDetailUseCase.h"
#import "../MRR Project/Core/Domain/UseCases/LoadDemoListUseCase.h"

@interface RepositoryAndUseCaseTests : XCTestCase
@end

@implementation RepositoryAndUseCaseTests

- (void)testRepositoryExposesThreeCategories {
    StaticMRRDemoRepository *repository = [[StaticMRRDemoRepository alloc] init];
    NSArray<MRRDemoCategory *> *categories = [repository fetchCategories];

    XCTAssertEqual(categories.count, 3U);
    XCTAssertEqualObjects(categories[0].identifier, MRRDemoCategoryIdentifierBasics);
    XCTAssertEqualObjects(categories[1].identifier, MRRDemoCategoryIdentifierRelationships);
    XCTAssertEqualObjects(categories[2].identifier, MRRDemoCategoryIdentifierLifecycle);
}

- (void)testListUseCaseReturnsSummariesForRelationships {
    StaticMRRDemoRepository *repository = [[StaticMRRDemoRepository alloc] init];
    LoadDemoListUseCase *useCase = [[LoadDemoListUseCase alloc] initWithRepository:repository];

    NSArray *summaries = [useCase loadDemoSummariesForCategoryIdentifier:MRRDemoCategoryIdentifierRelationships];

    XCTAssertEqual(summaries.count, 3U);
}

- (void)testDetailUseCaseReturnsExpectedSections {
    StaticMRRDemoRepository *repository = [[StaticMRRDemoRepository alloc] init];
    LoadDemoDetailUseCase *useCase = [[LoadDemoDetailUseCase alloc] initWithRepository:repository];

    MRRDemoDetail *detail = [useCase loadDemoDetailForIdentifier:@"lifecycle.dealloc-order"];

    XCTAssertNotNil(detail);
    XCTAssertEqualObjects(detail.title, @"dealloc Order");
    XCTAssertEqual(detail.sections.count, 2U);
}

@end
