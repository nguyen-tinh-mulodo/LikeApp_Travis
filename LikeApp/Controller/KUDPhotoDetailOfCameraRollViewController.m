//
//  KUDPhotoDetailOfCameraRollViewController.m
//  LikeApp
//
//  Created by Nhat Huy on 6/17/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import "KUDPhotoDetailOfCameraRollViewController.h"
#import "KUDResponseModel.h"
#import "KUDConstants.h"

@interface KUDPhotoDetailOfCameraRollViewController ()

@property (strong,nonatomic) UIView *notificationBanner;

@end

@implementation KUDPhotoDetailOfCameraRollViewController

@synthesize imageOfPicker;
@synthesize navigationItem, navigationBar, buttonBackToLibrary, buttonEditComment, textFieldComment, labelComment, shadowImage, buttonUpload;
@synthesize tapGesture;
@synthesize responseModel,restFul;
@synthesize proceedBarView, notificationBanner;

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
    
    // Set datasource
    self.dataSource = self;
    
    // Init First View
    KUDPageOfPhotoDetailCameraRollViewController *pagePhotoDetail = [[KUDPageOfPhotoDetailCameraRollViewController alloc] initWithImageOfPicker:imageOfPicker];
    
    // Set View
    [self setViewControllers:@[pagePhotoDetail] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
    
    }];
    
    // Init navigation bar
    navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    
    navigationItem = [[UINavigationItem alloc] init];
    [navigationItem setTitle:@"Library"];
    
    // Init Library button
    buttonBackToLibrary = [[UIBarButtonItem alloc] initWithTitle:@"Library" style:UIBarButtonItemStyleBordered target:self action:@selector(backToLibrary:)];
    [navigationItem setLeftBarButtonItem:buttonBackToLibrary];
    
    // Init Edit comment button
    buttonEditComment = [[UIBarButtonItem alloc] initWithTitle:@"Comment before upload" style:UIBarButtonItemStyleBordered target:self action:@selector(tapOnScreen)];
    
    // Init Upload image button
    buttonUpload = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(uploadImage)];
    
    
    [navigationItem setRightBarButtonItem:buttonEditComment];
    
    [navigationBar setItems:@[navigationItem]];
    
    //[self.view addSubview:navigationBar];
    
    // Init gesture
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnScreen)];
    [self.view addGestureRecognizer:tapGesture];

    // Init RestFul
    restFul = [[KUDRESTFul alloc] init];
    restFul.baseUrl = URL_API;
    
    // Init Proceed Bar
    proceedBarView = [[UIProgressView alloc] initWithFrame:CGRectMake(20, navigationBar.frame.size.height + 20, self.view.frame.size.width - 40, 30)];
    [self.view addSubview:proceedBarView];
    
    // nhtinh test
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    return nil;
}

#pragma mark - Show Custom Notification

- (void)showNotificationWithMessage:(NSString *)message andIcon:(NSString *)iconName {
    
    if (notificationBanner == nil) {
        
        notificationBanner = [[UIView alloc] initWithFrame:CGRectMake(-self.view.frame.size.width, self.navigationBar.frame.size.height + 4, self.view.frame.size.width, 40)];
    }
    
    // [notificationBanner setHidden:YES];
    [notificationBanner setBackgroundColor:[UIColor darkGrayColor]];
    
    UILabel *labelMessage = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, notificationBanner.frame.size.width - 40, notificationBanner.frame.size.height)];
    // [labelMessage setTextAlignment:NSTextAlignmentCenter];
    [labelMessage setTextColor:[UIColor whiteColor]];
    [labelMessage setBackgroundColor:[UIColor clearColor]];
    [labelMessage setFont:[UIFont fontWithName:@"GillSans-Light" size:16]];
    [labelMessage setText:message];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(notificationBanner.frame.size.width - 40, 4, 30, 30)];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setImage:[UIImage imageNamed:iconName]];
    
    [self.view addSubview:notificationBanner];
    [notificationBanner addSubview:labelMessage];
    [notificationBanner addSubview:imageView];
    
    [UIView animateWithDuration:0.7 animations:^{
        
        // [notificationBanner setHidden:NO];
        [notificationBanner setFrame:CGRectMake(0, self.navigationBar.frame.size.height + 4, self.view.frame.size.width, 40)];
    } completion:^(BOOL finished) {
        
        if ([responseModel.statusCode isEqualToNumber:@200]) {
            
            [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(backToLibrary:) userInfo:nil repeats:NO];
            //[self backToLibrary:nil];
        }
    }];
}


// Hidden notification and reset proceedView when retouch upload file
- (void)hiddenNotification {
    
    [UIView animateWithDuration:0.3 animations:^{
    
        [notificationBanner setFrame:CGRectMake(-self.view.frame.size.width, self.navigationBar.frame.size.height + 4, self.view.frame.size.width, 40)];
        [proceedBarView setProgress:0];
    }];
}

