//
//  KUDRESTFul.m
//  LikeApp
//
//  Created by Nhat Huy on 6/10/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import "KUDRESTFul.h"

@interface KUDRESTFul()

// Private property

// This block will be call when didFinishConnection
@property (copy) CompleteBlock blockExecuteAfterCompleteConnect;

// This block will be call when didFailConnection
@property (copy) ErrorBlock blockExecuteWhenErrorAppear;

// This block will be call overlapping when the connection being proceed
@property (copy) ProceedBlock blockExecuteWhenBeingInProceed;

// Dispatch_queue for proceed block
@property (nonatomic) dispatch_queue_t dispatchForProceed;

// A weak reference of this class to avoid leak memory when alloc (NSMutableData) responseData
@property (weak,nonatomic) KUDRESTFul *weakSelf;

@end

@implementation KUDRESTFul

@synthesize urlConnection,responseData, delegate, weakSelf;
@synthesize apiUrl, baseUrl;
@synthesize blockExecuteAfterCompleteConnect, blockExecuteWhenErrorAppear, blockExecuteWhenBeingInProceed, dispatchForProceed;

//@synthesize requestMethod;

// SingleTons
+ (id)sharedRESTFul {
    
    static KUDRESTFul *sharedRESTFul = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedRESTFul = [[self alloc] init];
        sharedRESTFul.baseUrl = URL_API;
    });
    return sharedRESTFul;
}

- (id)init {
    self = [super init];
    if (self) {
        
        weakSelf = self;
    }
    
    return self;
}

