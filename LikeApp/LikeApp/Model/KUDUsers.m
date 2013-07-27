//
//  KUDUsers.m
//  LikeApp
//
//  Created by Nguyen Huu Tinh on 6/4/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import "KUDUsers.h"

@implementation KUDUsers
@synthesize name,userId,email;
- (id)initWithResponse:(NSData *)responseData {
    
    self = [super init];
    if (self) {
        
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
        
        // Get name
        name = [[jsonObject objectForKey:@"response"] objectForKey:@"name"];
        
        
    }
    return self;
    
}
@end
