//
//  Product.h
//  MVVM-C-MRR
//
//  Product Model
//  MRR (Manual Retain-Release) Version
//
//  IMPORTANT: Compile with -fno-objc-arc flag
//

#import <Foundation/Foundation.h>

@interface Product : NSObject {
  NSString *_productId;
  NSString *_name;
  NSString *_productDescription;
  double _price;
  NSString *_imageURL;
  NSInteger _reviewCount;
  double _rating;
}

@property(nonatomic, copy) NSString *productId;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *productDescription;
@property(nonatomic, assign) double price;
@property(nonatomic, copy) NSString *imageURL;
@property(nonatomic, assign) NSInteger reviewCount;
@property(nonatomic, assign) double rating;

#pragma mark - Initialization

+ (id)productWithId:(NSString *)productId
               name:(NSString *)name
              price:(double)price;

- (id)initWithId:(NSString *)productId
            name:(NSString *)name
           price:(double)price;

#pragma mark - Sample Data

/// Returns an autoreleased array of sample products
+ (NSArray *)sampleProducts;

/// Returns an autoreleased sample product with the given ID
+ (Product *)sampleProductWithId:(NSString *)productId;

@end
