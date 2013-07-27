//
//  KUDCallAPI.m
//  LikeApp
//
//  Created by Nhat Huy on 7/9/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//



#import "KUDCallAPI.h"

@implementation KUDCallAPI

+ (void)getTop20WithCompletionBlock:(void (^)(NSArray *arrayOfPhotoModel))completionBlock didFail:(DidAppearError)errorBlock {
    
    // Create a weak pointer for RESTFul
    KUDRESTFul __weak *weakRESTFul = [KUDRESTFul sharedRESTFul];
    
    // Set API Name
    [weakRESTFul setApiUrl:@"GetTopPhoto"];
    
    // Call API
    [weakRESTFul blockPostRequestWithParameter:@{@"apiKey": API_KEY, @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"limit": @"20", @"offset": @"0"} andReturnType:@"JSON" byEncType:nil afterCompletion:^(NSMutableData *responseData) {
        
        // Get Response Model from Parser
        KUDResponseModel *errorMessage = [KUDParserData parseJSONtoResponseModel:responseData];
        
        // Check the Status Code
        switch ([errorMessage.statusCode integerValue]) {
                
                // Load API success
            case 200: {
                
                // Parser data into ArrayOfPhotoModel
                NSArray *arrayPhotoModel = [KUDParserData parseJSONtoArrayOfPhotoModel:responseData];
                
                // Call the CompletionBlock to return ArrayOfPhotoModel
                if (completionBlock != NULL) {
                    
                    completionBlock(arrayPhotoModel);
                }
                break;
            }
            
            // Other statusCode
            default: {

                
                [self controllerOfErrorMessage:errorMessage shouldAlert:NO];
                break;
            }

                
                // Other statusCode
        }
        
    } ifErrorAppear:^(NSError *error){
        
        // If don't set errorBlock, a AlertView auto show with information of error
        if (errorBlock == NULL) {
            
            [[[UIAlertView alloc] initWithTitle:@"Sorry for this inconveience"
                                        message:error.localizedDescription
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil] show];
        } else {
            
            errorBlock(error);
        }
    }];
}

+ (void)getPhoto:(NSString *)photoId completion:(void (^)(KUDPhotoModel *))completionBlock didFail:(DidAppearError)errorBlock {
    
    // Create a weak pointer for RESTFul
    KUDRESTFul __weak *weakRESTFul = [KUDRESTFul sharedRESTFul];
    
    // Set API Name
    [weakRESTFul setApiUrl:@"GetPhoto"];
    
    // Call API
    [weakRESTFul blockPostRequestWithParameter:@{@"apiKey": API_KEY, @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"photoId": photoId} andReturnType:@"JSON" byEncType:nil afterCompletion:^(NSMutableData *responseData) {
        
        // Get Response Model from Parser
        KUDResponseModel *errorMessage = [KUDParserData parseJSONtoResponseModel:responseData];
        
        // Check the Status Code
        switch ([errorMessage.statusCode integerValue]) {
                
            // Load API success
            case 200: {
                
                // Parser data into ArrayOfPhotoModel
                KUDPhotoModel *photoModel = [KUDParserData parseJSONtoPhotoModel:responseData];
                
                // Call the CompletionBlock to return ArrayOfPhotoModel
                if (completionBlock != NULL) {
                    
                    completionBlock(photoModel);
                }
                break;
            }
                
            // Other statusCode

            default: {
                
                [self controllerOfErrorMessage:errorMessage shouldAlert:NO];
                break;
            }
        }
        
    } ifErrorAppear:^(NSError *error){
        
        // If don't set errorBlock, a AlertView auto show with information of error
        if (errorBlock == NULL) {
            
            [[[UIAlertView alloc] initWithTitle:@"Sorry for this inconveience"
                                        message:error.localizedDescription
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil] show];
        } else {
            
            errorBlock(error);
        }
    }];
}



