//
//  KIFTestStep+KUDLikeApp.h
//  KIF
//
//  Created by Nguyen Huu Tinh on 7/3/13.
//
//
#import <Foundation/Foundation.h>
#import "KIFTestStep.h"

@interface KIFTestStep (KUDLikeApp)


// Factory Steps

+ (id)stepToReset;

// Step Collections

// Assumes the application was reset and sitting at the welcome screen
+ (NSArray *)stepsToGoToLoginPage;
+ (NSArray *)stepsLoginFailAndForGetPassword;
+ (NSArray *)stepsLoginFailAndCreateAccount;
+ (NSArray *)stepsGoToSetting;
+ (NSArray *)stepsGoToUploader;
+ (NSArray *)stepsGoToShowListLike;
+ (NSArray *)stepsGoToLogin;
+ (NSArray *)stepsGoToNavigation;
@end
