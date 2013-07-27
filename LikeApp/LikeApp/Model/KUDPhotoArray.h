//
//  KUDPhotoMedium.h
//  LikeApp
//
//  Created by Nhat Huy on 6/12/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KUDPhotoModel.h"

@interface KUDPhotoArray : NSObject

@property (strong,nonatomic) NSArray *arrayOfDictionaryPhotoMainView;
@property (strong,nonatomic) NSMutableArray *arrayOfPhotoModel;

- (id)initWithData:(NSData *)responseData;

@end
