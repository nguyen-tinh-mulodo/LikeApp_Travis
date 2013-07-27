//
//  KUDMainViewController.m
//  LikeApp
//
//  Created by Nhat Huy on 6/10/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import "KUDMainViewController.h"
#import "KUDRESTFulDelegate.h"
#import "KUDResponseModel.h"
#import "KUDPhotoDetailOfMainViewController.h"
#import "KUDConstants.h"
#import "KUDQuickNavigationViewController.h"
#import "KUDCallAPI.h"

#import <QuartzCore/QuartzCore.h>

// Create Class extensions of UIButton to store data. Use to LikePhoto
@interface UIButton ()

//@property UILabel *weakLabelNumberLike;
//@property KUDPhotoModel *photoModelOfThisButton;

@end
/////////////////////////////////////////////
/////////////////////////////////////////////
/////////////////////////////////////////////
@interface KUDMainViewController ()

// QuickNavigation
@property (strong,nonatomic) KUDQuickNavigationViewController *quickNavigation;

// OperationQueue for load photo from server
@property (strong,nonatomic) NSOperationQueue *operationQueueForLoadPhoto;

@end

@implementation KUDMainViewController

@synthesize scrollView, quickNavigation, panGesture;
@synthesize arrayOfImage, arrayOfCommentBanner, arrayOfBannerInfoOfImage, arrayOfLikeNumber;
@synthesize restFul;
@synthesize arrayPhotoModel;
@synthesize refreshControl;
@synthesize arrayOfPhotoId;
@synthesize tokenKey;
@synthesize operationQueueForLoadPhoto;

#pragma mark - Init

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
    
    // Init Scroll View
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [scrollView setBackgroundColor:[UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:1]];
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 100)];
    [self.view addSubview:scrollView];
    
    // Add UIRefresh
    refreshControl = [[UIRefreshControl alloc] init];
    // [refreshControl setTintColor:[UIColor darkTextColor]];
    
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh ..."];
    
    [refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [scrollView addSubview:refreshControl];
    
    // Create UIImageView
    //[self createArrayOfUIImageView];
    
    // Init RESTFul
    restFul = [[KUDRESTFul alloc] init];
    restFul.baseUrl = URL_API;
    
    // Get TokenKey
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"] != nil) {
        
        tokenKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    } else {
        
        [self logoutWithToken];
    }
    
    
    // Init navigations
    quickNavigation = [[KUDQuickNavigationViewController alloc] init];
    
    // Reference navigation controller
    quickNavigation.viewController = self.navigationController;
    
    // Reference with self
    quickNavigation.weakSelf = self;
    
    // Hidden Navigation
    [quickNavigation.tableView setFrame:CGRectMake( -quickNavigation.tableView.frame.size.width - 2, quickNavigation.tableView.frame.origin.y, quickNavigation.tableView.frame.size.width, quickNavigation.tableView.frame.size.height)];

    // Add Navigation into subview
    [self.view addSubview:quickNavigation.tableView];
    
    // Setup PanGesture
    [panGesture setDelegate:self];
    [panGesture addTarget:self action:@selector(beingPanGesture)];
    
    // Create NSOperation to stop download when need
    operationQueueForLoadPhoto = [NSOperationQueue new];
    
    // Set concurent to force the operation will run serializable
    [operationQueueForLoadPhoto setMaxConcurrentOperationCount:1];

    
    // nhtinh test
    [self.scrollView setAccessibilityLabel:@"scrollView"];
     
}

