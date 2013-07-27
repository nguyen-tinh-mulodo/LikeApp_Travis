//
//  KUDPhotoDetailOfMainViewController.h
//  LikeApp
//
//  Created by Nhat Huy on 6/13/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUDPageOfPhotoDetailMainViewController.h"
#import "KUDPhotoArray.h"

@interface KUDPhotoDetailOfMainViewController : UIPageViewController <UIPageViewControllerDataSource,UIPageViewControllerDelegate>

// Array of all Photo Controller
@property (strong,atomic) NSMutableArray *arrayOfPhotoViewController;

// Array of PhotoId
@property (strong,atomic) NSMutableArray *arrayOfPhotoPage;

// The photoId be touched on MainView
@property (copy,nonatomic) NSString *photoId;

// Array of photo model
// Use weak to create a weak pointer to the arrayPhotoModel has been created in MainView
// So we don't need to recall API to get arrayOfPhotoModel onemore
@property (weak,atomic) NSArray *arrayOfPhotoModel;

// Photo Model for InitPage
// This is a weak pointer, what reference with the PhotoModel of Image has been touched in MainView
// It will create the First Page of PageView
@property (weak,nonatomic) KUDPhotoModel *photoModelInitPage;

// Temp controller to add Controller into array
@property (strong,nonatomic) KUDPageOfPhotoDetailMainViewController *photoDetail;

// Controller will be show when init page view
@property (strong,nonatomic) KUDPageOfPhotoDetailMainViewController *initPage;

@end
