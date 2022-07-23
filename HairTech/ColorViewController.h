

#import <UIKit/UIKit.h>
#import "GzColors.h"
#import "ColorButton.h"
#import "ASValueTrackingSlider.h"



@class ColorViewController;




@protocol ColorViewControllerDelegate<NSObject>

- (void)colorPopoverControllerDidSelectColor:(NSString *)hexColor;

- (void)sliderDidSelectWidth:(CGFloat)lineWidth;
@end



@interface ColorViewController : UIViewController<ASValueTrackingSliderDelegate,ASValueTrackingSliderDataSource>{
    
    id <ColorViewControllerDelegate> __weak delegate;
    
    UIView *sliderBack;
    ASValueTrackingSlider*slider;
    
    BOOL sliderActive;
    NSArray *numbers;
    
    
    
    
    

}

//@property(nonatomic, strong) UISlider *slider;

@property(nonatomic, strong) NSMutableArray *buttonCollection;


@property (nonatomic, strong) NSArray *colorCollection;
@property (nonatomic, weak) id <ColorViewControllerDelegate> delegate;


@property (weak, nonatomic) IBOutlet UILabel *timerText;


@property (nonatomic, retain) IBOutlet UIButton *widthButton1;
@property (nonatomic, retain) IBOutlet UIButton *widthButton2;
@property (nonatomic, retain) IBOutlet UIButton *widthButton3;
@property (nonatomic, retain) IBOutlet UIButton *widthButton4;
@property (nonatomic, retain) IBOutlet UIButton *widthButton5;

@property UIColor* tColor1;
@property UIColor* tColor2;
@property UIColor* tColor3;
@property UIColor* tColor4;
@property UIColor* tColor5;
@property UIColor* tColor6;;

@property UIColor* currentPenColor;




@end
