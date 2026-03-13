#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MRRLayoutScalingMode) {
  MRRLayoutScalingModePureScreenScaling,
  MRRLayoutScalingModeGuardedFluidScaling,
};

typedef NS_ENUM(NSInteger, MRRLayoutScaleAxis) {
  MRRLayoutScaleAxisWidth,
  MRRLayoutScaleAxisHeight,
  MRRLayoutScaleAxisMinDimension,
};

FOUNDATION_EXTERN NSString *const MRRLayoutScalingModeLaunchArgument;
FOUNDATION_EXTERN NSString *const MRRLayoutScalingModeDefaultsKey;

FOUNDATION_EXTERN CGFloat MRRLayoutClampedFloat(CGFloat value, CGFloat minimumValue, CGFloat maximumValue);
FOUNDATION_EXTERN CGFloat MRRLayoutRoundedMetric(CGFloat value);
FOUNDATION_EXTERN CGFloat MRRLayoutInterpolatedMetricForValue(CGFloat value,
                                                              CGFloat inputMinimum,
                                                              CGFloat inputMaximum,
                                                              CGFloat outputMinimum,
                                                              CGFloat outputMaximum);
FOUNDATION_EXTERN CGFloat MRRLayoutScaleFactor(CGSize viewportSize, MRRLayoutScaleAxis axis, MRRLayoutScalingMode mode);
FOUNDATION_EXTERN CGFloat MRRLayoutScaledValue(CGFloat baseValue,
                                               CGSize viewportSize,
                                               MRRLayoutScaleAxis axis,
                                               MRRLayoutScalingMode mode);
FOUNDATION_EXTERN MRRLayoutScalingMode MRRLayoutScalingModeFromArguments(NSArray<NSString *> *arguments);
FOUNDATION_EXTERN NSString *MRRLayoutScalingModeDisplayName(MRRLayoutScalingMode mode);
FOUNDATION_EXTERN MRRLayoutScalingMode MRRStoredLayoutScalingMode(NSUserDefaults *userDefaults);
FOUNDATION_EXTERN void MRRStoreLayoutScalingMode(NSUserDefaults *userDefaults, MRRLayoutScalingMode mode);

NS_ASSUME_NONNULL_END
