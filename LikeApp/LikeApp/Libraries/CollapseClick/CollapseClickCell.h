

#import <UIKit/UIKit.h>
#import "KUDCollapseClickArrow.h"

#define kCCHeaderHeight 50

@interface CollapseClickCell : UIView

// Header
@property (weak, nonatomic) IBOutlet UIView *TitleView;
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *TitleButton;
@property (weak, nonatomic) IBOutlet KUDCollapseClickArrow *TitleArrow;

// Body
@property (weak, nonatomic) IBOutlet UIView *ContentView;

// Properties
@property (nonatomic, assign) BOOL isClicked;
@property (nonatomic, assign) int index;

// Init
+ (CollapseClickCell *)newCollapseClickCellWithTitle:(NSString *)title index:(int)index content:(UIView *)content;

@end
