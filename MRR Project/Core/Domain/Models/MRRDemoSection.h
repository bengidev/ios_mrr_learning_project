#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MRRDemoSection : NSObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *bodyText;
@property (nonatomic, copy, readonly) NSArray<NSString *> *checklistItems;

- (instancetype)initWithTitle:(NSString *)title
                     bodyText:(NSString *)bodyText
               checklistItems:(NSArray<NSString *> *)checklistItems NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
