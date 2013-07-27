//
//  KUDCameraRollViewController.h
//  LikeApp
//
//  Created by Nhat Huy on 6/17/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "KUDPhotoDetailOfCameraRollViewController.h"

@interface KUDCameraRollViewController : UIImagePickerController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

- (void)takePhoto;

@end
