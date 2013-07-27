//
//  KUD.m
//  LikeApp
//
//  Created by Nhat Huy on 7/2/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <OCMock/OCMock.h>

#import "KUDMainViewController.h"


@interface KUDMainViewController ()

- (void)viewDidLoad;

- (void)getTop20;

- (void)cancelQueueLoadPhotoFromURL;

@end

@interface KUDMainViewUnitTest : GHTestCase

@property (strong,nonatomic) KUDMainViewController *_mainView;
    
@end

@implementation KUDMainViewUnitTest

@synthesize _mainView;

- (void)setUp {
    
    _mainView = [[KUDMainViewController alloc] init];
}

// Test ViewDidLoad with WrongToken
- (void)testViewDidLoadWithWrongToken {
    
    // Goto load API getTop20 with wrong token when init MainView
    [[NSUserDefaults standardUserDefaults] setObject:@"asdsa6151202e888086db702734acb4c4d4df" forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_mainView viewDidLoad];
    [_mainView viewDidAppear:YES];
}

// Test GetTop20 with correct token
- (void)testGetTop20 {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"6151202e888086db702734acb4c4d4df" forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_mainView viewDidLoad];
    [_mainView viewDidAppear:YES];
    // [_mainView getTop20];
}

// Logout with wrong token
- (void)testLogout {
    
    // Setup tokenKey
    [_mainView setTokenKey:@"abasabc8e6e87f1bcf35cf3bf63c109546272c8"];
    [_mainView logout:nil];
    
}

// Test when photos is loading, message cancel has been send to them
- (void)testStopLoadPhoto {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"6151202e888086db702734acb4c4d4df" forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_mainView viewDidLoad];
    [_mainView viewDidAppear:YES];
    
    // [_mainView cancelQueueLoadPhotoFromURL];
    double delayInSeconds = 2.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [_mainView cancelQueueLoadPhotoFromURL];

    });
    
}

@end
