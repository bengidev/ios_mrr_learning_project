#import <UIKit/UIKit.h>

#import "../../../../Layout/MRRLayoutScaling.h"

NS_ASSUME_NONNULL_BEGIN

@class OnboardingRecipe;
@class OnboardingRecipeDetailViewController;

@protocol OnboardingRecipeDetailViewControllerDelegate <NSObject>

- (void)recipeDetailViewControllerDidClose:(OnboardingRecipeDetailViewController *)viewController;
- (void)recipeDetailViewControllerDidStartCooking:(OnboardingRecipeDetailViewController *)viewController;

@end

@interface OnboardingRecipeDetailViewController : UIViewController

@property(nonatomic, assign, nullable) id<OnboardingRecipeDetailViewControllerDelegate> delegate;
@property(nonatomic, retain, readonly) OnboardingRecipe *recipe;

- (instancetype)initWithRecipe:(OnboardingRecipe *)recipe;
- (instancetype)initWithRecipe:(OnboardingRecipe *)recipe layoutScalingMode:(MRRLayoutScalingMode)layoutScalingMode;

@end

NS_ASSUME_NONNULL_END
