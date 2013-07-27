//
//  KUDPhotoDetailOfCameraRollViewController.h
//  LikeApp
//
//  Created by Nhat Huy on 6/17/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUDPageOfPhotoDetailCameraRollViewController.h"
#import "KUDRESTFul.h"
#import "KUDResponseModel.h"

@interface KUDPhotoDetailOfCameraRollViewController : UIPageViewController <UIPageViewControllerDataSource, UIAlertViewDelegate>

// ImageInfo when picker
@property (strong,nonatomic) NSDictionary *imageOfPicker;

// NavigationBar
@property (strong,nonatomic) UINavigationBar *navigationBar;
@property (strong,nonatomic) UINavigationItem *navigationItem;
@property (strong,nonatomic) UIBarButtonItem *buttonBackToLibrary;
@property (strong,nonatomic) UIBarButtonItem *buttonEditComment;
@property (strong,nonatomic) UIBarButtonItem *buttonUpload;

// TextField, Label and Shadow
@property (strong,nonatomic) UITextField *textFieldComment;
@property (strong,nonatomic) UILabel *labelComment;
@property (strong,nonatomic) UIImageView *shadowImage;

// Proceed Bar
@property (strong,nonatomic) UIProgressView *proceedBarView;

// Gesture on screen
@property (strong,nonatomic) UITapGestureRecognizer *tapGesture;

// Restful
@property (strong,nonatomic) KUDRESTFul *restFul;
@property (strong,nonatomic) KUDResponseModel *responseModel;

- (IBAction)backToLibrary:(id)sender;

@end