- (void)viewDidAppear:(BOOL)animated {
    
    // Check -------------------------------------------------------------------------------------------*
    if (arrayOfImage == nil) {
        // Init Array of UIImageView and Comment
        arrayOfImage = [[NSMutableArray alloc] init];
        arrayOfCommentBanner = [[NSMutableArray alloc] init];
        arrayOfPhotoId = [[NSMutableArray alloc] init];
        arrayOfBannerInfoOfImage = [[NSMutableArray alloc] init];
        
        // Array contain Lable Like Number
        arrayOfLikeNumber = [[NSMutableDictionary alloc] init];
        
        // Call API
        [self getTop20];
    } else {
        
        // Refresh Number Likes of Photo
        [self.view setNeedsLayout];
        for (KUDPhotoModel *photoModel in arrayPhotoModel.arrayOfPhotoModel) {
            
            UILabel __weak *labelNumberLikes = [arrayOfLikeNumber objectForKey:photoModel.photoId];
            labelNumberLikes.text = photoModel.numberLikes;
        }
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Reload ScrollView

- (void)reloadScrollView {
    
    // Cancel All Download Image to redownload
    [self cancelQueueLoadPhotoFromURL];
    
    // Release Old Data
    [arrayOfImage removeAllObjects];
    [arrayOfCommentBanner removeAllObjects];
    [arrayOfPhotoId removeAllObjects];
    [arrayOfBannerInfoOfImage removeAllObjects];
    [arrayOfLikeNumber removeAllObjects];
    [arrayPhotoModel.arrayOfPhotoModel removeAllObjects];
    
    CGFloat delay = 0.0;
    
    for (UIImageView *object in scrollView.subviews) {
        
        if (![object isKindOfClass:[UIRefreshControl class]]) {
            
            [UIView animateWithDuration:0.3 delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
                
                [object setAlpha:0];
            } completion:^(BOOL finished) {
                
                [object removeFromSuperview];
            }];
        }
        
        // Just delay the UIImage second
        if ([scrollView.subviews indexOfObject:object] == 1) {
            delay = 0.2;
        } else {
            delay = 0.0;
        }
    }
    
    // Recall API
    [self getTop20];
}

#pragma mark - Refresh view by pull scrollView

- (void)refreshView:(UIRefreshControl *)refresh {
    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing ..."];
    
    // Reaload scrollview
    [self reloadScrollView];
    
    // Set refreshControl title
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M dd, h:mm a"];
    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:[dateFormatter stringFromDate:[NSDate date]]];
    [refresh endRefreshing];
    
}


#pragma mark - Call APIs

// Call API Get Top20 then load photo from host by information of response data
- (void)getTop20 {
    
    // Init apiURL
    restFul.apiUrl = @"GetTopPhoto";
    
    KUDMainViewController __weak *weakSelf = self;
    
    [restFul blockPostRequestWithParameter:@{@"apiKey": API_KEY,@"token": tokenKey, @"limit": @"20", @"offset": @"0"} andReturnType:@"JSON" byEncType:nil afterCompletion:^(NSMutableData *data){
        
        // Init Response Model
        KUDResponseModel *errorMessage = [[KUDResponseModel alloc] initWithResponse:[NSData dataWithData:data]];

        switch ([errorMessage.statusCode integerValue]) {
            case 200: { // Load API success
                
                // Setup arrayPhotoModel
                arrayPhotoModel = [[KUDPhotoArray alloc] initWithData:data];
                
                // Load photo
                [weakSelf loadPhotoFromURL];
                break;
            }
                
            case 401: { // The token key is expired
                
                // Logout immediately
                [weakSelf logoutWithToken];
                break;
            }
                
            default:
                break;
        }
     
    
        
        
    } ifErrorAppear:^(NSError *error){
    
        NSLog(@"%@", error.localizedDescription);
    }];
    
}

- (void)logoutWithToken {
    
    // Init apiUrl
    restFul.apiUrl = @"LogoutWithToken";
    
    // Init Response Model
    
    KUDResponseModel __block *errorMessage = nil;
    
    KUDMainViewController __weak *weakSelf = self;
    
    [restFul blockPostRequestWithParameter:@{@"apiKey": API_KEY, @"token": tokenKey} andReturnType:@"JSON" byEncType:nil afterCompletion:^(NSMutableData *data){
        
        // Init Response Model from response data
        errorMessage = [[KUDResponseModel alloc] initWithResponse:[NSData dataWithData:data]];
        
        // Create a reusable block
        void (^RemoveUserDefaultAndComeBackToConnectionView)(void) = ^() {
            
            if([errorMessage.statusCode isEqualToNumber:@200] || [errorMessage.statusCode isEqualToNumber:@401]) {
                
                // Remove Token in User Defaults
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"token"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // Return to Connection View
                [weakSelf dismissViewControllerAnimated:YES completion:^{}]; 
            }
        };
                
        switch ([errorMessage.statusCode integerValue]) {
            case 200: {
                
                RemoveUserDefaultAndComeBackToConnectionView();
                break;
            }
                
            case 401: {
                
                RemoveUserDefaultAndComeBackToConnectionView();
                break;
            }
                
            default:
                break;
        }

        // Turn off network indicator
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } ifErrorAppear:^(NSError *error) {
        
        NSLog(@"%@",error.localizedDescription);
    }];
}


#pragma mark - Load Photo from URL

