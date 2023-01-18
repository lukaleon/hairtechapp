//
//  UIViewController+ColorWheelController.m
//  hairtech
//
//  Created by Alexander Prent on 12.01.2023.
//  Copyright © 2023 Admin. All rights reserved.
//

#import "ColorWheelController.h"
#import "GzColors.h"
#import "ColorButton.h"
#import "HapticHelper.h"


@implementation ColorWheelController
{
    ColorButton * currentButton;

}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSUserDefaults standardUserDefaults] setObject:self.colorCollection forKey:@"colorCollection"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCloseButton];
    // define a variable to store initial touch position
    initialTouchPoint  = CGPointMake(0, 0);

    
    self.colorCollection = [NSMutableArray array];
    self.buttonCollection = [NSMutableArray array];
    
    self.colorCollection = [[[NSUserDefaults standardUserDefaults] objectForKey:@"colorCollection"]mutableCopy];
    
    if(!self.isIpad){
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
        panGesture.delegate = self;
        [self.view addGestureRecognizer:panGesture];
    }
  
    self.view.backgroundColor = [UIColor colorNamed:@"grey"];
    
    
    CGSize size = self.view.bounds.size;
    
    CGFloat screenPartitionIdx;
    CGFloat screenPartitionWidth;

    CGFloat colorButtonSize;
    CGFloat distance;
    CGFloat correctionIdx;
    CGFloat fontSize;
    CGFloat axeYLift;
    CGFloat axeYforSE;
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        screenPartitionIdx = size.height / 12;
        screenPartitionWidth = size.width / 20;

        colorButtonSize = 36;
        distance = 60;
        correctionIdx = 38;
        fontSize = 18;
        axeYLift = 120;
        axeYforSE = 0;
    
    }else {
        
        screenPartitionIdx = size.height / 20;
        screenPartitionWidth = size.width / 20;

        colorButtonSize = 26;
        distance = 36;
        correctionIdx = 0;
        fontSize = 14;
        axeYforSE = 0;

        
        CGRect screenSize = [[UIScreen mainScreen] bounds];
        NSLog(@" difffff %f",screenSize.size.height / screenSize.size.width);

        if(screenSize.size.height / screenSize.size.width < 2){
            axeYLift = 20;
            axeYforSE = 20;

            
        }
        else {
            axeYLift = 0;

        }
    }
    
    CGSize wheelSize = CGSizeMake(size.width * .46, size.width * .46);
    
    [self addRestoreButton];
    
    [self addHorizontalLine:size.height * .06];

    /*_colorWheel = [[ISColorWheel alloc] initWithFrame:CGRectMake(size.width / 3.5 - wheelSize.width / 3.5,
                                                                 size.height * .08,
                                                                 wheelSize.width,
                                                                 wheelSize.height)];*/
    _colorWheel = [[ISColorWheel alloc] initWithFrame:CGRectMake(screenPartitionWidth * 4,
                                                                 screenPartitionIdx * 1.7 + axeYLift,
                                                                 screenPartitionIdx * 4,
                                                                 screenPartitionIdx * 4)];
    
    //_colorWheel.center = self.view.center;
    _colorWheel.delegate = self;
    _colorWheel.continuous = true;
    [self.view addSubview:_colorWheel];
    
   /* _brightnessSlider = [[UISlider alloc] initWithFrame:CGRectMake(size.width * .56,
                                                                   size.height * .14,
                                                                   size.width * .40,
                                                                   size.height * .1)];*/
    _brightnessSlider = [[UISlider alloc] initWithFrame:CGRectMake(screenPartitionWidth * 11,
                                                                   screenPartitionIdx * 3.4 + axeYLift,
                                                                   screenPartitionIdx * 3.5,
                                                                   40 )];
    
    _brightnessSlider.tintColor = [UIColor colorNamed:@"cellBg"];
    _brightnessSlider.minimumValue = 0.0;
    _brightnessSlider.maximumValue = 1.0;
    _brightnessSlider.value = 1.0;
    _brightnessSlider.continuous = true;
//    [_brightnessSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
//    [_brightnessSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateHighlighted];

    [_brightnessSlider addTarget:self action:@selector(changeBrightness:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_brightnessSlider];
  
    
    
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * 1.5);
      _brightnessSlider.transform = trans;
//    NSLog(@"slider %f, %f, %f, %f",_brightnessSlider.frame.origin.x, _brightnessSlider.frame.origin.y, _brightnessSlider.frame.size.width, _brightnessSlider.frame.size.height );
    
    
//    [self addHorizontalLine:size.height * .31];
    [self addHorizontalLine:(screenPartitionIdx * 6.2) + axeYLift];
    
