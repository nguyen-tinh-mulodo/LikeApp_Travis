//
//  KUDPhotoDetailViewController.m
//  LikeApp
//
//  Created by Nhat Huy on 6/13/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import "KUDPageOfPhotoDetailMainViewController.h"
#import "KUDResponseModel.h"
#import "KUDConstants.h"
#import <QuartzCore/QuartzCore.h>


@interface KUDPageOfPhotoDetailMainViewController ()

// Check whether the comment and uploader banner should be visible of invisible
@property (nonatomic) BOOL visibleBanner;

// Width and Height of Image to scale that image competible with screen
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@end

@implementation KUDPageOfPhotoDetailMainViewController

@synthesize photoId, restFul, imageViewOfPhoto, photoModel;
@synthesize labelCommentOfPhoto, labelNameOfUploader, likeButton, labelNumberLikes;
@synthesize listLiker;
@synthesize layerComment, layerUploader;
@synthesize token;
@synthesize visibleBanner, width, height;

#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPhotoId:(NSString *)idOfPhoto {
    self = [super init];
    if (self) {
        // Custom initialization
        self.photoId = idOfPhoto;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get TokenKey
    token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];

    // Init RESTFul
    restFul = [[KUDRESTFul alloc] init];
    restFul.baseUrl = URL_API;
    
    // Set Comment banner position competible with 3.5" screen
    [layerComment setFrame:CGRectMake(0, self.view.frame.size.height - layerComment.frame.size.height, self.view.frame.size.width, layerComment.frame.size.height)];
    
    // Call API
    // [self getPhoto];
    
    // Check whether this photo is liked by current user
    [self isLikedByCurrentUser];
    
    // Load photo by info in Photo Model
    [self loadByPhotoModel];
    
    // Hide Comment banner and UserBanner
    [self hideAllBanner];
    
    // Set Font for navigation
    
}

- (void)loadByPhotoModel {
    
    // Load photo from url --------------------------- Test
    [self loadPhotoByName: photoModel.l_photo_link];
    
    // Set Comment
    labelCommentOfPhoto.text = photoModel.comment;
    
    // Set Uploader
    labelNameOfUploader.text = photoModel.uploader;
    
    // Set NumberLike
    labelNumberLikes.text = photoModel.numberLikes;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated {
    
    if (imageViewOfPhoto.image != nil) {
        
        // Change UIImageViewFrame to competible with orientation of photo
        [self changeUIImageViewFrame];
        
    }
    
    // Change content frame of LayerComment to competible with landscape screen
    [self changeContentFrameOfLayerComment];
    
    // Hide all banner
    [self hideAllBanner];
    
    // Auto visible banner comment and username
    [self unHideAllBanner];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    // Auto visible banner comment and username
    [self hideAllBanner];
}

- (void)viewDidDisappear:(BOOL)animated {
    
}

#pragma mark - Animation Label

- (void)hideAllBanner {
    
    // Hide All banner
    // [self.navigationController.navigationBar setHidden:YES];
    [layerComment setHidden:YES];
    [layerUploader setHidden:YES];
    visibleBanner = NO;
    [self toggleBanner:nil];
}

- (void)unHideAllBanner {
    
    visibleBanner = YES;
    [self toggleBanner:nil];
}

- (IBAction)toggleBanner:(id)sender {
    
    // Hide or Unhide All banner
    if (visibleBanner) {
        
        // Visible 2 Banner to animation
        [layerComment setHidden:NO];
        [layerUploader setHidden:NO];
        // [self.navigationController.navigationBar setHidden:NO];
        
        [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            [layerComment setFrame:CGRectMake(0, layerComment.frame.origin.y, layerComment.frame.size.width, layerComment.frame.size.height)];
            [layerUploader setFrame:CGRectMake(self.view.frame.size.width - layerUploader.frame.size.width, layerUploader.frame.origin.y, layerUploader.frame.size.width, layerUploader.frame.size.height)];
            
            [self.navigationController.navigationBar.layer setOpacity:1];
            
            [self.view setNeedsLayout];
            
        } completion:^(BOOL finished) {
            if(finished) {
                
            }
        }];
    } else {
        
        // Hide 2 banner
        [self hideBanner];
    }
    
}