+ (void)isLikedPhoto:(NSString *)photoId completion:(void (^)(BOOL isLiked))completionBlock didFail:(DidAppearError)errorBlock {
    
    // Create a weak pointer for RESTFul
    KUDRESTFul __weak *weakRESTFul = [KUDRESTFul sharedRESTFul];
    
    // Set API Name
    [weakRESTFul setApiUrl:@"IsLikedPhoto"];
    
    // Call API
    [weakRESTFul blockPostRequestWithParameter:@{@"apiKey": API_KEY, @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"photoId": photoId} andReturnType:@"JSON" byEncType:nil afterCompletion:^(NSMutableData *responseData) {
        
        // Get Response Model from Parser
        KUDResponseModel *errorMessage = [KUDParserData parseJSONtoResponseModel:responseData];
        
        // Check the Status Code
        switch ([errorMessage.statusCode integerValue]) {
                
            // Load API success
            case 200: {
                
                // Call the CompletionBlock to return ArrayOfPhotoModel
                if (completionBlock != NULL) {
                    
                    BOOL isLiked = [KUDParserData parseJSONofIsLikedPhotoAPI:responseData];
                    completionBlock(isLiked);
                }
                break;
            }
                
            // Other statusCode
            default: {
                
                [self controllerOfErrorMessage:errorMessage shouldAlert:NO];
                break;
            }
        }
        
    } ifErrorAppear:^(NSError *error){
        
        // If don't set errorBlock, a AlertView auto show with information of error
        if (errorBlock == NULL) {
            
            [[[UIAlertView alloc] initWithTitle:@"Sorry for this inconveience"
                                        message:error.localizedDescription
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil] show];
        } else {
            
            errorBlock(error);
        }
    }];
}
/* ***** begin nhtinh ***** */
+ (void)getUploadedPhoto:(NSInteger )offset limit:(NSInteger)limit completionBlock:(GetPhotoUploadCompletionBlock)completionBlock didFail:(DidAppearError)errorBlock{
    @try {
        KUDRESTFul __weak *weakRESTFul = [KUDRESTFul sharedRESTFul];
        weakRESTFul.apiUrl = @"GetListUploaded";
        
        // Get data photo with block
        [weakRESTFul blockPostRequestWithParameter:@{@"apiKey":API_KEY,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"offset":[NSString stringWithFormat:@"%d",offset],@"limit":@"10"} andReturnType:@"JSON" byEncType:@"application/x-www-form-urlencoded" afterCompletion:^(NSData *data){
            // Get Response Model from Parser
            //KUDResponseModel *errorMessage = [KUDParserData parseJSONtoResponseModel:data];
            //  =====> check error
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                NSError __autoreleasing *error;
                // Parse the JSON Response
                NSDictionary *resultsDict = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:kNilOptions
                                                                            error:&error];
                if(error != nil)
                {
                    completionBlock(offset,nil,FALSE);
                    return ;
                }
                
                NSArray *objPhotos = resultsDict[@"response"][@"photo"];
                NSMutableArray *photosUpload = [@[] mutableCopy];
                
                for(NSMutableDictionary *objPhoto in objPhotos)
                {
                    KUDPhotoModel *photo = [KUDParserData parseNSDictionaryToPhotoModel:objPhoto];
                    
                    NSString *urlPhotoSizeS = [self getPhotoURL:photo.s_photo_link];
                    
                    if ([self validateUrl:urlPhotoSizeS]) {
                        
                        NSURLResponse *urlResponse = nil;
                        
                        NSData *responseData = [self getDataPhotoWithURL:urlPhotoSizeS urlResponse:urlResponse];
                        if (responseData) {
                            
                            if([[[urlResponse MIMEType] substringToIndex:5] isEqualToString:@"image"]) {
                                photo.sPhoto = [UIImage imageWithData:responseData];
                                [photosUpload addObject:photo];
                                // return one photo
                                completionBlock(offset,photosUpload,FALSE);
                            }
                        } else {
                            NSLog(@"Error image");
                        }
                        
                    } else {
                        NSLog(@"Error URL");
                    }
                    
                }
                
                completionBlock(offset,photosUpload,TRUE);
                
            });
            
        } ifErrorAppear:^(NSError *error) {
            if (errorBlock == NULL) {
                
                [[[UIAlertView alloc] initWithTitle:@"Sorry for this inconveience"
                                            message:error.localizedDescription
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil] show];
            } else {
                
                errorBlock(error);
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"getUploadedPhoto:%@",exception);
        
    }
    @finally {
        
    }
    
}
+ (void)getListOfLiker:(NSString *)idPhoto completionBlock:(GetListLikeCompletionBlock)completionBlock didFail:(DidAppearError)errorBlock{
    @try {
        KUDRESTFul __weak *weakRESTFul = [KUDRESTFul sharedRESTFul];
        weakRESTFul.apiUrl = @"GetListLike";
        // Get list like of photo with block
        [weakRESTFul blockPostRequestWithParameter:@{@"apiKey":API_KEY,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"photoId":idPhoto } andReturnType:@"JSON" byEncType:@"application/x-www-form-urlencoded" afterCompletion:^(NSData *data) {
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                
                NSError __autoreleasing *error;
                // Parse the JSON Response
                
                NSDictionary *resultsDict = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:kNilOptions
                                                                              error:&error];
                // Check Parse error
                if(error != nil)
                {
                    completionBlock(nil,error);
                    return;
                }
                
                NSNumber *statusCode = [[[resultsDict objectForKey:@"response"] objectForKey:@"error"] objectForKey:@"statusCode"];
                NSString *message = [[[resultsDict objectForKey:@"response"] objectForKey:@"error"] objectForKey:@"message"];
                
                if (![statusCode isEqualToNumber:[NSNumber numberWithInt:200]]) {
                    
                    NSError * error = [[NSError alloc] initWithDomain:@"192.168.1.199" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey:message}];
                    completionBlock( nil, error);
                } else {
                    NSMutableArray *liskLikePhoto = [ NSMutableArray arrayWithArray:[KUDParserData parseJSONtoArrayOfPhotoModel:data]];
                    completionBlock(liskLikePhoto,nil);
                }
                
                
            });
        } ifErrorAppear:^(NSError *error) {
            if (errorBlock == NULL) {
                
                [[[UIAlertView alloc] initWithTitle:@"Sorry for this inconveience"
                                            message:error.localizedDescription
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil] show];
            } else {
                
                errorBlock(error);
            }
        }];
    }
    
    @catch (NSException *exception) {
        NSLog(@"loadData Myphoto :%@",exception);
    }
    @finally {
        
    }
    
}
+ (void)loadDataImageLarge:(NSMutableArray *)arrayPhoto completionBlock:(LoadDataPhotoLargeCompletionBlock)completionBlock
didFail:(DidAppearError)errorBlock{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        for ( KUDPhotoModel *photo in arrayPhoto) {
            if(photo.lPhoto == NULL){
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                NSURL *urlRequest = [NSURL URLWithString:[self getPhotoURL:photo.l_photo_link]];
                // Test Cache Photo
                NSURLRequest *request = [[NSURLRequest alloc] initWithURL:urlRequest cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
                
                // Create new queue
                NSOperationQueue *queueToLoadPhoto = [NSOperationQueue new];
        
                // Send request with asynchorous style
                [NSURLConnection sendAsynchronousRequest:request queue:queueToLoadPhoto completionHandler:^(NSURLResponse *urlResponse, NSData *responseData, NSError *error) {
                    
                    // Check Error
                    if (![[[urlResponse MIMEType] substringToIndex:5] isEqualToString:@"image"]) {
                        
                        return;
                    }
                    // Create UIImage
                    UIImage *image = [UIImage imageWithData:responseData];
                    photo.lPhoto = image;
                    if ([photo isEqual:[arrayPhoto lastObject]]) {
                        completionBlock(arrayPhoto,nil);
                    }
                    //completionBlock(arrayPhoto,nil);
                }];
            }
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    });
    
}
+ (void)getNameWithToken:(NSString *)token  completion:(void (^)(NSMutableData *data))completionBlock didFail:(DidAppearError)errorBlock{
    @try {
        KUDRESTFul __weak *weakRESTFul = [KUDRESTFul sharedRESTFul];
        weakRESTFul.apiUrl = @"GetName";
        [weakRESTFul blockPostRequestWithParameter:@{@"apiKey": API_KEY, @"token": token} andReturnType:@"JSON" byEncType:nil afterCompletion:^(NSMutableData *data){
            completionBlock(data);
            
        }ifErrorAppear:^(NSError *error){
            errorBlock(error);
            
        }];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
+ (void)login:(NSString *)email password:(NSString *)password completion:(void (^)( NSString *status))completionBlock didFail:(DidAppearError)errorBlock{
    @try {
        KUDRESTFul __weak *weakRESTFul = [KUDRESTFul sharedRESTFul];
        weakRESTFul.apiUrl = @"LoginWithEmailAndPassword";
        
        [weakRESTFul blockPostRequestWithParameter:@{@"apiKey":API_KEY,@"email":email,@"password":password} andReturnType:@"json" byEncType:@"application/x-www-form-urlencoded" afterCompletion:^(NSMutableData *data){
            // Get Response Model from Parser
            KUDResponseModel *errorMessage = [KUDParserData parseJSONtoResponseModel:data];
            
            switch ([errorMessage.statusCode intValue]) {
                case 200:
                    
                    [[NSUserDefaults standardUserDefaults] setObject:errorMessage.token forKey:@"token"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    // get name save to userdefaults
                    [self getNameWithToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] completion:^(NSMutableData *data){
                        
                        KUDResponseModel *responseModel = [KUDParserData parseJSONtoResponseModel:data];
                        if ([responseModel.statusCode isEqualToNumber:[NSNumber numberWithInt:200]]) {

                            KUDUsers *user =[KUDParserData parseJSONtoUserModel:data];
                            [[NSUserDefaults standardUserDefaults] setObject:user.name forKey:@"name"];
                            
                        }else{
                            [[[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:responseModel.errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Retype", nil) otherButtonTitles:nil] show];
                            
                        }
                    }didFail:^(NSError *error){
                        
                    }];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"email"];
                    completionBlock([NSString stringWithFormat:@"%@",errorMessage.statusCode]);
                    break;
                    
                default:
                    errorBlock([NSString stringWithFormat:@"%@",errorMessage.statusCode]);
                    break;
            }
        
            
        }ifErrorAppear:^(NSError *error){
            if (errorBlock == NULL) {
                
                [[[UIAlertView alloc] initWithTitle:@"Sorry for this inconveience"
                                            message:error.localizedDescription
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil] show];
            } else {
                
                errorBlock(error);
            }

        }];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}
/*   **********  Utility  ***********  */

// check url
+ (BOOL)validateUrl:(NSString *)url{
    NSString *theURL =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", theURL];
    return [urlTest evaluateWithObject:url];
}
// Create url
+ (NSString *)getPhotoURL:(NSString *)namePhoto
{
    return [NSString stringWithFormat:@"%@%@",URL_API_Photo,namePhoto];
}
// get data photo use sendSynchronousRequest
+ (NSData *)getDataPhotoWithURL:(NSString *)urlPhoto urlResponse:(NSURLResponse *)response
{
    NSURL *photoURL = [NSURL URLWithString:urlPhoto];
    NSURLRequest *requestImage = [[NSURLRequest alloc] initWithURL:photoURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];// NSURLCacheStorageNotAllowed
    // Init ResponseUrl and NSError
    NSError *error = nil;
    // Get Response by request with Synchronous style
    NSData *responseData = [NSURLConnection sendSynchronousRequest:requestImage returningResponse:&response error:&error];
    return responseData;
}


/* ***** the end nhtinh ***** */

+ (void)likePhoto:(NSString *)photoId completion:(void (^)())completionBlock didFail:(DidAppearError)errorBlock {
    
    // Create a weak pointer for RESTFul
    KUDRESTFul __weak *weakRESTFul = [KUDRESTFul sharedRESTFul];
    
    // Set API Name
    [weakRESTFul setApiUrl:@"LikePhoto"];
    
    // Call API
    [weakRESTFul blockPostRequestWithParameter:@{@"apiKey": API_KEY, @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"photoId": photoId} andReturnType:@"JSON" byEncType:nil afterCompletion:^(NSMutableData *responseData) {
        
        // Get Response Model from Parser
        KUDResponseModel *errorMessage = [KUDParserData parseJSONtoResponseModel:responseData];
        
        // Check the Status Code
        switch ([errorMessage.statusCode integerValue]) {
                
            // Load API success
            case 200: {
                
                // Call the CompletionBlock to return ArrayOfPhotoModel
                if (completionBlock != NULL) {
                    
                    completionBlock();
                }
                break;
            }
                
            // Other statusCode
            default: {
                
                [self controllerOfErrorMessage:errorMessage shouldAlert:YES];
                break;
            }
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
    } ifErrorAppear:^(NSError *error){
        
        // If don't set errorBlock, a AlertView auto show with information of error
        if (errorBlock == NULL) {
            
            [[[UIAlertView alloc] initWithTitle:@"Sorry for this inconveience"
                                        message:error.localizedDescription
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil] show];
        } else {
            
            errorBlock(error);
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

+ (void)uploadPhoto:(NSData *)photoFile comment:(NSString *)comment proceed:(Processing)processBlock completion:(void (^)())completionBlock didFail:(DidAppearError)errorBlock {
    
    // Create a weak pointer for RESTFul
    KUDRESTFul __weak *weakRESTFul = [KUDRESTFul sharedRESTFul];
    
    // Call API
    weakRESTFul.apiUrl = @"UploadPhoto";
    
    [weakRESTFul blockUploadFile:photoFile fileType:@"image/jpeg" WithParameter:@{@"apiKey": API_KEY, @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"comment": comment} andReturnType:@"JSON" beingProceed:^(NSInteger didWritten, NSInteger expectWritten) {
    
        if (processBlock != NULL) {
            
            processBlock(didWritten, expectWritten);
        }
    } afterCompletion:^(NSMutableData *responseData) {
        
        // Get Response Model from Parser
        KUDResponseModel *errorMessage = [KUDParserData parseJSONtoResponseModel:responseData];
        
        // Check the Status Code
        switch ([errorMessage.statusCode integerValue]) {
                
            // Load API success
            case 200: {
                
                // Call the CompletionBlock to return ArrayOfPhotoModel
                if (completionBlock != NULL) {
                    
                    completionBlock();
                }
                break;
            }
                
            // Other statusCode
            default: {
                
                [self controllerOfErrorMessage:errorMessage shouldAlert:YES];
                break;
            }
        }
    } ifErrorAppear:^(NSError *error) {
        
        // If don't set errorBlock, a AlertView auto show with information of error
        if (errorBlock == NULL) {
            
            [[[UIAlertView alloc] initWithTitle:@"Sorry for this inconveience"
                                        message:error.localizedDescription
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil] show];
        } else {
            
            errorBlock(error);
        }
    }];
}

// Load Photo Data from Name of Photo
+ (void)loadPhoto:(NSString *)photoLink queue:(NSOperationQueue *)queue completion:(void (^)(NSData *photoData))completionBlock didFail:(DidAppearError)errorBlock {
    
    // Create BlockOperation to stop donwload image when we need
    NSBlockOperation __block *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        if(blockOperation.isCancelled || photoLink == nil) {
            
            return;
        }
        
        // Get Photo Link
        NSString *urlString = [NSString stringWithFormat:@"%@%@", URL_API_Photo, photoLink];
        
        // Create NSURL from urlString
        NSURL *imageUrl = [NSURL URLWithString:urlString];
        
        // Create request
        // Config cache
        NSURLRequest *requestImage = [[NSURLRequest alloc] initWithURL:imageUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
        
        // Init ResponseUrl and NSError
        NSURLResponse *urlResponse = nil;
        NSError *error = nil;
        
        // Check whether this operation has been cancelled
        if(blockOperation.isCancelled) {
            
            return;
        }
        
        // Get Response by request with Synchronous style
        NSData *responseData = [NSURLConnection sendSynchronousRequest:requestImage returningResponse:&urlResponse error:&error];
        
        // Check whether this operation has been cancelled
        if(blockOperation.isCancelled) {
            
            return;
        }
        
        if (responseData || [[urlResponse.MIMEType substringFromIndex:5] isEqualToString:@"image"]) {
            
            if (completionBlock != NULL) {
                
                completionBlock(responseData);
            }
        } else {
            
            if (error != nil && errorBlock != NULL) {
                
                errorBlock(error);
            } else {
                
                NSLog(@"%@", error.localizedDescription);
            }
        }
    }];
    
    // Add Operation into OperationQueue
    [queue addOperation:blockOperation];
    
}

#pragma mark - Private Utility

+ (void)controllerOfErrorMessage:(KUDResponseModel *)errorMessage shouldAlert:(BOOL)shouldAlert {
    
    switch ([errorMessage.statusCode integerValue]) {
            
        // The token key is expired
        case 401: {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kTokenIsExpired object:nil userInfo:nil];
            break;
        }
            
        // Other statusCode
        default: {
            
            if (shouldAlert) {
                
                [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error %@", errorMessage.statusCode]
                                            message:errorMessage.errorMessage
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil] show];
            } else {
                
                NSLog(@"Status Code: %@ - Message: %@", errorMessage.statusCode, errorMessage.errorMessage);
            }
            
            break;
        }
    }
}

@end





















