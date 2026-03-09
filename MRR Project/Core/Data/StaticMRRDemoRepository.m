#import "StaticMRRDemoRepository.h"
#import "../Domain/Models/MRRDemoCategory.h"
#import "../Domain/Models/MRRDemoDetail.h"
#import "../Domain/Models/MRRDemoSection.h"
#import "../Domain/Models/MRRDemoSummary.h"

@interface StaticMRRDemoRepository ()

@property (nonatomic, retain) NSArray<MRRDemoCategory *> *categories;
@property (nonatomic, retain) NSDictionary<NSString *, NSArray<MRRDemoSummary *> *> *summariesByCategoryIdentifier;
@property (nonatomic, retain) NSDictionary<NSString *, MRRDemoDetail *> *detailsByIdentifier;

@end

@implementation StaticMRRDemoRepository

- (instancetype)init {
    self = [super init];
    if (self) {
        self.categories = [self buildCategories];
        self.summariesByCategoryIdentifier = [self buildSummaries];
        self.detailsByIdentifier = [self buildDetails];
    }

    return self;
}

- (void)dealloc {
    [_categories release];
    [_summariesByCategoryIdentifier release];
    [_detailsByIdentifier release];
    [super dealloc];
}

- (NSArray<MRRDemoCategory *> *)fetchCategories {
    return _categories;
}

- (NSArray<MRRDemoSummary *> *)fetchDemoSummariesForCategoryIdentifier:(NSString *)categoryIdentifier {
    NSArray<MRRDemoSummary *> *summaries = [_summariesByCategoryIdentifier objectForKey:categoryIdentifier];
    return summaries != nil ? summaries : [NSArray array];
}

- (MRRDemoDetail *)fetchDemoDetailForIdentifier:(NSString *)demoIdentifier {
    return [_detailsByIdentifier objectForKey:demoIdentifier];
}

- (NSArray<MRRDemoCategory *> *)buildCategories {
    MRRDemoCategory *basics = [[[MRRDemoCategory alloc] initWithIdentifier:MRRDemoCategoryIdentifierBasics
                                                                     title:@"Basics"
                                                               summaryText:@"Ownership rules, retain/release balance, and property semantics."] autorelease];
    MRRDemoCategory *relationships = [[[MRRDemoCategory alloc] initWithIdentifier:MRRDemoCategoryIdentifierRelationships
                                                                             title:@"Relationships"
                                                                       summaryText:@"Delegate references, parent-child ownership, and collection behavior."] autorelease];
    MRRDemoCategory *lifecycle = [[[MRRDemoCategory alloc] initWithIdentifier:MRRDemoCategoryIdentifierLifecycle
                                                                         title:@"Lifecycle"
                                                                   summaryText:@"dealloc sequencing, observer cleanup, and timer invalidation."] autorelease];

    return [NSArray arrayWithObjects:basics, relationships, lifecycle, nil];
}

