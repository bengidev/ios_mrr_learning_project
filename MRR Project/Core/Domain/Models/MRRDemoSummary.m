#import "MRRDemoSummary.h"

@implementation MRRDemoSummary

- (instancetype)initWithDemoIdentifier:(NSString *)demoIdentifier
                                 title:(NSString *)title
                           summaryText:(NSString *)summaryText {
    NSParameterAssert(demoIdentifier != nil);
    NSParameterAssert(title != nil);
    NSParameterAssert(summaryText != nil);

    self = [super init];
    if (self) {
        _demoIdentifier = [demoIdentifier copy];
        _title = [title copy];
        _summaryText = [summaryText copy];
    }

    return self;
}

- (void)dealloc {
    [_demoIdentifier release];
    [_title release];
    [_summaryText release];
    [super dealloc];
}

@end
