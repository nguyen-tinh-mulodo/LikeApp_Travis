//
//  KUDImageViewInMain.m
//  LikeApp
//
//  Created by Nhat Huy on 7/10/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import "KUDImageViewInMain.h"

@implementation KUDImageViewInMain

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        
        // Init BannerImageInfo
        _bannerOfImageInfo = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.size.height - (frame.size.height * 0.318), frame.size.width, frame.size.height * 0.318)];
        [_bannerOfImageInfo setBackgroundColor:[UIColor darkTextColor]];
        
        // Init ImageView
        _imageViewOfThisPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - _bannerOfImageInfo.frame.size.height)];
        
        // Init Button Like
        _buttonLike = [[UIButton alloc] initWithFrame:CGRectMake(_bannerOfImageInfo.frame.size.width - 40, _bannerOfImageInfo.frame.size.height * 0.2, 40, 40)];
        [_buttonLike setImage:[UIImage imageNamed:@"star-2.png"] forState:UIControlStateNormal];
        
        // Init Label Number Like
        _labelOfNumberLike = [[UILabel alloc] initWithFrame:CGRectMake(_buttonLike.frame.origin.x - 40, _bannerOfImageInfo.frame.size.height * 0.2, 60, 40)];
        [_labelOfNumberLike setTextAlignment:NSTextAlignmentRight];
        
        // Init TextView
        _textViewOfComment = [[UITextView alloc] initWithFrame:CGRectMake(_bannerOfImageInfo.frame.origin.x, _bannerOfImageInfo.frame.origin.y, _bannerOfImageInfo.frame.size.width - _buttonLike.frame.size.width - _labelOfNumberLike.frame.size.width, _bannerOfImageInfo.frame.size.height)];
        
        [self addSubview:_bannerOfImageInfo];
        [self addSubview:_imageViewOfThisPhoto];
        
        [_bannerOfImageInfo addSubview:_textViewOfComment];
        [_bannerOfImageInfo addSubview:_labelOfNumberLike];
        [_bannerOfImageInfo addSubview:_buttonLike];
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
