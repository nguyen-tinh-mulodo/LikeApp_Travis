//
//  KUDReponseModel.m
//  LikeApp
//
//  Created by Nhat Huy on 6/7/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import "KUDResponseModel.h"

@implementation KUDResponseModel

@synthesize statusCode,errorMessage,token;

- (id)initWithResponse:(NSData *)responseData {
    
    self = [super init];
    if (self) {
        
        // Test the result
        /*
        NSString *stringOfResponse = [[NSString alloc] initWithBytes:[responseData bytes] length:responseData.length encoding:NSUTF8StringEncoding];
        
        NSLog(@"-------- Result Debug -------------- \n %@", stringOfResponse);
        */
        
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        
        // Debug If responseData isn't a jsonObject. Log will parse to string
        if (![NSJSONSerialization isValidJSONObject:jsonObject]) {
            
            NSString *stringOfResponse = [[NSString alloc] initWithBytes:[responseData bytes] length:responseData.length encoding:NSUTF8StringEncoding];
            
            NSLog(@"-------- Result Debug -------------- \n %@", stringOfResponse);
        }
        
        // Get Status Code
        statusCode = [[[jsonObject objectForKey:@"response"] objectForKey:@"error"] objectForKey:@"statusCode"];
        
        // Get Error Message
        errorMessage = [[[jsonObject objectForKey:@"response"] objectForKey:@"error"] objectForKey:@"message"];
        
        // Get Token Key
        token = [[jsonObject objectForKey:@"response"] objectForKey:@"token"];
        
        
        NSLog(@"Status:%@ - %@",self.statusCode, self.errorMessage);
    }
    return self;

}

- (void)getResponse:(NSData *)responseData {
    
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    
    // Get Status Code
    statusCode = [[[jsonObject objectForKey:@"response"] objectForKey:@"error"] objectForKey:@"statusCode"];
    
    // Get Error Message
    errorMessage = [[[jsonObject objectForKey:@"response"] objectForKey:@"error"] objectForKey:@"message"];
    
    // Get Token Key
    token = [[jsonObject objectForKey:@"response"] objectForKey:@"token"];
}


@end
