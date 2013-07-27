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
   // [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"connect"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:3.0 description:@"wait LogIn"]];
  
    
    return scenario;
}
+ (id)scenarioToMain;
{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can successfully Main."];
    [scenario addStep:[KIFTestStep stepToReset]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:3.0 description:@"wait loding main"]];
    // load data home
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Home"]];
    
    // refetch scroll
    [scenario addStep:[KIFTestStep stepToScrollViewWithAccessibilityLabel:@"scrollView" byFractionOfSizeHorizontal:-0.5 vertical:0.5]];
    
    // wait load data
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"Home"]];
    
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:4.0 description:@" wait scrollView loaddata"]];
    
    // KIFSwipeDirectionRight scrollView --->>> show table setting
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"scrollView" inDirection:KIFSwipeDirectionRight]];
     [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@" wait KIFSwipeDirectionRight"]];
    
    // Go to setting
    //[scenario addStepsFromArray:[KIFTestStep stepsGoToSetting]];
    
    // KIFSwipeDirectionLeft scrollView  ---->> hidden table setting
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"scrollView" inDirection:KIFSwipeDirectionLeft]];
    // KIFSwipeDirectionUp scrollView
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"scrollView" inDirection:KIFSwipeDirectionUp]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@" wait KIFSwipeDirectionUp"]];
    // tap scroll ===>> view detail main page
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"scrollView"]];
    
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@" wait tap point"]];
    
    // KIFSwipeDirectionRight KUDPhotoDetailOfMainViewController
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"KUDPhotoDetailOfMainViewController" inDirection:KIFSwipeDirectionRight]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:3.0 description:@" wait tap KIFSwipeDirectionRight"]];
    
    
    // quay tro lai man hinh main
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Home"]];
    
    // tap "My Page" button
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"My Page"]];
   
    
    return scenario;
}
+ (id)scenarioToMyPage;
{
    
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can successfully MyPage."];
    [scenario addStep:[KIFTestStep stepToReset]];
    //[scenario addStep:[KIFTestStep stepToWaitForTimeInterval:5.0 description:@"wait loding my page"]];
    // wait load data my page
    [scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"GameK"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@" wait load MyPage"]];
    
    // KIFSwipeDirectionUp collectionView
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"viewmypage" inDirection:KIFSwipeDirectionDown]];
     [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"viewmypage" inDirection:KIFSwipeDirectionDown]];
    
    
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:4.0 description:@" wait load MyPage"]];
    

    // KIFSwipeDirectionUp collectionView
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"viewmypage" inDirection:KIFSwipeDirectionUp]];
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"viewmypage" inDirection:KIFSwipeDirectionUp]];
    
    // tap photo =>> show photo detail
    [scenario addStep:[KIFTestStep stepToTapScreenAtPoint:CGPointMake(200,200)]];
    
    // tap collectionView ===>> view detail my page
    //[scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"viewmypage"]];
    
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:6.0 description:@" wait view detail mypage"]];
    // show list like
    [scenario addStepsFromArray:[KIFTestStep stepsGoToShowListLike]];
    // KIFSwipeDirectionDown for MyPageViewController
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"KUDPhotoDetailOfMyPageViewController" inDirection:KIFSwipeDirectionRight]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@" wait swipe view detail mypage"]];
    // tap screen show button back
    [scenario addStep:[KIFTestStep stepToTapScreenAtPoint:CGPointMake(100,100)]];
    
    // quay ve mypage 
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"GameK"]];
    
    
    // tap "upload" button
    //[scenario addStepsFromArray:[KIFTestStep stepsGoToUploader]];
    

    // quay tro lai home
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Home"]];
    // tap "logout" button
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Log out"]];
    // wait 2.0s
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@" wait out"]];
    // tap ""Create a new account"" button
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Create a new account"]];
     // tap "I don't remember my password" button
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"I don't remember my password"]];
    // tap "I already have an account" button
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"I already have an account"]];
    
    

    
    //[scenario addStep:[KIFTestStep stepToTapScreenAtPoint:CGPointMake(300, 50)]];
    //[scenario addStep:[KIFTestStep stepToWaitForTappableViewWithAccessibilityLabel:@"test"]];
    
    return scenario;
}
+ (id)scenarioToLoginFailToForGetPassword{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can successfully ForGetPassword."];
    [scenario addStep:[KIFTestStep stepToReset]];
    [scenario addStepsFromArray:[KIFTestStep stepsLoginFailAndForGetPassword]];
    return scenario;
}
+ (id)scenarioToLoginFailAndCreateAccount{
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can successfully CreateAccount."];
    [scenario addStep:[KIFTestStep stepToReset]];
    [scenario addStepsFromArray:[KIFTestStep stepsLoginFailAndCreateAccount]];
    return scenario;
    
}
@end