// Hide 2 banner of Uploader and Comment
- (void)hideBanner {
    
    [UIView animateWithDuration:0.5 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        [layerComment setFrame:CGRectMake( -layerComment.frame.size.width, layerComment.frame.origin.y, layerComment.frame.size.width, layerComment.frame.size.height)];
        
        [layerUploader setFrame:CGRectMake(self.view.frame.size.width + layerUploader.frame.size.width, self.navigationController.navigationBar.frame.size.height + 10, layerUploader.frame.size.width, layerUploader.frame.size.height)];    
        
        // [self.navigationController.navigationBar.layer setOpacity:0];
    
    } completion:^(BOOL finished) {
        if(finished) {
            
            [layerComment setHidden:YES];
            [layerUploader setHidden:YES];
            // [self.navigationController.navigationBar setHidden:YES];
        }
    }];
}


#pragma mark - Call APIs

- (void)isLikedByCurrentUser {
    
    // Send request
    restFul.apiUrl = @"IsLikedPhoto";
    
    [restFul blockPostRequestWithParameter:@{@"apiKey": API_KEY, @"token": token, @"photoId": photoId} andReturnType:@"JSON" byEncType:@"application/x-www-form-urlencoded" afterCompletion:^(NSMutableData *data) {
        
        // Get response
        KUDResponseModel *errorMessage = [[KUDResponseModel alloc] initWithResponse:data];
        if([errorMessage.statusCode isEqualToNumber:[NSNumber numberWithInt:200]]) {
            
            // Parse JSON data
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            // Check whether current user is liked this photo
            if([[[jsonObject objectForKey:@"response"] objectForKey:@"isLiked"] isEqualToNumber:@1]) {
                
                [likeButton setEnabled:NO];
                [likeButton setImage:[UIImage imageNamed:@"icon_checked_white@2x"] forState:UIControlStateDisabled];
            } else {
                
                [likeButton setEnabled:YES];
                [likeButton setUserInteractionEnabled:YES];
            }
            
        }
    } ifErrorAppear:^(NSError *error){
    
        NSLog(@"%@", error.localizedDescription);
    }];
}


#pragma mark - Load Photo from URL

- (void)loadPhotoByName:(NSString *)photoName {
    
    // Create URL
    NSString *stringUrl = [NSString stringWithFormat:@"%@%@",URL_API_Photo, photoName];
    
    NSURL *urlRequest = [NSURL URLWithString:stringUrl];
    
    // Create Reuqest
    // NSURLRequest *request = [[NSURLRequest alloc] initWithURL:urlRequest];
    
    // Test Cache Photo
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:urlRequest cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    // Create new queue
    NSOperationQueue *queueToLoadPhoto = [NSOperationQueue new];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // Send request with asynchorous style
    [NSURLConnection sendAsynchronousRequest:request queue:queueToLoadPhoto completionHandler:^(NSURLResponse *urlResponse, NSData *responseData, NSError *error) {
        
        // Check Error
        if (![[[urlResponse MIMEType] substringToIndex:5] isEqualToString:@"image"]) {
            
            return;
        }
        
        if (error != nil) {
            
            NSLog(@"%@", error);
        }
        
        
        // Create UIImage
        UIImage *image = [UIImage imageWithData:responseData];
        
        // Change thhe UIImageView to competible with orientation of image
        width = image.size.width;
        height = image.size.height;
        
        // Send UIImage to UIImageView
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [imageViewOfPhoto setAlpha:0];
            
            // Check the orientation of device to set frame of UIImageView to competible with screen
            if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
                
                [imageViewOfPhoto setFrame:CGRectMake(0, 0, (self.view.frame.size.height / height) * width,self.view.frame.size.height)];
            } else {
                
                [imageViewOfPhoto setFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.width / width) * height)];
            }
            
            // Move the photo to the center of screen
            [imageViewOfPhoto setCenter:self.view.center];
            [imageViewOfPhoto setImage:image];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                [imageViewOfPhoto setAlpha:1];
            }];
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
        
        
    }];
    
}

#pragma mark - IBAction

