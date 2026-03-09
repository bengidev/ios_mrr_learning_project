#import "RelationshipsListViewController.h"
#import "../../../Core/Domain/Models/MRRDemoCategory.h"
#import "../../../Core/Domain/UseCases/LoadDemoListUseCase.h"
#import "../../../Core/Presentation/Factories/DemoScreenFactory.h"
#import "../../../Core/Presentation/Presenters/DemoListPresenter.h"

@implementation RelationshipsListViewController

- (instancetype)initWithListUseCase:(LoadDemoListUseCase *)listUseCase
                      screenFactory:(DemoScreenFactory *)screenFactory {
    DemoListPresenter *presenter = [[[DemoListPresenter alloc] initWithUseCase:listUseCase
                                                            categoryIdentifier:MRRDemoCategoryIdentifierRelationships] autorelease];
    return [super initWithPresenter:presenter screenFactory:screenFactory];
}

@end
