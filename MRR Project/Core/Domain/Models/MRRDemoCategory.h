#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const MRRDemoCategoryIdentifierBasics;
extern NSString *const MRRDemoCategoryIdentifierRelationships;
extern NSString *const MRRDemoCategoryIdentifierLifecycle;

@interface MRRDemoCategory : NSObject

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *summaryText;

- (instancetype)initWithIdentifier:(NSString *)identifier
                             title:(NSString *)title
                       summaryText:(NSString *)summaryText NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