#pragma mark - Alert

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        [self backToLibrary:nil];
    }
}

#pragma mark - IBAction

- (void)tapOnScreen {
    
    if (textFieldComment == nil) {
        
        [self initTextFieldComment];
    }
    
    if (shadowImage == nil) {
        
        [self initShadow];
    }
    
    if (labelComment == nil) {
        [self initLabelComment];
    }
    
    if ([textFieldComment isHidden]) {
        
        [textFieldComment setHidden:NO];
        [textFieldComment becomeFirstResponder];
    } else {
        
        labelComment.text = textFieldComment.text;
        [textFieldComment setHidden:YES];
        [textFieldComment resignFirstResponder];
    }
    
    if ([textFieldComment.text isEqualToString:@""]) {
        
        [shadowImage setHidden:YES];
        [navigationItem setRightBarButtonItem:buttonEditComment animated:YES];

    } else {
        
        [shadowImage setHidden:NO];
        [navigationItem setRightBarButtonItem:buttonUpload animated:YES];
    }
}

- (void)backToLibrary:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initTextFieldComment {
    
    // Init Textfield
    textFieldComment = [[UITextField alloc] initWithFrame:CGRectMake(0, self.view.window.frame.size.height - 275, 320, 40)];
    [textFieldComment setBackgroundColor:[UIColor whiteColor]];
    [textFieldComment setFont:[UIFont fontWithName:@"GillSans-Light" size:17]];
    [textFieldComment setAlpha:0.8];
    [textFieldComment setTextAlignment:NSTextAlignmentCenter];
    [textFieldComment setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [textFieldComment setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [textFieldComment setPlaceholder:@"Type your comment of this photo"];
    [textFieldComment addTarget:self action:@selector(tapOnScreen) forControlEvents:UIControlEventEditingDidEndOnExit];
    [textFieldComment setHidden:YES];
    [self.textFieldComment setAccessibilityLabel:@"textFieldComment"];
    [self.view addSubview:textFieldComment];
    
}

- (void)initLabelComment {
    
    // Init label comment
    labelComment = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, 320, 50)];
    [labelComment setTextAlignment:NSTextAlignmentCenter];
    [labelComment setBackgroundColor:[UIColor clearColor]];
    [labelComment setTextColor:[UIColor whiteColor]];
    [labelComment setFont:[UIFont fontWithName:@"GillSans-Light" size:17]];
    labelComment.text = textFieldComment.text;
    
    [self.view addSubview:labelComment];
}

- (void)initShadow {
    
    // Init shadow image
    shadowImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 200, 320, 360)];
    [shadowImage setImage:[UIImage imageNamed:@"shadow@2x.png"]];
    [self.view addSubview:shadowImage];
}

// Visible or change Label Comment
- (void)visibleComment {
    
    // Hidden textFieldComment
    [textFieldComment resignFirstResponder];
    [textFieldComment setHidden:YES];
}

- (void)uploadImage {
    
    // Hidden Notification
    [self hiddenNotification];
    
    // Prepare Data and parameters
    KUDPageOfPhotoDetailCameraRollViewController *currentPage = self.viewControllers[0];
    
    NSLog(@"%lld", currentPage.imageInfo.fileSize);
    
    NSData *fileData = UIImageJPEGRepresentation(currentPage.imageView.image, 0.4);
    NSString *tokenKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    // Call API
    restFul.apiUrl = @"UploadPhoto";
    
    UIProgressView __weak *progressView = proceedBarView;
    
    [restFul blockUploadFile:fileData fileType:@"image/jpeg" WithParameter:@{@"apiKey": API_KEY, @"token": tokenKey, @"comment": textFieldComment.text} andReturnType:@"JSON" beingProceed:^(NSInteger didWritten, NSInteger expectWritten) {
        
        // Change the progress view to show the progress of upload file
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [progressView setProgress:((float)didWritten / (float)expectWritten) animated:YES];
        });
        
    } afterCompletion:^(NSMutableData *responseData){
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            // Process after done upload file
            responseModel = [[KUDResponseModel alloc] initWithResponse:responseData];
            NSString *string = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            NSLog(@"%@",string);
            
            if ([responseModel.statusCode isEqualToNumber:@200]) {
                
                [self showNotificationWithMessage:@"Successful upload your file ^^" andIcon:@"icon_checked_green"];
            } else {
             
                [self showNotificationWithMessage:@"Can't upload this file" andIcon:@"icon_error"];
            }
        });
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    } ifErrorAppear:^(NSError *error) {
        
        // If have any error appear, it will show on AlertView
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:error.localizedDescription
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil] show];
    }];
    
}



@end













