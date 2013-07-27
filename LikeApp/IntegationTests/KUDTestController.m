//
//  KUDTestController.m
//  KIF
//
//  Created by Nguyen Huu Tinh on 7/3/13.
//
//

#import "KUDTestController.h"
#import "KIFTestScenario+KUDLikeApp.h"
@implementation KUDTestController
- (void)initializeScenarios;
{
    //[super initializeScenarios];
    // ---------- begin test all like app ----------
    
    // test screen Login
    [self addScenario:[KIFTestScenario scenarioToLogIn]];
    // test screen Main
    [self addScenario:[KIFTestScenario scenarioToMain]];
    // screen MyPage
    [self addScenario:[KIFTestScenario scenarioToMyPage]];
    
    // -----------the end test all ------------------
    
    
    // login fail and forget password
    //[self addScenario:[KIFTestScenario scenarioToLoginFailToForGetPassword]];
     // login fail and create password
    //[self addScenario:[KIFTestScenario scenarioToLoginFailAndCreateAccount]];
    
    
    // test navigation
    //[self addScenario:[KIFTestScenario scenarioToNavigation]];
    

}

@end
