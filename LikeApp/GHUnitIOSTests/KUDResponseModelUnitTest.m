//
//  KUDDetailPhotoOfMainViewUnitTest.m
//  LikeApp
//
//  Created by Nhat Huy on 7/3/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <OCMock/OCMock.h>

#import "KUDResponseModel.h"

@interface KUDResponseModelUnitTest : GHTestCase

@property (strong,nonatomic) KUDResponseModel *responseModel;

@end


@implementation KUDResponseModelUnitTest

@synthesize responseModel;

- (void)setUp {
    
    
}

// If we have a correct JSON data
- (void)testInitWithCorrectData {
    
    NSData *data = [@"{\"response\":{\"error\":{\"statusCode\":\"200\", \"message\":\"Success\"}}}" dataUsingEncoding:NSUTF8StringEncoding];
    
    responseModel = [[KUDResponseModel alloc] initWithResponse:data];
}


// If we have an incorrect JSON data
- (void)testInitWithInCorrectData {
     
    NSData *data = [@"{[]}  {\"response\":{\"error\":{\"statusCode\":\"200\", \"message\":\"Success\"}}}" dataUsingEncoding:NSUTF8StringEncoding];
    
    responseModel = [[KUDResponseModel alloc] initWithResponse:data];
}

// 
- (void)testInitWithNotEnoughData {
    
    NSData *data = [@"{\"error\":{\"statusCode\":\"200\", \"message\":\"Success\"}}" dataUsingEncoding:NSUTF8StringEncoding];
    
    responseModel = [[KUDResponseModel alloc] initWithResponse:data];
}



@end
