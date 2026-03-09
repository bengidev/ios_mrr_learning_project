#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DemoListPresenter;
@class DemoScreenFactory;

@interface DemoListViewController : UIViewController

- (instancetype)initWithPresenter:(DemoListPresenter *)presenter
                    screenFactory:(DemoScreenFactory *)screenFactory;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

- (void)selectDemoAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
