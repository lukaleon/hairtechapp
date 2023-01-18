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
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
    
    [self.view addGestureRecognizer:panGesture];

  
    self.view.backgroundColor = [UIColor colorNamed:@"grey"];
    
    CGSize size = self.view.bounds.size;
    
    CGSize wheelSize = CGSizeMake(size.width * .6, size.width * .6);
    
    [self addRestoreButton];
    
    _colorWheel = [[ISColorWheel alloc] initWithFrame:CGRectMake(size.width / 3.4 - wheelSize.width / 3.4,
                                                                 size.height * .05,
                                                                 wheelSize.width,
                                                                 wheelSize.height)];
    //_colorWheel.center = self.view.center;
    _colorWheel.delegate = self;
    _colorWheel.continuous = true;
    [self.view addSubview:_colorWheel];
    
    _brightnessSlider = [[UISlider alloc] initWithFrame:CGRectMake(size.width * .62,
                                                                   size.height * .15,
                                                                   size.width * .45,
                                                                   size.height * .1)];
    _brightnessSlider.tintColor = [UIColor colorNamed:@"cellBg"];
    _brightnessSlider.minimumValue = 0.0;
    _brightnessSlider.maximumValue = 1.0;
    _brightnessSlider.value = 1.0;
    _brightnessSlider.continuous = true;
    [_brightnessSlider addTarget:self action:@selector(changeBrightness:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_brightnessSlider];
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * 1.5);
      _brightnessSlider.transform = trans;
    
    [self addHorizontalLine:size.height * .35];
    
    CGFloat newHeight = size.width * .17;
    _wellView = [[UIView alloc] initWithFrame:CGRectMake(size.width * .08,
                                                         size.height * .38,
                                                         size.width * .17,
                                                         newHeight)];
    _wellView.layer.backgroundColor =[GzColors colorFromHex:[self.colorCollection objectAtIndex:0]].CGColor;
    _wellView.layer.borderColor = [UIColor blackColor].CGColor;
    _wellView.layer.borderWidth = 0.0;
    _wellView.layer.cornerRadius = 10.0;
    [self.view addSubview:_wellView];
    
   [self addColorButtons:size.width * .35 height:size.height * .38];
    
    ColorButton * btn = [self.buttonCollection objectAtIndex:0];
    [self currentColorIndicator:btn];
    
    [self addApplyButton:size.height * .3];
    
}

-(void)addColorButtons:(CGFloat)width height:(CGFloat)height{
    int colorNumber = 0;
    for (int i=0; i<=1; i++) {
        for (int j=0; j<=5; j++) {
            
            ColorButton * colorButton = [ColorButton buttonWithType:UIButtonTypeCustom];
            colorButton.frame = CGRectMake(width +(j*36), height +(i*36), 26, 26);
            [colorButton addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
            colorButton.tag = colorNumber;
            [colorButton setSelected:NO];
            [colorButton setNeedsDisplay];
            [colorButton setBackgroundColor:[GzColors colorFromHex:[self.colorCollection objectAtIndex:colorNumber]]];
            colorButton.layer.cornerRadius = 13;
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
    UIButton *more = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 42, self.view.frame.origin.y + 10, 30, 30)];
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
    UIButton *more = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.origin.x +12, self.view.frame.origin.y + 10, 30, 30)];
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

-(void)addApplyButton:(CGFloat)y{
    UIButton * applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    applyBtn.frame = CGRectMake(self.view.frame.size.width / 2 + 60, y, 120, 40);
    [applyBtn addTarget:self action:@selector(applyColorChange:) forControlEvents:UIControlEventTouchUpInside];
    [applyBtn setTitle:@"Replace color" forState:UIControlStateNormal];
    [applyBtn setTitleColor:[UIColor colorNamed:@"orange"] forState:UIControlStateNormal];
    applyBtn.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14];

    [self.view addSubview:applyBtn];

    
}
-(IBAction)applyColorChange:(id)sender{
    
    NSString * color =  [self hexStringFromColor:_wellView.backgroundColor];
    currentButton.backgroundColor = _wellView.backgroundColor;
    
    [self.colorCollection replaceObjectAtIndex:currentButton.tag withObject:color];
    NSLog(@"color %@" , color);
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
}

- (void)colorWheelDidChangeColor:(ISColorWheel *)colorWheel
{
    [_wellView setBackgroundColor:_colorWheel.currentColor];
}
- (void)colorWheelDidChangeColorOnMove:(ISColorWheel *)colorWheel
{
    [self.presentationController.presentedView.gestureRecognizers.firstObject setEnabled:NO];
   
    [_wellView setBackgroundColor:_colorWheel.currentColor];
}
    // Do any additional setup after loading the view, typically from a nib.

-(void)enableGestures{
    [self.presentationController.presentedView.gestureRecognizers.firstObject setEnabled:YES];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buttonPushed:(id)sender{
    
    
    ColorButton *btn = (ColorButton *)sender;
    
    for(int i=0; i< self.buttonCollection.count; i++) {
        [[self.buttonCollection objectAtIndex:i] setSelected:NO];
        [line removeFromSuperlayer];
    }
    
    [self indicateSelctedButton:btn];
    currentButton = btn;
    
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
        [linePath moveToPoint: CGPointMake(10,14)];
        [linePath addLineToPoint:CGPointMake(13,17)];
        [linePath moveToPoint: CGPointMake(13,17)];
        [linePath addLineToPoint:CGPointMake(18,12)];
        line.path=linePath.CGPath;
        line.fillColor = nil;
        line.lineCap = kCALineCapRound;
        line.lineJoin = kCALineJoinRound;
        line.opacity = 1;
        line.lineWidth = 2.2;
        line.strokeColor = [UIColor whiteColor].CGColor;
        [colorBtn.layer addSublayer:line];
}

//-(void)addRestoreButton{
//
//    UIButton * restore = [UIButton buttonWithType:UIButtonTypeCustom];
//    restore.frame = CGRectMake(self.view.frame.size.width / 2 - 60, 200, 120, 40);
//    [restore addTarget:self action:@selector(restoreDefaultColors:) forControlEvents:UIControlEventTouchUpInside];
//    [restore setTitle:@"Restore" forState:UIControlStateNormal];
//    [restore setTitleColor:[UIColor colorNamed:@"orange"] forState:UIControlStateNormal];
//    restore.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14];
//
//    [self.view addSubview:restore];
//}

-(IBAction)restoreDefaultColors:(id)sender{
    
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
        //        //  NSLog(@"initial Y %f", initialTouchPoint.y);
        //        NSLog(@"loc - init  %f", location.y - frameStart);
        //
        //
        
        if(self.view.frame.origin.y - (frameStart + 400)  > 300){
            
            [UIView animateWithDuration:2 animations:^{
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
//    self.view.superview.bounds = CGRectMake(0, 0, self.view.frame.size.width, 300);
//}
//
@end
