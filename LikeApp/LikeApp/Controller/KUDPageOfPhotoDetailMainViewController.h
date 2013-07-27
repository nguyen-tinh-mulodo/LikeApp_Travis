//
//  KUDPhotoDetailViewController.h
//  LikeApp
//
//  Created by Nhat Huy on 6/13/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUDRESTFul.h"
#import "KUDPhotoModel.h"
#import "KUDListOfLikerModel.h"

@interface KUDPageOfPhotoDetailMainViewController : UIViewController <UIGestureRecognizerDelegate>

// Outlet
@property (weak,nonatomic) IBOutlet UILabel *labelNameOfUploader;
@property (weak,nonatomic) IBOutlet UILabel *labelCommentOfPhoto;
@property (weak,nonatomic) IBOutlet UILabel *labelNumberLikes;
@property (weak,nonatomic) IBOutlet UIImageView *imageViewOfPhoto;
@property (weak,nonatomic) IBOutlet UIButton *likeButton;

// Layer background
@property (weak,nonatomic) IBOutlet UIView *layerUploader;
@property (weak,nonatomic) IBOutlet UIView *layerComment;

// Photo Model
// With this weak pointer, We don't need to call API getPhoto again to get info of this photo.
// We just use the Photo Model, what we has been get from API in MainView
@property (weak,nonatomic) KUDPhotoModel *photoModel;

// ListLiked Model
@property (strong,nonatomic) KUDListOfLikerModel *listLiker;

// PhotoId of this Page
@property (copy,nonatomic) NSString *photoId;

// RESTFul
@property (strong,nonatomic) KUDRESTFul *restFul;

// Token
@property (strong,nonatomic) NSString *token;


// Method
- (id)initWithPhotoId:(NSString *)idOfPhoto;

// Call API LikePhoto
- (IBAction)likePhoto:(id)sender;

// Trigger when we tap on screen to hide or unhide infomation of image
- (IBAction)tapOnScreen:(id)sender;

@end
