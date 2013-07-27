//
//  KUDMyPageViewController.h
//  LikeApp
//
//  Created by Nguyen Huu Tinh on 6/13/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNMBottomPullToRefreshManager.h"
@interface KUDMyPageViewController : UIViewController<UIScrollViewDelegate,MNMBottomPullToRefreshManagerClient,UIGestureRecognizerDelegate>{
    
    MNMBottomPullToRefreshManager *pullToRefreshManager_;
    NSInteger flagOffset;
}

//-(void)loadMyPhoto:(NSInteger )offset limit:(NSInteger )limit;
- (IBAction)pushToCameraRollView:(id)sender;

@end
