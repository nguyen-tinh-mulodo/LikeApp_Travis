//
//  KUDPhotoModelForDetailOfMainView.h
//  LikeApp
//
//  Created by Nhat Huy on 6/14/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KUDPhotoModel : NSObject

// Have be liked by current user
@property (nonatomic) BOOL isLiked;

// Attribute of photo
@property (strong,nonatomic) NSString *photoId;
@property (strong,nonatomic) NSString *uploader;
@property (strong,nonatomic) NSString *l_photo_link;
@property (strong,nonatomic) NSString *m_photo_link;
@property (strong,nonatomic) NSString *s_photo_link;
@property (strong,nonatomic) NSString *comment;
@property (strong,nonatomic) NSString *numberLikes;
@property (strong,nonatomic) NSString *created;
@property (strong,nonatomic) NSString *modified;

@property(nonatomic)int user_id;
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *name;

// 3 size of photo
@property (strong,nonatomic) UIImage *lPhoto;
@property (strong,nonatomic) UIImage *mPhoto;
@property (strong,nonatomic) UIImage *sPhoto;

// Weak UILabel of NumberLikes
// @property (strong,nonatomic) UILabel *labelOfNumberLikes;

// original photo
@property (strong,nonatomic) UIImage *imageFile;

// Init Photo Model with dataResponse from URL
- (id)initWithData:(NSData *)dataResponse;

// Init Photo Model with JSON Object
- (id)initWithJsonObject:(NSDictionary *)jsonObject;



@end
