//
//  KUDControllShowImage.m
//  LikeApp
//
//  Created by Nguyen Huu Tinh on 6/21/13.
//  Copyright (c) 2013 Mulodo Viet Nam. All rights reserved.
//

#import "KUDControllShowImage.h"
#import "KUDPhotoModel.h"
#import "KUDViewPhoto.h"
@implementation KUDControllShowImage
@synthesize delegate,listLikePhoto,pages,backgroundImage1,backgroundImage2;

- (id)initWithFrame:(CGRect)frame pages:(NSArray*)pagesArray pageSet:(int)pageSet listLike:(UITextView *)listLike
{
    self = [super initWithFrame:frame];
    if(self != nil) {
        firstShow = TRUE;
        //Initial Background images
        self.backgroundColor = [UIColor blackColor];
        
        backgroundImage1 = [[UIImageView alloc] initWithFrame:frame];
        [backgroundImage1 setContentMode:UIViewContentModeScaleAspectFill];
        [backgroundImage1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [self addSubview:backgroundImage1];
        
        backgroundImage2 = [[UIImageView alloc] initWithFrame:frame];
        [backgroundImage2 setContentMode:UIViewContentModeScaleAspectFill];
        [backgroundImage2 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [self addSubview:backgroundImage2];
        
        //Initial shadow
        UIImageView *shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow1.png"]];
        shadowImageView.contentMode = UIViewContentModeScaleToFill;
        shadowImageView.frame = CGRectMake(0,0, frame.size.width, frame.size.height);
        [self addSubview:shadowImageView];
        
        
        //Initial ScrollView
        scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        [self addSubview:scrollView];
        
        //Initial PageView
        pageControl = [[UIPageControl alloc] init];
        pageControl.numberOfPages = pagesArray.count;
        [pageControl sizeToFit];
        [pageControl setCenter:CGPointMake(frame.size.width/2.0, frame.size.height-50)];
        [self addSubview:pageControl];
        [pageControl setEnabled:NO];
        
        //Create pages
        pages = pagesArray;
        
        scrollView.contentSize = CGSizeMake(pages.count * frame.size.width, frame.size.height);
        
        currentPhotoNum = -1;
        
        //insert TextViews into ScrollView
        for(int i = 0; i <  pages.count; i++) {
            KUDViewPhoto *viewPhoto = [[KUDViewPhoto alloc] initWithFrame:frame model:[pages objectAtIndex:i]];
            viewPhoto.frame = CGRectOffset(viewPhoto.frame, i*frame.size.width, 0);
            [scrollView addSubview:viewPhoto];
        }
        
        //start timer
        timer =  [NSTimer scheduledTimerWithTimeInterval:10.0
         target:self
         selector:@selector(tick)
         userInfo:nil
         repeats:YES];
         
        
        [scrollView setContentOffset:CGPointMake(pageSet*320,5) animated:YES];
        //[self initShow];
        UITapGestureRecognizer *doubleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(hiddenNavigationBar:)];
        [doubleFingerTap setNumberOfTapsRequired:1];
        [doubleFingerTap setNumberOfTouchesRequired:1];
        [doubleFingerTap setDelegate:self];
        [doubleFingerTap setCancelsTouchesInView:NO];
        [self addGestureRecognizer:doubleFingerTap];
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeRecognizer:)];
        // And assuming the "Up" direction in your screenshot is no accident
        //swipe.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:swipe];
        
        listLikePhoto = listLike;
        
        
    }
    
    return self;
}
- (void) SwipeRecognizer:(UISwipeGestureRecognizer *)sender {
    
    if ( sender.direction == UISwipeGestureRecognizerDirectionLeft ){
        NSLog(@" *** SWIPE LEFT ***");
        
    }
    if ( sender.direction == UISwipeGestureRecognizerDirectionRight ){
        NSLog(@" *** SWIPE RIGHT ***");
        
    }
    if ( sender.direction== UISwipeGestureRecognizerDirectionUp ){
        NSLog(@" *** SWIPE UP ***");
        
    }
    if ( sender.direction == UISwipeGestureRecognizerDirectionDown ){
        NSLog(@" *** SWIPE DOWN ***");
        
    }
}
-(IBAction)hiddenNavigationBar:(UIGestureRecognizer *)recognizer{
    CGPoint location = [recognizer locationInView:self];
    if(location.x > self.frame.size.width-70 && location.y > self.frame.size.height-30){
        
        [self.delegate loadListLike:[[(KUDPhotoModel*)[pages objectAtIndex:currentPhotoNum] photoId] intValue] count:[(KUDPhotoModel*)[pages objectAtIndex:currentPhotoNum] numberLikes]];
    }else{
        [self.delegate listLikePhotoHidden];
        [self.delegate navigationBarHidden];
    }
}
- (void) tick {
    [scrollView setContentOffset:CGPointMake((currentPhotoNum+1 == pages.count ? 0 : currentPhotoNum+1)*self.frame.size.width, 0) animated:YES];
}
// show photo
-(void)loadPhotoShowing{
    @try {
        int scrollPhotoNumber = MAX(0, MIN(pages.count-1, (int)(scrollView.contentOffset.x / self.frame.size.width)));
        currentPhotoNum = scrollPhotoNumber;
        if ([(KUDPhotoModel*)[pages objectAtIndex:currentPhotoNum] lPhoto] == nil ) {
            backgroundImage1.image = [UIImage imageNamed:@"shadow.png"];
        }else{
            backgroundImage1.image = [(KUDPhotoModel*)[pages objectAtIndex:currentPhotoNum] lPhoto];
        }
        [UIView animateWithDuration:0.5 animations:^{
            backgroundImage1.frame = CGRectMake(0,(self.frame.size.height-(backgroundImage1.image.size.height*320/backgroundImage1.image.size.width))/2,backgroundImage1.frame.size.width < 320?backgroundImage1.frame.size.width:320, (backgroundImage1.image.size.height*320/backgroundImage1.image.size.width));
            [UIView commitAnimations];
        }completion:^(BOOL finished) {
            
            
        }];
        backgroundImage1.alpha = 1;
        
    }
    @catch (NSException *exception) {
        NSLog(@"loadPhotoShowing:%@",exception);
    }
    @finally {
        
    }
}
- (void) initShow {
    @try {
        int scrollPhotoNumber = MAX(0, MIN(pages.count-1, (int)(scrollView.contentOffset.x / self.frame.size.width)));
        //if(scrollPhotoNumber != currentPhotoNum)
        currentPhotoNum = scrollPhotoNumber;
        if ([(KUDPhotoModel*)[pages objectAtIndex:currentPhotoNum] lPhoto] == nil ) {
            backgroundImage1.image = [UIImage imageNamed:@"shadow.png"];
        }else{
            backgroundImage1.image = [(KUDPhotoModel*)[pages objectAtIndex:currentPhotoNum] lPhoto];
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            backgroundImage1.frame = CGRectMake(0,(self.frame.size.height-(backgroundImage1.image.size.height*320/backgroundImage1.image.size.width))/2,backgroundImage1.frame.size.width < 320?backgroundImage1.frame.size.width:320, (backgroundImage1.image.size.height*320/backgroundImage1.image.size.width));
            [UIView commitAnimations];
        }completion:^(BOOL finished) {
            
            
        }];
        if (currentPhotoNum +1 != [pages count]) {
            backgroundImage2.image = [(KUDPhotoModel*)[pages objectAtIndex:currentPhotoNum+1] lPhoto]!= nil ? [(KUDPhotoModel*)[pages objectAtIndex:currentPhotoNum+1] lPhoto] :[UIImage imageNamed:@"shadow.png"] ;
            
        }else{
            backgroundImage2.image = nil;
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            backgroundImage2.frame = CGRectMake(0,(self.frame.size.height-(backgroundImage1.image.size.height*320/backgroundImage1.image.size.width))/2,backgroundImage2.frame.size.width < 320?backgroundImage2.frame.size.width:320, (backgroundImage1.image.size.height*320/backgroundImage1.image.size.width));
            [UIView commitAnimations];
        }completion:^(BOOL finished) {
            
        }];
        
        
        float offset =  scrollView.contentOffset.x - (currentPhotoNum * self.frame.size.width);
        //left
        if(offset < 0) {
            pageControl.currentPage = 0;
            
            offset = self.frame.size.width - MIN(-offset, self.frame.size.width);
            backgroundImage2.alpha = 0;
            backgroundImage1.alpha = (offset / self.frame.size.width);
            
            //other
        } else if(offset != 0) {
            //last
            if(scrollPhotoNumber == pages.count-1) {
                pageControl.currentPage = pages.count-1;
                
                backgroundImage1.alpha = 1.0 - (offset / self.frame.size.width);
            } else {
                
                pageControl.currentPage = (offset > self.frame.size.width/2) ? currentPhotoNum+1 : currentPhotoNum;
                
                backgroundImage2.alpha = offset / self.frame.size.width;
                backgroundImage1.alpha = 1.0 - backgroundImage2.alpha;
            }
            //stable
        } else {
            pageControl.currentPage = currentPhotoNum;
            backgroundImage1.alpha = 1;
            backgroundImage2.alpha = 0;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"initShow:%@",exception);
    }
    @finally {
        
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scroll {
    if (firstShow) {
        [self initShow];
        //[self initfirstShow];
        firstShow = FALSE;
    }else{
        [self initShow];
    }
    
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scroll {
    [self.delegate listLikePhotoHidden];
    [self.delegate navigationHidden];
    if(timer != nil) {
        [timer invalidate];
        timer = nil;
    }
    [self initShow];
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (touch.view  == self.listLikePhoto)
    {
        return NO;
    }
    return YES;
    
}

@end
