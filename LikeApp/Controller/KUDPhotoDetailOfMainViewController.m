//
//  KUDPhotoDetailOfMainViewController.m
//  LikeApp
//
//  Created by Nhat Huy on 6/13/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import "KUDPhotoDetailOfMainViewController.h"


@interface KUDPhotoDetailOfMainViewController ()


@end

@implementation KUDPhotoDetailOfMainViewController

@synthesize arrayOfPhotoPage, arrayOfPhotoViewController, photoDetail, initPage, arrayOfPhotoModel, photoModelInitPage;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set Delegate and Datasources
    self.dataSource = self;
    self.delegate = self;
    
    // Set title of Navigation Bar
    self.navigationItem.title = [NSString stringWithFormat:@"%d of %d", [arrayOfPhotoPage indexOfObject:self.photoId] + 1 , arrayOfPhotoPage.count];
    
    // Init the first page
    initPage = [[KUDPageOfPhotoDetailMainViewController alloc] init];
    initPage.photoModel = photoModelInitPage;
    initPage.photoId = photoModelInitPage.photoId;
    [self setViewControllers:@[initPage] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    // Load UIViewController
    [self loadUIViewController];
    
    
    // nhtinh test
    [self.view setAccessibilityLabel:@"KUDPhotoDetailOfMainViewController"];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self.view setBackgroundColor:[UIColor blackColor]];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    // Remove controllers in array to release them
    [arrayOfPhotoViewController removeAllObjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 
#pragma mark - Load the UIViewController

- (void)loadUIViewController {
    
    // Create a new queue to init all controller for per photoId and add them into array
    NSOperationQueue *loadUIViewQueue = [[NSOperationQueue alloc] init];
    [loadUIViewQueue setName:@"Load UIView Queue"];
    
    arrayOfPhotoViewController = [[NSMutableArray alloc] init];
            
    [loadUIViewQueue addOperationWithBlock:^{
        
        // Enum the photoModel to create ViewController of DetailPage
        for (KUDPhotoModel *photoModel in arrayOfPhotoModel) {
            
            // Check to add Init Page into Array Of PhotoViewController
            if ([initPage.photoId isEqualToString:photoModel.photoId]) {
                
                [arrayOfPhotoViewController addObject:initPage];
                continue;
            }
            
            // Init KUDPageOfPhotoDetail and add infomation into their viewController
            photoDetail = [[KUDPageOfPhotoDetailMainViewController alloc] init];
            photoDetail.photoId = photoModel.photoId;
            photoDetail.photoModel = photoModel;
            
            // Save this viewController into array
            [arrayOfPhotoViewController addObject:photoDetail];
        }
    }];
    
}

#pragma mark - DataSource of PageView


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    

    KUDPageOfPhotoDetailMainViewController __weak *detailPhotoView = viewController;
    NSString *photoId = detailPhotoView.photoId;
    
    NSInteger indexOfNextPhotoId = [arrayOfPhotoPage indexOfObject:photoId];
    
    if ((indexOfNextPhotoId + 1) == arrayOfPhotoPage.count) {
        return nil;
    }
    
    if ([arrayOfPhotoViewController objectAtIndex:(indexOfNextPhotoId + 1)] != nil) {
        
        return ([arrayOfPhotoViewController objectAtIndex:(indexOfNextPhotoId + 1)]);
    } else {
        
        return nil;
    }
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    // return ([arrayOfPhotoViewController objectAtIndex:2]);
    
    KUDPageOfPhotoDetailMainViewController __weak *detailPhotoView = viewController;
    NSString *photoId = detailPhotoView.photoId;
    
    NSInteger indexOfNextPhotoId = [arrayOfPhotoPage indexOfObject:photoId];
    
    if ((indexOfNextPhotoId - 1) < 0) {
        return nil;
    }
    
    if ([arrayOfPhotoViewController objectAtIndex:(indexOfNextPhotoId - 1)] != nil) {
        
        return ([arrayOfPhotoViewController objectAtIndex:(indexOfNextPhotoId - 1)]);
        
    } else {
        
        return nil;
    }

}

#pragma mark - Delegate of PageView

// After animate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
}

// Before animate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    // Set title of Navigation Bar
    self.navigationItem.title = [NSString stringWithFormat:@"%d of %d", [arrayOfPhotoPage indexOfObject:[pendingViewControllers[0] photoId]] + 1 , arrayOfPhotoPage.count];
}



@end
