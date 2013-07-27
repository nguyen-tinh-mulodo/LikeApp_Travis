//
//  KUDMainViewController.h
//  LikeApp
//
//  Created by Nhat Huy on 6/10/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUDRESTFul.h"
#import "KUDPhotoArray.h"
#import "KUDPhotoModel.h"

@interface KUDMainViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate>

// ScrollView 
@property (strong,nonatomic) IBOutlet UIScrollView *scrollView;

// Pan gesture IBOutlet
@property (weak,nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;

// Array of Image
@property (strong,nonatomic) NSMutableArray *arrayOfImage;
@property (strong,nonatomic) NSMutableArray *arrayOfPhotoId;
@property (strong,nonatomic) NSMutableArray *arrayOfBannerInfoOfImage;
@property (strong,nonatomic) NSMutableArray *arrayOfCommentBanner;

// Array of label Number Likes
@property (strong,nonatomic) NSMutableDictionary *arrayOfLikeNumber;

// RESTFul
@property (strong,nonatomic) KUDRESTFul *restFul;

// Array of Photo
@property (strong,nonatomic) KUDPhotoArray *arrayPhotoModel;
@property (strong,nonatomic) NSArray *photoModels;

// Pull to refresh
@property (strong,nonatomic) UIRefreshControl *refreshControl;

// Token key
@property (strong,nonatomic) NSString *tokenKey;

// Log out user
- (IBAction)logout:(id)sender;

- (void)cancelQueueLoadPhotoFromURL;

@end
