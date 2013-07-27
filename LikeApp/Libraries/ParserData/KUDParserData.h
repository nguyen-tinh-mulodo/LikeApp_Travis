//
//  KUDParserData.h
//  LikeApp
//
//  Created by Nhat Huy on 7/9/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KUDResponseModel.h"
#import "KUDListOfLikerModel.h"
#import "KUDPhotoModel.h"
#import "KUDUsers.h"

@interface KUDParserData : NSObject

// Parser JSON to Model

// Parser the JSON to get a Response Model
+ (KUDResponseModel *)parseJSONtoResponseModel:(NSData *)responseData;

// Parser the JSON to get a Photo Model
+ (KUDPhotoModel *)parseJSONtoPhotoModel:(NSData *)responseData;

// Parser the JSON to get List of Liker on a PhotoId
+ (KUDListOfLikerModel *)parseJSONtoListOfLikerModel:(NSData *)responseData;

// Parser the JSON to get the UserModel
+ (KUDUsers *)parseJSONtoUserModel:(NSData *)responseData;

// Parser the JSON to get an array of photo models
+ (NSArray *)parseJSONtoArrayOfPhotoModel:(NSData *)responseData;
+ (KUDPhotoModel *)parseNSDictionaryToPhotoModel:(NSDictionary *)jsonObject;

// Parser the JSON to get info whether this photo is liked by a user
+ (BOOL)parseJSONofIsLikedPhotoAPI:(NSData *)responseData;

@end
