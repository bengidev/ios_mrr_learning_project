#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LoadDemoDetailUseCase;

@interface DemoScreenFactory : NSObject

- (instancetype)initWithDetailUseCase:(LoadDemoDetailUseCase *)detailUseCase NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (UIViewController *)detailViewControllerForDemoIdentifier:(NSString *)demoIdentifier;

@end

NS_ASSUME_NONNULL_END
