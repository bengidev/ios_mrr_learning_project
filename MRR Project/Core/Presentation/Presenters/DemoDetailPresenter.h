#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LoadDemoDetailUseCase;
@protocol DemoDetailView;

@interface DemoDetailPresenter : NSObject

- (instancetype)initWithUseCase:(LoadDemoDetailUseCase *)useCase
                 demoIdentifier:(NSString *)demoIdentifier NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (void)attachView:(id<DemoDetailView>)view;
- (void)viewDidLoad;

@end

NS_ASSUME_NONNULL_END
