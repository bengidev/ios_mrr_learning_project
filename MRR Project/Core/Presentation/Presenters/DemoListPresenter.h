#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LoadDemoListUseCase;
@protocol DemoListView;

@interface DemoListPresenter : NSObject

- (instancetype)initWithUseCase:(LoadDemoListUseCase *)useCase
             categoryIdentifier:(NSString *)categoryIdentifier NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (void)attachView:(id<DemoListView>)view;
- (void)viewDidLoad;

@end

NS_ASSUME_NONNULL_END
