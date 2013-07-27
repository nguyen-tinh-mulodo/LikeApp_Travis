//
//  KUDPhotoDetailOfMyPageViewController.h
//  LikeApp
//
//  Created by Nguyen Huu Tinh on 6/14/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KUDControllShowImage.h"

@class KUDPhotoModel;
@interface KUDPhotoDetailOfMyPageViewController : UIViewController<UIScrollViewDelegate,KUDControllShowImageDelegate,UITableViewDelegate,UITableViewDataSource>{
    BOOL pageControlBeingUsed;
    KUDControllShowImage *introcontroll;
}
@property(nonatomic,strong)KUDPhotoModel *photo;
// index of photo when use click from mypage
@property(nonatomic)int indexShowDetail;
// array photo show detail
@property(nonatomic,strong)NSMutableArray *arrayphotoDetail;
// show list use like this photo
@property (nonatomic,strong)UITextView *listLikePhoto;

@end
