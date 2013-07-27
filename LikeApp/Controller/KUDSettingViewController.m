//
//  KUDSettingViewController.m
//  LikeApp
//
//  Created by Nguyen Huu Tinh on 6/28/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import "KUDSettingViewController.h"
#import "KUDRESTFul.h"
#import "KUDConstants.h"
#import "KUDResponseModel.h"
#import "MBProgressHUD.h"
@interface KUDSettingViewController ()

@end

@implementation KUDSettingViewController
@synthesize editProfileView,changePasswordView,textFieldConfirmNewPassword,textFieldCurrentPassword,textFieldName,textFieldNewPassword,buttonSaveNameUser,restFul,buttonChangePassword,textErrorchangeName,textErrorchangePassword;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Init RESTFul
    restFul = [[KUDRESTFul alloc] init];
    restFul.delegate = self;
    restFul.baseUrl = URL_API;
    
    self.title = @"Setting";
  	// Do any additional setup after loading the view.
    
    myCollapseClick.CollapseClickDelegate = self;
    [myCollapseClick reloadCollapseClick];
    
    //[myCollapseClick openCollapseClickCellAtIndex:0 animated:NO];
    /*
     NSArray *indexArray = @[[NSNumber numberWithInt:0],[NSNumber numberWithInt:2]];
     [myCollapseClick openCollapseClickCellsWithIndexes:indexArray animated:NO];
     */
    UITapGestureRecognizer *fingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(returnKeyboard:)];
    [fingerTap setNumberOfTapsRequired:1];
    [fingerTap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:fingerTap];
    
    // set delegate for textField
    [self.textFieldConfirmNewPassword setDelegate:self];
    [self.textFieldCurrentPassword setDelegate:self];
    [self.textFieldNewPassword setDelegate:self];
    self.textFieldName.placeholder = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    
    // Set font cho textErrorChangeName va textErrorChangePass
    [textErrorchangeName setFont:[UIFont fontWithName:@"GillSans-Light" size:16]];
    [textErrorchangePassword setFont:[UIFont fontWithName:@"GillSans-Light" size:16]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Collapse Click Delegate

// Required Methods
-(int)numberOfCellsForCollapseClick {
    return 2;
}

-(NSString *)titleForCollapseClickAtIndex:(int)index {
    switch (index) {
        case 0:
            return @"Edit Your Profile";
            break;
        case 1:
            return @"Change Password";
            break;
        default:
            return nil;
            break;
    }
}

-(UIView *)viewForCollapseClickContentViewAtIndex:(int)index {
    switch (index) {
        case 0:
            return editProfileView;
            break;
        case 1:
            return changePasswordView;
            break;
            
        default:
            return nil;
            break;
    }
}


// Optional Methods
-(UIColor *)colorForCollapseClickTitleViewAtIndex:(int)index {
    return [UIColor colorWithRed:223/255.0f green:47/255.0f blue:51/255.0f alpha:1.0];
}

-(UIColor *)colorForTitleLabelAtIndex:(int)index {
    return [UIColor colorWithWhite:1.0 alpha:0.85];
}

-(UIColor *)colorForTitleArrowAtIndex:(int)index {
    return [UIColor colorWithWhite:0.0 alpha:0.25];
}

-(void)didClickCollapseClickCellAtIndex:(int)index isNowOpen:(BOOL)open {
    textErrorchangeName.text = @"";
    textErrorchangePassword.text = @"";
    NSLog(@"%d and it's open:%@", index, (open ? @"YES" : @"NO"));
}


#pragma mark - TextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)returnKeyboard:(id)sender{
    [textFieldCurrentPassword resignFirstResponder];
    [textFieldName resignFirstResponder];
    [textFieldNewPassword resignFirstResponder];
    [textFieldConfirmNewPassword resignFirstResponder];
    
    
}
// change name user
- (IBAction)changeName:(id)sender{
    if (textFieldName.text.length == 0) {
        textErrorchangeName.text = @"Required field cannot be left blank.";
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Please wait ...";
        restFul.apiUrl = @"ChangeName";
        //[restFul getRequestWithParameter:@[API_KEY,[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],textFieldName.text] andReturnType:@"JSON"];
        [restFul postRequestWithParameter:@{@"apiKey":API_KEY,@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"name":textFieldName.text} andReturnType:@"json" byEncType:@"application/x-www-form-urlencoded"];
    }
    
}
// change password user
- (IBAction)changePassword:(id)sender{
    [textErrorchangePassword setFont: [UIFont fontWithName:@"GillSans-Light" size:16.0]];
    textErrorchangePassword.text = @"Please wait...";
    if ([textFieldNewPassword.text isEqualToString:textFieldConfirmNewPassword.text] && textFieldNewPassword.text.length >= 6) {
        
        if ([textFieldCurrentPassword.text isEqualToString:textFieldConfirmNewPassword.text]) {
            [textErrorchangePassword setFont: [UIFont fontWithName:@"HelveticaNeue" size:10.0]];
            textErrorchangePassword.text = @"Choose a password that you haven't previously used with this account.";
            return;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to change password?" message:[NSString stringWithFormat:@""] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Change",nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        
    }else{
        if (textFieldCurrentPassword.text.length == 0 || textFieldConfirmNewPassword.text.length == 0 || textFieldNewPassword.text.length == 0) {

            textErrorchangePassword.text = @"Required field cannot be blank.";
        }else{
            textErrorchangePassword.text = @"Confirm password does not match.";
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    @try {
        if(buttonIndex==0){
            textErrorchangePassword.text = @"";
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Please wait ...";
            restFul.apiUrl = @"ChangePassword";
            [restFul postRequestWithParameter:@{@"apiKey":API_KEY,
             @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"oldPass":textFieldCurrentPassword.text,@"newPass":textFieldNewPassword.text} andReturnType:@"json" byEncType:@"application/x-www-form-urlencoded"];

        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"alertView:%@",exception);
    }
    @finally {
        
    }
}

#pragma mark - KUDRESTFulDelagete

- (void)finishLoadRESTFulByAPI:(NSString *)apiName{
    @try {
        NSString *checkApiName = [apiName lastPathComponent];
        if ([checkApiName isEqualToString:@"ChangeName"]) {
            
            KUDResponseModel *responseModel = [[KUDResponseModel alloc] initWithResponse:restFul.responseData];
            if ([responseModel.statusCode isEqualToNumber:[NSNumber numberWithInt:200]]) {
                [[NSUserDefaults standardUserDefaults] setObject:textFieldName.text forKey:@"name"];
                textErrorchangeName.text = @"Change name sucssecful!";
            }else{
                textErrorchangeName.text = @"";
                [[[UIAlertView alloc] initWithTitle:@"Error!"
                                            message:responseModel.errorMessage
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"Retype", nil) otherButtonTitles:nil] show];
            }
            
        }
        if ([checkApiName isEqualToString:@"ChangePassword"]) {
            
            KUDResponseModel *responseModel = [[KUDResponseModel alloc] initWithResponse:restFul.responseData];
            if ([responseModel.statusCode isEqualToNumber:[NSNumber numberWithInt:200]]) {
                textErrorchangePassword.text = @"Change password sucssecfull";
            }else{
                textErrorchangePassword.text = @"";
                [[[UIAlertView alloc] initWithTitle:@"Error!"
                                            message:responseModel.errorMessage
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"Retype", nil) otherButtonTitles:nil] show];
            }
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"NSException parserDataPhoto :%@",exception);
    }
    @finally {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
}

- (void)errorAppearWhenLoadingAPI:(NSString *)apiName withError:(NSError *)error{
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:error.localizedDescription
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"Retype", nil) otherButtonTitles:nil] show];
    
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

/*
 Move view Setting
 */
-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    if (textField != self.textFieldName) {
        int movement = (up ? - 100 : 0);
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            [self.view setFrame:CGRectMake( 0, movement, self.view.frame.size.width, self.view.frame.size.height)];
        } completion:nil];
    }
    
}
@end
