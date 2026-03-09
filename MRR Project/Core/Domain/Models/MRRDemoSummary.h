#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MRRDemoSummary : NSObject

@property (nonatomic, copy, readonly) NSString *demoIdentifier;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *summaryText;

- (instancetype)initWithDemoIdentifier:(NSString *)demoIdentifier
                                 title:(NSString *)title
                           summaryText:(NSString *)summaryText NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