- (NSDictionary<NSString *, NSArray<MRRDemoSummary *> *> *)buildSummaries {
    NSArray<MRRDemoSummary *> *basics = [NSArray arrayWithObjects:
                                         [[[MRRDemoSummary alloc] initWithDemoIdentifier:@"basics.retain-release"
                                                                                  title:@"Retain / Release Balance"
                                                                            summaryText:@"Track ownership changes created by alloc, retain, and autorelease."] autorelease],
                                         [[[MRRDemoSummary alloc] initWithDemoIdentifier:@"basics.autorelease-pool"
                                                                                  title:@"Autorelease Pools"
                                                                            summaryText:@"Use autorelease for handoff and keep explicit pools scoped."] autorelease],
                                         [[[MRRDemoSummary alloc] initWithDemoIdentifier:@"basics.property-semantics"
                                                                                  title:@"Property Semantics"
                                                                            summaryText:@"Choose retain, assign, or copy based on ownership guarantees."] autorelease],
                                         nil];

    NSArray<MRRDemoSummary *> *relationships = [NSArray arrayWithObjects:
                                                [[[MRRDemoSummary alloc] initWithDemoIdentifier:@"relationships.delegate-ownership"
                                                                                         title:@"Delegate Ownership"
                                                                                   summaryText:@"Delegates must stay non-owning to avoid retain cycles."] autorelease],
                                                [[[MRRDemoSummary alloc] initWithDemoIdentifier:@"relationships.parent-child"
                                                                                         title:@"Parent / Child Flow"
                                                                                   summaryText:@"Parents own children; children point back with assign references."] autorelease],
                                                [[[MRRDemoSummary alloc] initWithDemoIdentifier:@"relationships.collection-behavior"
                                                                                         title:@"Collection Semantics"
                                                                                   summaryText:@"Collections retain inserted objects, so call sites must release correctly."] autorelease],
                                                nil];

    NSArray<MRRDemoSummary *> *lifecycle = [NSArray arrayWithObjects:
                                            [[[MRRDemoSummary alloc] initWithDemoIdentifier:@"lifecycle.dealloc-order"
                                                                                     title:@"dealloc Order"
                                                                               summaryText:@"Release retained ivars first and call [super dealloc] last."] autorelease],
                                            [[[MRRDemoSummary alloc] initWithDemoIdentifier:@"lifecycle.observer-cleanup"
                                                                                     title:@"Observer Cleanup"
                                                                               summaryText:@"Remove observers before objects disappear to avoid dangling callbacks."] autorelease],
                                            [[[MRRDemoSummary alloc] initWithDemoIdentifier:@"lifecycle.timer-cleanup"
                                                                                     title:@"Timer Cleanup"
                                                                               summaryText:@"Invalidate timers before teardown so they stop messaging released targets."] autorelease],
                                            nil];

    return [NSDictionary dictionaryWithObjectsAndKeys:
            basics, MRRDemoCategoryIdentifierBasics,
            relationships, MRRDemoCategoryIdentifierRelationships,
            lifecycle, MRRDemoCategoryIdentifierLifecycle,
            nil];
}

- (NSDictionary<NSString *, MRRDemoDetail *> *)buildDetails {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [self detailForRetainRelease], @"basics.retain-release",
            [self detailForAutoreleasePool], @"basics.autorelease-pool",
            [self detailForPropertySemantics], @"basics.property-semantics",
            [self detailForDelegateOwnership], @"relationships.delegate-ownership",
            [self detailForParentChild], @"relationships.parent-child",
            [self detailForCollectionBehavior], @"relationships.collection-behavior",
            [self detailForDeallocOrder], @"lifecycle.dealloc-order",
            [self detailForObserverCleanup], @"lifecycle.observer-cleanup",
            [self detailForTimerCleanup], @"lifecycle.timer-cleanup",
            nil];
}

- (MRRDemoDetail *)detailWithIdentifier:(NSString *)identifier
                                  title:(NSString *)title
                               subtitle:(NSString *)subtitle
                               sections:(NSArray<MRRDemoSection *> *)sections {
    return [[[MRRDemoDetail alloc] initWithDemoIdentifier:identifier
                                                    title:title
                                             subtitleText:subtitle
                                                 sections:sections] autorelease];
}

- (MRRDemoSection *)sectionWithTitle:(NSString *)title
                            bodyText:(NSString *)bodyText
                      checklistItems:(NSArray<NSString *> *)checklistItems {
    return [[[MRRDemoSection alloc] initWithTitle:title bodyText:bodyText checklistItems:checklistItems] autorelease];
}

- (MRRDemoDetail *)detailForRetainRelease {
    NSArray *sections = [NSArray arrayWithObjects:
                         [self sectionWithTitle:@"Rule"
                                       bodyText:@"Anything created with alloc, new, copy, or mutableCopy gives you ownership. Balance that ownership before the current scope is finished."
                                 checklistItems:[NSArray arrayWithObjects:@"Retain only when you need to extend lifetime.", @"Release every owned object exactly once.", @"Do not release objects you never owned.", nil]],
                         [self sectionWithTitle:@"Review Prompt"
                                       bodyText:@"When reading a method, highlight each ownership gain and verify where the matching release happens."
                                 checklistItems:[NSArray arrayWithObjects:@"Look for retained properties assigned from +1 objects.", @"Check early returns for leaked ownership.", nil]],
                         nil];
    return [self detailWithIdentifier:@"basics.retain-release"
                                title:@"Retain / Release Balance"
                             subtitle:@"The foundation of MRR is explicit ownership accounting."
                             sections:sections];
}

