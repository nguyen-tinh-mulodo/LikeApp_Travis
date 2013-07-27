//
//  KUDSettingViewController.h
//  LikeApp
//
//  Created by Nguyen Huu Tinh on 6/28/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUDCollapseClick.h"
#import "KUDRESTFul.h"
@interface KUDSettingViewController : UIViewController<CollapseClickDelegate,UITextFieldDelegate,KUDRESTFulDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,UIAlertViewDelegate> {
     __weak IBOutlet KUDCollapseClick *myCollapseClick;
}
// Form Edit profile
@property(weak,nonatomic)IBOutlet UIView *editProfileView;
// Form change password
@property(weak,nonatomic)IBOutlet UIView *changePasswordView;

@property (weak,nonatomic) IBOutlet UITextField *textFieldCurrentPassword;
@property (weak,nonatomic) IBOutlet UITextField *textFieldName;
@property (weak,nonatomic) IBOutlet UIButton *buttonSaveNameUser;
@property (weak,nonatomic) IBOutlet UIButton *buttonChangePassword;
@property (weak,nonatomic) IBOutlet UITextField *textFieldNewPassword;
@property (weak,nonatomic) IBOutlet UITextField *textFieldConfirmNewPassword;
@property (weak,nonatomic) IBOutlet UILabel *textErrorchangePassword;
@property (weak,nonatomic) IBOutlet UILabel *textErrorchangeName;
@property (strong,nonatomic) KUDRESTFul *restFul;

- (IBAction)returnKeyboard:(id)sender;
- (IBAction)changeName:(id)sender;
- (IBAction)changePassword:(id)sender;
@end
