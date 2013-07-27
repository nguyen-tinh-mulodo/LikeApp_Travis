//
//  KIFTestScenario+KUDLikeApp.h
//  KIF
//
//  Created by Nguyen Huu Tinh on 7/3/13.
//
//
#import <Foundation/Foundation.h>
#import "KIFTestScenario.h"

@interface KIFTestScenario (KUDLikeApp)
+ (id)scenarioToLogIn;
+ (id)scenarioToMain;
+ (id)scenarioToMyPage;
+ (id)scenarioToLoginFailToForGetPassword;
+ (id)scenarioToLoginFailAndCreateAccount;
@end
