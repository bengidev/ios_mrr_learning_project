//
//  AppDelegate.h
//  MRR Project
//
//  Created for MRR Learning
//

#import <UIKit/UIKit.h>

#import "../Layout/MRRLayoutScaling.h"

@class OnboardingStateController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(nonatomic, retain) UIWindow *window;

- (instancetype)initWithOnboardingStateController:(OnboardingStateController *)onboardingStateController;
- (instancetype)initWithOnboardingStateController:(OnboardingStateController *)onboardingStateController
                                layoutScalingMode:(MRRLayoutScalingMode)layoutScalingMode;
- (instancetype)initWithOnboardingStateController:(OnboardingStateController *)onboardingStateController
                                     userDefaults:(NSUserDefaults *)userDefaults
                                layoutScalingMode:(MRRLayoutScalingMode)layoutScalingMode;

@end
