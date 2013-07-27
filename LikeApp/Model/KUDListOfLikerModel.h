//
//  KUDListOfLikerModel.h
//  LikeApp
//
//  Created by Nhat Huy on 6/14/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KUDListOfLikerModel : NSObject

@property (strong,nonatomic) NSMutableArray *arrayOfLikedList;

// Method
- (id)initWithData:(NSData *)dataResponse;

@end
