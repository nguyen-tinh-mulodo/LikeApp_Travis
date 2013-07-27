//
//  KUDPhotoModelForDetailOfMainView.m
//  LikeApp
//
//  Created by Nhat Huy on 6/14/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import "KUDPhotoModel.h"

@implementation KUDPhotoModel

@synthesize photoId,uploader,l_photo_link,s_photo_link,m_photo_link,created,modified,comment,numberLikes;
@synthesize lPhoto, mPhoto, sPhoto;
@synthesize user_id,date,name;
@synthesize isLiked;


- (id)initWithData:(NSData *)dataResponse {
    
    self = [super init];
    if (self) {
        
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:dataResponse options:kNilOptions error:nil];
        // NSLog(@"%@",[[[jsonObject objectForKey:@"response"] objectForKey:@"photo"] objectForKey:@"l_photo_link"]);
        
        // Get PhotoId
        photoId = [[[jsonObject objectForKey:@"response"] objectForKey:@"photo"] objectForKey:@"id"];
        
        // Get l_Photo_Link
        l_photo_link = [[[jsonObject objectForKey:@"response"] objectForKey:@"photo"] objectForKey:@"l_photo_link"];
        // [l_photo_link substringFromIndex:2];
        
        // Get m_Photo_link
        m_photo_link = [[[jsonObject objectForKey:@"response"] objectForKey:@"photo"] objectForKey:@"m_photo_link"];
        
        // Get s_Photo_link
        s_photo_link = [[[jsonObject objectForKey:@"response"] objectForKey:@"photo"] objectForKey:@"s_photo_link"];
        
        // Get Comment
        comment = [[[jsonObject objectForKey:@"response"] objectForKey:@"photo"] objectForKey:@"comment"];
        
        // Get Uploader
        uploader = [[jsonObject objectForKey:@"response"] objectForKey:@"uploader"];
        
        // Get NumberLikes
        numberLikes = [[[jsonObject objectForKey:@"response"] objectForKey:@"photo"] objectForKey:@"number_likes"];
        
        // Get Created
        created = [[[jsonObject objectForKey:@"response"] objectForKey:@"photo"] objectForKey:@"created"];
    }
    
    return self;
}

- (id)initWithJsonObject:(NSDictionary *)jsonObject {
    
    self = [super init];
    if (self) {
        
        // Get PhotoId
        photoId = [jsonObject objectForKey:@"id"];
        //NSLog(@"%@", photoId);
        
        // Get l_Photo_Link
        l_photo_link = [jsonObject objectForKey:@"l_photo_link"];
        // [l_photo_link substringFromIndex:2];
        
        // Get m_Photo_link
        m_photo_link = [jsonObject objectForKey:@"m_photo_link"];
        
        // Get s_Photo_link
        s_photo_link = [jsonObject objectForKey:@"s_photo_link"];
        
        // Get Comment
        comment = [jsonObject objectForKey:@"comment"];
        
        // Get NumberLikes
        numberLikes = [jsonObject objectForKey:@"number_likes"];
        
        // Get Created
        created = [jsonObject objectForKey:@"created"];
        
        // Get Uploader
        uploader = [jsonObject objectForKey:@"uploader"];
    }
    
    return self;
}

@end
