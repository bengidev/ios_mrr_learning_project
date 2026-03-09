#import "MRRDemoCategory.h"

NSString *const MRRDemoCategoryIdentifierBasics = @"basics";
NSString *const MRRDemoCategoryIdentifierRelationships = @"relationships";
NSString *const MRRDemoCategoryIdentifierLifecycle = @"lifecycle";

@implementation MRRDemoCategory

- (instancetype)initWithIdentifier:(NSString *)identifier
                             title:(NSString *)title
                       summaryText:(NSString *)summaryText {
    NSParameterAssert(identifier != nil);
    NSParameterAssert(title != nil);
    NSParameterAssert(summaryText != nil);

    self = [super init];
    if (self) {
        _identifier = [identifier copy];
        _title = [title copy];
        _summaryText = [summaryText copy];
    }

    return self;
}

- (void)dealloc {
    [_identifier release];
    [_title release];
    [_summaryText release];
    [super dealloc];
}

@end
