//
//  KUDControllShowImage.h
//  LikeApp
//
//  Created by Nguyen Huu Tinh on 6/21/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//
@protocol KUDControllShowImageDelegate <NSObject>
@optional
- (void)loadListLike:(NSInteger)idPhoto count:(NSString *)count;
- (void)navigationBarHidden;
- (void)listLikePhotoHidden;
- (void)navigationHidden;
@end
#import <UIKit/UIKit.h>

@interface KUDControllShowImage : UIView <UIScrollViewDelegate,UIGestureRecognizerDelegate> 
{
    UIImageView *backgroundImage1;
    UIImageView *backgroundImage2;
    UIScrollView *scrollView;
    UIPageControl *pageControl;
    NSArray *pages;
    NSTimer *timer;
    BOOL firstShow;
    int currentPhotoNum;
    
}
@property(nonatomic,strong)UIImageView *backgroundImage1;
@property(nonatomic,strong)UIImageView *backgroundImage2;
@property(nonatomic,strong) NSArray *pages;
@property (nonatomic,strong)UITextView *listLikePhoto;
@property (weak,nonatomic) id<KUDControllShowImageDelegate> delegate;
- (id)initWithFrame:(CGRect)frame pages:(NSArray*)pagesArray pageSet:(int)pageSet listLike:(UITextView *)listLike;
-(void)loadPhotoShowing;
@end
