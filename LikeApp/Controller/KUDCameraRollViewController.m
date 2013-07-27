//
//  KUDCameraRollViewController.m
//  LikeApp
//
//  Created by Nhat Huy on 6/17/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

// Check the type of TARGET BUILD
#if TARGET_IPHONE_SIMULATOR
    NSString *device = @"simulator";
#else
    NSString *device = @"device";
#endif

#import "KUDCameraRollViewController.h"

@interface KUDCameraRollViewController ()

@end

@implementation KUDCameraRollViewController

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
    
    // Set Delegate of ImagePicker
    self.delegate = self;
	// Do any additional setup after loading the view.
    // [self setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    KUDPhotoDetailOfCameraRollViewController *pageViewOfPhotoDetailCameraRollView = [segue destinationViewController];
    
    pageViewOfPhotoDetailCameraRollView.imageOfPicker = sender;
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    UIImageWriteToSavedPhotosAlbum(image, nil,nil,nil);
    [picker dismissModalViewControllerAnimated:YES];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (self.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            // save image
            UIImageWriteToSavedPhotosAlbum(image, nil,nil,nil);
        }
        
        // Init PhotoDetailOfCameraRollView
        KUDPhotoDetailOfCameraRollViewController *pageViewOfPhotoDetailCameraRollView = [[KUDPhotoDetailOfCameraRollViewController alloc] init];
        pageViewOfPhotoDetailCameraRollView.imageOfPicker = info;
        // Push to PhotoDetailOfCameraRollView
        [self pushViewController:pageViewOfPhotoDetailCameraRollView animated:YES];
        
    } else {
        
        // Init PhotoDetailOfCameraRollView
        KUDPhotoDetailOfCameraRollViewController *pageViewOfPhotoDetailCameraRollView = [[KUDPhotoDetailOfCameraRollViewController alloc] init];
        pageViewOfPhotoDetailCameraRollView.imageOfPicker = info;
        // Push to PhotoDetailOfCameraRollView
        [self pushViewController:pageViewOfPhotoDetailCameraRollView animated:YES];
        
    }
    
    // show statusbar and navigation
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    [self setNavigationBarHidden:NO];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    // If view is in Camera, touch cancel will return to library. If view is in library, touch cancel will dismiss view
    if (self.sourceType == UIImagePickerControllerSourceTypeCamera || self.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        
        [self setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self.navigationBar setFrame:CGRectMake(0,19, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height)];
    } else {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    [self setNavigationBarHidden:NO];
}

// Add the camera button into Navigation Bar
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    UINavigationItem *top = navigationController.navigationBar.topItem;
    top.title = @"Photos";
    UIBarButtonItem *secondButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePhoto)];
    //UIBarButtonItem *secondButton = [[UIBarButtonItem alloc] initWithTitle:@"Take Photo" style:UIBarButtonItemStylePlain target:self action:@selector(takePhoto)];
    //[secondButton setImage:[UIImage imageNamed:@"Camera-icon.png"]];
    top.leftBarButtonItem = secondButton;
    
}

#pragma mark - Change to Camera View

-(void)takePhoto {
    
    if ([device isEqualToString:@"simulator"]) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Can't open camera on simulator!"
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    } else {
        [self setSourceType:UIImagePickerControllerSourceTypeCamera];
    
    }
}

@end
