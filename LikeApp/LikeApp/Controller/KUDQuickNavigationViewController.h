//
//  KUDQuickNavigationViewController.h
//  LikeApp
//
//  Created by Nhat Huy on 6/27/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KUDQuickNavigationViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak,nonatomic) UINavigationController *viewController;

@property (weak,nonatomic) id weakSelf;

@end