- (MRRDemoDetail *)detailForAutoreleasePool {
    NSArray *sections = [NSArray arrayWithObjects:
                         [self sectionWithTitle:@"Rule"
                                       bodyText:@"Autorelease lets a method hand back an object without forcing the caller to release it immediately. Pools drain later, so do not abuse them in tight loops."
                                 checklistItems:[NSArray arrayWithObjects:@"Return autoreleased objects from convenience methods.", @"Create local pools for heavy temporary work.", @"Prefer explicit release when no delayed lifetime is needed.", nil]],
                         [self sectionWithTitle:@"Review Prompt"
                                       bodyText:@"Spot code that creates many temporaries. If they rely on a distant pool drain, memory spikes will follow."
                                 checklistItems:[NSArray arrayWithObjects:@"Audit loops that build temporary strings or arrays.", @"Ensure any explicit pool is drained on every path.", nil]],
                         nil];
    return [self detailWithIdentifier:@"basics.autorelease-pool"
                                title:@"Autorelease Pools"
                             subtitle:@"Autorelease is a delayed release, not free memory management."
                             sections:sections];
}

- (MRRDemoDetail *)detailForPropertySemantics {
    NSArray *sections = [NSArray arrayWithObjects:
                         [self sectionWithTitle:@"Rule"
                                       bodyText:@"retain owns an object reference, copy owns an immutable snapshot, and assign is for primitives or non-owning back references."
                                 checklistItems:[NSArray arrayWithObjects:@"Use copy for NSString and blocks when mutation would be unsafe.", @"Use assign for delegates under MRR.", @"Release every retained or copied ivar in dealloc.", nil]],
                         [self sectionWithTitle:@"Review Prompt"
                                       bodyText:@"The property attribute should match the semantic promise the object makes to the rest of the app."
                                 checklistItems:[NSArray arrayWithObjects:@"Check that mutable input is copied when required.", @"Check that delegates are not retained.", nil]],
                         nil];
    return [self detailWithIdentifier:@"basics.property-semantics"
                                title:@"Property Semantics"
                             subtitle:@"Property attributes document and enforce ownership policy."
                             sections:sections];
}

- (MRRDemoDetail *)detailForDelegateOwnership {
    NSArray *sections = [NSArray arrayWithObjects:
                         [self sectionWithTitle:@"Rule"
                                       bodyText:@"A delegate should not own the object that delegates to it. Under MRR, that means assign instead of retain."
                                 checklistItems:[NSArray arrayWithObjects:@"Delegate properties stay assign.", @"Clear delegate references when either side tears down.", @"Never create a retain cycle between controller and service.", nil]],
                         [self sectionWithTitle:@"Review Prompt"
                                       bodyText:@"Follow both directions of the relationship. If each side retains the other, neither will deallocate."
                                 checklistItems:[NSArray arrayWithObjects:@"Inspect service-to-controller references.", @"Inspect parent-child callback references.", nil]],
                         nil];
    return [self detailWithIdentifier:@"relationships.delegate-ownership"
                                title:@"Delegate Ownership"
                             subtitle:@"Delegation should move messages, not ownership."
                             sections:sections];
}

- (MRRDemoDetail *)detailForParentChild {
    NSArray *sections = [NSArray arrayWithObjects:
                         [self sectionWithTitle:@"Rule"
                                       bodyText:@"The parent flow owns child objects that are active. Children point back with assign references only long enough to signal completion."
                                 checklistItems:[NSArray arrayWithObjects:@"Parent retains active children.", @"Child-to-parent references stay assign.", @"Remove finished children from retained collections.", nil]],
                         [self sectionWithTitle:@"Review Prompt"
                                       bodyText:@"This is the same ownership rule you would apply to nested controllers, services, or routers without needing a coordinator abstraction."
                                 checklistItems:[NSArray arrayWithObjects:@"Audit collections that hold children.", @"Check finish paths for remove-and-release behavior.", nil]],
                         nil];
    return [self detailWithIdentifier:@"relationships.parent-child"
                                title:@"Parent / Child Ownership"
                             subtitle:@"Ownership should flow in one direction through a hierarchy."
                             sections:sections];
}

