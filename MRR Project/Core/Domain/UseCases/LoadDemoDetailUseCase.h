#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MRRDemoDetail;
@protocol MRRDemoRepository;

@interface LoadDemoDetailUseCase : NSObject

- (instancetype)initWithRepository:(id<MRRDemoRepository>)repository NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (nullable MRRDemoDetail *)loadDemoDetailForIdentifier:(NSString *)demoIdentifier;

@end

NS_ASSUME_NONNULL_END
