//
//  KUDUsers.h
//  LikeApp
//
//  Created by Nguyen Huu Tinh on 6/4/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KUDUsers : NSObject

@property (strong,nonatomic) NSNumber *userId;
@property (strong,nonatomic) NSString *email;
@property (strong,nonatomic) NSString *name;

- (id)initWithResponse:(NSData *)responseData;

@end
