//
//  KUDCallAPIUnitTest.m
//  LikeApp
//
//  Created by Nhat Huy on 7/9/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <OCMock/OCMock.h>
#import "KUDCallAPI.h"

@interface KUDCallAPIUnitTest : GHTestCase

@end

@implementation KUDCallAPIUnitTest

- (void)setUp {
    
    NSString *tokenKey = @"a7ba9f3ad7ff0ae7c3219803b1787863";
    [[NSUserDefaults standardUserDefaults] setObject:tokenKey forKey:@"token"];
}

- (void)testGetTop20 {

    [KUDCallAPI getTop20WithCompletionBlock:^(NSArray *arrayOfPhotoModel) {
    
        NSLog(@"OK");
    } didFail:nil];
}

- (void)testGetPhoto {
    
    [KUDCallAPI getPhoto:@"13" completion:^(KUDPhotoModel *photoModel) {
    
        NSLog(@"%@", photoModel.l_photo_link);
    } didFail:nil];
}

- (void)testIsLikedPhoto {
    
    [KUDCallAPI isLikedPhoto:@"11" completion:^(BOOL isLiked) {
        
        if(isLiked) {
            
            NSLog(@"Is Liked");
        }
    } didFail:nil];
}

- (void)testLikePhoto {
    
    [KUDCallAPI likePhoto:@"10" completion:^{
    
        NSLog(@"You liked successful");
    } didFail:nil];
}


- (void)testUploadPhoto {
    
    [KUDCallAPI uploadPhoto:UIImageJPEGRepresentation([UIImage imageNamed:@"d.png"], 0.5) comment:@"Test Upload By GHUnit" proceed:^(NSInteger written, NSInteger totalWritten) {
    
        NSLog(@"%d / %d", written, totalWritten);
    } completion:^{
        
        NSLog(@"Successful upload photo");
    } didFail:nil];
}

- (void)testLoadPhoto {
    
    [KUDCallAPI loadPhoto:@"s_30_thefilename.jpeg" queue:[NSOperationQueue mainQueue] completion:^(NSData *data) {
    
        NSLog(@"Success");
    } didFail:nil];
    
}

@end