// Load photo from host by information of response data what we get by call getTop20 API
- (void)loadPhotoFromURL {
    
        
    // Create weak pointer to avoid Cycle Retain
    KUDMainViewController __weak *weakSelf = self;
    KUDPhotoArray __weak *weakPhotoArray = arrayPhotoModel;
    UIScrollView  __weak *weakScrollView = scrollView;
    NSArray __weak *weakArrayOfBannerInfo = arrayOfBannerInfoOfImage;
    
    // If use dispatch, so hard to stop
    // dispatch_queue_t dispatchQueueToLoadPhoto = dispatch_queue_create("GCD load Photo", DISPATCH_QUEUE_SERIAL);
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // Enumerate the arrayOfPhotoModel
    for (KUDPhotoModel *photo in arrayPhotoModel.arrayOfPhotoModel) {
        
        KUDPhotoModel __weak *weakPhotoModel = photo;
        
        // Create BlockOperation to stop donwload image when we need
        NSBlockOperation __block *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            
            if(blockOperation.isCancelled) {
                
                return;
            }
            
            if (weakPhotoModel.s_photo_link == nil) {
                
                return;
            }
            
            // Get Photo Link
            NSString *urlString = [NSString stringWithFormat:@"%@%@", URL_API_Photo, weakPhotoModel.s_photo_link];
            
            // Create NSURL from urlString
            NSURL *imageUrl = [NSURL URLWithString:urlString];
            
            // Create request
            // Config cache
            NSURLRequest *requestImage = [[NSURLRequest alloc] initWithURL:imageUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
            
            // Init ResponseUrl and NSError
            NSURLResponse *urlResponse = nil;
            NSError *error = nil;
            
            // Check whether this operation has been cancelled
            if(blockOperation.isCancelled) {
                
                return;
            }
            
            // Get Response by request with Synchronous style
            NSData *responseData = [NSURLConnection sendSynchronousRequest:requestImage returningResponse:&urlResponse error:&error];
        
            // Check whether this operation has been cancelled
            if(blockOperation.isCancelled) {
                
                return;
            }
        
            if(!responseData) {
                
                [weakPhotoArray.arrayOfPhotoModel removeObject:weakPhotoModel];
                NSLog(@"Download photo fail");
                return;
            }
        
            // Check whether we get exactly a image response
            if([[[urlResponse MIMEType] substringToIndex:5] isEqualToString:@"image"]) {
                
                // Create UIImage
                weakPhotoModel.mPhoto = [UIImage imageWithData:responseData];
                
                // Create UIImageView
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    // Create Button of UIImageView
                    [weakSelf createUIImageViewWithModel:weakPhotoModel];
                    
                    // Change content size of ScrollView
                    [weakScrollView setContentSize:CGSizeMake(weakSelf.view.frame.size.width, [[weakArrayOfBannerInfo lastObject] frame].origin.y + [[weakArrayOfBannerInfo lastObject] frame].size.height + 60 )];
                    [weakScrollView setNeedsDisplay];
                    [weakSelf.view setNeedsDisplay];
                    
                    //NSLog(@"Dispatch");
                }); 
            } else {
                
                [weakPhotoArray.arrayOfPhotoModel removeObject:weakPhotoModel];
                NSLog(@"It's not image");
            }

        }]; 
                
        // Add Operation into OperationQueue
        [operationQueueForLoadPhoto addOperation:blockOperation];
    }
    
    [operationQueueForLoadPhoto addOperationWithBlock:^{
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
}

- (void)cancelQueueLoadPhotoFromURL {
    
    // Cancel all download image
    [operationQueueForLoadPhoto cancelAllOperations];
    
    // Turn of network indicator
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


#pragma mark - DataSource for ScrollView

- (void)createUIImageViewWithModel:(KUDPhotoModel *)photoModel {
    
    // Start Point of First Image
    CGFloat position = 60;
    
    // Init UIImageView
    UIButton *imageView = nil;
    imageView = [[UIButton alloc] init];
    
    // Load UIImage
    [imageView setBackgroundImage:photoModel.mPhoto forState:UIControlStateNormal];
    
    // Create Ratio
    CGFloat height = photoModel.mPhoto.size.height;
    CGFloat width = photoModel.mPhoto.size.width;
    
    // Set up the position of image on scrollView
    if (arrayOfImage.count == 0) {
        
        [imageView setFrame:CGRectMake(10, position, 313, ( 313 / width ) * height )];
    } else {
        
        CGRect oldPointOfBanner = [[arrayOfBannerInfoOfImage lastObject] frame];
        [imageView setFrame:CGRectOffset([[arrayOfBannerInfoOfImage lastObject] frame], 0, oldPointOfBanner.size.height + 10)];
    }
    
    // Hidden image to fadeIn
    [imageView setAlpha:0];
    
    // Check Image Rotation
    if (photoModel.mPhoto.size.width < photoModel.mPhoto.size.height) {
        // UIImageView with portraint
        [imageView setFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 313, ( 313 / width ) * height )];
    } else {
        // UIImageView with Landscape
        [imageView setFrame:CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 313, ( 313 / width ) * height )];
    }
    
    // Set UIImage
    [imageView setBackgroundImage:photoModel.mPhoto forState:UIControlStateNormal];
    
    // Set shadow for image
    [imageView.layer setShadowColor:[UIColor darkTextColor].CGColor];
    [imageView.layer setShadowOpacity:1];
    [imageView.layer setShadowOffset:CGSizeMake(-1, 2)];
    [imageView.layer setShadowRadius:1];
    [imageView.layer setShadowPath:[[UIBezierPath bezierPathWithRect:imageView.bounds] CGPath]];
    
    // Push into Array of UIImageView
    [arrayOfImage addObject:imageView];
    
    // Set PhotoId into array
    [arrayOfPhotoId insertObject:photoModel.photoId atIndex:[arrayOfImage indexOfObject:imageView]];
    //[arrayOfPhotoId addObject:photoId];
    
    // Add Event Control for this image
    [imageView addTarget:self action:@selector(showDetailPhotoOfMainView:) forControlEvents:UIControlEventTouchUpInside];
    
    // Add to subviews
    [scrollView addSubview:imageView];
    
    // Create Banner Info for this ImageView
    UIView *bannerInfo = [[UIView alloc] initWithFrame:CGRectOffset(imageView.frame, 0, imageView.frame.size.height)];
    [bannerInfo setFrame:CGRectMake(bannerInfo.frame.origin.x, bannerInfo.frame.origin.y, imageView.frame.size.width, 40)];
    [bannerInfo setBackgroundColor:[UIColor darkTextColor]];
    
    // Set shadow for Banner Info
    [bannerInfo.layer setShadowColor:[UIColor darkTextColor].CGColor];
    [bannerInfo.layer setShadowOpacity:0.8];
    [bannerInfo.layer setShadowOffset:CGSizeMake(-1, 2)];
    [bannerInfo.layer setShadowRadius:1];
    [bannerInfo.layer setShadowPath:[[UIBezierPath bezierPathWithRect:bannerInfo.bounds] CGPath]];
    
    [arrayOfBannerInfoOfImage addObject:bannerInfo];
    
    [self.scrollView addSubview:bannerInfo];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [imageView setAlpha:1];
        
    } completion:^(BOOL finished) {
        
        // Init label
        UILabel *labelLikeNumber = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80, 5, 30, 30)];
        labelLikeNumber.text = photoModel.numberLikes;
        [labelLikeNumber setTextColor:[UIColor whiteColor]];
        [labelLikeNumber setBackgroundColor:[UIColor clearColor]];
        [labelLikeNumber setTextAlignment:NSTextAlignmentRight];
        [arrayOfLikeNumber setObject:labelLikeNumber forKey:photoModel.photoId];
        
        // Set font
        [labelLikeNumber setFont:[UIFont fontWithName:@"GillSans-Light" size:16]];
        
        
        // CreateLikeIcon
        UIButton *imageLikeIcon = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 45, 10, 20, 20)];
        [imageLikeIcon setContentMode:UIViewContentModeRedraw];
        [imageLikeIcon setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
        [imageLikeIcon setImage:[UIImage imageNamed:@"star-2-disable.png"] forState:UIControlStateDisabled];
        [imageLikeIcon addTarget:self action:@selector(likePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [imageLikeIcon setTag:[photoModel.photoId integerValue]];
        if (photoModel.isLiked) {
            
            [imageLikeIcon setEnabled:NO];
        }
        
        // Init label
        UITextView *labelComment = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, bannerInfo.frame.size.width - 80, bannerInfo.frame.size.height)];
        [labelComment setScrollsToTop:NO];
        [labelComment setEditable:NO];
        // [labelComment setAdjustsFontSizeToFitWidth:YES]; // Use for label
        [labelComment setBackgroundColor:[UIColor clearColor]];
        [labelComment setTextAlignment:NSTextAlignmentCenter];
        [labelComment setTextColor:[UIColor whiteColor]];
        if (photoModel.comment.length < 27) {
            
            labelComment.text = photoModel.comment;
        } else {
            
            // Use for label
            //labelComment.text = [NSString stringWithFormat:@"%@ ...", [photoModel.comment substringToIndex:27]];
            
            // Use for TextView
            labelComment.text = photoModel.comment;
        }
       
        // Set font
        [labelComment setFont:[UIFont fontWithName:@"GillSans-Light" size:16]];
        
        // Add to Banner Info of Image
        [bannerInfo addSubview:labelComment];
          
        [bannerInfo addSubview:labelLikeNumber];
        [bannerInfo addSubview:imageLikeIcon];
        
        
    }];
}