- (MRRDemoDetail *)detailForCollectionBehavior {
    NSArray *sections = [NSArray arrayWithObjects:
                         [self sectionWithTitle:@"Rule"
                                       bodyText:@"Foundation collections retain inserted objects. After adding an owned object to a collection, the caller can usually release its own ownership."
                                 checklistItems:[NSArray arrayWithObjects:@"Release owned objects after inserting into retaining collections.", @"Copy collections only when isolation is required.", @"Audit removal paths for stale references.", nil]],
                         [self sectionWithTitle:@"Review Prompt"
                                       bodyText:@"Collection APIs often hide retains, so missing one release at the call site is a common source of leaks."
                                 checklistItems:[NSArray arrayWithObjects:@"Check init/addObject/release sequences.", @"Check copied collections for missing release calls.", nil]],
                         nil];
    return [self detailWithIdentifier:@"relationships.collection-behavior"
                                title:@"Collection Semantics"
                             subtitle:@"Collections participate in ownership whether or not your API spells it out."
                             sections:sections];
}

- (MRRDemoDetail *)detailForDeallocOrder {
    NSArray *sections = [NSArray arrayWithObjects:
                         [self sectionWithTitle:@"Rule"
                                       bodyText:@"Release retained ivars first, then call [super dealloc] last. There is no cleanup opportunity after super dealloc runs."
                                 checklistItems:[NSArray arrayWithObjects:@"Release every retained or copied ivar.", @"Do not send messages to self after [super dealloc].", @"Avoid setting ivars to nil unless it clarifies a live teardown path.", nil]],
                         [self sectionWithTitle:@"Review Prompt"
                                       bodyText:@"A clean dealloc method is short, explicit, and mirrors the ownership in the class interface."
                                 checklistItems:[NSArray arrayWithObjects:@"Compare retained properties to dealloc releases.", @"Check for superclass call ordering.", nil]],
                         nil];
    return [self detailWithIdentifier:@"lifecycle.dealloc-order"
                                title:@"dealloc Order"
                             subtitle:@"dealloc is the final ownership checkpoint in an MRR object."
                             sections:sections];
}

- (MRRDemoDetail *)detailForObserverCleanup {
    NSArray *sections = [NSArray arrayWithObjects:
                         [self sectionWithTitle:@"Rule"
                                       bodyText:@"Observers must be removed before an observed object or observer disappears, otherwise callbacks can target released memory."
                                 checklistItems:[NSArray arrayWithObjects:@"Unregister in dealloc or an earlier stop method.", @"Mirror every addObserver with a removeObserver.", @"Keep observer registration close to cleanup logic.", nil]],
                         [self sectionWithTitle:@"Review Prompt"
                                       bodyText:@"Notification and KVO cleanup often fail when registration is hidden in one method and teardown is forgotten elsewhere."
                                 checklistItems:[NSArray arrayWithObjects:@"Search for addObserver calls and match them.", @"Verify teardown runs on every lifecycle path.", nil]],
                         nil];
    return [self detailWithIdentifier:@"lifecycle.observer-cleanup"
                                title:@"Observer Cleanup"
                             subtitle:@"Temporary observation requires symmetrical cleanup."
                             sections:sections];
}

- (MRRDemoDetail *)detailForTimerCleanup {
    NSArray *sections = [NSArray arrayWithObjects:
                         [self sectionWithTitle:@"Rule"
                                       bodyText:@"NSTimer retains its target through the run loop. Invalidate the timer before the target is released."
                                 checklistItems:[NSArray arrayWithObjects:@"Invalidate timers in stop/dealloc paths.", @"Nil out timer ivars after invalidation when the object remains alive.", @"Avoid timers that outlive the owning controller or service.", nil]],
                         [self sectionWithTitle:@"Review Prompt"
                                       bodyText:@"Run-loop driven objects are easy to forget because no direct owner is visible at the call site."
                                 checklistItems:[NSArray arrayWithObjects:@"Check repeating timers first.", @"Check whether teardown runs before view controller disappearance.", nil]],
                         nil];
    return [self detailWithIdentifier:@"lifecycle.timer-cleanup"
                                title:@"Timer Cleanup"
                             subtitle:@"Time-based callbacks can outlive their UI unless invalidated explicitly."
                             sections:sections];
}

@end
