#import "../../../Core/Presentation/ViewControllers/DemoListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class LoadDemoListUseCase;
@class DemoScreenFactory;

@interface BasicsListViewController : DemoListViewController

- (instancetype)initWithListUseCase:(LoadDemoListUseCase *)listUseCase
                      screenFactory:(DemoScreenFactory *)screenFactory;

@end

NS_ASSUME_NONNULL_END
