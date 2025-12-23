//
//  URLRouter.h
//  MVVM-C-MRR
//
//  URLRouter - Singleton router for handling and parsing deep link URLs
//  MRR (Manual Retain-Release) Version
//
//  IMPORTANT: Compile with -fno-objc-arc flag
//

#import <Foundation/Foundation.h>

@class DeepLinkRoute;
@protocol Coordinator;

@interface URLRouter : NSObject {
  NSMutableArray *_registeredSchemes;
  NSArray *_universalLinkDomains;
  NSString *_urlScheme;
  id<Coordinator> _rootCoordinator; // assign, not retained
}

/// Shared singleton instance
+ (instancetype)sharedRouter;

/// The root coordinator that will handle routes (assign, not retained)
@property(nonatomic, assign) id<Coordinator> rootCoordinator;

/// The registered URL scheme for the app
@property(nonatomic, copy) NSString *urlScheme;

/// Universal link domains (copy)
@property(nonatomic, copy) NSArray *universalLinkDomains;

#pragma mark - URL Handling

/// Parses a URL and returns a DeepLinkRoute (autoreleased)
- (DeepLinkRoute *)parseURL:(NSURL *)url;

/// Handles an incoming URL
- (BOOL)handleURL:(NSURL *)url;

#pragma mark - URL Scheme Registration

/// Registers URL schemes
- (void)registerURLSchemes:(NSArray *)schemes;

/// Checks if a URL can be handled
- (BOOL)canHandleURL:(NSURL *)url;

/// Registers domains for universal links
- (void)registerUniversalLinkDomains:(NSArray *)domains;

@end
