//
//  URLRouter.m
//  MVVM-C-MRR
//
//  URLRouter Implementation
//  MRR (Manual Retain-Release) Version
//
//  IMPORTANT: Compile with -fno-objc-arc flag
//

#import "URLRouter.h"
#import "Coordinator.h"
#import "DeepLinkRoute.h"
#import "DeepLinkable.h"

@implementation URLRouter

@synthesize rootCoordinator = _rootCoordinator;
@synthesize urlScheme = _urlScheme;
@synthesize universalLinkDomains = _universalLinkDomains;

#pragma mark - Singleton

+ (instancetype)sharedRouter {
  static URLRouter *sharedInstance = nil;
  if (sharedInstance == nil) {
    sharedInstance = [[URLRouter alloc] init];
  }
  return sharedInstance;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _registeredSchemes = [[NSMutableArray alloc] init];
    _universalLinkDomains = [[NSArray alloc] init];
    _urlScheme = [@"myapp" copy];
    [_registeredSchemes addObject:_urlScheme];
  }
  return self;
}

- (void)dealloc {
  [_registeredSchemes release];
  [_universalLinkDomains release];
  [_urlScheme release];
  // Do NOT release _rootCoordinator (assign property)
  [super dealloc];
}

#pragma mark - Property Setters

- (void)setUrlScheme:(NSString *)urlScheme {
  if (_urlScheme != urlScheme) {
    [_urlScheme release];
    _urlScheme = [urlScheme copy];
  }
}

- (void)setUniversalLinkDomains:(NSArray *)universalLinkDomains {
  if (_universalLinkDomains != universalLinkDomains) {
    [_universalLinkDomains release];
    _universalLinkDomains = [universalLinkDomains copy];
  }
}

#pragma mark - URL Handling

- (DeepLinkRoute *)parseURL:(NSURL *)url {
  if (![self canHandleURL:url]) {
    NSLog(@"[URLRouter] Cannot handle URL: %@", url);
    return nil;
  }

  DeepLinkRoute *route = [DeepLinkRoute routeFromURL:url];

  if (route) {
    NSLog(@"[URLRouter] Parsed URL: %@ -> %@", url, route);
  } else {
    NSLog(@"[URLRouter] Failed to parse URL: %@", url);
  }

  return route;
}

- (BOOL)handleURL:(NSURL *)url {
  DeepLinkRoute *route = [self parseURL:url];

  if (!route) {
    return NO;
  }

  if (!self.rootCoordinator) {
    NSLog(@"[URLRouter] No root coordinator set");
    return NO;
  }

  if ([self.rootCoordinator conformsToProtocol:@protocol(DeepLinkable)]) {
    id<DeepLinkable> deepLinkable = (id<DeepLinkable>)self.rootCoordinator;

    if ([deepLinkable canHandleRoute:route]) {
      [deepLinkable handleRoute:route];
      return YES;
    }
  }

  NSLog(@"[URLRouter] Root coordinator cannot handle route: %@", route);
  return NO;
}

#pragma mark - URL Scheme Registration

- (void)registerURLSchemes:(NSArray *)schemes {
  for (NSString *scheme in schemes) {
    if (![_registeredSchemes containsObject:scheme]) {
      [_registeredSchemes addObject:scheme];
    }
  }
}

- (BOOL)canHandleURL:(NSURL *)url {
  if (!url) {
    return NO;
  }

  // Check custom URL schemes
  NSString *scheme = [url.scheme lowercaseString];
  for (NSString *registeredScheme in _registeredSchemes) {
    if ([scheme isEqualToString:[registeredScheme lowercaseString]]) {
      return YES;
    }
  }

  // Check universal link domains
  NSString *host = [url.host lowercaseString];
  for (NSString *domain in _universalLinkDomains) {
    NSString *lowerDomain = [domain lowercaseString];
    if ([host isEqualToString:lowerDomain] ||
        [host hasSuffix:[NSString stringWithFormat:@".%@", lowerDomain]]) {
      return YES;
    }
  }

  return NO;
}

- (void)registerUniversalLinkDomains:(NSArray *)domains {
  self.universalLinkDomains = domains;
}

@end
