#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MRRDemoCategory;
@class MRRDemoDetail;
@class MRRDemoSummary;

@protocol MRRDemoRepository <NSObject>

- (NSArray<MRRDemoCategory *> *)fetchCategories;
- (NSArray<MRRDemoSummary *> *)fetchDemoSummariesForCategoryIdentifier:(NSString *)categoryIdentifier;
- (nullable MRRDemoDetail *)fetchDemoDetailForIdentifier:(NSString *)demoIdentifier;

@end

NS_ASSUME_NONNULL_END
