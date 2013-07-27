//
//  KUDPhotoCell.m
//  LikeApp
//
//  Created by Nguyen Huu Tinh on 6/14/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import "KUDPhotoCell.h"
#import "KUDPhotoModel.h"
@implementation KUDPhotoCell
- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
        UIView *bgView = [[UIView alloc] initWithFrame:self.backgroundView.frame];
        bgView.backgroundColor = [UIColor blueColor];
        self.selectedBackgroundView = bgView;
    }
    return self;
}

- (void) setPhoto:(KUDPhotoModel *)photo
{
    if(_photo != photo)
    {
        _photo = photo;
    }
    
    self.imageView.image = _photo.sPhoto;
    
    self.totalLike.text = [NSString stringWithFormat:@"%@",_photo.numberLikes];
}
@end
