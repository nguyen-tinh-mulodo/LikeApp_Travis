//
//  KUDRESTFul.h
//  LikeApp
//
//  Created by Nhat Huy on 6/10/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KUDRESTFulDelegate.h"
#import "KUDConstants.h"

// Define Block to use. It has been described in Interface of .m file
typedef void (^CompleteBlock)(NSMutableData *data);
typedef void (^ErrorBlock)(NSError *error);
typedef void (^ProceedBlock)(NSInteger written, NSInteger expectToWrite);

@interface KUDRESTFul : NSObject <NSURLConnectionDataDelegate>

@property (weak,nonatomic) id<KUDRESTFulDelegate> delegate;

// Root URL of API
@property (strong,nonatomic) NSString *baseUrl; 

// Path of API in root URL
@property (strong,nonatomic) NSString *apiUrl; 

// Data request from APIs
@property (strong,atomic) NSMutableData *responseData;

// Connection URL
@property (strong,nonatomic) NSURLConnection *urlConnection;

// Method

// Singletons method
+ (id)sharedRESTFul;

// POST Request with Block and Handle Process Upload
- (void)blockUploadFile:(NSData *)fileData fileType:(NSString *)fileType WithParameter:(NSDictionary *)parameters andReturnType:(NSString *)returnType beingProceed:(ProceedBlock)proceedBlock afterCompletion:(CompleteBlock)completionBlock ifErrorAppear:(ErrorBlock)errorBlock;

// POST Request with Block
- (void)blockPostRequestWithParameter:(NSDictionary *)parameters andReturnType:(NSString *)returnType byEncType:(NSString *)encType afterCompletion:(CompleteBlock)completionBlock ifErrorAppear:(ErrorBlock)errorBlock;

// GET Request with Block
- (void)blockGetRequestWithParameter:(NSArray *)parameters andReturnType:(NSString *)returnType afterCompletion:(CompleteBlock)completionBlock ifErrorAppear:(ErrorBlock)errorBlock;

// POST Request
- (void)postRequestWithParameter:(NSDictionary *)parameters andReturnType:(NSString *)returnType byEncType:(NSString *)encType;

// GET Request
- (void)getRequestWithParameter:(NSArray *)parameters andReturnType:(NSString *)returnType;

// Upload file
- (void)uploadFile:(NSData *)fileData fileType:(NSString *)fileType withParameter:(NSDictionary *)parameters andReturnType:(NSString *)returnType;

// Stop Request
- (void)dismissAllConnection;

@end
