//
//  KUDPhotoDetailOfMyPageViewController.m
//  LikeApp
//
//  Created by Nguyen Huu Tinh on 6/14/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import "KUDPhotoDetailOfMyPageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "KUDPhotoModel.h"
#import "KUDControllShowImage.h"
#import "KUDUtilLoadData.h"
@interface KUDPhotoDetailOfMyPageViewController ()
@property(nonatomic,weak)IBOutlet UIImageView *photoDetail;
@property(nonatomic, strong) KUDUtilLoadData *utilLoadData;
@end

@implementation KUDPhotoDetailOfMyPageViewController
@synthesize photo,arrayphotoDetail,indexShowDetail,listLikePhoto;
- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    self.wantsFullScreenLayout = YES;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) loadView {
    [super loadView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // init
    listLikePhoto = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 150, self.view.frame.size.height - 230, 140, 200)];
    //listLikePhoto.textColor = [UIColor darkTextColor];
    listLikePhoto.textColor = [UIColor whiteColor];
    [listLikePhoto.layer setBackgroundColor: [[UIColor blackColor] CGColor]];
    [listLikePhoto.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [listLikePhoto.layer setBorderWidth: 2.0];
    [listLikePhoto.layer setCornerRadius:10.0f];
    [listLikePhoto.layer setMasksToBounds:NO];
    
    [listLikePhoto.layer setShadowColor:[UIColor darkTextColor].CGColor];
    [listLikePhoto.layer setShadowOffset:CGSizeMake(1, 1)];
    [listLikePhoto.layer setShadowOpacity:1];
    [listLikePhoto.layer setShadowRadius:1];
    
    [listLikePhoto.layer setOpacity:0.0];
    [listLikePhoto setEditable:NO];
    
    self.utilLoadData = [[KUDUtilLoadData alloc] init];
    
    // load photo showing
    [self loadPhotoShowing];
    // load list photo detail
    [self loadPhotoImageLarge];
    // init ControllShowImage
    introcontroll = [[KUDControllShowImage alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) pages:arrayphotoDetail pageSet:self.indexShowDetail listLike:listLikePhoto];
    self.view = introcontroll;
    introcontroll.delegate = self;
    
    
    [self.view setAccessibilityLabel:@"KUDPhotoDetailOfMyPageViewController"];
}
// Get photo dang xem
-(void)loadPhotoShowing{
    [self.utilLoadData loadPhotoShowing:arrayphotoDetail index:self.indexShowDetail completionBlock:^(NSMutableArray *arrayPhoto, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [introcontroll loadPhotoShowing];
        });
        
    }];
}
// Get List photo trong array photo dang xem
-(void)loadPhotoImageLarge{
    @try {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self.utilLoadData loadDataImageLarge:FALSE arrayPhoto:arrayphotoDetail completionBlock:^(NSMutableArray *arrayPhoto, NSError *error) {
            if(arrayPhoto && [arrayPhoto count] > 0)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [introcontroll loadPhotoShowing];
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                });
            } else {
                NSLog(@"Error: %@", error.localizedDescription);
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"loadPhotoImageL:%@",exception);
    }
    @finally {
        
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    if(self.photo.sPhoto)
    {
        //self.photoDetail.image = self.photo.sPhoto;
    }

}
#pragma mark - IntroControllDelegate
// show list use like this photo
- (void)loadListLike:(NSInteger)idPhoto count:(NSString *)count{
    self.listLikePhoto.text = @"";
    // get list like photo
    if ([count integerValue] >0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self.utilLoadData loadDataListLikePhoto:[NSString stringWithFormat:@"%d",idPhoto] completionBlock:^(NSMutableArray *arrayPhoto, NSError *error) {
            if(arrayPhoto && [arrayPhoto count] > 0)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.3 animations:^{
                        NSString *textLikedUser = @"";
                        // add list user like photo
                        for (int i=0 ;i<arrayPhoto.count ;i++) {
                            textLikedUser = [NSString stringWithFormat:@"%@ \n%@\n%@",textLikedUser,[[arrayPhoto objectAtIndex:i] name],[[arrayPhoto objectAtIndex:i] date]];
                            if (i == arrayPhoto.count -1) {
                                textLikedUser = [NSString stringWithFormat:@"%d people like this photo:\n%@",i+1,textLikedUser];
                            }
                        }
                        listLikePhoto.text=textLikedUser;
                        [self.view addSubview:listLikePhoto];
                        [listLikePhoto setAlpha:0.5];
                        
                    }completion:^(BOOL finished) {
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        
                    }];
                    
                    
                });
                
            } else {
                NSLog(@"Error loadListLike: %@", error.localizedDescription);
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }
            
        }];
    }
}
#pragma KUDControllShowImageDelegate

- (void)navigationBarHidden{
    if (self.navigationController.navigationBarHidden) {
        [UIView animateWithDuration:0.5 animations:^{
            [UIView setAnimationBeginsFromCurrentState: YES];
            self.navigationController.navigationBarHidden = NO;
            [UIView commitAnimations];
        }];
        
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            [UIView setAnimationBeginsFromCurrentState: YES];
            self.navigationController.navigationBarHidden = YES;
            [UIView commitAnimations];
        }];
    }
    
}
- (void)navigationHidden{
    [UIView animateWithDuration:0.5 animations:^{
        [UIView setAnimationBeginsFromCurrentState: YES];
        self.navigationController.navigationBarHidden = YES;
        
        [UIView commitAnimations];
    }];
}
- (void)listLikePhotoHidden{
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationBeginsFromCurrentState: YES];
        [self.listLikePhoto setAlpha:0];
    }];
    
}

#pragma mark - Rotation Delegate

- (BOOL)shouldAutorotate {
    
    return NO;
}
@end
