//
//  UIViewController+ColorWheelController.m
//  hairtech
//
//  Created by Alexander Prent on 12.01.2023.
//  Copyright © 2023 Admin. All rights reserved.
//

#import "ColorWheelController.h"


@implementation ColorWheelController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorNamed:@"grey"];

    CGSize size = self.view.bounds.size;
    
    CGSize wheelSize = CGSizeMake(size.width * .9, size.width * .9);
    
    _colorWheel = [[ISColorWheel alloc] initWithFrame:CGRectMake(size.width / 2 - wheelSize.width / 2,
                                                                 size.height * .2,
                                                                 wheelSize.width,
                                                                 wheelSize.height)];
    _colorWheel.delegate = self;
    _colorWheel.continuous = true;
    [self.view addSubview:_colorWheel];
    
    _brightnessSlider = [[UISlider alloc] initWithFrame:CGRectMake(size.width * .4,
                                                                   size.height * .7,
                                                                   size.width * .56,
                                                                   size.height * .1)];
    _brightnessSlider.minimumValue = 0.0;
    _brightnessSlider.maximumValue = 1.0;
    _brightnessSlider.value = 1.0;
    _brightnessSlider.continuous = true;
    [_brightnessSlider addTarget:self action:@selector(changeBrightness:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_brightnessSlider];
    
    CGFloat newHeight = size.width * .2;
    _wellView = [[UIView alloc] initWithFrame:CGRectMake(size.width * .1,
                                                         size.height * .7,
                                                         size.width * .2,
                                                         newHeight)];
    
    _wellView.layer.borderColor = [UIColor blackColor].CGColor;
    _wellView.layer.borderWidth = 0.0;
    _wellView.layer.cornerRadius = 14.0;
    [self.view addSubview:_wellView];
    
    [self addColorButtons:size.width * .4 height:size.height * .8];
}

-(void)addColorButtons:(CGFloat)width height:(CGFloat)height{
    int colorNumber = 0;
    for (int i=0; i<=1; i++) {
        for (int j=0; j<=5; j++) {
            
            colorButton = [UIButton buttonWithType:UIButtonTypeCustom];
            colorButton.frame = CGRectMake(width +(j*36), height +(i*36), 28, 28);
            [colorButton addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
            [colorButton setSelected:NO];
            [colorButton setNeedsDisplay];
            [colorButton setBackgroundColor:[UIColor colorNamed:@"orange"]];
           // [colorButton setHexColor:[self.colorCollection objectAtIndex:colorNumber]];
            colorButton.layer.cornerRadius = 14;
            colorButton.layer.masksToBounds = YES;
            
            colorButton.layer.borderColor = [UIColor colorWithRed:140.0f/255.0f green:140.0f/255.0f blue:140.0f/255.0f alpha:0.7f].CGColor;
            colorButton.layer.borderWidth = 0.0f;
            colorNumber ++;
            
            
           //dispatch_sync(dispatch_get_main_queue(), ^{
              //  [self.buttonCollection addObject:colorButton];
                [self.view addSubview:colorButton];
          // });//end block
            

        }
    }
}
-(IBAction)buttonPushed:(id)sender{
    NSLog(@"button pushed");
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

@end
