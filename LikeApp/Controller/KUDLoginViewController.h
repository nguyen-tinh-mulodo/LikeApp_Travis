//
//  KUDLoginViewController.h
//  LikeApp
//
//  Created by Nguyen Huu Tinh on 6/3/13.
//  Modified by Le Minh Nhat Huy on 06/06/2013
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//  Description:
//  - Change name more readability
//  - Use property for variable
//  - Change the XIB

#import <UIKit/UIKit.h>
#import "KUDRESTFul.h"
#import "KUDXMLParserLogin.h"
#import "KUDError.h"
#import "KUDMainViewController.h"
#import "KUDResponseModel.h"

@interface KUDLoginViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,KUDRESTFulDelegate, UIGestureRecognizerDelegate>
{
    int flagChooseButtonMain;
    UIAlertView *alertView;
    
    
}
// Properties
@property (weak,nonatomic) IBOutlet UITextField *textFieldRetypePassword;
@property (weak,nonatomic) IBOutlet UITextField *textFieldName;
@property (strong,nonatomic) UITableView *tableViewConnectionLayout;
@property (weak,nonatomic) IBOutlet UIButton *buttonMain;
@property (weak,nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak,nonatomic) IBOutlet UITextField *textFieldPassword;
@property (strong,nonatomic) KUDRESTFul *restFul;

// Methods
- (IBAction)actionLogin:(id)sender;
- (IBAction)resignTextfield:(id)sender;
- (IBAction)returnKeyboard:(id)sender; 
- (IBAction)pushUpTableConnection:(id)sender;
- (IBAction)pullDownTableConnection:(id)sender;

@end
