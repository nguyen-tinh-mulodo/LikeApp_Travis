//
//  KUDPageOfPhotoDetailCameraRollViewController.h
//  LikeApp
//
//  Created by Nhat Huy on 6/17/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KUDPageOfPhotoDetailCameraRollViewController : UIViewController

@property (weak,nonatomic) IBOutlet UIImageView *imageView;



@property (strong,nonatomic) NSDictionary *imageInfo;

- (id)initWithImageOfPicker:(NSDictionary *)imageInfo;


@end
