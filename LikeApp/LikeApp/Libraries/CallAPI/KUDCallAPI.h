//
//  KUDCallAPI.h
//  LikeApp
//
//  Created by Nhat Huy on 7/9/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KUDParserData.h"
#import "KUDRESTFul.h"

// Block to call when error appear
typedef void (^DidAppearError)(NSError *error);

typedef void (^GetPhotoUploadCompletionBlock)(NSInteger someTimesGetData, NSArray *results,BOOL flag);
typedef void (^GetListLikeCompletionBlock)(NSArray *results,NSError *error);
typedef void (^LoadDataPhotoLargeCompletionBlock)(NSMutableArray *arrayPhoto, NSError *error);

typedef void (^Processing)(NSInteger written, NSInteger totalWritten);


@interface KUDCallAPI : NSObject

// API Caller

// Get the JSON Data of 20 newest photo from API and return the array of 20 Photo Models
+ (void)getTop20WithCompletionBlock:(void (^)(NSArray *arrayOfPhotoModel))completionBlock didFail:(DidAppearError)errorBlock;

+ (void)getUploadedPhoto:(NSInteger )offset limit:(NSInteger)limit completionBlock:(GetPhotoUploadCompletionBlock)completionBlock didFail:(DidAppearError)errorBlock;
+ (void)getListOfLiker:(NSString *)idPhoto completionBlock:(GetListLikeCompletionBlock)completionBlock didFail:(DidAppearError)errorBlock;
+ (void)loadDataImageLarge:(NSMutableArray *)arrayPhoto completionBlock:(LoadDataPhotoLargeCompletionBlock)completionBlock
                  didFail:(DidAppearError)errorBlock;

// Get the JSON Data of the particular photo from API and return a photo model
+ (void)getPhoto:(NSString *)photoId completion:(void (^)(KUDPhotoModel *photoModel))completionBlock didFail:(DidAppearError)errorBlock;

// Check whether a user has been liked a photo. It return YES or NO.
// The users is defined by tokenKey
+ (void)isLikedPhoto:(NSString *)photoId completion:(void (^)(BOOL isLiked))completionBlock didFail:(DidAppearError)errorBlock;

// Call the API LikePhoto to request a Like from a user. User is defined by tokenKey
+ (void)likePhoto:(NSString *)photoId completion:(void (^)())completionBlock didFail:(DidAppearError)errorBlock;

// Upload a photo to server
+ (void)uploadPhoto:(NSData *)photoFile comment:(NSString *)comment proceed:(Processing)processBlock completion:(void(^)())completionBlock didFail:(DidAppearError)errorBlock;

//+ (void)createUser;
//+ (void)forgetPassword;

+ (void)getNameWithToken:(NSString *)token  completion:(void (^)(NSMutableData *data))completionBlock didFail:(DidAppearError)errorBlock;
+ (void)login:(NSString *)email password:(NSString *)password completion:(void (^)( NSString *status))completionBlock didFail:(DidAppearError)errorBlock;

// Load photo data from server by photoLink
+ (void)loadPhoto:(NSString *)photoLink queue:(NSOperationQueue *)queue completion:(void (^)(NSData *photoData))completionBlock didFail:(DidAppearError)errorBlock;

@end
