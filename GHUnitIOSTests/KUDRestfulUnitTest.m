//
//  KUDResfulUnitTest.m
//  LikeApp
//
//  Created by Nhat Huy on 7/3/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//


#import <GHUnitIOS/GHUnit.h>
#import <OCMock/OCMock.h>

#import "KUDRESTFul.h"

@interface KUDRestfulUnitTest : GHTestCase

@property (strong,nonatomic) KUDRESTFul *restFul;

@end

@implementation KUDRestfulUnitTest
@synthesize restFul;

// Set up standard with correct API and URL
- (void)setUp {
    
    restFul = [[KUDRESTFul alloc] init];
    restFul.baseUrl = @"http://hqt.pusku.com/social_photo/";
}

- (void)testGetWithBlock {
    
    restFul.apiUrl = @"photos/getTop20";
    [restFul blockGetRequestWithParameter:@[@"4110b393b8f0b6362725bf21afad6330", @"3121388f6e557271dd0b3150a20792ff"] andReturnType:@"JSON" afterCompletion:^(NSData *responseData) {
        
        NSString *stringOfResponse = [[NSString alloc] initWithBytes:[responseData bytes] length:responseData.length encoding:NSUTF8StringEncoding];
        
        NSLog(@"-------- Result Debug -------------- \n %@", stringOfResponse);
    } ifErrorAppear:^(NSError *error) {
        
        GHTestLog(@"%@", error.localizedDescription);
    }];
}

- (void)testGetWithBlockWithIncorrectURL {
    
    restFul.baseUrl = @"http://hqt.puskuasdass.com/social_photo/";
    restFul.apiUrl = @"photos/getTop";
    [restFul blockGetRequestWithParameter:@[@"4110b393b8f0b6362725bf21afad6330", @"3121388f6e557271dd0b3150a20792ff"] andReturnType:@"JSON" afterCompletion:^(NSData *responseData) {
        
        NSString *stringOfResponse = [[NSString alloc] initWithBytes:[responseData bytes] length:responseData.length encoding:NSUTF8StringEncoding];
        
        NSLog(@"-------- Result Debug -------------- \n %@", stringOfResponse);
    } ifErrorAppear:^(NSError *error) {
        
        GHTestLog(@"%@", error.localizedDescription);
    }];
}

- (void)testPostWithBlock {
    
    restFul.apiUrl = @"users/loginWithToken";
    [restFul blockPostRequestWithParameter:@{@"apiKey": @"4110b393b8f0b6362725bf21afad6330",@"token": @"3121388f6e557271dd0b3150a20792ff"} andReturnType:@"JSON" byEncType:@"application/x-www-form-urlencoded" afterCompletion:^(NSData *responseData) {
        
        NSString *stringOfResponse = [[NSString alloc] initWithBytes:[responseData bytes] length:responseData.length encoding:NSUTF8StringEncoding];
        
        NSLog(@"-------- Result Debug -------------- \n %@", stringOfResponse);
    } ifErrorAppear:^(NSError *error) {
        
        GHTestLog(@"%@", error.localizedDescription);
    }];
}

- (void)testPostWithBlockAndReturnXML {
    
    restFul.apiUrl = @"users/loginWithToken";
    [restFul blockPostRequestWithParameter:@{@"apiKey": @"4110b393b8f0b6362725bf21afad6330",@"token": @"3121388f6e557271dd0b3150a20792ff"} andReturnType:@"XML" byEncType:@"application/x-www-form-urlencoded" afterCompletion:^(NSData *responseData) {
        
        NSString *stringOfResponse = [[NSString alloc] initWithBytes:[responseData bytes] length:responseData.length encoding:NSUTF8StringEncoding];
        
        NSLog(@"-------- Result Debug -------------- \n %@", stringOfResponse);
    } ifErrorAppear:^(NSError *error) {
        
        GHTestLog(@"%@", error.localizedDescription);
    }];
}

- (void)testPostWithBlockAndWrongEncType {
    
    restFul.apiUrl = @"users/loginWithToken";
    [restFul blockPostRequestWithParameter:@{@"apiKey": @"4110b393b8f0b6362725bf21afad6330",@"token": @"3121388f6e557271dd0b3150a20792ff"} andReturnType:@"XML" byEncType:@"application/" afterCompletion:^(NSData *responseData) {
        
        NSString *stringOfResponse = [[NSString alloc] initWithBytes:[responseData bytes] length:responseData.length encoding:NSUTF8StringEncoding];
        
        NSLog(@"-------- Result Debug -------------- \n %@", stringOfResponse);
    } ifErrorAppear:^(NSError *error) {
        
        GHTestLog(@"%@", error.localizedDescription);
    }];
}

- (void)testPostWithBlockAndNilParameter {
    
    restFul.apiUrl = @"users/loginWithToken";
    [restFul blockPostRequestWithParameter:nil andReturnType:@"XML" byEncType:@"application/" afterCompletion:^(NSData *responseData) {
        
        NSString *stringOfResponse = [[NSString alloc] initWithBytes:[responseData bytes] length:responseData.length encoding:NSUTF8StringEncoding];
        
        NSLog(@"-------- Result Debug -------------- \n %@", stringOfResponse);
    } ifErrorAppear:^(NSError *error) {
        
        GHTestLog(@"%@", error.localizedDescription);
    }];
}

