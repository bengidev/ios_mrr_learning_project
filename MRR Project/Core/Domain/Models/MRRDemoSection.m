#import "MRRDemoSection.h"

@implementation MRRDemoSection

- (instancetype)initWithTitle:(NSString *)title
                     bodyText:(NSString *)bodyText
               checklistItems:(NSArray<NSString *> *)checklistItems {
    NSParameterAssert(title != nil);
    NSParameterAssert(bodyText != nil);
    NSParameterAssert(checklistItems != nil);

    self = [super init];
    if (self) {
        _title = [title copy];
        _bodyText = [bodyText copy];
        _checklistItems = [checklistItems copy];
    }

    return self;
}

- (void)dealloc {
    [_title release];
    [_bodyText release];
    [_checklistItems release];
    [super dealloc];
}

@end
