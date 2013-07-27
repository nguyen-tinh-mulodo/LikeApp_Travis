//
//  LikeApp - KUDMyPageTest.m
//  Copyright 2013 Mulodo Viet Nam. All rights reserved.
//
//  Created by: Nguyen Huu Tinh
//

    // Class under test
#import <GHUnitIOS/GHUnit.h>
#import <OCMock/OCMock.h>
#import "KUDMyPageViewController.h"
#import "KUDUtilLoadData.h"
    // Collaborators

    // Test support
//#import <SenTestingKit/SenTestingKit.h>

// Uncomment the next two lines to use OCHamcrest for test assertions:
//#define HC_SHORTHAND
//#import <OCHamcrestIOS/OCHamcrestIOS.h>

// Uncomment the next two lines to use OCMockito for mock objects:
//#define MOCKITO_SHORTHAND
//#import <OCMockitoIOS/OCMockitoIOS.h>

@interface KUDMyPageViewController ()
-(void)loadMyPhoto:(NSInteger )offset limit:(NSInteger )limit;
@end
@interface KUDMyPageTest : GHTestCase{
    KUDMyPageViewController *myPageViewController;
    KUDUtilLoadData *utilLoadData;
}
    
@end

@implementation KUDMyPageTest
{
    // test fixture ivars go here
}

- (void)setUp{
    myPageViewController  = [[KUDMyPageViewController alloc] init];
    utilLoadData = [[KUDUtilLoadData alloc] init];

}

//! Run after each test method
- (void)tearDown{
    
}
-(void)testLoadMyphoto{
    [myPageViewController loadMyPhoto:0 limit:9];
    
}

@end
