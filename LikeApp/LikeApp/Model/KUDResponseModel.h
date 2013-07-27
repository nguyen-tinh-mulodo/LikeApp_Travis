//
//  KUDReponseModel.h
//  LikeApp
//
//  Created by Nhat Huy on 6/7/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KUDResponseModel : NSObject

@property (strong,nonatomic) NSNumber *statusCode;
@property (strong,nonatomic) NSString *errorMessage;
@property (strong,nonatomic) NSString *token;

- (id)initWithResponse:(NSData *)responseData;
- (void)getResponse:(NSData *)responseData;

@end
