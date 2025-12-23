//
//  DeepLinkRoute.m
//  MVVM-C-MRR
//
//  DeepLinkRoute Model Implementation
//  MRR (Manual Retain-Release) Version
//
//  IMPORTANT: Compile with -fno-objc-arc flag
//

#import "DeepLinkRoute.h"

@implementation DeepLinkRoute

@synthesize type = _type;
@synthesize productId = _productId;
@synthesize userId = _userId;
@synthesize childRoute = _childRoute;
@synthesize queryParams = _queryParams;

#pragma mark - Memory Management

- (void)dealloc {
  [_productId release];
  [_userId release];
  [_childRoute release];
  [_queryParams release];
  [super dealloc];
}

#pragma mark - Property Setters (Manual Memory Management)

- (void)setProductId:(NSString *)productId {
  if (_productId != productId) {
    [_productId release];
    _productId = [productId copy];
  }
}

- (void)setUserId:(NSString *)userId {
  if (_userId != userId) {
    [_userId release];
    _userId = [userId copy];
  }
}

- (void)setChildRoute:(DeepLinkRoute *)childRoute {
  if (_childRoute != childRoute) {
    [_childRoute release];
    _childRoute = [childRoute retain];
  }
}

- (void)setQueryParams:(NSDictionary *)queryParams {
  if (_queryParams != queryParams) {
    [_queryParams release];
    _queryParams = [queryParams copy];
  }
}

#pragma mark - Factory Methods

+ (id)routeFromURL:(NSURL *)url {
  if (!url || !url.host) {
    return nil;
  }

  // Parse path components
  NSArray *pathComponents = url.pathComponents;
  NSMutableArray *components = [NSMutableArray array];

  // Add host as first component
  [components addObject:url.host];

  // Add path components, filtering out "/"
  for (NSString *component in pathComponents) {
    if (![component isEqualToString:@"/"]) {
      [components addObject:component];
    }
  }

  // Parse query parameters
  NSMutableDictionary *queryParams = [NSMutableDictionary dictionary];
  NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url
                                              resolvingAgainstBaseURL:NO];
  for (NSURLQueryItem *item in urlComponents.queryItems) {
    if (item.value) {
      [queryParams setObject:item.value forKey:item.name];
    }
  }

  // Build route chain from components
  return [self buildRouteChainFromComponents:components
                                 queryParams:queryParams];
}

+ (id)buildRouteChainFromComponents:(NSArray *)components
                        queryParams:(NSDictionary *)queryParams {
  if (components.count == 0) {
    return nil;
  }

  DeepLinkRoute *rootRoute = nil;
  DeepLinkRoute *currentRoute = nil;
  NSString *pendingProductId = nil;

  for (NSInteger i = 0; i < components.count; i++) {
    NSString *component = [components objectAtIndex:i];
    DeepLinkRoute *route = [[[DeepLinkRoute alloc] init] autorelease];
    route.queryParams = queryParams;

    // Determine route type based on component
    if ([component isEqualToString:@"home"]) {
      route.type = DeepLinkRouteTypeHome;
    } else if ([component isEqualToString:@"products"]) {
      route.type = DeepLinkRouteTypeProductList;
    } else if ([component isEqualToString:@"reviews"]) {
      route.type = DeepLinkRouteTypeProductReviews;
      route.productId = pendingProductId;
    } else if ([component isEqualToString:@"profile"]) {
      route.type = DeepLinkRouteTypeUserProfile;
    } else if ([component isEqualToString:@"settings"]) {
      route.type = DeepLinkRouteTypeSettings;
    } else if ([component isEqualToString:@"cart"]) {
      route.type = DeepLinkRouteTypeCart;
    } else if ([self isNumericString:component]) {
      // This is likely an ID
      if (currentRoute.type == DeepLinkRouteTypeProductList) {
        route.type = DeepLinkRouteTypeProductDetail;
        route.productId = component;
        pendingProductId = component;
      } else if (currentRoute.type == DeepLinkRouteTypeUserProfile) {
        currentRoute.userId = component;
        continue; // Don't create a new route
      } else {
        continue; // Unknown context for ID
      }
    } else {
      continue; // Unknown component, skip
    }

    // Chain routes together
    if (!rootRoute) {
      rootRoute = route;
    } else {
      currentRoute.childRoute = route;
    }
    currentRoute = route;
  }

  return [[rootRoute retain] autorelease];
}

+ (BOOL)isNumericString:(NSString *)string {
  NSCharacterSet *nonDigits =
      [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
  return string.length > 0 &&
         [string rangeOfCharacterFromSet:nonDigits].location == NSNotFound;
}

+ (id)routeWithType:(DeepLinkRouteType)type {
  DeepLinkRoute *route = [[[DeepLinkRoute alloc] init] autorelease];
  route.type = type;
  return route;
}

+ (id)productDetailRouteWithId:(NSString *)productId {
  DeepLinkRoute *route = [[[DeepLinkRoute alloc] init] autorelease];
  route.type = DeepLinkRouteTypeProductDetail;
  route.productId = productId;
  return route;
}

#pragma mark - Utility Methods

- (NSString *)routeTypeString {
  switch (self.type) {
  case DeepLinkRouteTypeNone:
    return @"None";
  case DeepLinkRouteTypeHome:
    return @"Home";
  case DeepLinkRouteTypeProductList:
    return @"ProductList";
  case DeepLinkRouteTypeProductDetail:
    return @"ProductDetail";
  case DeepLinkRouteTypeProductReviews:
    return @"ProductReviews";
  case DeepLinkRouteTypeUserProfile:
    return @"UserProfile";
  case DeepLinkRouteTypeSettings:
    return @"Settings";
  case DeepLinkRouteTypeCart:
    return @"Cart";
  }
  return @"Unknown";
}

- (BOOL)hasChildRoute {
  return self.childRoute != nil;
}

- (DeepLinkRoute *)deepestRoute {
  DeepLinkRoute *route = self;
  while (route.childRoute) {
    route = route.childRoute;
  }
  return route;
}

- (NSString *)description {
  NSMutableString *desc = [NSMutableString
      stringWithFormat:@"<%@: %@", NSStringFromClass([self class]),
                       [self routeTypeString]];
  if (self.productId) {
    [desc appendFormat:@", productId=%@", self.productId];
  }
  if (self.userId) {
    [desc appendFormat:@", userId=%@", self.userId];
  }
  if (self.childRoute) {
    [desc appendFormat:@" -> %@", self.childRoute];
  }
  [desc appendString:@">"];
  return desc;
}

@end
