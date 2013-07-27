//
//  KUDCollapseClickArrow.m
//  LikeApp
//
//  Created by Nguyen Huu Tinh on 7/3/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import "KUDCollapseClickArrow.h"

@implementation KUDCollapseClickArrow


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.arrowColor = [UIColor whiteColor];
    }
    return self;
}

-(void)drawWithColor:(UIColor *)color {
    self.arrowColor = color;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *arrow = [UIBezierPath bezierPath];
    [self.arrowColor setFill];
    [arrow moveToPoint:CGPointMake(self.frame.size.width, self.frame.size.height/2)];
    [arrow addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [arrow addLineToPoint:CGPointMake(0, 0)];
    [arrow addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height/2)];
    [arrow fill];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
