#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MRRDemoDetail;

@protocol DemoDetailView <NSObject>

- (void)displayDemoDetail:(MRRDemoDetail *)detail;
- (void)displayDetailErrorMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
