#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MRRDemoSection;

@interface MRRDemoDetail : NSObject

@property (nonatomic, copy, readonly) NSString *demoIdentifier;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subtitleText;
@property (nonatomic, copy, readonly) NSArray<MRRDemoSection *> *sections;

- (instancetype)initWithDemoIdentifier:(NSString *)demoIdentifier
                                 title:(NSString *)title
                          subtitleText:(NSString *)subtitleText
                              sections:(NSArray<MRRDemoSection *> *)sections NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
