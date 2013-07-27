//
//  KUDError.h
//  LikeApp
//
//  Created by Nguyen Huu Tinh on 6/11/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KUDError : NSObject

@property(nonatomic,strong)NSString *statusCode;
@property(nonatomic,strong)NSString *message;
@property(nonatomic,strong)NSString *token;

@end
