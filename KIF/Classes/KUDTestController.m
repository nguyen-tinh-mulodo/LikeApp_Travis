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
    [self addScenario:[KIFTestScenario scenarioToLogIn]];
    //[super initializeScenarios];
    // Add additional scenarios you want to test here
}

@end
