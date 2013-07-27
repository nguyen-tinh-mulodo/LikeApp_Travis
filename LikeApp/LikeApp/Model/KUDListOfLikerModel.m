//
//  KUDListOfLikerModel.m
//  LikeApp
//
//  Created by Nhat Huy on 6/14/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import "KUDListOfLikerModel.h"

@implementation KUDListOfLikerModel

@synthesize arrayOfLikedList;

- (id)initWithData:(NSData *)dataResponse {
    
    self = [super init];
    if (self) {
        
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:dataResponse options:kNilOptions error:nil];
        // NSLog(@"%@",[[[jsonObject objectForKey:@"response"] objectForKey:@"photo"] objectForKey:@"l_photo_link"]);
        
        arrayOfLikedList = [[NSMutableArray alloc] init];
        for (NSDictionary *row in [[jsonObject objectForKey:@"response"] objectForKey:@"listLiker"]) {
            [arrayOfLikedList addObject:row];
        }
        
    }
    
    return self;
}

@end
