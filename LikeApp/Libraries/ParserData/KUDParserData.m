//
//  KUDParserData.m
//  LikeApp
//
//  Created by Nhat Huy on 7/9/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import "KUDParserData.h"

@implementation KUDParserData

+ (KUDResponseModel *)parseJSONtoResponseModel:(NSData *)responseData {
    
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    
    KUDResponseModel *responseModel = [[KUDResponseModel alloc] init];
    
    // Debug If responseData isn't a jsonObject. Log will parse to string
    if (![NSJSONSerialization isValidJSONObject:jsonObject]) {
        
        NSString *stringOfResponse = [[NSString alloc] initWithBytes:[responseData bytes] length:responseData.length encoding:NSUTF8StringEncoding];
        
        NSLog(@"-------- Result Debug -------------- \n %@", stringOfResponse);
    }
    
    // Get Status Code
    responseModel.statusCode = [[[jsonObject objectForKey:@"response"] objectForKey:@"error"] objectForKey:@"statusCode"];
    
    // Get Error Message
    responseModel.errorMessage = [[[jsonObject objectForKey:@"response"] objectForKey:@"error"] objectForKey:@"message"];
    
    // Get Token Key
    responseModel.token = [[jsonObject objectForKey:@"response"] objectForKey:@"token"];
    
    return responseModel;
}

+ (KUDPhotoModel *)parseJSONtoPhotoModel:(NSData *)responseData {
    
    KUDPhotoModel *photoModel = [[KUDPhotoModel alloc] init];
    
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    
    photoModel = [self parseNSDictionaryToPhotoModel:[[jsonObject objectForKey:@"response"] objectForKey:@"photo"]];
    
    return photoModel;
}

+ (KUDPhotoModel *)parseNSDictionaryToPhotoModel:(NSDictionary *)jsonObject {
    
    KUDPhotoModel *photoModel = [[KUDPhotoModel alloc] init];
    
    // Get PhotoId
    photoModel.photoId = [jsonObject objectForKey:@"id"];
    //NSLog(@"%@", photoId);
    
    // Get l_Photo_Link
    photoModel.l_photo_link = [jsonObject objectForKey:@"l_photo_link"];
    // [l_photo_link substringFromIndex:2];
    
    // Get m_Photo_link
    photoModel.m_photo_link = [jsonObject objectForKey:@"m_photo_link"];
    
    // Get s_Photo_link
    photoModel.s_photo_link = [jsonObject objectForKey:@"s_photo_link"];
    
    // Get Comment
    photoModel.comment = [jsonObject objectForKey:@"comment"];
    
    // Get NumberLikes
    photoModel.numberLikes = [jsonObject objectForKey:@"number_likes"];
    
    // Get Created
    photoModel.created = [jsonObject objectForKey:@"created"];
    
    // Get Uploader
    photoModel.uploader = [jsonObject objectForKey:@"uploader"];
    
    return photoModel;
}

+ (NSArray *)parseJSONtoArrayOfPhotoModel:(NSData *)responseData {
    
    // Parse JSON
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error: nil];
    
    // This code is don't need now
    // Load photo array
    NSArray *photoArray = [[jsonObject objectForKey:@"response"] objectForKey:@"photo"];
    
    // Init PhotoModel Array
    NSMutableArray *arrayOfPhotoModel = [[NSMutableArray alloc] init];
    
    for (NSDictionary *photoObject in photoArray) {
        
        KUDPhotoModel *photoModel = [self parseNSDictionaryToPhotoModel:photoObject];
        [arrayOfPhotoModel addObject:photoModel];
    }
    
    return arrayOfPhotoModel;
}

+ (BOOL)parseJSONofIsLikedPhotoAPI:(NSData *)responseData {
    
    // Parse JSON
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    
    NSNumber *isLiked = [[jsonObject objectForKey:@"response"] objectForKey:@"isLiked"];
    
    if ([isLiked isEqualToNumber:@0]) {
        
        return NO;
    } else {
        
        return YES;
    }
}

@end