- (IBAction)tapOnScreen:(id)sender {
    
    if (visibleBanner) {
        
        visibleBanner = NO;
        [self toggleBanner:nil];
    } else {
        
        visibleBanner = YES;
        [self toggleBanner:nil];
    }
}

- (IBAction)likePhoto:(id)sender {
    
    // Network indicator animate
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // Call API
    restFul.apiUrl = @"LikePhoto";
    
    [restFul blockPostRequestWithParameter:@{@"apiKey": API_KEY, @"token": token, @"photoId": photoModel.photoId} andReturnType:@"JSON" byEncType:nil afterCompletion:^(NSMutableData *data){
        
        KUDResponseModel *errorMessage = [[KUDResponseModel alloc] initWithResponse:restFul.responseData];
        if([errorMessage.statusCode isEqualToNumber:[NSNumber numberWithInt:200]]) {
            
            // Alert Success
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You liked that photo!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
            [alertView show];
            
            // Change color of button Like
            [likeButton setEnabled:NO];
            [likeButton setImage:[UIImage imageNamed:@"icon_checked_white"] forState:UIControlStateDisabled];
            [labelNumberLikes setText:[NSString stringWithFormat:@"%d",[labelNumberLikes.text integerValue] + 1]];
            photoModel.numberLikes = [NSString stringWithFormat:@"%d", photoModel.numberLikes.intValue + 1];
        }
        
        // Network indicator animate
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } ifErrorAppear:^(NSError *error){
    
        // Network indicator animate
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}


#pragma mark - Gesture Delegate 

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    // Get the location of the gesture on view
    CGPoint locationInView = [gestureRecognizer locationInView:layerComment];
    
    // Check whether you are tapping on likeButton
    // If tap on likeButton, it will choose action of button, not choose action of gesture
    if (CGRectContainsPoint(likeButton.frame, locationInView)) {
        
        return NO;
    } else {
        
        return YES;
    }
    
}

#pragma mark - Rotation Screen Delegate

// Hidden 2 Banner to make Rotate more smooth
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // Change the size and position of layerComment
    [layerComment setFrame:CGRectMake(0, self.view.frame.size.height - layerComment.frame.size.height, self.view.frame.size.width, layerComment.frame.size.height)];
    
    // Set Content of comment banner competible with Landscape screen
    [self changeContentFrameOfLayerComment];
    
    
    // Hide all banner
    [self hideAllBanner];
    
}

// Make 2 banner competible with new orientation screen
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    [self changeUIImageViewFrame];
    
    // Show 2 banner
    [self unHideAllBanner];
    
    // [self.view setNeedsLayout];
}

#pragma mark - Change the content when rotate

- (void)changeUIImageViewFrame {
    
    // Check whether this image is nil
    if (imageViewOfPhoto.image == nil) {
        
        return;
    }
    
    // Calculate the new ratio for size of image
    width = imageViewOfPhoto.image.size.width;
    height = imageViewOfPhoto.image.size.height;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            
            // Change size of UIImageView to competible with screen
            if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
                
                [imageViewOfPhoto setFrame:CGRectMake(0, 0, (self.view.frame.size.height / height) * width,self.view.frame.size.height)];
            } else {
                
                [imageViewOfPhoto setFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.width / width) * height)];
            }
        
        }];
        
        // Move the Image to center of screen
        [imageViewOfPhoto setCenter:self.view.center];
    });
    
}

- (void)changeContentFrameOfLayerComment {
    
    // Change the size and position of layerComment to competible with Screen
    [layerComment setFrame:CGRectMake(0, self.view.frame.size.height - layerComment.frame.size.height, self.view.frame.size.width, layerComment.frame.size.height)];
    
    // Set Content of comment banner competible with Landscape screen
    [likeButton setFrame:CGRectMake( self.view.frame.size.width - likeButton.frame.size.width - 13, 11, likeButton.frame.size.width, likeButton.frame.size.height)];
    [labelCommentOfPhoto setFrame:CGRectMake( labelCommentOfPhoto.frame.origin.x, labelCommentOfPhoto.frame.origin.y, self.view.frame.size.width - 66 - 50, labelCommentOfPhoto.frame.size.height)];
}



@end
