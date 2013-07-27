//
//  KUDPhotoCell.h
//  LikeApp
//
//  Created by Nguyen Huu Tinh on 6/14/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  KUDPhotoModel;
@interface KUDPhotoCell : UICollectionViewCell

// imageView used to display photo
@property(nonatomic, weak) IBOutlet UIImageView *imageView;
// totalLike display counts for like
@property(nonatomic,weak)IBOutlet UILabel *totalLike;

@property(nonatomic, strong) KUDPhotoModel *photo;
@end