//    CGFloat newHeight = size.width * .16;
    _wellView = [[UIView alloc] initWithFrame:CGRectMake(screenPartitionWidth * 2,
                                                         screenPartitionIdx * 6.6 + axeYLift,
                                                         (screenPartitionWidth * 3.4) - correctionIdx,
                                                         (screenPartitionWidth) * 3.4 - correctionIdx)];
    _wellView.layer.backgroundColor = [GzColors colorFromHex:[self.colorCollection objectAtIndex:0]].CGColor;
    _wellView.layer.borderColor = [UIColor blackColor].CGColor;
    _wellView.layer.borderWidth = 0.0;
    _wellView.layer.cornerRadius = 10.0;
    [self.view addSubview:_wellView];
    
    [self addColorButtons:screenPartitionWidth * 7.2 height:(screenPartitionIdx * 6.6 ) + axeYLift buttonWidth:colorButtonSize distance:distance];
    
    ColorButton * btn = [self.buttonCollection objectAtIndex:0];
   // [self currentColorIndicator:btn];
    [self buttonPushed:btn];
    NSLog(@"axe %f", (screenPartitionIdx * 8.3) + axeYLift);
    [self addApplyButtonX:(screenPartitionWidth * 7) + correctionIdx  startY:(screenPartitionIdx * 8.3) + axeYLift + axeYforSE fontSize:fontSize];
    
}

-(void)addColorButtons:(CGFloat)x height:(CGFloat)height buttonWidth:(CGFloat)width distance:(CGFloat)distance{
    int colorNumber = 0;
    for (int i=0; i<=1; i++) {
        for (int j=0; j<=5; j++) {
            
            ColorButton * colorButton = [ColorButton buttonWithType:UIButtonTypeCustom];
            colorButton.frame = CGRectMake(x +(j*distance), height +(i*distance), width, width);
            [colorButton addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
            colorButton.tag = colorNumber;
            [colorButton setSelected:NO];
            [colorButton setNeedsDisplay];
            [colorButton setBackgroundColor:[GzColors colorFromHex:[self.colorCollection objectAtIndex:colorNumber]]];
            colorButton.layer.cornerRadius = width / 2;
            colorButton.layer.masksToBounds = YES;
            
            colorButton.layer.borderColor = [UIColor colorWithRed:140.0f/255.0f green:140.0f/255.0f blue:140.0f/255.0f alpha:0.7f].CGColor;
            colorButton.layer.borderWidth = 0.0f;
            colorNumber ++;
            
            
           //dispatch_sync(dispatch_get_main_queue(), ^{
               [self.buttonCollection addObject:colorButton];
                [self.view addSubview:colorButton];
          // });//end block
            

        }
    }
}


-(void)addCloseButton{
    CGFloat startOfButton;
    CGFloat startY;
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        startOfButton = 120;
        startY = 18;
    }else {
        startOfButton = 42;
        startY = 10;
    }
    
    UIButton *more = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - startOfButton, self.view.frame.origin.y + startY, 30, 30)];
    [more addTarget:self
             action:@selector(closeView:)
   forControlEvents:UIControlEventTouchUpInside];
    [more.widthAnchor constraintEqualToConstant:30].active = YES;
    [more.heightAnchor constraintEqualToConstant:30].active = YES;
   // [more setImage:[UIImage imageNamed:@"Close"] forState:UIControlStateNormal];
    
    CGFloat pts = [UIFont buttonFontSize];
    UIImageSymbolConfiguration* conf = [UIImageSymbolConfiguration configurationWithPointSize:pts weight:UIImageSymbolWeightSemibold];
    [more setImage:[UIImage systemImageNamed:@"xmark" withConfiguration:conf] forState:UIControlStateNormal];
    [more setTintColor:[UIColor colorNamed:@"textWhiteDeepBlue"]];
//    UIBarButtonItem * moreBtn =[[UIBarButtonItem alloc] initWithCustomView:more];
//    self.navigationItem.leftBarButtonItem = moreBtn;
    [self.view addSubview:more];
}

