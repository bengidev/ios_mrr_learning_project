#import "MRRLayoutScaling.h"

NSString *const MRRLayoutScalingModeLaunchArgument = @"-MRRLayoutScalingMode";
NSString *const MRRLayoutScalingModeDefaultsKey = @"mrr.layoutScalingMode";

static CGFloat const MRRLayoutBaseViewportWidth = 390.0;
static CGFloat const MRRLayoutBaseViewportHeight = 844.0;

CGFloat MRRLayoutClampedFloat(CGFloat value, CGFloat minimumValue, CGFloat maximumValue) {
  return MIN(MAX(value, minimumValue), maximumValue);
}

CGFloat MRRLayoutRoundedMetric(CGFloat value) {
  return round(value * 10.0) / 10.0;
}

static CGFloat MRRLayoutNormalizedProgress(CGFloat value, CGFloat minimumValue, CGFloat maximumValue) {
  if (maximumValue <= minimumValue) {
    return 0.0;
  }

  return MRRLayoutClampedFloat((value - minimumValue) / (maximumValue - minimumValue), 0.0, 1.0);
}

CGFloat MRRLayoutInterpolatedMetricForValue(CGFloat value,
                                            CGFloat inputMinimum,
                                            CGFloat inputMaximum,
                                            CGFloat outputMinimum,
                                            CGFloat outputMaximum) {
  CGFloat progress = MRRLayoutNormalizedProgress(value, inputMinimum, inputMaximum);
  return outputMinimum + ((outputMaximum - outputMinimum) * progress);
}

CGFloat MRRLayoutScaleFactor(CGSize viewportSize, MRRLayoutScaleAxis axis, MRRLayoutScalingMode mode) {
  CGFloat dimension = 1.0;
  CGFloat baseDimension = 1.0;

  switch (axis) {
    case MRRLayoutScaleAxisWidth:
      dimension = viewportSize.width;
      baseDimension = MRRLayoutBaseViewportWidth;
      break;
    case MRRLayoutScaleAxisHeight:
      dimension = viewportSize.height;
      baseDimension = MRRLayoutBaseViewportHeight;
      break;
    case MRRLayoutScaleAxisMinDimension:
      dimension = MIN(viewportSize.width, viewportSize.height);
      baseDimension = MIN(MRRLayoutBaseViewportWidth, MRRLayoutBaseViewportHeight);
      break;
  }

  if (dimension <= 0.0 || baseDimension <= 0.0) {
    return 1.0;
  }

  CGFloat rawFactor = dimension / baseDimension;
  if (mode == MRRLayoutScalingModePureScreenScaling) {
    return rawFactor;
  }

  switch (axis) {
    case MRRLayoutScaleAxisWidth:
      return MRRLayoutClampedFloat(rawFactor, 0.92, 1.08);
    case MRRLayoutScaleAxisHeight:
      return MRRLayoutClampedFloat(rawFactor, 0.90, 1.08);
    case MRRLayoutScaleAxisMinDimension:
      return MRRLayoutClampedFloat(rawFactor, 0.90, 1.08);
  }

  return 1.0;
}

CGFloat MRRLayoutScaledValue(CGFloat baseValue, CGSize viewportSize, MRRLayoutScaleAxis axis, MRRLayoutScalingMode mode) {
  return MRRLayoutRoundedMetric(baseValue * MRRLayoutScaleFactor(viewportSize, axis, mode));
}

MRRLayoutScalingMode MRRLayoutScalingModeFromArguments(NSArray<NSString *> *arguments) {
  NSUInteger modeArgumentIndex = [arguments indexOfObject:MRRLayoutScalingModeLaunchArgument];
  if (modeArgumentIndex == NSNotFound || (modeArgumentIndex + 1) >= arguments.count) {
    return MRRLayoutScalingModeGuardedFluidScaling;
  }

  NSString *modeValue = arguments[modeArgumentIndex + 1];
  if ([modeValue caseInsensitiveCompare:@"pure"] == NSOrderedSame) {
    return MRRLayoutScalingModePureScreenScaling;
  }

  return MRRLayoutScalingModeGuardedFluidScaling;
}

NSString *MRRLayoutScalingModeDisplayName(MRRLayoutScalingMode mode) {
  switch (mode) {
    case MRRLayoutScalingModePureScreenScaling:
      return @"Pure Screen Scaling";
    case MRRLayoutScalingModeGuardedFluidScaling:
      return @"Guarded Fluid Scaling";
  }

  return @"Guarded Fluid Scaling";
}

MRRLayoutScalingMode MRRStoredLayoutScalingMode(NSUserDefaults *userDefaults) {
  NSString *storedValue = [userDefaults stringForKey:MRRLayoutScalingModeDefaultsKey];
  if ([storedValue caseInsensitiveCompare:@"pure"] == NSOrderedSame) {
    return MRRLayoutScalingModePureScreenScaling;
  }

  return MRRLayoutScalingModeGuardedFluidScaling;
}

void MRRStoreLayoutScalingMode(NSUserDefaults *userDefaults, MRRLayoutScalingMode mode) {
  NSString *storedValue = mode == MRRLayoutScalingModePureScreenScaling ? @"pure" : @"guarded";
  [userDefaults setObject:storedValue forKey:MRRLayoutScalingModeDefaultsKey];
  [userDefaults synchronize];
}
