//
//  KUDMyPageViewController.m
//  LikeApp
//
//  Created by Nguyen Huu Tinh on 6/13/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import "KUDMyPageViewController.h"
#import "KUDPhotoDetailOfMyPageViewController.h"
#import "KUDUtilLoadData.h"
#import "KUDPhotoCell.h"
#import "KUDQuickNavigationViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface KUDMyPageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
// Dictionary all photo
@property(nonatomic, strong) NSMutableDictionary *dataResults;
// array number of get photo
@property(nonatomic, strong) NSMutableArray *someTimesGetData;

@property(nonatomic, strong) KUDUtilLoadData *utilLoadData;
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
// Pan gesture IBOutlet
@property (weak,nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
// limit,offset: paging when load photo
@property(nonatomic)NSInteger limit;
@property(nonatomic)NSInteger offset;
// id photo show detail
@property(nonatomic)int indexShowDetail;
@property (strong,nonatomic) KUDQuickNavigationViewController *quickNavigation;
// refresh photo Mypage
@property (strong,nonatomic) UIRefreshControl *refreshPhoto;

@end

@implementation KUDMyPageViewController
@synthesize quickNavigation,panGesture,refreshPhoto;

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
    // init
    self.offset =0;
    self.limit = 9;
    flagOffset = self.offset;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MY_CELL"];
    self.someTimesGetData = [@[] mutableCopy];
	self.dataResults = [@{} mutableCopy];
    self.utilLoadData = [[KUDUtilLoadData alloc] init];
    // lay danh sach 10 photo dau tien
    [self loadMyPhoto:self.offset limit:self.limit];
    [self.collectionView setBackgroundColor:[UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:1]];
    // alwaysBounceVertical----> khi collectionView khong co hinh van refresh duoc
    self.collectionView.alwaysBounceVertical = YES;
    //self.collectionView.alwaysBounceHorizontal = YES;
    
    // init refetch photo mypage
    refreshPhoto= [[UIRefreshControl alloc] init];
    refreshPhoto.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh ..."];
    [refreshPhoto addTarget:self action:@selector(refreshMyPhoto:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshPhoto];
    
    // init loading more
    pullToRefreshManager_ = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f tableView:self.collectionView withClient:self];
    
    // set title for mypage
    self.title = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    
    // copy from KUDMainViewController
    
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
    quickNavigation.tableView.hidden = YES;
    // Setup PanGesture
    [panGesture setDelegate:self];
    [panGesture addTarget:self action:@selector(beingPanGesture)];
	// Do any additional setup after loading the view.
    
    [self.collectionView setAccessibilityValue:@"collectionView"];
    [self.view setAccessibilityLabel:@"viewmypage"];
}

- (void)viewDidAppear:(BOOL)animated {
    self.title = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    
}
// pull to refresh
- (void)refreshMyPhoto:(UIRefreshControl *)refreshControl
{
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing ..."];
    self.offset =0;
    flagOffset = self.offset;
    self.limit = 9;
    [self.dataResults removeAllObjects];
    [self.someTimesGetData removeAllObjects];
    [self.collectionView reloadData];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing];
    });
    [self loadMyPhoto:self.offset limit:self.limit];
    
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    //[pullToRefreshManager_ relocatePullToRefreshView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    if ([self.someTimesGetData count]>0) {
        NSString *searchTerm = self.someTimesGetData[section];
        return [self.dataResults[searchTerm] count];
    }else{
        return 0;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.someTimesGetData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KUDPhotoCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"photocell" forIndexPath:indexPath];
    if ([self.someTimesGetData count] > 0) {
        NSString *searchTerm = self.someTimesGetData[indexPath.section];
        [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            cell.photo = self.dataResults[searchTerm][indexPath.row];
        } completion:nil];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexShowDetail = indexPath.row;
    NSString *searchTerm = self.someTimesGetData[indexPath.section];
    [self performSegueWithIdentifier:@"pushToDetailPhotoOfMyPage" sender:searchTerm];
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"pushToDetailPhotoOfMyPage"])
	{
        KUDPhotoDetailOfMyPageViewController *photoDetailOfMyPageViewController = segue.destinationViewController;
        //photoDetailOfMyPageViewController.photo = sender;
        photoDetailOfMyPageViewController.arrayphotoDetail = self.dataResults[sender];
        photoDetailOfMyPageViewController.indexShowDetail = self.indexShowDetail;
	}
}
// Get photo with offset and limit
-(void)loadMyPhoto:(NSInteger )offset limit:(NSInteger )limit{
    @try {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        // call loaddata from KUDUtilLoadData
        [self.utilLoadData loadData:offset limit:limit completionBlock:^(NSInteger searchTerm, NSArray *results, NSError *error, BOOL flag) {
            if(results && [results count] > 0)
            {
                if(![self.someTimesGetData containsObject:[NSString stringWithFormat:@"%d",searchTerm]])
                {
                    NSLog(@"loadMyPhoto:Found %d photos matching %d",[results count],searchTerm);
                    [self.someTimesGetData insertObject:[NSString stringWithFormat:@"%d",searchTerm] atIndex:[self.someTimesGetData count]];
                    self.dataResults[[NSString stringWithFormat:@"%d",searchTerm]] = results;
                }else{
                    NSLog(@"loadMyPhoto:Found %d photos matching %d",[results count],searchTerm);
                    self.dataResults[[NSString stringWithFormat:@"%d",searchTerm]] = results;
                }
                if (flag == TRUE) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [refreshPhoto endRefreshing];
                        self.offset = self.limit+1;
                        self.limit = self.offset+ 10;
                        [self.collectionView reloadData];
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        refreshPhoto.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh ..."];
                        
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.collectionView reloadData];
                        
                    });
                }
            } else {
                NSLog(@"load MyPhoto count = 0: %@", error.localizedDescription);
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }
            
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"loadMyPhoto:%@",exception);
        refreshPhoto.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh ..."];
    }
    @finally {
        
    }
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didEndDisplayingSupplementaryView");
}

#pragma mark - Push to CameraRoll View

- (IBAction)pushToCameraRollView:(id)sender {
    
    [self performSegueWithIdentifier:@"modalToCameraRollView" sender:self];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [pullToRefreshManager_ relocatePullToRefreshView];
    [pullToRefreshManager_ tableViewScrolled];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"scrollViewDidEndDragging");
    [pullToRefreshManager_ tableViewReleased];
}
- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager {
    
    [self performSelector:@selector(stopPull) withObject:nil afterDelay:1.0f];
    if(flagOffset != self.offset){
        [self loadMyPhoto:self.offset limit:self.limit];
        flagOffset = self.offset;
    }
    
    
    
}
- (void)stopPull {
    
    [pullToRefreshManager_ tableViewReloadFinished];
}
// copy from KUDMainViewController
#pragma mark - UIPanGesture Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    quickNavigation.tableView.hidden = NO;
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
