//
//  KUDViewPhoto.m
//  LikeApp
//
//  Created by Nguyen Huu Tinh on 6/21/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import "KUDViewPhoto.h"
#import "KUDPhotoModel.h"
@implementation KUDViewPhoto

- (id)initWithFrame:(CGRect)frame model:(KUDPhotoModel*)model
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *counLike = [[UILabel alloc] init];
        [counLike setText:[NSString stringWithFormat:@"%@ Likes",model.numberLikes]];
        [counLike setTextColor:[UIColor whiteColor]];
        [counLike setFont:[UIFont fontWithName:@"GillSans-Light" size:17]];
        [counLike setShadowColor:[UIColor blackColor]];
        [counLike setShadowOffset:CGSizeMake(1, 1)];
        [counLike setBackgroundColor:[UIColor clearColor]];
        [counLike sizeToFit];
        [counLike setCenter:CGPointMake(frame.size.width-40, frame.size.height-20)];
        // [counLike setTextColor:[UIColor whiteColor]];
        
        
        UILabel *comment = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 120, 320, 60)];
        [comment setText:model.comment];
        [comment setFont:[UIFont fontWithName:@"GillSans-Light" size:17]];
        [comment setTextColor:[UIColor whiteColor]];
        [comment setShadowColor:[UIColor blackColor]];
        [comment setShadowOffset:CGSizeMake(1, 1)];
        [comment setNumberOfLines:3];
        [comment setBackgroundColor:[UIColor clearColor]];
        [comment setTextAlignment:NSTextAlignmentCenter];
        
        // Init banner for comment (Huy)
        UIView *bannerComment = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 120, 320, 60)];
        [bannerComment setAlpha:0.6];
        [bannerComment setBackgroundColor:[UIColor blackColor]];
        
        [self addSubview:bannerComment];
        [self addSubview:counLike];
        [self addSubview:comment];
        /*CGSize s = [comment.text sizeWithFont:comment.font constrainedToSize:CGSizeMake(frame.size.width-40, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
         
         //three lines height
         CGSize three = [@"1 \n 2 \n 3" sizeWithFont:comment.font constrainedToSize:CGSizeMake(frame.size.width-40, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
         
         comment.frame = CGRectMake((self.frame.size.width-s.width)-180,(-30)+ counLike.frame.origin.y+counLike.frame.size.height+4,s.width, MIN(s.height, three.height));
         
         NSLog(@"%f", s.height);
         */
        //comment.frame = CGRectMake(20,420,200,50);
        
        
    }
    return self;
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
