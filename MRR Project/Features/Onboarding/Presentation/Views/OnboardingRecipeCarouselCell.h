#import <UIKit/UIKit.h>

#import "../../../../Layout/MRRLayoutScaling.h"

NS_ASSUME_NONNULL_BEGIN

@class OnboardingRecipe;

@interface OnboardingRecipeCarouselCell : UICollectionViewCell

@property(nonatomic, assign) MRRLayoutScalingMode layoutScalingMode;

- (void)configureWithRecipe:(OnboardingRecipe *)recipe;

@end

NS_ASSUME_NONNULL_END
