//
//  KIFTestScenario+KUDLikeApp.m
//  KIF
//
//  Created by Nguyen Huu Tinh on 7/3/13.
//
//

#import "KIFTestScenario+KUDLikeApp.h"
#import "KIFTestStep.h"
#import "KIFTestStep+KUDLikeApp.h"
@implementation KIFTestScenario (KUDLikeApp)

+ (id)scenarioToLogIn;
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can successfully log in."];
    [scenario addStep:[KIFTestStep stepToReset]];
    //[scenario addStepsFromArray:[KIFTestStep stepsToGoToLoginPage]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"login@mulodo.com" intoViewWithAccessibilityLabel:@"email"]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"123456" intoViewWithAccessibilityLabel:@"password"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"connect"]];
    
    // Verify that the login succeeded
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Welcome"]];
    
    return scenario;
}
@end
