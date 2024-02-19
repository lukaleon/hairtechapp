

#import <UIKit/UIKit.h>
#import "GzColors.h"
#import "ColorButton.h"
#import "ASValueTrackingSlider.h"



@class ColorViewController;

@protocol ColorViewControllerDelegate<NSObject>
- (void)textSettingsDidSelectFontSize:(CGFloat)fontSize;
- (void)colorPopoverControllerDidSelectColor:(NSString *)hexColor;
- (void)colorPopoverDidSelectTextColor:(NSString *)hexColor;
- (void)sliderDidSelectWidth:(CGFloat)lineWidth;
- (void)addTextFromTextSettings;
- (void)colorPopoverWillShowColorWheel:(UIColor*)currentColor;

@end



@interface ColorViewController : UIView <ASValueTrackingSliderDelegate,ASValueTrackingSliderDataSource>{
    
    id <ColorViewControllerDelegate> __weak delegate;
    
    UIView *sliderBack;
    ASValueTrackingSlider*slider;
    
    BOOL sliderActive;
    NSArray *numbers;
    
    BOOL textSelected;
    CAShapeLayer *line;
    CAShapeLayer * circle;
    CGFloat lastColorButtonX;
    CGFloat lineCoordinateX;
    NSString * _currentToolName;
    NSMutableArray * arrayOfCircles;
    BOOL editMode;
    

}
@property(nonatomic, strong)  UIScrollView * scrollText;

@property(nonatomic, strong)  UIButton * editBtn;
@property(nonatomic, strong)  UILabel * currentTool;

@property(nonatomic, strong)  ColorButton * startButton;


@property( nonatomic, assign) CGFloat fontSizee;
@property( nonatomic, assign) UIColor * currentTextColorForIndicator;

@property IBOutlet UIView * rectView;
@property IBOutlet CAShapeLayer * lineSeparator;
@property(nonatomic, strong)  IBOutlet UIButton * button1;
@property (nonatomic, strong) IBOutlet UIButton * button2;
@property (nonatomic, strong) IBOutlet UIButton * button3;

- (id)initWithFrame:(CGRect)frame isSelected:(BOOL)isSelected color:(UIColor*)currentColor currentTool:(NSString*)currentTool;
@property (nonatomic, assign) BOOL isTextSelected;

//@property(nonatomic, strong) UISlider *slider;

@property(nonatomic, strong) NSMutableArray *buttonCollection;


@property (nonatomic, strong) NSArray *colorCollection;
@property (nonatomic, strong) NSArray *colorCollectionForText;
@property (nonatomic, strong) NSMutableArray *currentColorCollection;


@property (nonatomic, weak) id <ColorViewControllerDelegate> delegate;


@property (weak, nonatomic) IBOutlet UILabel *timerText;
@property (retain, nonatomic) IBOutlet UIButton *btnFontDecrease;
@property (retain, nonatomic) IBOutlet UIButton *btnFontIncrease;



@property (nonatomic, retain) IBOutlet UIButton *widthButton1;
@property (nonatomic, retain) IBOutlet UIButton *widthButton2;
@property (nonatomic, retain) IBOutlet UIButton *widthButton3;
@property (nonatomic, retain) IBOutlet UIButton *widthButton4;
@property (nonatomic, retain) IBOutlet UIButton *widthButton5;

@property UIColor * penColor;
@property UIColor * curveColor;
@property UIColor * dashColor;
@property UIColor * arrowColor;
@property UIColor * lineColor;

@property UIColor* currentPenColor;



@end