-(void)addRestoreButton{
    CGFloat startOfButton;
    CGFloat startY;
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        startOfButton = 24;
        startY = 18;

    }else {
        startOfButton = 12;
        startY = 10;

    }
    UIButton *more = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + startOfButton, self.view.frame.origin.y + startY, 30, 30)];
    [more addTarget:self
             action:@selector(showMenu)
   forControlEvents:UIControlEventTouchUpInside];
    [more.widthAnchor constraintEqualToConstant:30].active = YES;
    [more.heightAnchor constraintEqualToConstant:30].active = YES;
    CGFloat pts = [UIFont buttonFontSize];
    UIImageSymbolConfiguration* conf = [UIImageSymbolConfiguration configurationWithPointSize:pts weight:UIImageSymbolWeightSemibold];
    [more setImage:[UIImage systemImageNamed:@"slider.horizontal.2.gobackward" withConfiguration:conf] forState:UIControlStateNormal];
    
    [more setTintColor:[UIColor colorNamed:@"textWhiteDeepBlue"]];
//    UIBarButtonItem * moreBtn =[[UIBarButtonItem alloc] initWithCustomView:more];
//    self.navigationItem.leftBarButtonItem = moreBtn;
    btnRect = more.frame;
    [self.view addSubview:more];
}
-(void)showMenu{
    UIMenuController * menu = [UIMenuController sharedMenuController];
    menu.menuItems = @[
        [[UIMenuItem alloc] initWithTitle:@"Restore Color Set" action:@selector(restoreDefaultColors:)]];
    [menu setArrowDirection:UIMenuControllerArrowUp];
    [menu showMenuFromView:self.view rect:btnRect];
}
-(IBAction)closeView:(id)senxer{
    
    [self dismissViewControllerAnimated:true completion:nil];

}

- (void)addHorizontalLine:(CGFloat)y {
    CAShapeLayer *line = [CAShapeLayer layer];
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    [linePath moveToPoint: CGPointMake(0,y)];
    [linePath addLineToPoint:CGPointMake(self.view.frame.size.width,y)];
    line.path = linePath.CGPath;
    line.fillColor = nil;
    line.opacity = 0.1;
    line.strokeColor = [UIColor grayColor].CGColor;
    [self.view.layer addSublayer:line];
}

-(void)addApplyButtonX:(CGFloat)x startY:(CGFloat)y fontSize:(CGFloat)fonttSize{
    self.applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.applyBtn.frame = CGRectMake(x, y, 120, 40);
    [self.applyBtn addTarget:self action:@selector(applyColorChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.applyBtn setTitle:@"Set color" forState:UIControlStateNormal];
    [self.applyBtn setTitleColor:[UIColor colorNamed:@"textWhiteDeepBlue"] forState:UIControlStateNormal];
    [self.applyBtn setTitleColor:[UIColor colorNamed:@"setColor"] forState:UIControlStateDisabled];
    self.applyBtn.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:fonttSize];
    self.applyBtn.enabled = NO;
    [self.view addSubview:self.applyBtn];

}
-(IBAction)applyColorChange:(id)sender{
    
    [HapticHelper generateFeedback:FeedbackType_Impact_Light];

    NSString * color =  [self hexStringFromColor:_wellView.backgroundColor];
    currentButton.backgroundColor = _wellView.backgroundColor;
    
    [self.colorCollection replaceObjectAtIndex:currentButton.tag withObject:color];
    NSLog(@"color %@" , color);
    self.applyBtn.enabled = NO;
}


- (NSString *)hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);

    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];

    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

- (void)changeBrightness:(UISlider*)sender
{
    
    [_colorWheel setBrightness:_brightnessSlider.value];
    [_wellView setBackgroundColor:_colorWheel.currentColor];
    self.applyBtn.enabled = YES;
}

- (void)colorWheelDidChangeColor:(ISColorWheel *)colorWheel
{
    self.applyBtn.enabled = YES;
    [_wellView setBackgroundColor:_colorWheel.currentColor];
}
- (void)colorWheelDidChangeColorOnMove:(ISColorWheel *)colorWheel
{
    [self.presentationController.presentedView.gestureRecognizers.firstObject setEnabled:NO];
   
    [_wellView setBackgroundColor:_colorWheel.currentColor];
    self.applyBtn.enabled = YES;
}
    // Do any additional setup after loading the view, typically from a nib.

