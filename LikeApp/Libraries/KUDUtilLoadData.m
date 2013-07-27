//
//  KUDUtilLoadData.m
//  LikeApp
//
//  Created by Nguyen Huu Tinh on 6/14/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import "KUDUtilLoadData.h"
#import "KUDPhotoModel.h"
#import "KUDConstants.h"
#import "KUDRESTFul.h"
#import "KUDResponseModel.h"
@implementation KUDUtilLoadData
@synthesize restFul;

- (id)init {
    
    self = [super init];
    if (self) {
        restFul = [[KUDRESTFul alloc] init];
        restFul.baseUrl = URL_API;
    }
    return self;
}

+ (NSString *)photoURLForLoadPhoto:(NSInteger)offset
{
    
    return [NSString stringWithFormat:@"%@GetListUploaded/index/%@/%@/%d/10/.json",URL_API,API_KEY,[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],offset];
    
}

+ (NSString *)photoURLForLikePhoto:(KUDPhotoModel *) photo size:(NSString *) size
{
    return [NSString stringWithFormat:@"%@%@",URL_API_Photo,size];
}

- (void)loadData:(NSInteger )offset limit:(NSInteger)limit completionBlock:(LoadDataCompletionBlock) completionBlock
{
    @try {
        
        
        restFul.apiUrl = @"GetListUploaded";
        // Get data photo with block
        [restFul blockPostRequestWithParameter:@{@"apiKey":API_KEY,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"offset":[NSString stringWithFormat:@"%d",offset],@"limit":@"10"} andReturnType:@"JSON" byEncType:@"application/x-www-form-urlencoded" afterCompletion:^(NSData *data){
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                
                NSError __autoreleasing *error;
                
                // Parse the JSON Response
                // NSData *jsonData = [searchResultString dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *resultsDict = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:kNilOptions
                                                                              error:&error];
                if(error != nil)
                {
                    completionBlock(offset,nil,error,FALSE);
                    return ;
                }

                NSArray *objPhotos = resultsDict[@"response"][@"photo"];
                NSMutableArray *flickrPhotos = [@[] mutableCopy];
                for(NSMutableDictionary *objPhoto in objPhotos)
                {
                    KUDPhotoModel *photo = [[KUDPhotoModel alloc] init];
                    photo.photoId = objPhoto[@"id"];
                    photo.user_id = [objPhoto[@"user_id"] intValue];
                    photo.l_photo_link = objPhoto[@"l_photo_link"];
                    photo.m_photo_link = objPhoto[@"m_photo_link"];
                    photo.s_photo_link = objPhoto[@"s_photo_link"];
                    photo.numberLikes = objPhoto[@"number_likes"];
                    photo.comment = objPhoto[@"comment"];
                    
                    NSString *searchURL = [KUDUtilLoadData photoURLForLikePhoto:photo size: photo.s_photo_link];
                    if ([KUDUtilLoadData validateUrl:searchURL]) {
                        NSURL *photoURL = [NSURL URLWithString:searchURL];
                        
                        NSURLRequest *requestImage = [[NSURLRequest alloc] initWithURL:photoURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];// NSURLCacheStorageNotAllowed
                        // Init ResponseUrl and NSError
                        NSURLResponse *urlResponse = nil;
                        NSError *error = nil;
                        // Get Response by request with Synchronous style
                        NSData *responseData = [NSURLConnection sendSynchronousRequest:requestImage returningResponse:&urlResponse error:&error];
                        if (responseData) {
                            if([[[urlResponse MIMEType] substringToIndex:5] isEqualToString:@"image"]) {
                                photo.sPhoto = [UIImage imageWithData:responseData];
                                [flickrPhotos addObject:photo];
                                // return one photo
                                completionBlock(offset,flickrPhotos,nil,FALSE);
                            }else{
                                [flickrPhotos removeObject:photo];
                            }
                        }else{
                            NSLog(@"Error image");
                        }
                        
                    }else{
                        NSLog(@"Error URL");
                    }
                    
                }
                
                completionBlock(offset,flickrPhotos,nil,TRUE);
                
            });
            
        }ifErrorAppear:^(NSError *errorBlock){
            
        }];
        
    }
    @catch (NSException *exception) {
        NSLog(@"loadData Myphoto :%@",exception);
    }
    @finally {
        
    }
}
+ (BOOL)validateUrl: (NSString *) url {
    NSString *theURL =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", theURL];
    return [urlTest evaluateWithObject:url];
}
// load photo
- (void)loadPhotoShowing:(NSMutableArray *)arrayPhoto index:(NSInteger )index completionBlock:(LoadDataImageLCompletionBlock) completionBlock
{
    NSLog(@"loadPhotoShowing");
    // Create URL
    KUDPhotoModel *photo =  [arrayPhoto objectAtIndex:index];
    // if (photo.lPhoto == NULL) {
    NSString *stringUrl = [NSString stringWithFormat:@"%@%@",URL_API_Photo, photo.l_photo_link];
    NSURL *urlRequest = [NSURL URLWithString:stringUrl];
    // Test Cache Photo
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:urlRequest cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    // Create new queue
    NSOperationQueue *queueToLoadPhoto = [NSOperationQueue new];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // Send request with asynchorous style
    [NSURLConnection sendAsynchronousRequest:request queue:queueToLoadPhoto completionHandler:^(NSURLResponse *urlResponse, NSData *responseData, NSError *error) {
        
        // Check Error
        if (![[[urlResponse MIMEType] substringToIndex:5] isEqualToString:@"image"]) {
            
            return;
        }
        // Create UIImage
        UIImage *image = [UIImage imageWithData:responseData];
        photo.lPhoto = image;
        completionBlock(arrayPhoto,nil);
    }];
    // }
}
- (void)loadDataImageLarge:(BOOL)thumbnail arrayPhoto:(NSMutableArray *)arrayPhoto completionBlock:(LoadDataImageLCompletionBlock) completionBlock
{
    NSLog(@"loadDataImageL");
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        for ( KUDPhotoModel *photo in arrayPhoto) {
            if(photo.lPhoto == NULL){
                NSString *stringUrl = [NSString stringWithFormat:@"%@%@",URL_API_Photo, photo.l_photo_link];
                NSURL *urlRequest = [NSURL URLWithString:stringUrl];
                // Test Cache Photo
                NSURLRequest *request = [[NSURLRequest alloc] initWithURL:urlRequest cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
                
                // Create new queue
                NSOperationQueue *queueToLoadPhoto = [NSOperationQueue new];
                
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
                
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

+ (void)loadImageForPhoto:(KUDPhotoModel *)photo thumbnail:(BOOL)thumbnail completionBlock:(PhotoCompletionBlock) completionBlock
{
    
    NSString *size = thumbnail ? @"m" : @"b";
    
    NSString *searchURL = [KUDUtilLoadData photoURLForLikePhoto:photo size:size];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSError *error = nil;
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:searchURL]
                                                  options:0
                                                    error:&error];
        if(error)
        {
            completionBlock(nil,error);
        }
        else
        {
            UIImage *image = [UIImage imageWithData:imageData];
            if([size isEqualToString:@"m"])
            {
                photo.sPhoto = image;
            }
            else
            {
                photo.lPhoto = image;
            }
            completionBlock(image,nil);
        }
        
    });
}
// get list user like photo
- (void)loadDataListLikePhoto:(NSString *)idPhoto completionBlock:(LoadDataListLike) completionBlock {
    @try {
        
        restFul.apiUrl = @"GetListLike";
        // Get list like of photo with block
        [restFul blockPostRequestWithParameter:@{@"apiKey":API_KEY,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"photoId":idPhoto } andReturnType:@"JSON" byEncType:@"application/x-www-form-urlencoded" afterCompletion:^(NSData *data) {
            NSMutableData *test = [NSMutableData dataWithData:data];
            NSString *theXML = [[NSString alloc]
                                initWithBytes: [test mutableBytes]
                                length:[test length]
                                encoding:NSUTF8StringEncoding];
            
            NSLog(@"debug---->responseData:%@",theXML);
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
                    
                    NSArray *objPhotos = resultsDict[@"response"][@"listLiker"];
                    NSMutableArray *liskLikePhoto = [@[] mutableCopy];
                    
                    for(NSMutableDictionary *objPhoto in objPhotos)
                    {
                        KUDPhotoModel *photo = [[KUDPhotoModel alloc] init];
                        photo.name = objPhoto[@"name"] ;
                        photo.date = objPhoto[@"likedDate"];
                        photo.numberLikes = objPhoto[@"number_likes"];
                        [liskLikePhoto addObject:photo];
                    }
                    
                    completionBlock(liskLikePhoto,nil);
                }
                
                
            });
        } ifErrorAppear:^(NSError *error) {
            
            NSLog(@"%@", error.localizedDescription);
            completionBlock(nil,error);
        }];
    }
    
    @catch (NSException *exception) {
        NSLog(@"loadData Myphoto :%@",exception);
    }
    @finally {
        
    }
}
@end