#pragma mark - Pass data over Controller in Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"pushToMyPageView"]) {
        
        // Cancel all download image
        [operationQueueForLoadPhoto cancelAllOperations];
    }
    
    if([[segue identifier] isEqualToString:@"pushToDetailPhotoOfMainView"]) {
        
        KUDPhotoDetailOfMainViewController __weak *photoDetailPageView = [segue destinationViewController];
        
        // Get photoId of this Choosen photo
        NSUInteger indexOfImage = [arrayOfImage indexOfObject:sender];
        
        // Get PhotoId
        NSString *photoId = [arrayOfPhotoId objectAtIndex:indexOfImage];
         
        // Pass photoId
        photoDetailPageView.photoId = photoId;
        
        // Pass photoModel
        photoDetailPageView.photoModelInitPage = [arrayPhotoModel.arrayOfPhotoModel objectAtIndex:indexOfImage];
        
        // Pass top20 PhotoId
        photoDetailPageView.arrayOfPhotoPage = [NSArray arrayWithArray:arrayOfPhotoId];
        
        // Pass arrayOfPhotoModel
        photoDetailPageView.arrayOfPhotoModel = arrayPhotoModel.arrayOfPhotoModel;
    }
    
    
}



#pragma mark - IBAction

// Touch up inside the star button on photo banner info
- (void)likePhoto:(UIButton *)likeButton {
    
    [KUDCallAPI likePhoto:[NSString stringWithFormat:@"%d", likeButton.tag] completion:^{
        
        // Alert Like this photo successful
        [[[UIAlertView alloc] initWithTitle:@"Thanks you"
                                    message:@"Successful like this photo"
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil] show];
        
        // Change Label NumberLikes
        UILabel *labelNumberLike = [arrayOfLikeNumber objectForKey:[NSString stringWithFormat:@"%d", likeButton.tag]];
        labelNumberLike.text = [NSString stringWithFormat:@"%d", [labelNumberLike.text integerValue] + 1];
        
        // Change PhotoModel
        for (KUDPhotoModel *photoModel in arrayPhotoModel.arrayOfPhotoModel) {
            
            if ([photoModel.photoId isEqualToString:[NSString stringWithFormat:@"%d", likeButton.tag]]) {
                
                photoModel.numberLikes = labelNumberLike.text;
            }
        }
    } didFail:nil];
}

