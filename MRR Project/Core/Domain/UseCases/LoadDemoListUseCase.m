#import "LoadDemoListUseCase.h"
#import "../Repositories/MRRDemoRepository.h"

@interface LoadDemoListUseCase ()

@property (nonatomic, retain) id<MRRDemoRepository> repository;

@end

@implementation LoadDemoListUseCase

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

- (NSArray *)loadCategories {
    return [_repository fetchCategories];
}

- (NSArray *)loadDemoSummariesForCategoryIdentifier:(NSString *)categoryIdentifier {
    return [_repository fetchDemoSummariesForCategoryIdentifier:categoryIdentifier];
}

@end
