//
//  KUDUtilLoadData.h
//  LikeApp
//
//  Created by Nguyen Huu Tinh on 6/14/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KUDPhotoModel;
@class KUDRESTFul;
// Define Block
typedef void (^LoadDataCompletionBlock)(NSInteger searchTerm, NSArray *results, NSError *error, BOOL flag);
typedef void (^PhotoCompletionBlock)(UIImage *photoImage, NSError *error);
typedef void (^LoadDataImageLCompletionBlock)(NSMutableArray *arrayPhoto, NSError *error);
typedef void (^LoadDataListLike)(NSMutableArray *arrayPhoto, NSError *error);
typedef void (^LoadOneDataPhoto)(NSMutableArray *arrayPhoto, NSError *error);


@interface KUDUtilLoadData : NSObject
@property(nonatomic,strong)KUDRESTFul *restFul;
// Get Data Model
- (void)loadData:(NSInteger )offset limit:(NSInteger)limit completionBlock:(LoadDataCompletionBlock) completionBlock;
// Get photo for model
- (void)loadDataImageLarge:(BOOL)thumbnail arrayPhoto:(NSMutableArray *)arrayPhoto completionBlock:(LoadDataImageLCompletionBlock) completionBlock;
// Get lisk use like this photo
- (void)loadDataListLikePhoto:(NSString *)idPhoto completionBlock:(LoadDataListLike) completionBlock;
// get 1 photo (cần hiển thị photo này trước)
- (void)loadPhotoShowing:(NSMutableArray *)arrayPhoto index:(NSInteger )index completionBlock:(LoadDataImageLCompletionBlock) completionBlock;

+ (void)loadImageForPhoto:(KUDPhotoModel *)photo thumbnail:(BOOL)thumbnail completionBlock:(PhotoCompletionBlock) completionBlock;
+ (NSString *)photoURLForLikePhoto:(KUDPhotoModel *)photo size:(NSString *) size;
// check url
+ (BOOL)validateUrl:(NSString *)url;
@end
