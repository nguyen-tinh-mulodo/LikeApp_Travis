//
//  KUDPhotoModelUnitTest.m
//  LikeApp
//
//  Created by Nhat Huy on 7/8/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//
#import <GHUnitIOS/GHUnit.h>
#import <OCMock/OCMock.h>
#import "KUDPhotoModel.h"

@interface KUDPhotoModelUnitTest : GHTestCase

@property (strong,nonatomic) KUDPhotoModel *photoModel;

@end

@implementation KUDPhotoModelUnitTest

@synthesize photoModel;

// If we have a correct JSON data
- (void)testInitWithCorrectData {
    
    NSData *data = [@"{\"response\":{\"error\":{\"statusCode\":\"200\", \"message\":\"Success\"},\"photo\":{},\"uploader\":\"BiBi\"}}" dataUsingEncoding:NSUTF8StringEncoding];
    
    photoModel = [[KUDPhotoModel alloc] initWithData:data];
}


// If we have an incorrect JSON data
- (void)testInitWithInCorrectData {
    
    NSData *data = [@"{[]}  {\"response\":{\"error\":{\"statusCode\":\"200\", \"message\":\"Success\"}}}" dataUsingEncoding:NSUTF8StringEncoding];
    
    photoModel = [[KUDPhotoModel alloc] initWithData:data];
}

//
- (void)testInitWithNotEnoughData {
    
    NSData *data = [@"{\"error\":{\"statusCode\":\"200\", \"message\":\"Success\"}}" dataUsingEncoding:NSUTF8StringEncoding];
    
    photoModel = [[KUDPhotoModel alloc] initWithData:data];
}

@end
