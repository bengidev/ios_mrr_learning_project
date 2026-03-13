#import <UIKit/UIKit.h>

#import "../../../../Layout/MRRLayoutScaling.h"

NS_ASSUME_NONNULL_BEGIN

@class OnboardingStateController;
@class OnboardingViewController;

@protocol OnboardingViewControllerDelegate <NSObject>

- (void)onboardingViewControllerDidFinish:(OnboardingViewController *)viewController;

@end

@interface OnboardingViewController : UIViewController

@property(nonatomic, assign, nullable) id<OnboardingViewControllerDelegate> delegate;

- (instancetype)initWithStateController:(OnboardingStateController *)stateController;
- (instancetype)initWithStateController:(OnboardingStateController *)stateController
                       layoutScalingMode:(MRRLayoutScalingMode)layoutScalingMode;

@end

NS_ASSUME_NONNULL_END
