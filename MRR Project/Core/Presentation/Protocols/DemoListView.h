#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MRRDemoCategory;
@class MRRDemoSummary;

@protocol DemoListView <NSObject>

- (void)displayCategory:(MRRDemoCategory *)category demos:(NSArray<MRRDemoSummary *> *)demos;
- (void)displayListErrorMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
