#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MainMenuViewController;

@protocol MainMenuViewControllerDelegate <NSObject>

- (void)mainMenuViewController:(MainMenuViewController *)viewController didSelectTabIndex:(NSUInteger)tabIndex;

@end

@interface MainMenuViewController : UIViewController

@property (nonatomic, assign, nullable) id<MainMenuViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
