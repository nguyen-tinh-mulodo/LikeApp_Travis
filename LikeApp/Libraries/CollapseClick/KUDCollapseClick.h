//
//  KUDCollapseClick.h
//  LikeApp
//
//  Created by Nguyen Huu Tinh on 7/3/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollapseClickCell.h"
#define kCCPad 10

// Delegate //
@protocol CollapseClickDelegate
@required
-(int)numberOfCellsForCollapseClick;
-(NSString *)titleForCollapseClickAtIndex:(int)index;
-(UIView *)viewForCollapseClickContentViewAtIndex:(int)index;

@optional
-(UIColor *)colorForCollapseClickTitleViewAtIndex:(int)index;
-(UIColor *)colorForTitleLabelAtIndex:(int)index;
-(UIColor *)colorForTitleArrowAtIndex:(int)index;
-(void)didClickCollapseClickCellAtIndex:(int)index isNowOpen:(BOOL)open;

@end

@interface KUDCollapseClick : UIScrollView<UIScrollViewDelegate>{
    __weak id <CollapseClickDelegate> CollapseClickDelegate;
}
// Delegate
@property (weak) id <CollapseClickDelegate> CollapseClickDelegate;

// Properties
@property (nonatomic, retain) NSMutableArray *isClickedArray;
@property (nonatomic, retain) NSMutableArray *dataArray;

// Methods
-(void)reloadCollapseClick;
-(CollapseClickCell *)collapseClickCellForIndex:(int)index;
-(void)scrollToCollapseClickCellAtIndex:(int)index animated:(BOOL)animated;
-(UIView *)contentViewForCellAtIndex:(int)index;
-(void)openCollapseClickCellAtIndex:(int)index animated:(BOOL)animated;
-(void)closeCollapseClickCellAtIndex:(int)index animated:(BOOL)animated;
-(void)openCollapseClickCellsWithIndexes:(NSArray *)indexArray animated:(BOOL)animated;
-(void)closeCollapseClickCellsWithIndexes:(NSArray *)indexArray animated:(BOOL)animated;

@end
