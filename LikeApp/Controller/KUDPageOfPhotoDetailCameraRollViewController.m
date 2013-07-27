//
//  KUDPageOfPhotoDetailCameraRollViewController.m
//  LikeApp
//
//  Created by Nhat Huy on 6/17/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import "KUDPageOfPhotoDetailCameraRollViewController.h"

@interface KUDPageOfPhotoDetailCameraRollViewController ()

@property (nonatomic) CGFloat widthImage;
@property (nonatomic) CGFloat heightImage;

@end

@implementation KUDPageOfPhotoDetailCameraRollViewController

@synthesize imageView, imageInfo, widthImage, heightImage;

#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithImageOfPicker:(NSDictionary *)infoOfPickedPhoto {
    self = [super init];
    if (self) {
        
        // Get ImageInfo
        self.imageInfo = infoOfPickedPhoto;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImage *imageOriginal = [imageInfo objectForKey:@"UIImagePickerControllerOriginalImage"];
    [imageView setImage:imageOriginal];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self changeUIImageViewFrame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIInterface rotation delegate

- (BOOL)shouldAutorotate {
    
    return YES;
}



#pragma mark - Change the UIImageView frame

- (void)changeUIImageViewFrame {
    
    // Calculate the new ratio for size of image
    widthImage = imageView.image.size.width;
    heightImage = imageView.image.size.height;
    
    // Change size of UIImageView to competible with orientation of image
    if (widthImage < heightImage) {
        
        [imageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    } else {
        
        [imageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.width / self.view.frame.size.height) * self.view.frame.size.height)];
    }
    
    [imageView setCenter:self.view.center];}

@end
