#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DemoDetailPresenter;

@interface DemoDetailViewController : UIViewController

- (instancetype)initWithPresenter:(DemoDetailPresenter *)presenter;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
