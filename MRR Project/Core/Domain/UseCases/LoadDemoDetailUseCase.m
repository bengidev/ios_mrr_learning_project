#import "LoadDemoDetailUseCase.h"
#import "../Repositories/MRRDemoRepository.h"

@interface LoadDemoDetailUseCase ()

@property (nonatomic, retain) id<MRRDemoRepository> repository;

@end

@implementation LoadDemoDetailUseCase

- (instancetype)initWithRepository:(id<MRRDemoRepository>)repository {
    NSParameterAssert(repository != nil);

    self = [super init];
    if (self) {
        _repository = [repository retain];
    }

    return self;
}

- (void)dealloc {
    [_repository release];
    [super dealloc];
}

- (MRRDemoDetail *)loadDemoDetailForIdentifier:(NSString *)demoIdentifier {
    return [_repository fetchDemoDetailForIdentifier:demoIdentifier];
}

@end
