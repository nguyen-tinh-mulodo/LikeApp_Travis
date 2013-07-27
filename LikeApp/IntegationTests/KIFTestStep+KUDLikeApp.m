//
//  KIFTestStep+KUDLikeApp.m
//  KIF
//
//  Created by Nguyen Huu Tinh on 7/3/13.
//
//

#import "KIFTestStep+KUDLikeApp.h"

@implementation KIFTestStep (KUDLikeApp)
#pragma mark - Factory Steps

+ (id)stepToReset;
{
    return [KIFTestStep stepWithDescription:@"Reset the application state." executionBlock:^(KIFTestStep *step, NSError **error) {
        BOOL successfulReset = YES;
        
        // Do the actual reset for your app. Set successfulReset = NO if it fails.
        
        KIFTestCondition(successfulReset, error, @"Failed to reset some part of the application.");
        
        return KIFTestStepResultSuccess;
    }];
}

#pragma mark - Step Collections

+ (NSArray *)stepsToGoToLoginPage;
{
    NSMutableArray *steps = [NSMutableArray array];
    
    // Dismiss the welcome message
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"That's awesome!"]];
    
    //Tap the "I already have an account" button
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"I already have an account."]];
    
    return steps;
}
+ (NSArray *)stepsLoginFailAndForGetPassword{
    NSMutableArray *steps = [NSMutableArray array];
    [steps addObject:[KIFTestStep stepToEnterText:@"nhtinhtest@gmail.com" intoViewWithAccessibilityLabel:@"email"]];
    //[steps addObject:[KIFTestStep stepToEnterText:@"sfsfsffsasd@mulodo.com" intoViewWithAccessibilityLabel:@"email" traits:UIActionSheetStyleAutomatic expectedResult:@""]];
    [steps addObject:[KIFTestStep stepToEnterText:@"12345" intoViewWithAccessibilityLabel:@"password"]];
    //Tap the "connect" button
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"connect"]];
    // wait connect
    [steps addObject:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"connect"]];
    
    //Tap the "Retype" button
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Retype"]];
    
    // Tap the "I don't remember my password" button
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"I don't remember my password"]];
    
    // send password to email
    [steps addObject:[KIFTestStep stepToEnterText:@"nhtinhtest@gmail.com" intoViewWithAccessibilityLabel:@"email"]];
    
    
    //Tap the "Send" button
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"connect"]];
    
    //Tap the "connect" button
    [steps addObject:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"connect"]];
    
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:5.0 description:@"wait send mail"]];
    
    return steps;
    
}
+ (NSArray *)stepsLoginFailAndCreateAccount{
    NSMutableArray *steps = [NSMutableArray array];
    [steps addObject:[KIFTestStep stepToEnterText:@"nhtinhtest@mulodo.com" intoViewWithAccessibilityLabel:@"email"]];
    [steps addObject:[KIFTestStep stepToEnterText:@"12345" intoViewWithAccessibilityLabel:@"password"]];
    //Tap the "connect" button
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"connect"]];
    // wait connect
    [steps addObject:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"connect"]];
    
    //Tap the "Retype" button
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Retype"]];
    
    // Tap the "I don't remember my password" button
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Create a new account"]];
    
    // send password to email
    [steps addObject:[KIFTestStep stepToEnterText:@"nhtinh" intoViewWithAccessibilityLabel:@"name"]];
    [steps addObject:[KIFTestStep stepToEnterText:@"nhtinhtest@gmail.com" intoViewWithAccessibilityLabel:@"email"]];
    [steps addObject:[KIFTestStep stepToEnterText:@"11558888" intoViewWithAccessibilityLabel:@"password"]];
    [steps addObject:[KIFTestStep stepToEnterText:@"11558888" intoViewWithAccessibilityLabel:@"repassword"]];
    
    //Tap the "Send" button
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"connect"]];
    
    //Tap the "connect" button
    //[steps addObject:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"connect"]];
    
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:10.0 description:@"wait send mail"]];
    
    return steps;
    
}
+ (NSArray *)stepsGoToSetting{
    NSMutableArray *steps = [NSMutableArray array];
    
    // tap "Setting"
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Setting"]];
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@"wait 2.0"]];
    // edit your profile
    [steps addObject:[KIFTestStep stepToTapScreenAtPoint:CGPointMake(100, 100)]];
    // write full name
    [steps addObject:[KIFTestStep stepToEnterText:@"BiBi" intoViewWithAccessibilityLabel:@"fullname"]];
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@"wait 2.0"]];
    // tap "Change name" button
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Change name"]];
    
    [steps addObject:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Change name"]];
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:4.0 description:@"wait 4.0"]];
    // tap "ChangePassword "button
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"ChangePassword"]];
    
    // write passwod to textfild
    [steps addObject:[KIFTestStep stepToEnterText:@"123456" intoViewWithAccessibilityLabel:@"Current password"]];
    [steps addObject:[KIFTestStep stepToEnterText:@"123456" intoViewWithAccessibilityLabel:@"New password"]];
    [steps addObject:[KIFTestStep stepToEnterText:@"123456" intoViewWithAccessibilityLabel:@"Confirm new password"]];
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"wait 2.0"]];
    // tap "change password" button
    [steps addObject:[KIFTestStep stepToTapScreenAtPoint:CGPointMake(100, 100)]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Change password"]];
    
    [steps addObject:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Change password"]];
    
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@"wait 5.0"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Home"]];
    
    return steps;
}
+ (NSArray *)stepsGoToUploader{
    NSMutableArray *steps = [NSMutableArray array];
    // tap "Uploader" button
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Uploader"]];
    
    // wait 2.0 view photo upload
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@" wait view photo Uploader"]];
    
    // tap view album photo
    [steps addObject:[KIFTestStep stepToTapScreenAtPoint:CGPointMake(300,100)]];
    // wait 2.0s show view album photo
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@" wait view photo"]];
    // tap choose photo to upload
    [steps  addObject:[KIFTestStep stepToTapScreenAtPoint:CGPointMake(50,100)]];
    
    // wait 2.0s show view photo
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@" wait view photo"]];
    
    // tap "Comment before upload" button
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Comment before upload"]];
    
    
    //write comment labelComment
    [steps addObject:[KIFTestStep stepToEnterText:@"nhtinh_test" intoViewWithAccessibilityLabel:@"textFieldComment"]];
    // wait 2.0s show view photo
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@" wait view textFieldComment"]];
    // tap Screen
    [steps addObject:[KIFTestStep stepToTapScreenAtPoint:CGPointMake(300,100)]];
    // tap "Upload" button
    [steps addObject:[KIFTestStep stepToTapScreenAtPoint:CGPointMake(300,30)]];
    //tap cancel button
    //[steps addObject:[KIFTestStep stepToTapScreenAtPoint:CGPointMake(10,30)]];
    
    //[steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Library"]];
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:5.0 description:@" wait"]];
    // tap "Cancel" button
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Cancel"]];
    return steps;
    
}
+ (NSArray *)stepsGoToShowListLike{
    NSMutableArray *steps = [NSMutableArray array];
    [steps addObject:[KIFTestStep stepToTapScreenAtPoint:CGPointMake(100, 100)]];
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@" wait begin tap show list"]];
    [steps addObject:[KIFTestStep stepToTapScreenAtPoint:CGPointMake(315, 540)]];
    // wait 2.0s show view photo
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:4.0 description:@" wait view list like"]];
    
    return steps;
    
}
+ (NSArray *)stepsGoToLogin{
    NSMutableArray *steps = [NSMutableArray array];
    [steps addObject:[KIFTestStep stepToEnterText:@"lmn.huy@gmail.com" intoViewWithAccessibilityLabel:@"email"]];
    [steps addObject:[KIFTestStep stepToEnterText:@"123456" intoViewWithAccessibilityLabel:@"password"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"connect"]];
    return steps;
    
}
+ (NSArray *)stepsGoToNavigation{
    NSMutableArray *steps = [NSMutableArray array];
    // KIFSwipeDirectionRight scrollView --->>> show table setting
    [steps addObject:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"scrollView" inDirection:KIFSwipeDirectionRight]];
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@" wait KIFSwipeDirectionRight"]];
    // tap "Setting"
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Setting"]];
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@"wait 2.0"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Home"]];
    
    // tap mypage
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"My Page"]];
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:4.0 description:@"wait 4.0"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Home"]];
    
    // tap photos
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Photos"]];
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@"wait 2.0"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Cancel"]];
    
    // tap camera
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Camera"]];
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@"wait 2.0"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"OK"]];
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@"wait 2.0"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Cancel"]];
    
    // tap logout
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Log out"]];
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@"wait 2.0"]];
    
    // connect
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"connect"]];
    
    // KIFSwipeDirectionRight scrollView --->>> show table setting
    [steps addObject:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"scrollView" inDirection:KIFSwipeDirectionRight]];
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@" wait KIFSwipeDirectionRight"]];
    [steps addObject:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@"ok.. 2.0"]];
    return steps;
}
@end
