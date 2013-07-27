//
//  KUDLoginViewController.m
//  LikeApp
//
//  Created by Nguyen huu Tinh on 6/4/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import "KUDLoginViewController.h"
#import "KUDUsers.h"
#import "MBProgressHUD.h"
#import "KUDConstants.h"
#import "KUDUsers.h"

#import <QuartzCore/QuartzCore.h>

@interface KUDLoginViewController ()
@property (strong,nonatomic) KUDResponseModel *response;
@end

@implementation KUDLoginViewController

@synthesize buttonMain, textFieldEmail, textFieldPassword,textFieldName,textFieldRetypePassword;    
@synthesize tableViewConnectionLayout;
@synthesize response, restFul;

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
    
    //Init KUDRESTFul
    restFul = [[KUDRESTFul alloc] init];
    restFul.delegate = self;
    restFul.baseUrl = URL_API;
    flagChooseButtonMain = 1;
    
    //Init Response Model
    //error = [[KUDError alloc] init];
    response = [[KUDResponseModel alloc] init];
    
    //Init the TableViewConnectionLayout
    tableViewConnectionLayout = [[UITableView alloc] init];
    tableViewConnectionLayout.frame = CGRectMake(15, self.view.frame.size.height - 130 - 10, 290, 130);
    [tableViewConnectionLayout setScrollEnabled:NO];
    tableViewConnectionLayout.dataSource = self;
    tableViewConnectionLayout.delegate = self;
    [self.view addSubview:tableViewConnectionLayout];
    [tableViewConnectionLayout selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    // init GesTure
    UITapGestureRecognizer *fingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(returnKeyboard:)];
    [fingerTap setNumberOfTapsRequired:1];
    [fingerTap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:fingerTap];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"] != nil && ![[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] isEqualToString:@""]) {
        [self checkToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    }
    
    // Set Delegate
    [textFieldEmail setDelegate:self];
    [textFieldPassword setDelegate:self];
    [textFieldName setDelegate:self];
    [textFieldRetypePassword setDelegate:self];
    
    //Show form account
    [self formAlrealyAccount:YES];
}
-(void)checkToken:(NSString *)token{
    restFul.apiUrl = @"GetName";
    [restFul postRequestWithParameter:@{@"apiKey": API_KEY, @"token": token} andReturnType:@"JSON" byEncType:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    //[self testParseJSON];
    
}
- (void)viewWillAppear:(BOOL)animated{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"] != nil ) {
        self.textFieldEmail.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)returnKeyboard:(id)sender{
    [textFieldEmail resignFirstResponder];
    [textFieldPassword resignFirstResponder];
    [textFieldName resignFirstResponder];
    [textFieldRetypePassword resignFirstResponder];
}

- (void)resignTextfield:(id)sender {
    [textFieldEmail resignFirstResponder];
    [textFieldPassword resignFirstResponder];
    [textFieldName resignFirstResponder];
    [textFieldRetypePassword resignFirstResponder];
}


- (IBAction)actionLogin:(id)sender {
    switch (flagChooseButtonMain) {
        case 1:
            self.buttonMain.titleLabel.text = @"Connect";
            if(![self isValidEmail:self.textFieldEmail.text] || [textFieldPassword.text isEqualToString:@""]){
                [[[UIAlertView alloc] initWithTitle:nil
                                            message:@"Email or password is incorrect..."
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"Retype", nil) otherButtonTitles:nil] show];
                
            } else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.labelText = @"Please wait ...";
                
                restFul.apiUrl = @"LoginWithEmailAndPassword";
                [restFul postRequestWithParameter:@{@"apiKey":API_KEY,@"email":textFieldEmail.text,@"password":textFieldPassword.text} andReturnType:@"json" byEncType:@"application/x-www-form-urlencoded"];
            }
            break;
        case 2:
            self.buttonMain.titleLabel.text = @"Create";
            if (![textFieldPassword.text isEqualToString:textFieldRetypePassword.text]) {
                [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:@"Password incorrect"
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"Retype", nil) otherButtonTitles:nil] show];
                break;
            }
            if(![self isValidEmail:self.textFieldEmail.text] || [textFieldPassword.text isEqualToString:@""]|| [textFieldRetypePassword.text isEqualToString:@""]||[textFieldName.text isEqualToString:@""]){
                
                [[[UIAlertView alloc] initWithTitle:nil
                                            message:@"Email or password is incorrect..."
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"Retype", nil) otherButtonTitles:nil] show];
            } else{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                hud.labelText = @"Please wait ...";
                restFul.apiUrl = @"CreateUser";
                [restFul postRequestWithParameter:@{@"apiKey":API_KEY,@"name":self.textFieldName.text,@"email":textFieldEmail.text,@"password":textFieldPassword.text} andReturnType:@"JSON" byEncType:@"application/x-www-form-urlencoded"];
                
            }
            
            
            break;
        case 3:
            [self.buttonMain setTitle:@"Send" forState:UIControlStateNormal];
            if([self isValidEmail:self.textFieldEmail.text]){
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                hud.labelText = @"Please wait ...";
                
                restFul.apiUrl = @"ResendPassword";
                [restFul postRequestWithParameter:@{@"apiKey": API_KEY,@"email": self.textFieldEmail.text} andReturnType:@"JSON" byEncType:nil];
                
            } else{
                [[[UIAlertView alloc] initWithTitle:nil
                                            message:@"Email is incorrect..."
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"Retype", nil) otherButtonTitles:nil] show];            }
            
            break;
            
        default:
            break;
    }
    
    
    [self resignTextfield:nil];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableViewConnectionLayout dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell.selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:0.741 green:0.765 blue:0.78 alpha:1]];
    cell.textLabel.font = [UIFont fontWithName:@"GillSans-Light" size:16];
    switch (indexPath.row) {
        case 0:
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.indentationLevel = 2;
            cell.textLabel.text = @"I already have an account";
            break;
        case 1:
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.indentationLevel = 2;
            cell.textLabel.text = @"Create a new account";
            break;
        case 2:
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.indentationLevel = 2;
            cell.textLabel.text = @"I don't remember my password";
            break;
            
        default:
            break;
    }
    
    
    
    return cell;
}
// check email
-(BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FALSE;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL boolCheck;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        boolCheck = TRUE;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        for(int i = 0 ; i < 3 ; i ++){
            if(i != indexPath.row){
                cell= [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        
        
    } else {
        boolCheck = FALSE;
        for(int i = 0 ; i < 3 ; i ++){
            if(i != indexPath.row){
                cell= [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
    
    switch (indexPath.row) {
        case 0:
            //load form: @"I already have an account";
            [self formAlrealyAccount:boolCheck];
            break;
        case 1:
            //load form: @"Create a new account";
            [self formCreateAccount:boolCheck];
            break;
        case 2:
            //load form: @"I don't remember my password";
            [self formForgetAccount:boolCheck];
            break;
            
        default:
            break;
    }
    
}
#pragma mark - xu li form connection
// Form Login
-(void)formAlrealyAccount:(BOOL)isAlrealy{
    if (isAlrealy) {
        flagChooseButtonMain = 1;
        self.textFieldName.hidden = YES;
        self.textFieldPassword.hidden = NO;
        self.textFieldPassword.text = @"";
        self.textFieldEmail.hidden = NO;
        self.textFieldRetypePassword.hidden = YES;
        [self.buttonMain setTitle:@"Connect" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.0 animations:^{
            self.textFieldEmail.frame = CGRectMake(31.0f, 150.0f, 257.0f, 42.0f);
            self.textFieldPassword.frame = CGRectMake(31.0f, 200.0f, 257.0f, 42.0f);
            buttonMain.frame = CGRectMake(90 , 260 , 142, 44);
        }];
    }
}
// Form create account
-(void)formCreateAccount:(BOOL)isCreate{
    if (isCreate) {
        flagChooseButtonMain = 2;
        self.textFieldEmail.text = @"";
        self.textFieldName.hidden = NO;
        self.textFieldRetypePassword.hidden = NO;
        self.textFieldPassword.hidden = NO;
        self.textFieldEmail.hidden = NO;
        [self.buttonMain setTitle:@"Create" forState:UIControlStateNormal];
        self.buttonMain.titleLabel.textAlignment = UIBaselineAdjustmentAlignCenters;
        [UIView animateWithDuration:0.0 animations:^{
            buttonMain.frame = CGRectMake(90 , 330, 142, 44);
            self.textFieldName.frame = CGRectMake(31.0f, 120.0f, 257.0f, 42.0f);
            self.textFieldRetypePassword.frame = CGRectMake(31.0f, 270.0f, 257.0f, 42.0f);
            self.textFieldPassword.frame = CGRectMake(31.0f, 220.0f, 257.0f, 42.0f);
            self.textFieldEmail.frame = CGRectMake(31.0f, 170.0f, 257.0f, 42.0f);
        }];
        
    }
}
// form for get account
-(void)formForgetAccount:(BOOL)isForget{
    if (isForget) {
        
        [self.buttonMain setTitle:@"Send" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.0 animations:^{
            flagChooseButtonMain = 3;
            self.textFieldEmail.text = @"";
            self.textFieldName.hidden = YES;
            self.textFieldPassword.hidden = YES;
            self.textFieldRetypePassword.hidden = YES;
            self.buttonMain.titleLabel.textAlignment = UIBaselineAdjustmentAlignCenters;
            buttonMain.frame = CGRectMake(90, 220, 142, 44);
            self.textFieldEmail.frame = CGRectMake(31.0f, 160.0f, 257.0f, 42.0f);
        }];
    }
}
#pragma mark - KUDRESTFulDelagete
- (void)finishLoadRESTFulByAPI:(NSString *)apiName{
    @try {
        NSString *checkApiName = [apiName lastPathComponent];
        if ([checkApiName isEqualToString:@"LoginWithEmailAndPassword"]) {
            KUDResponseModel *responseModel = [[KUDResponseModel alloc] initWithResponse:restFul.responseData];
            if ([responseModel.statusCode intValue] == 200) {
                
                [[NSUserDefaults standardUserDefaults] setObject:responseModel.token forKey:@"token"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                // get name save to userdefaults
                [self checkToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
                [[NSUserDefaults standardUserDefaults] setObject:self.textFieldEmail.text forKey:@"email"];
                
            }else{
                
                [[[UIAlertView alloc] initWithTitle:@"Error!"
                                            message:responseModel.errorMessage
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"Retype", nil) otherButtonTitles:nil] show];
            }
        }
        if ([checkApiName isEqualToString:@"CreateUser"]) {
            
            KUDResponseModel *responseModel = [[KUDResponseModel alloc] initWithResponse:restFul.responseData];
            if ([responseModel.statusCode intValue] == 200) {
                [[[UIAlertView alloc] initWithTitle:responseModel.errorMessage
                                            message:@"Create Account Succecfull! Please check email..."
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                [self.tableViewConnectionLayout reloadData];
                [self formAlrealyAccount:TRUE];
            }else{
                [[[UIAlertView alloc] initWithTitle:@"Error!"
                                            message:responseModel.errorMessage
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"Retype", nil) otherButtonTitles:nil] show];
            }
        }
        if ([checkApiName isEqualToString:@"ResendPassword"]) {
            
            KUDResponseModel *responseModel = [[KUDResponseModel alloc] initWithResponse:restFul.responseData];
            if ([responseModel.statusCode intValue] == 200) {
                [[[UIAlertView alloc] initWithTitle:responseModel.errorMessage
                                            message:@"Send password to email Succecfull. Please check email."
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
                [self.tableViewConnectionLayout reloadData];
                [self formAlrealyAccount:TRUE];
            }else{
                [[[UIAlertView alloc] initWithTitle:@"Error!"
                                            message:responseModel.errorMessage
                                           delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"Retype", nil) otherButtonTitles:nil] show];
            }
        }
        // check token
        if ([checkApiName isEqualToString:@"GetName"]) {
        
            KUDResponseModel *responseModel = [[KUDResponseModel alloc] initWithResponse:restFul.responseData];
            if ([responseModel.statusCode intValue] == 200) {
                KUDUsers *user = [[KUDUsers alloc] initWithResponse:restFul.responseData];
                [[NSUserDefaults standardUserDefaults] setObject:user.name forKey:@"name"];
                [self performSegueWithIdentifier:@"modalToMainView" sender:self];
            }else{
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
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    }
    
}
- (void)errorAppearWhenLoadingAPI:(NSString *)apiName withError:(NSError *)error{
    [[[UIAlertView alloc] initWithTitle:@"Sorry for this inconvenience!"
                                message:error.localizedDescription
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"Retype", nil) otherButtonTitles:nil] show];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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


// Move view Login
 
-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    if ((self.view.frame.size.height - buttonMain.frame.origin.y - buttonMain.frame.size.height) > 226) {
        
        return;
    }
    CGFloat movementDistance = 0;
    
    if (self.view.frame.size.height < 500) {
        
        if (![textFieldName isHidden]) {
            
            if (textField == textFieldRetypePassword) {
                
                movementDistance = textFieldEmail.frame.origin.y - 20 -20;
            } else {
                
                movementDistance = textFieldName.frame.origin.y - 20 - 10;
            }
            
            [UIView animateWithDuration:0.3 animations:^{
                
                [tableViewConnectionLayout setFrame:CGRectMake(tableViewConnectionLayout.frame.origin.x , self.view.frame.size.height - 10, tableViewConnectionLayout.frame.size.width, tableViewConnectionLayout.frame.size.height)];
            }];
        }
        
        if ([textFieldName isHidden] && [textFieldRetypePassword isHidden]) {
            
            movementDistance = textFieldEmail.frame.origin.y - 20 -20;
        }
        
    } else {
        
        movementDistance = 216 - (self.view.frame.size.height - (buttonMain.frame.origin.y + buttonMain.frame.size.height) + 10);
    }
    
    
    int movement = (up ? - movementDistance : 20);
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        [self.view setFrame:CGRectMake( 0, movement, self.view.frame.size.width, self.view.frame.size.height)];
    } completion:nil];
}

- (void)pushUpTableConnection:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [tableViewConnectionLayout setFrame:CGRectMake(tableViewConnectionLayout.frame.origin.x , self.view.frame.size.height - tableViewConnectionLayout.frame.size.height - 10, tableViewConnectionLayout.frame.size.width, tableViewConnectionLayout.frame.size.height)];
    }];
}

- (void)pullDownTableConnection:(id)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [tableViewConnectionLayout setFrame:CGRectMake(tableViewConnectionLayout.frame.origin.x , self.view.frame.size.height - 10, tableViewConnectionLayout.frame.size.width, tableViewConnectionLayout.frame.size.height)];
    }];
}

#pragma mark - Rotation Delegate

- (BOOL)shouldAutorotate {
    
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}


@end
