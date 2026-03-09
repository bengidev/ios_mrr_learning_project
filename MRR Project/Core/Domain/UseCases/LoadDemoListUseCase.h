#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MRRDemoCategory;
@class MRRDemoSummary;
@protocol MRRDemoRepository;

@interface LoadDemoListUseCase : NSObject

- (instancetype)initWithRepository:(id<MRRDemoRepository>)repository NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (NSArray<MRRDemoCategory *> *)loadCategories;
- (NSArray<MRRDemoSummary *> *)loadDemoSummariesForCategoryIdentifier:(NSString *)categoryIdentifier;

@end

NS_ASSUME_NONNULL_END
