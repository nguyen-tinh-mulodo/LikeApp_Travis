//
//  KUDPhotoMedium.m
//  LikeApp
//
//  Created by Nhat Huy on 6/12/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import "KUDPhotoArray.h"

@implementation KUDPhotoArray

@synthesize arrayOfDictionaryPhotoMainView, arrayOfPhotoModel;

- (id)initWithData:(NSData *)responseData {
    
    self = [super init];
    if(self) {
        
        // Parse JSON
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error: nil];
        
        // This code is don't need now
        // Load photo array
        arrayOfDictionaryPhotoMainView = [[jsonObject objectForKey:@"response"] objectForKey:@"photo"];
        
        // Init PhotoModel Array
        arrayOfPhotoModel = [[NSMutableArray alloc] init]; 
        
        for (NSDictionary *jsonObject in arrayOfDictionaryPhotoMainView) {
            
            KUDPhotoModel *photoModel = [[KUDPhotoModel alloc] initWithJsonObject:jsonObject];
            [arrayOfPhotoModel addObject:photoModel];
            // NSLog(@"%@",photoModel.photoId);
        }
        
    }
    
    return self;
}

@end
