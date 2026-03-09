#import "MRRDemoDetail.h"

@implementation MRRDemoDetail

- (instancetype)initWithDemoIdentifier:(NSString *)demoIdentifier
                                 title:(NSString *)title
                          subtitleText:(NSString *)subtitleText
                              sections:(NSArray *)sections {
    NSParameterAssert(demoIdentifier != nil);
    NSParameterAssert(title != nil);
    NSParameterAssert(subtitleText != nil);
    NSParameterAssert(sections != nil);

    self = [super init];
    if (self) {
        _demoIdentifier = [demoIdentifier copy];
        _title = [title copy];
        _subtitleText = [subtitleText copy];
        _sections = [sections copy];
    }

    return self;
}

- (void)dealloc {
    [_demoIdentifier release];
    [_title release];
    [_subtitleText release];
    [_sections release];
    [super dealloc];
}

@end
