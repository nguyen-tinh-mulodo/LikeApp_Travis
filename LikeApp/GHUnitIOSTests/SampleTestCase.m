#import <GHUnitIOS/GHUnit.h>
#import <OCMock/OCMock.h>
#import "KUDRESTFul.h"
#import "KUDUtilLoadData.h"
#import "KUDLoginViewController.h"
#import "KUDConstants.h"
#import "KUDResponseModel.h"
#import "KUDMainViewController.h"

@interface KUDMainViewController ()
- (void)loadPhotoFromURL;
@end

@interface SampleLibTest : GHTestCase<KUDRESTFulDelegate> {
    @private
    KUDUtilLoadData *utilLoadData;
    KUDRESTFul *restFul;
    
}
@end

@implementation SampleLibTest
- (void)setUp{
    utilLoadData = [[KUDUtilLoadData alloc] init];
    restFul = [[KUDRESTFul alloc]init];
    restFul.delegate = self;
    restFul.baseUrl = URL_API;
}

//! Run after each test method
- (void)tearDown{
    
}
- (void)testSimplePass {
    // Another test
}
- (void)testSimpleFail {
    GHAssertTrue(NO, nil);
}
- (void)testPravite {
    KUDMainViewController *test = [[KUDMainViewController alloc] init];
    [test loadPhotoFromURL];
}
// simple test to ensure building, linking, and running test case works in the project
- (void)testOCMockPass {
    id mock = [OCMockObject mockForClass:NSString.class];
    [[[mock stub] andReturn:@"mocktest"] lowercaseString];
    
    NSString *returnValue = [mock lowercaseString];
    GHAssertEqualObjects(@"mocktest", returnValue, @"Should have returned the expected string.");
}

- (void)testOCMockFail {
    id mock = [OCMockObject mockForClass:NSString.class];
    [[[mock stub] andReturn:@"mocktest"] lowercaseString];
    
    NSString *returnValue = [mock lowercaseString];
    GHAssertEqualObjects(@"thisIsTheWrongValueToCheck", returnValue, @"Should have returned the expected string.");
}
- (void)testnhtinh {
    
    id mock = [OCMockObject partialMockForObject:restFul];
    [[mock stub] andReturn:@"mocktest"];
    
    NSString *returnValue = [mock lowercaseString];
    GHAssertEqualObjects(@"mocktest", returnValue, @"Should have returned the expected string.");
     
     

}
// set userdefaults
-(void)testSetUserDefaults{
    [[NSUserDefaults standardUserDefaults] setObject:@"2fe8f8d09039cfc35fb1b1151dd7145d" forKey:@"token"];
}
- (NSString *)getMyDefault:(NSString *)token {
    return [[NSUserDefaults standardUserDefaults]
            stringForKey:token];
}
//get userDefaults
-(void)testGetUserDefaults{
    NSLog(@"token:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]);
}
 // test load data photo mypage
-(void)testLoadData{
    [utilLoadData loadData:1 limit:0 completionBlock:^(NSInteger searchTerm, NSArray *results, NSError *error,BOOL flag) {
        NSLog(@"results:%d",[results count]);
        
    }];
}
-(void)testLoginWithEmailAndPass{
    restFul.apiUrl = @"/users/loginWithEmailAndPass";
    [restFul postRequestWithParameter:@{@"apiKey":API_KEY,@"email":@"login@mulodo.com",@"password":@"123456"} andReturnType:@"json" byEncType:@"application/x-www-form-urlencoded"];
}
-(void)testCreateUser{
    restFul.apiUrl = @"/MLDUsers/createUser";
    [restFul postRequestWithParameter:@{@"apiKey":API_KEY,@"name":@"",@"email":@"",@"password":@""} andReturnType:@"JSON" byEncType:@"application/x-www-form-urlencoded"];
}
-(void)testResendPass{
    restFul.apiUrl = @"forgetPasswords/resendPass";
    [restFul getRequestWithParameter:@[API_KEY,@"email"] andReturnType:@"JSON"];
}
-(void)testGetName{
    restFul.apiUrl = @"/MLDUsers/getName";
    [restFul getRequestWithParameter:@[API_KEY,[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]] andReturnType:@"JSON"];
}
- (void)finishLoadRESTFulByAPI:(NSString *)apiName;{
    @try {
        NSString *checkApiName = [apiName lastPathComponent];
        
        if ([checkApiName isEqualToString:@"loginWithEmailAndPass"]) {
            KUDResponseModel *responseModel = [[KUDResponseModel alloc] initWithResponse:restFul.responseData];
            if ([responseModel.statusCode isEqualToNumber:[NSNumber numberWithInt:200]]) {
                NSLog(@"responseModel.errorMessage:%@",responseModel.errorMessage);
                
            }else{
                [[[UIAlertView alloc] initWithTitle:responseModel.errorMessage
                                            message:@"Please try again!"
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"Retype", nil) otherButtonTitles:nil] show];
            }
            
                    }
        if ([checkApiName isEqualToString:@"createUser"]) {
            KUDResponseModel *responseModel = [[KUDResponseModel alloc] initWithResponse:restFul.responseData];
            if ([responseModel.statusCode isEqualToNumber:[NSNumber numberWithInt:200]]) {
                
            }else{
                [[[UIAlertView alloc] initWithTitle:responseModel.errorMessage
                                            message:@"Please try again!"
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"Retype", nil) otherButtonTitles:nil] show];
            }
        }
        if ([checkApiName isEqualToString:@"resendPass"]) {
            KUDResponseModel *responseModel = [[KUDResponseModel alloc] initWithResponse:restFul.responseData];
            if ([responseModel.statusCode isEqualToNumber:[NSNumber numberWithInt:200]]) {
               
            }else{
                [[[UIAlertView alloc] initWithTitle:responseModel.errorMessage
                                            message:@"Please try again!"
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"Retype", nil) otherButtonTitles:nil] show];
            }
        }
        // check token
        if ([checkApiName isEqualToString:@"getName"]) {
            KUDResponseModel *responseModel = [[KUDResponseModel alloc] initWithResponse:restFul.responseData];
            if ([responseModel.statusCode isEqualToNumber:[NSNumber numberWithInt:200]]) {
               
            }else{
                NSLog(@"Token expired");
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"NSException parserDataPhoto :%@",exception);
    }
    @finally {
       
        
    }
    
}
@end