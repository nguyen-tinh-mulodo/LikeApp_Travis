//
//  KUDRESTFulDelegate.h
//  LikeApp
//
//  Created by Nhat Huy on 6/10/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KUDRESTFulDelegate <NSObject>

- (void)finishLoadRESTFulByAPI:(NSString *)apiName;

@optional
- (void)errorAppearWhenLoadingAPI:(NSString *)apiName withError:(NSError *)error;

@end