- (void)testPostWithBlockAndWrongURL {
    
    restFul.baseUrl = @"http://asdgshqt.puskuasdass.com/social_photo/";
    restFul.apiUrl = @"users/loginWithToken";
    [restFul blockPostRequestWithParameter:nil andReturnType:@"XML" byEncType:@"application/" afterCompletion:^(NSData *responseData) {
        
        NSString *stringOfResponse = [[NSString alloc] initWithBytes:[responseData bytes] length:responseData.length encoding:NSUTF8StringEncoding];
        
        NSLog(@"-------- Result Debug -------------- \n %@", stringOfResponse);
    } ifErrorAppear:^(NSError *error) {
        
        GHTestLog(@"%@", error.localizedDescription);
    }];
}

- (void)testUploadWithBlock {
    
    restFul.apiUrl = @"photos/uploadPhoto";
    [restFul blockUploadFile:UIImageJPEGRepresentation([UIImage imageNamed:@"Default@2x"], 50) fileType:@"image/jpeg" WithParameter:@{@"apiKey": @"4110b393b8f0b6362725bf21afad6330",@"token": @"3121388f6e557271dd0b3150a20792ff", @"comment":@"Test by UnitTest"} andReturnType:@"JSON" beingProceed:^(NSInteger written, NSInteger expectWritten){
        
        NSLog(@"Written:%d / Total:%d", written, expectWritten);
    } afterCompletion:^(NSData *responseData){
    
        NSString *stringOfResponse = [[NSString alloc] initWithBytes:[responseData bytes] length:responseData.length encoding:NSUTF8StringEncoding];
        
        NSLog(@"-------- Result Debug -------------- \n %@", stringOfResponse);
    } ifErrorAppear:^(NSError *error){
        
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void)testUploadWithBlockWithWrongImage {
    
    restFul.apiUrl = @"photos/uploadPhoto";
    [restFul blockUploadFile:UIImageJPEGRepresentation([UIImage imageNamed:@""], 50) fileType:@"image/jpeg" WithParameter:@{@"apiKey": @"4110b393b8f0b6362725bf21afad6330",@"token": @"3121388f6e557271dd0b3150a20792ff", @"comment":@"Test by UnitTest"} andReturnType:@"JSON" beingProceed:^(NSInteger written, NSInteger expectWritten){
        
        NSLog(@"Written:%d / Total:%d", written, expectWritten);
    } afterCompletion:^(NSData *responseData){
        
        NSString *stringOfResponse = [[NSString alloc] initWithBytes:[responseData bytes] length:responseData.length encoding:NSUTF8StringEncoding];
        
        NSLog(@"-------- Result Debug -------------- \n %@", stringOfResponse);
    } ifErrorAppear:^(NSError *error){
        
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void)testUploadWithBlockWithWrongParameter {
    
    restFul.apiUrl = @"photos/uploadPhoto";
    [restFul blockUploadFile:UIImageJPEGRepresentation([UIImage imageNamed:@"Default@2x"], 50) fileType:@"image/jpeg" WithParameter:@{@"apiKey": @"4110b393b8f0b6362725bf21afad6330",@"token": @"3121388f6e557271dd0b3150a20792ff"} andReturnType:@"JSON" beingProceed:^(NSInteger written, NSInteger expectWritten){
        
        NSLog(@"Written:%d / Total:%d", written, expectWritten);
    } afterCompletion:^(NSData *responseData){
        
        NSString *stringOfResponse = [[NSString alloc] initWithBytes:[responseData bytes] length:responseData.length encoding:NSUTF8StringEncoding];
        
        NSLog(@"-------- Result Debug -------------- \n %@", stringOfResponse);
    } ifErrorAppear:^(NSError *error){
        
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void)testUploadWithBlockWithWrongTypeReturn {
    
    restFul.apiUrl = @"photos/uploadPhoto";
    [restFul blockUploadFile:UIImageJPEGRepresentation([UIImage imageNamed:@"Default@2x"], 50) fileType:@"image/jpeg" WithParameter:@{@"apiKey": @"4110b393b8f0b6362725bf21afad6330",@"token": @"3121388f6e557271dd0b3150a20792ff", @"comment":@"Test by UnitTest"} andReturnType:@"JSONHNE" beingProceed:^(NSInteger written, NSInteger expectWritten){
        
        NSLog(@"Written:%d / Total:%d", written, expectWritten);
    } afterCompletion:^(NSData *responseData){
        
        NSString *stringOfResponse = [[NSString alloc] initWithBytes:[responseData bytes] length:responseData.length encoding:NSUTF8StringEncoding];
        
        NSLog(@"-------- Result Debug -------------- \n %@", stringOfResponse);
    } ifErrorAppear:^(NSError *error){
        
        NSLog(@"%@", error.localizedDescription);
    }];
}




@end
