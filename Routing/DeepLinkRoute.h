//
//  DeepLinkRoute.h
//  MVVM-C-MRR
//
//  DeepLinkRoute Model - Represents a parsed deep link destination
//  MRR (Manual Retain-Release) Version
//
//  IMPORTANT: Compile with -fno-objc-arc flag
//

#import <Foundation/Foundation.h>

/// Enum representing different route types in the app
typedef NS_ENUM(NSInteger, DeepLinkRouteType) {
  DeepLinkRouteTypeNone = 0,
  DeepLinkRouteTypeHome,
  DeepLinkRouteTypeProductList,
  DeepLinkRouteTypeProductDetail,
  DeepLinkRouteTypeProductReviews,
  DeepLinkRouteTypeUserProfile,
  DeepLinkRouteTypeSettings,
  DeepLinkRouteTypeCart
};

@interface DeepLinkRoute : NSObject {
  DeepLinkRouteType _type;
  NSString *_productId;
  NSString *_userId;
  DeepLinkRoute *_childRoute;
  NSDictionary *_queryParams;
}

/// The type of this route
@property(nonatomic, assign) DeepLinkRouteType type;

/// Product ID (for product-related routes) - use copy
@property(nonatomic, copy) NSString *productId;

/// User ID (for user-related routes) - use copy
@property(nonatomic, copy) NSString *userId;

/// Nested child route (for deep navigation paths) - use retain
@property(nonatomic, retain) DeepLinkRoute *childRoute;

/// Query parameters from the URL - use copy
@property(nonatomic, copy) NSDictionary *queryParams;

#pragma mark - Factory Methods

/// Creates a route from a URL
/// @param url The URL to parse (e.g., myapp://products/123/reviews)
/// @return An autoreleased DeepLinkRoute
+ (id)routeFromURL:(NSURL *)url;

/// Creates a route with a specific type
/// @return An autoreleased DeepLinkRoute
+ (id)routeWithType:(DeepLinkRouteType)type;

/// Creates a product detail route
/// @return An autoreleased DeepLinkRoute
+ (id)productDetailRouteWithId:(NSString *)productId;

#pragma mark - Utility Methods

/// Returns a string representation of the route type
- (NSString *)routeTypeString;

/// Returns YES if this route has a child route
- (BOOL)hasChildRoute;

/// Returns the deepest child route in the chain
- (DeepLinkRoute *)deepestRoute;

@end