// Upload file by POST Request
- (void)uploadFile:(NSData *)fileData fileType:(NSString *)fileType withParameter:(NSDictionary *)parameters andReturnType:(NSString *)returnType {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    // Choose the return type of response data
    if ([returnType isEqualToString:@"JSON"]) {
        
        returnType = @".json";
    } else {
        returnType = @".xml";
    }
    
    // Prepare infomation for request
    NSString *stringUrl = [NSString stringWithFormat:@"%@%@%@",baseUrl,apiUrl,returnType];
    
    [request setURL:[NSURL URLWithString:stringUrl]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"29154787378233593420402431"; // This is important! //NSURLConnection is very sensitive to format.
    
    // Use multipart/form-data to upload file
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Add file into body of request
    [body appendData:[@"Content-Disposition: form-data; name=\"data[PhotoFile]\"; filename=\"thefilename.jpeg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", fileType] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:fileData]];
    
    // Add parameter into body of request
    for (NSString *key in [parameters allKeys]) {
        
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[parameters objectForKey:key] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    // setting the body of the post to the request
    [request setHTTPBody:body];
    
    // now lets make the connection to the web
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (urlConnection) {
        
        if (responseData == nil) {
            
            weakSelf.responseData = [[NSMutableData alloc] init];
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    
}


// POST Request
- (void)postRequestWithParameter:(NSDictionary *)parameters andReturnType:(NSString *)returnType byEncType:(NSString *)encType {
    
    NSURL *requestUrl = [self createUrlWithParameters:nil andReturnType:returnType];
    NSString *parameterString = [self createParameterWithValueAndKeyOfArray:parameters];
    [self requestAPIwithURL:requestUrl byMethod:@"POST" andParameters:parameterString andEnctype:encType];
}

// GET Request
- (void)getRequestWithParameter:(NSArray *)parameters andReturnType:(NSString *)returnType {
    
    NSURL *requestUrl = [self createUrlWithParameters:parameters andReturnType:returnType];
    [self requestAPIwithURL:requestUrl byMethod:@"GET" andParameters:nil andEnctype:nil];
}

/*
The block will be execute when delegate of NSURLConnection Start.
*/

// POST Request with block and Handler proceed when upload file
- (void)blockUploadFile:(NSData *)fileData fileType:(NSString *)fileType WithParameter:(NSDictionary *)parameters andReturnType:(NSString *)returnType beingProceed:(ProceedBlock)proceedBlock afterCompletion:(CompleteBlock)completionBlock ifErrorAppear:(ErrorBlock)errorBlock {
    
    // Copy block into Global Block
    blockExecuteAfterCompleteConnect = completionBlock;
    blockExecuteWhenErrorAppear = errorBlock;
    blockExecuteWhenBeingInProceed = proceedBlock;
    
    dispatchForProceed = dispatch_queue_create("Dispatch for proceed", DISPATCH_QUEUE_SERIAL);
    
    [self uploadFile:fileData fileType:fileType withParameter:parameters andReturnType:returnType];
}

// POST Request with Block
- (void)blockPostRequestWithParameter:(NSDictionary *)parameters andReturnType:(NSString *)returnType byEncType:(NSString *)encType afterCompletion:(CompleteBlock)completionBlock ifErrorAppear:(ErrorBlock)errorBlock {
    
    // Copy block into Global Block
    blockExecuteAfterCompleteConnect = completionBlock;
    blockExecuteWhenErrorAppear = errorBlock;
   
    NSURL *requestUrl = [self createUrlWithParameters:nil andReturnType:returnType];
    NSString *parameterString = [self createParameterWithValueAndKeyOfArray:parameters];
    [self requestAPIwithURL:requestUrl byMethod:@"POST" andParameters:parameterString andEnctype:encType];
}

// GET Request with Block
- (void)blockGetRequestWithParameter:(NSArray *)parameters andReturnType:(NSString *)returnType afterCompletion:(CompleteBlock)completionBlock ifErrorAppear:(ErrorBlock)errorBlock {
    
    blockExecuteAfterCompleteConnect = completionBlock;
    blockExecuteWhenErrorAppear = errorBlock;
    
    NSURL *requestUrl = [self createUrlWithParameters:parameters andReturnType:returnType];
    [self requestAPIwithURL:requestUrl byMethod:@"GET" andParameters:nil andEnctype:nil];
}


- (void)requestAPIwithURL:(NSURL *)url byMethod:(NSString *)requestMethod andParameters:(NSString *)parameters andEnctype:(NSString *)encType {
    
    //Create Parameter
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];

    // If isPOST
    if( [requestMethod isEqualToString:@"POST"]) {
        
        NSString *msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
        if (encType == nil) {
            
            [urlRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        } else {
            
            [urlRequest addValue:encType forHTTPHeaderField:@"Content-Type"];
        }
        
        [urlRequest addValue:msgLength forHTTPHeaderField:@"Content-Length"];
        [urlRequest setHTTPBody: [parameters dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // Init request with URLConnetion
    [urlRequest setHTTPMethod:requestMethod];
    urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    if (urlConnection) {
        
        if (responseData == nil) {
            
            weakSelf.responseData = [[NSMutableData alloc] init];
        }
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    
}

- (NSString *)createParameterWithValueAndKeyOfArray:(NSDictionary *)dictionaryParameter {
    
    NSString *parameterString = @""; //Return the string of POST parameter
    NSArray *keyOfDictionary = [dictionaryParameter allKeys]; //List of all parameter jey
    //Make the POST string
    for (NSString *parameterKey in keyOfDictionary) {
        parameterString = [NSString stringWithFormat:@"%@&%@=%@", parameterString, parameterKey,[dictionaryParameter valueForKey:parameterKey]];
    }
    // Remove the char '&' in the head of string
    [parameterString substringFromIndex:1];
    return parameterString;
}

- (NSString *)createParameterForMVCwithArray:(NSArray *)parameterArray {
    
    NSString *parameterString = @""; //Return the string for GET parameter in MVC Model
    for (NSString *parameter in parameterArray) {
        parameterString = [NSString stringWithFormat:@"%@/%@",parameterString,parameter];
    }
    // Remove the char '/' in the head of string
    parameterString = [parameterString substringFromIndex:1];
    return parameterString;
}

// Create URL for GET or POST with return type is JSON or XML
- (NSURL *)createUrlWithParameters:(NSArray *)parameters andReturnType:(NSString *)returnType {
    
    NSString *tempUrlString = @"";
    // isPOST
    if (parameters == nil) {
        
        if ([returnType isEqualToString:@"XML"]) {
            
            tempUrlString = [NSString stringWithFormat:@"%@%@/.xml", baseUrl, apiUrl];
            
        } else { //is JSON
            
            tempUrlString = [NSString stringWithFormat:@"%@%@/.json", baseUrl, apiUrl];
        }
        
    } else { //isGET
        
        if ([returnType isEqualToString:@"XML"]) {
            
            tempUrlString = [NSString stringWithFormat:@"%@%@/%@/.xml", baseUrl, apiUrl, [self createParameterForMVCwithArray:parameters]];
            
        } else { //isJSON
            
            tempUrlString = [NSString stringWithFormat:@"%@%@/%@/.json", baseUrl, apiUrl, [self createParameterForMVCwithArray:parameters]];
        }
        
    }
    
    NSURL *url = [NSURL URLWithString:tempUrlString];
    return url;
}

#pragma mark - Handler Connection

- (void)dismissAllConnection {
    
    [urlConnection cancel];
}


#pragma mark - NSURLConnection Delegate

// I don't know :) Please explain it for me, Mr Tinh
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

// Challenge with SSL API
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

// Truncate NSMutableData
-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *) response {
    
//    NSLog(@"didReceiveResponse:%d",[response expectedContentLength]);
//    [response expectedContentLength];
 
    if (responseData == nil) {
        
        //weakSelf.responseData = [[NSMutableData data] initWithCapacity:response.expectedContentLength];
    }
    // responseData = [[NSMutableData data] initWithCapacity:response.expectedContentLength];
    
	[responseData setLength: 0];
}

// Map data into NSMutableData
-(void) connection:(NSURLConnection *) connection didReceiveData:(NSData *) data {
    
    // NSLog(@"didReceiveData:%d",[data length]);
    [responseData appendData:data];
}

// Delegate of Error on NSURLConneciton
-(void) connection:(NSURLConnection *) connection didFailWithError:(NSError *) error {
    
    //NSLog(@"error:%@",error);
    
//    [[[UIAlertView alloc] initWithTitle:nil
//                                message:error.localizedDescription
//                               delegate:nil
//                      cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    
    
    NSLog(@"%@", error.description);
    // Execute block if use Block message
    if (blockExecuteAfterCompleteConnect != NULL) {
        
        //
        if (blockExecuteWhenErrorAppear != NULL) {
            
            blockExecuteWhenErrorAppear(error);
        }
        blockExecuteAfterCompleteConnect = NULL;
    } else {
        
        // Execute Delegate
        [delegate errorAppearWhenLoadingAPI:apiUrl withError:error];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    
    // Check whether developer handle the proceed of sendData
    if (blockExecuteWhenBeingInProceed != NULL) {
        
        dispatch_async(dispatchForProceed, ^{
            
                blockExecuteWhenBeingInProceed(totalBytesWritten, totalBytesExpectedToWrite);
        });
    }
    // blockExecuteWhenBeingInProceed = NULL;
    
}

// Complete load the NSURLConneciton
-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
    // [responseData setLength:returnData.length];
    
    /*
    if (returnData == nil) {
        
        returnData = [NSData dataWithData:responseData];
    }
    */
    
    
    
    // Execute block if use Block message
    if(blockExecuteAfterCompleteConnect != NULL) {
        
        if (dispatchForProceed != NULL) {
            
            dispatch_async(dispatchForProceed, ^{
                
                blockExecuteAfterCompleteConnect(responseData);
                blockExecuteAfterCompleteConnect = NULL;
                blockExecuteWhenBeingInProceed = NULL;
            });
            
        } else {
            
            blockExecuteAfterCompleteConnect(responseData);
            blockExecuteAfterCompleteConnect = NULL;
            
        }
    } else {
        // Execute Delegate
        [delegate finishLoadRESTFulByAPI:apiUrl];
    }
//    returnData = nil;
//    responseData = nil;
    
    //[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}



@end
