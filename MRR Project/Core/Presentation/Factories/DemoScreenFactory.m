#import "DemoScreenFactory.h"
#import "../../Domain/UseCases/LoadDemoDetailUseCase.h"
#import "../Presenters/DemoDetailPresenter.h"
#import "../ViewControllers/DemoDetailViewController.h"

@interface DemoScreenFactory ()

@property (nonatomic, retain) LoadDemoDetailUseCase *detailUseCase;

@end

@implementation DemoScreenFactory

- (instancetype)initWithDetailUseCase:(LoadDemoDetailUseCase *)detailUseCase {
    NSParameterAssert(detailUseCase != nil);

    self = [super init];
    if (self) {
        _detailUseCase = [detailUseCase retain];
    }

    return self;
}

- (void)dealloc {
    [_detailUseCase release];
    [super dealloc];
}

- (UIViewController *)detailViewControllerForDemoIdentifier:(NSString *)demoIdentifier {
    DemoDetailPresenter *presenter = [[[DemoDetailPresenter alloc] initWithUseCase:self.detailUseCase
                                                                    demoIdentifier:demoIdentifier] autorelease];
    DemoDetailViewController *viewController = [[[DemoDetailViewController alloc] initWithPresenter:presenter] autorelease];
    return viewController;
}

@end