-(void)enableGestures{
    [self.presentationController.presentedView.gestureRecognizers.firstObject setEnabled:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)buttonPushed:(id)sender{
  
    [HapticHelper generateFeedback:FeedbackType_Impact_Light];
    
    ColorButton *btn = (ColorButton *)sender;
    
    for(int i=0; i< self.buttonCollection.count; i++) {
        [[self.buttonCollection objectAtIndex:i] setSelected:NO];
        [line removeFromSuperlayer];
    }
    
    [self indicateSelctedButton:btn];
    currentButton = btn;
    self.applyBtn.enabled = NO;

}
- (void)indicateSelctedButton:(ColorButton *)btn {
    btn.layer.borderWidth = 0.0f;
    btn.layer.borderColor = [UIColor darkGrayColor].CGColor ;
    [self currentColorIndicator:btn];
    _colorWheel.currentColor = btn.backgroundColor;
    [_colorWheel.knobView  performSelector:@selector(setFillColor:) withObject:btn.backgroundColor ];
    _brightnessSlider.value =_colorWheel.brightness;
    [_wellView setBackgroundColor: btn.backgroundColor];
}

-(void)currentColorIndicator:(ColorButton*)colorBtn
{
        line = [CAShapeLayer layer];
        UIBezierPath *linePath=[UIBezierPath bezierPath];
        [linePath moveToPoint: CGPointMake(9,13)];
        [linePath addLineToPoint:CGPointMake(12,16)];
        [linePath moveToPoint: CGPointMake(12,16)];
        [linePath addLineToPoint:CGPointMake(17,11)];
        line.path=linePath.CGPath;
        line.fillColor = nil;
        line.lineCap = kCALineCapRound;
        line.lineJoin = kCALineJoinRound;
        line.opacity = 1;
        line.lineWidth = 2.2;
        line.strokeColor = [UIColor whiteColor].CGColor;
        [colorBtn.layer addSublayer:line];
}

-(IBAction)restoreDefaultColors:(id)sender{
    
        self.applyBtn.enabled = NO;
       NSArray * defaultColors = [NSArray arrayWithObjects:
                                
                                Black,
                                RoyalBlue,
                                Red,
                                Green,
                                DarkRed,
                                DarkSlateGray,
                               
                                DeepPink,
                                Purple,
                                OrangeRed,
                                Orange,
                                DarkBlue,
                                Yellow,
                                nil];
    
    
    [self.colorCollection removeAllObjects];

    for(NSString * color in defaultColors){
        [self.colorCollection addObject:color];
    }
    int colorNumber = 0;
    for (ColorButton * btn in self.buttonCollection){
        
        
        [btn setBackgroundColor:[GzColors colorFromHex:[self.colorCollection objectAtIndex:colorNumber]]];
        colorNumber++;
    }
    
}

- (void)panGestureAction:(UIPanGestureRecognizer*)gesture {
    
    CGPoint location = [gesture locationInView:self.view];
    CGPoint locationInWindow = [gesture locationInView:self.view.window];
    CGFloat frameStart;
    CGPoint startPoint;
    //    if (translation.x != 0 || translation.y != 0) {
    //        double angle = atan2(fabs(translation.x), translation.y);
    //        if (angle < M_PI / 8) {
    if(gesture.state == UIGestureRecognizerStateBegan){
        
        initialTouchPoint = location;
        
        frameStart = self.view.frame.origin.y;
        startPoint = locationInWindow;
    }
    if(gesture.state == UIGestureRecognizerStateChanged){
        
        NSLog(@"diff %f - %f", startPoint.y, location.y );
        
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + (location.y - initialTouchPoint.y), self.view.frame.size.width, self.view.frame.size.height);
              NSLog(@"origin Y %f", self.view.frame.origin.y);
       
        
        if(self.view.frame.origin.y - (frameStart + 400)  > 200){
            
            [UIView animateWithDuration:0.5 animations:^{
                self.view.frame = CGRectMake(self.view.frame.origin.x, 800, self.view.frame.size.width, self.view.frame.size.height);
                
            } completion:^(BOOL finished){
                [self dismissViewControllerAnimated:true completion:nil];
            }];
            [self dismissViewControllerAnimated:true completion:nil];

            
            
        }
        if(self.view.frame.origin.y < 400){
            self.view.frame = CGRectMake(self.view.frame.origin.x, 400, self.view.frame.size.width, self.view.frame.size.height);

        }
    }

    if(gesture.state == UIGestureRecognizerStateEnded ){

        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = CGRectMake(self.view.frame.origin.x, 400, self.view.frame.size.width, self.view.frame.size.height);
            
        } completion:^(BOOL finished){
        }];
    }


}



//- (void)viewWillLayoutSubviews{
//    [super viewWillLayoutSubviews];
//    self.view.superview.bounds = CGRectMake(0, 0, 500, 600);
//}


@end