- (IBAction)showDetailPhotoOfMainView:(id)sender {
    
    [self performSegueWithIdentifier:@"pushToDetailPhotoOfMainView" sender:sender];
}

- (IBAction)logout:(id)sender {
    
    // Cancel loadPhoto from url
    [self cancelQueueLoadPhotoFromURL];
    
    // Call API Logout
    [self logoutWithToken];
}


#pragma mark - UIPanGesture Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return YES;
}

- (void)beingPanGesture {
    
    static CGFloat translationBefore;
    static int count = 0;
    static BOOL checkPoint = YES;
    CGPoint translationOfGesture = [panGesture translationInView:self.view];
    
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        
    }
    
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        
        
        
        // Check if gesture is pan to left
        if (translationOfGesture.x <= 0 && quickNavigation.tableView.frame.origin.x != - quickNavigation.tableView.frame.size.width) {
            
            if (quickNavigation.tableView.frame.origin.x == - quickNavigation.tableView.frame.size.width - 2) {
                
                return;
            }
            
            if (quickNavigation.tableView.frame.origin.x == 0) {
                
                [quickNavigation.tableView setFrame:CGRectMake( translationOfGesture.x  , quickNavigation.tableView.frame.origin.y, quickNavigation.tableView.frame.size.width, quickNavigation.tableView.frame.size.height)];
            } else {
                [quickNavigation.tableView setFrame:CGRectMake( translationOfGesture.x, quickNavigation.tableView.frame.origin.y, quickNavigation.tableView.frame.size.width, quickNavigation.tableView.frame.size.height)];
            }
            //[quickNavigation.tableView setFrame:CGRectMake( translationOfGesture.x, quickNavigation.tableView.frame.origin.y, quickNavigation.tableView.frame.size.width, quickNavigation.tableView.frame.size.height)];
            
        } else {
            
            // If gesture pan to right
            if (quickNavigation.tableView.frame.origin.x < 0 && translationOfGesture.x > 0) {
                
                [quickNavigation.tableView setFrame:CGRectMake( -quickNavigation.tableView.frame.size.width + translationOfGesture.x, quickNavigation.tableView.frame.origin.y, quickNavigation.tableView.frame.size.width, quickNavigation.tableView.frame.size.height)];
            } else {
                
                [UIView animateWithDuration:0.3 delay:0 options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut) animations:^{
                    
                    [quickNavigation.tableView setFrame:CGRectMake( 0, quickNavigation.tableView.frame.origin.y, quickNavigation.tableView.frame.size.width, quickNavigation.tableView.frame.size.height)];
                } completion:nil];
                
            }
            
        }
        
        // Save translation per 5 laps
        if (checkPoint) {
            
            translationBefore = translationOfGesture.x;
            checkPoint = NO;
        }
        
        // Savecheck point per 5 laps
        if (count == 7) {
            
            checkPoint = YES;
            count = 0;
        } else {
            
            count++;
        }

    
    }
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        
//        NSLog(@"%f - Trans", translationOfGesture.x);
//        NSLog(@"%f - Before", translationBefore);
//        NSLog(@"%f - Trans - Before", translationOfGesture.x - translationBefore );
        BOOL checkMinus = NO;
        
        // Check whether we one to re back the action
        if ((translationOfGesture.x - translationBefore) < 0) {
            
            checkMinus = YES;
        } else {
            
            checkMinus = NO;
        }
        
        // If gesture swipe to right
        if (!checkMinus && translationOfGesture.x > 0) {
            
            [UIView animateWithDuration:0.3 delay:0 options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut) animations:^{
                
                [quickNavigation.tableView setFrame:CGRectMake( 0, quickNavigation.tableView.frame.origin.y, quickNavigation.tableView.frame.size.width, quickNavigation.tableView.frame.size.height)];
            } completion:nil];
        }
        
        // If gesture pan to left then pan to right
        if (!checkMinus && translationOfGesture.x < 0) {
            
            [UIView animateWithDuration:0.3 delay:0 options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut) animations:^{
                
                [quickNavigation.tableView setFrame:CGRectMake( 0, quickNavigation.tableView.frame.origin.y, quickNavigation.tableView.frame.size.width, quickNavigation.tableView.frame.size.height)];
            } completion:nil];
        }
        /* -- decrease 2 point to hidden shadow -- */
        // If gesture pan to right then pan to left
        if (checkMinus && translationOfGesture.x > 0) {
            
            [UIView animateWithDuration:0.3 delay:0 options:(UIViewAnimationOptionBeginFromCurrentState) animations:^{
                
                [quickNavigation.tableView setFrame:CGRectMake( -quickNavigation.tableView.frame.size.width -2, quickNavigation.tableView.frame.origin.y, quickNavigation.tableView.frame.size.width, quickNavigation.tableView.frame.size.height)];
            } completion:nil];
        }
        
    	// If gesture swipe to left
        if (checkMinus && translationOfGesture.x < 0) {
            
            if (quickNavigation.tableView.frame.origin.x == - quickNavigation.tableView.frame.size.width) {
                
                return;
            }
            
            [UIView animateWithDuration:0.3 delay:0 options:(UIViewAnimationOptionBeginFromCurrentState) animations:^{
                
                [quickNavigation.tableView setFrame:CGRectMake( -quickNavigation.tableView.frame.size.width -2, quickNavigation.tableView.frame.origin.y, quickNavigation.tableView.frame.size.width, quickNavigation.tableView.frame.size.height)];
            } completion:nil];
        }
        
        // Reset static variables
        translationBefore = 0;
        checkPoint = YES;
        count = 0;
         
    }
}

#pragma mark - Rotation Delegate

- (BOOL)shouldAutorotate {
    
    return NO;
}

@end



@implementation UINavigationController (iOS6AutorotationFix)

-(BOOL)shouldAutorotate {
    
    return [self.topViewController shouldAutorotate];
}

@end
























