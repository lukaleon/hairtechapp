
#import "ColorViewController.h"

@interface ColorViewController ()

@end

@implementation ColorViewController

@synthesize delegate;
@synthesize widthButton1;
@synthesize widthButton2;
@synthesize widthButton3;
@synthesize widthButton4;
@synthesize widthButton5;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
   
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     
     
                if ([self respondsToSelector:@selector(setPreferredContentSize:)]) {
                    self.preferredContentSize = CGSizeMake(240, 120);
               } else {
                  self.contentSizeForViewInPopover = CGSizeMake(240,120);
                }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createSimplyfiedOrdenatedColorsArray];
    [self loadColorButtons];
    [self LoadColorsAtStart];
    

    
     NSLog(@"COLOR POPOVER IS CREATED");
    
    if([self loadFloatFromUserDefaultsForKey:@"lineWidth"] == 2.0 ){
        
        [self button1Select];
    }
    if([self loadFloatFromUserDefaultsForKey:@"lineWidth"] == 4.0 )
    {
        
        [self button2Select];
    }
    if([self loadFloatFromUserDefaultsForKey:@"lineWidth"] == 6.0 )
    {
        
        [self button3Select];
    }
    if([self loadFloatFromUserDefaultsForKey:@"lineWidth"] == 8.0 )
    {
        
        [self button4Select];
    }
    if([self loadFloatFromUserDefaultsForKey:@"lineWidth"] == 12.0 )
    {
        
        [self button5Select];
    }
    
    
    CGColorRef colorRef = self.currentPenColor.CGColor;
     NSString *colorString = [CIColor colorWithCGColor:colorRef].stringRepresentation;
     NSLog(@"PEN COLOR STRING = %@", colorString);
    
    //dispatch_queue_t myQueue = dispatch_queue_create("com.gazapps.myqueue", 0);
  //  dispatch_async(myQueue, ^{
        for (int i=0; i<=11; i++) {
          

            
             /* if([colorString isEqual:[GzColors colorFromHex:[self.colorCollection objectAtIndex:i]]]){
                    
                   NSLog(@"COLORS MATCHED %@ %@", colorString,[GzColors colorFromHex:[self.colorCollection objectAtIndex:colorNumber]]);
                    
                
            }*/

            if (CGColorEqualToColor(self.currentPenColor.CGColor,[GzColors colorFromHex:[self.colorCollection objectAtIndex:i]].CGColor))
               {
                   //NSLog(@"COLORS MATCHED %@ %@", colorString,[GzColors colorFromHex:[self.colorCollection objectAtIndex:i]]);
                   
                   
                   
                [self currentColorIndicator:[self.buttonCollection objectAtIndex:i]];

                   
                   
               }
    
        }
        
  //  });
    
   /* CGColorRef colorRef = self.currentPenColor.CGColor;
    NSString *colorString = [CIColor colorWithCGColor:colorRef].stringRepresentation;
    NSLog(@"colorString = %@", colorString);
    
    */
    
    
    
}







- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
/*
-(void) createSimplyfiedOrdenatedColorsArray{
    self.colorCollection = [NSArray arrayWithObjects:
Dark ,
Green,
Yellow,
RedOrange,
Violet,
GrayBlue,

Turqois,
LightBlue,
Red,
LightGray,
Gray,
Pink ,
                            Turqois,
                            LightBlue,
                            Red,
                            LightGray,
                            Gray,
                            Pink ,
                            
                            Turqois,
                            LightBlue,
                            Red,
                            LightGray,
                            Gray,
                            Pink ,
                            
                            Turqois,
                            LightBlue,
                            Red,
                            LightGray,
                            Gray,
                            Pink ,
                            
                            Turqois,
                            LightBlue,
                            Red,
                            LightGray,
                            Gray,
                            Pink ,
                            
                            
                            
                            nil];
    
}
*/

-(void) createSimplyfiedOrdenatedColorsArray{
    self.colorCollection = [NSArray arrayWithObjects:
                            
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
                         /*   Pink,
                            HotPink,
                            Coral,
                            Fuchsia,
                            Magenta,
                            Crimson,
                            
                            SeaGreen,
                            ForestGreen,
                            Green,
                            Tomato,
                            OliveDrab,
                            Olive,
                            
                            DeepSkyBlue,
                            CornflowerBlue,
                            Gold,
                            Blue,
                            LightCoral,
                            MidnightBlue,
                            
                            Goldenrod,
                            DarkGoldenrod,
                            Chocolate,
                            SaddleBrown,
                            Brown,
                            Maroon,
                            
                            White,
                            Snow,
                            Gainsboro,
                            LightGray,
                            Silver,
                            DarkGray,
                            
                            Gray,
                            DimGray,
                            LightSlateGray,
                            SlateGray,
                            Firebrick,
                            IndianRed, nil];*/
}




-(void)loadColorButtons{
    //self.view.backgroundColor = UIColor.grayColor;
    self.view.layer.cornerRadius = 10;
    UIColor *color = [UIColor grayColor];
        CGColorRef gray = color.CGColor;
        self.view.layer.shadowColor = gray;
        self.view.layer.shadowOffset = CGSizeMake(0, 0);
        self.view.layer.shadowRadius = 7;
        self.view.layer.shadowOpacity = 0.2;
        //self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        self.view.layer.masksToBounds = NO;

    [self.view setBackgroundColor: [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    
    //UIImageView *dot =[[UIImageView alloc] initWithFrame:CGRectMake(0.0,35.0,240.0,30.0)];
     // dot.image=[UIImage imageNamed:@"sliderdots.png"];
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 36, 240,80)];
    scroll.contentSize = CGSizeMake(200, 320);
    
    [self.view addSubview:scroll];
    
    [scroll setScrollEnabled:NO];
    
    [self addWidthButtons];
    
    CAShapeLayer *line = [CAShapeLayer layer];
        UIBezierPath *linePath=[UIBezierPath bezierPath];
        [linePath moveToPoint: CGPointMake(0,36)];
        [linePath addLineToPoint:CGPointMake(240,36)];
        line.path=linePath.CGPath;
        line.fillColor = nil;
        line.opacity = 0.1;
        line.strokeColor = [UIColor grayColor].CGColor;
        [self.view.layer addSublayer:line];
    
      //  [self.view.layer addSublayer:line];
    
    //[self.view addSubview:dot];

    
   //[self setupSlider];
    
   // [self.view addSubview:dot2];
   // [self.view addSubview:self.slider];
    
	if (self.buttonCollection != nil) {
		for (ColorButton *colorButton in self.buttonCollection) {
			[colorButton removeFromSuperview];
		}
		self.buttonCollection = nil;
	}
    
	self.buttonCollection = [[NSMutableArray alloc]init];

   // dispatch_queue_t myQueue = dispatch_queue_create("com.gazapps.myqueue", 0);
  //  dispatch_async(myQueue, ^{
        int colorNumber = 0;
        for (int i=0; i<=1; i++) {
            for (int j=0; j<=5; j++) {
                
                ColorButton *colorButton = [ColorButton buttonWithType:UIButtonTypeCustom];
                colorButton.frame = CGRectMake(14+(j*36), 14+(i*36), 28, 28);
                [colorButton addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
                
                [colorButton setSelected:NO];
                [colorButton setNeedsDisplay];
                [colorButton setBackgroundColor:[GzColors colorFromHex:[self.colorCollection objectAtIndex:colorNumber]]];
                [colorButton setHexColor:[self.colorCollection objectAtIndex:colorNumber]];
                
               colorButton.layer.cornerRadius = 14;
                colorButton.layer.masksToBounds = YES;
                
                
                
              //  colorButton.layer.borderColor = [UIColor blackColor].CGColor;
                
                colorButton.layer.borderColor = [UIColor colorWithRed:140.0f/255.0f green:140.0f/255.0f blue:140.0f/255.0f alpha:0.7f].CGColor;
                colorButton.layer.borderWidth = 0.0f;
                
               /* CAGradientLayer *gradient = [CAGradientLayer layer];
                gradient.frame = colorButton.bounds;
                //               gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor whiteColor] CGColor], nil];
                gradient.colors = [NSArray arrayWithObjects:(id)[ [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.45] CGColor], (id)[[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1]  CGColor], nil];
                
                
                [colorButton.layer insertSublayer:gradient atIndex:0];
                */
                

                
                colorNumber ++;
                
                
               //dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.buttonCollection addObject:colorButton];
                    [scroll addSubview:colorButton];
              // });//end block
                

            }
        }
        
  //  });//end block
   // dispatch_release(myQueue);
    NSLog(@"COLOR BUTTONS %lu", self.buttonCollection.count);

}



-(void) buttonPushed:(id)sender{    
    ColorButton *btn = (ColorButton *)sender;

    [delegate colorPopoverControllerDidSelectColor:btn.hexColor];
    
    btn.layer.borderWidth = 0.0f;
    btn.layer.borderColor = [UIColor darkGrayColor].CGColor ;
    
    [self currentColorIndicator:btn];
    NSLog(@"Current color %@",btn.hexColor );
}






/*
- (IBAction)sliderAction:(id)sender {
   // NSLog(@"Slider Value %f", sender.value);
}
*/




-(void)setupSlider{

      // [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    
    /*
    sliderActive=YES;
    sliderBack = [[UIView alloc]initWithFrame:CGRectMake(0, 224, 320, 0)];
    sliderBack.backgroundColor= [UIColor colorWithRed:228.0f/255.0f green:228.0f/255.0f blue:228.0f/255.0f alpha:1.0f];

*/
    //CGRect frame = CGRectMake(25, 206, 270, 0);
    sliderActive=YES;

    CGRect frame = CGRectMake(25.0, 35.0, 182.0, 30.0);
    
    slider = [[ASValueTrackingSlider alloc] initWithFrame:frame];
    //slider.minimumValue = 1.0;
    //slider.maximumValue = 6.0;

    
        numbers = @[@(2.0), @(5.0), @(8), @(12)];
        // slider values go from 0 to the number of values in your numbers array
    NSInteger numberOfSteps = ((float)[numbers count]-1);
    slider.maximumValue = numberOfSteps;
    slider.minimumValue = 0;
    
    slider.continuous = YES; // NO makes it call only once you let go
       [slider addTarget:self
                  action:@selector(valueChanged:)
        forControlEvents:UIControlEventValueChanged];
    
    
    
    slider.popUpViewCornerRadius = 12.0;
    [slider setMaxFractionDigitsDisplayed:0];
    slider.popUpViewColor = [UIColor colorWithRed:255.0/255.0 green:108.0/255.0 blue:64.0/255.0 alpha:0.9];
    slider.font = [UIFont fontWithName:@"AvenirNext-Medium" size:12];
   // slider.textColor = [UIColor colorWithHue:0.55 saturation:1.0 brightness:0.5 alpha:1];
    slider.textColor = [UIColor whiteColor];
   // [self.view addSubview:sliderBack];
    [self.view addSubview:slider];

    //slider.alpha = 0;
    //sliderBack.frame = CGRectMake(0, 224, 320, 0);
    
    //slider.frame=CGRectMake(25, 206, 270, 0);
   // slider.frame=CGRectMake(30.0, 0.0, 180.0, 0.0);
    
    
    /*
      [UIView animateWithDuration:0.2
                     animations:^{
      sliderBack.frame =CGRectMake(0,182, 320, 42);
      slider.frame=CGRectMake(25.0, 194.0, 270.0, 20.0);
                         slider.alpha=1;
                     }];
    */
    
    slider.delegate=self;
    slider.dataSource=self;
  //  [self.timerBtn setHidden:YES];
    
}
-(void)updateTimerText{
    
    //ASValueTrackingSlider * slider = [[ASValueTrackingSlider alloc]init];
    NSLog(@"SLIDER DELEGATE CALLED %@", slider.currentText);
    
    //[self.timerBtn setTitle:slider.currentText forState:UIControlStateNormal];
   
    self.timerText.text=slider.currentText;

    [UIView transitionWithView:self.timerText duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        self.timerText.textColor = [UIColor colorWithRed:255.0/255.0 green:87.0/255.0 blue:34.0/255.0 alpha:1];
    } completion:^(BOOL finished) {
    }];
    
   // sliderActive=NO;

}


- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value;
{
    value = roundf(value);
    NSString *s;
    
    //value=((int)((value + 2.5) / 5) * 5);

  // value=((int)((value + 2.5) / 1) * 1);
    NSUInteger index = (NSUInteger)(slider.value);
    
    NSNumber * number = numbers[index];
    
    value = [number floatValue];

    
            s = [NSString stringWithFormat:@"%@ %@", [slider.numberFormatter stringFromNumber:@(value)],@""];
    
 //   [delegate sliderDidSelectWidth:value];
    
        return s;
}
- (void)sliderWillDisplayPopUpView:(ASValueTrackingSlider *)slider;
{
    
}

- (void)valueChanged:(UISlider *)sender {
    // round the slider position to the nearest index of the numbers array
    NSUInteger index = (NSUInteger)(slider.value + 0.5);
    [slider setValue:index animated:NO];
    NSNumber * number = numbers[index]; // <-- This numeric value you want
    NSLog(@"sliderIndex: %i", (int)index);
    NSLog(@"number: %@", number);
    
    CGFloat slidervalue = [number floatValue];
    
    [delegate sliderDidSelectWidth:slidervalue];

}



-(void)addWidthButtons{
    widthButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [widthButton1 addTarget:self
               action:@selector(buttonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    widthButton1.tag = 0;
    widthButton1.frame = CGRectMake(50.0,10.0, 20.0, 20.0);
    
    UIImage *btnWidth1 = [UIImage imageNamed:@"width1.png"];
    [widthButton1 setBackgroundImage:btnWidth1 forState:UIControlStateNormal];
    widthButton1.backgroundColor = [UIColor grayColor];
    widthButton1.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:widthButton1];
    
    widthButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [widthButton2 addTarget:self
               action:@selector(buttonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    widthButton2.tag = 1;
    widthButton2.frame = CGRectMake(80.0, 10, 20.0, 20.0);
    UIImage *btnWidth2 = [UIImage imageNamed:@"width2.png"];
    [widthButton2 setBackgroundImage:btnWidth2 forState:UIControlStateNormal];
    widthButton2.backgroundColor = [UIColor grayColor];
    widthButton2.adjustsImageWhenHighlighted = NO;

    [self.view addSubview:widthButton2];

    
    widthButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [widthButton3 addTarget:self
               action:@selector(buttonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    widthButton3.tag = 2;
    widthButton3.frame = CGRectMake(110.0, 10, 20.0, 20.0);
    UIImage *btnWidth3 = [UIImage imageNamed:@"width3.png"];
    [widthButton3 setBackgroundImage:btnWidth3 forState:UIControlStateNormal];
    widthButton3.backgroundColor = [UIColor grayColor];
    widthButton3.adjustsImageWhenHighlighted = NO;

    [self.view addSubview:widthButton3];

    
    widthButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [widthButton4 addTarget:self
               action:@selector(buttonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    widthButton4.tag = 3;
    widthButton4.frame = CGRectMake(140.0, 10, 20.0, 20.0);
    UIImage *btnWidth4 = [UIImage imageNamed:@"width4.png"];
    [widthButton4 setBackgroundImage:btnWidth4 forState:UIControlStateNormal];
    widthButton4.backgroundColor = [UIColor grayColor];
    widthButton4.adjustsImageWhenHighlighted = NO;

    [self.view addSubview:widthButton4];
    
    widthButton5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [widthButton5 addTarget:self
               action:@selector(buttonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    widthButton5.tag = 4;
    widthButton5.frame = CGRectMake(170.0, 10, 20.0, 20.0);
    UIImage *btnWidth5 = [UIImage imageNamed:@"width5.png"];
    [widthButton5 setBackgroundImage:btnWidth5 forState:UIControlStateNormal];
    widthButton5.backgroundColor = [UIColor grayColor];
    widthButton5.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:widthButton5];
}
/*
[self extractRGBforBlack:tColor5];
[self extractRGBforBlue:tColor2];
[self extractRGBforRed:tColor3];
[self extractRGBforLine:tColor4];
[self extractRGBforPen:tColor6];
*/

-(void)button1Select{
    
    
    [widthButton1 setSelected:YES];
    [widthButton2 setSelected:NO];
    [widthButton3 setSelected:NO];
    [widthButton4 setSelected:NO];
    [widthButton5 setSelected:NO];
    
    if([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==0.0){
        [widthButton1 setBackgroundColor:self.tColor5];
    }
    if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==2.0){
        [widthButton1 setBackgroundColor:self.tColor3];
    }
    if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==3.0){
        [widthButton1 setBackgroundColor:self.tColor4];
    }
    
   if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==5.0){
        [widthButton1 setBackgroundColor:self.tColor6];
    }
    
   if([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==1.0){
        [widthButton1 setBackgroundColor:self.tColor2];
    }
    
   // [widthButton1 setBackgroundColor:UIColor.blueColor];
    [widthButton2 setBackgroundColor:UIColor.grayColor];
    [widthButton3 setBackgroundColor:UIColor.grayColor];
    [widthButton4 setBackgroundColor:UIColor.grayColor];
    [widthButton5 setBackgroundColor:UIColor.grayColor];
}

-(void)button2Select{
    
    [widthButton1 setSelected:NO];
    [widthButton2 setSelected:YES];
    [widthButton3 setSelected:NO];
    [widthButton4 setSelected:NO];
    [widthButton5 setSelected:NO];
    
    if([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==0.0){
        [widthButton2 setBackgroundColor:self.tColor5];
    }
    if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==2.0){
        [widthButton2 setBackgroundColor:self.tColor3];
    }
    if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==3.0){
        [widthButton2 setBackgroundColor:self.tColor4];
    }
    
   if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==5.0){
        [widthButton2 setBackgroundColor:self.tColor6];
    }
    
   if([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==1.0){
        [widthButton2 setBackgroundColor:self.tColor2];
    }
    [widthButton1 setBackgroundColor:UIColor.grayColor];
    [widthButton3 setBackgroundColor:UIColor.grayColor];
    [widthButton4 setBackgroundColor:UIColor.grayColor];
    [widthButton5 setBackgroundColor:UIColor.grayColor];
}

-(void)button3Select{
    

    
    
    [widthButton1 setSelected:NO];
    [widthButton2 setSelected:NO];
    [widthButton3 setSelected:YES];
    [widthButton4 setSelected:NO];
    [widthButton5 setSelected:NO];
    if([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==0.0){
        [widthButton3 setBackgroundColor:self.tColor5];
    }
    if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==2.0){
        [widthButton3 setBackgroundColor:self.tColor3];
    }
    if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==3.0){
        [widthButton3 setBackgroundColor:self.tColor4];
    }
    
   if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==5.0){
        [widthButton3 setBackgroundColor:self.tColor6];
    }
    
   if([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==1.0){
        [widthButton3 setBackgroundColor:self.tColor2];
    }
    
    [widthButton2 setBackgroundColor:UIColor.grayColor];
    [widthButton1 setBackgroundColor:UIColor.grayColor];
    [widthButton4 setBackgroundColor:UIColor.grayColor];
    [widthButton5 setBackgroundColor:UIColor.grayColor];
}

-(void)button4Select{
    
    [widthButton1 setSelected:NO];
    [widthButton2 setSelected:NO];
    [widthButton3 setSelected:NO];
    [widthButton4 setSelected:YES];
    [widthButton5 setSelected:NO];
    if([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==0.0){
        [widthButton4 setBackgroundColor:self.tColor5];
    }
    if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==2.0){
        [widthButton4 setBackgroundColor:self.tColor3];
    }
    if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==3.0){
        [widthButton4 setBackgroundColor:self.tColor4];
    }
    
   if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==5.0){
        [widthButton4 setBackgroundColor:self.tColor6];
    }
    
   if([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==1.0){
        [widthButton4 setBackgroundColor:self.tColor2];
    }
    
    [widthButton2 setBackgroundColor:UIColor.grayColor];
    [widthButton3 setBackgroundColor:UIColor.grayColor];
    [widthButton1 setBackgroundColor:UIColor.grayColor];
    [widthButton5 setBackgroundColor:UIColor.grayColor];
}

-(void)button5Select{
    [widthButton1 setSelected:NO];
    [widthButton2 setSelected:NO];
    [widthButton3 setSelected:NO];
    [widthButton4 setSelected:NO];
    [widthButton5 setSelected:YES];
    if([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==0.0){
        [widthButton5 setBackgroundColor:self.tColor5];
    }
    if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==2.0){
        [widthButton5 setBackgroundColor:self.tColor3];
    }
    if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==3.0){
        [widthButton5 setBackgroundColor:self.tColor4];
    }
    
   if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==5.0){
        [widthButton5 setBackgroundColor:self.tColor6];
    }
    
   if([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==1.0){
        [widthButton5 setBackgroundColor:self.tColor2];
    }
    
    [widthButton2 setBackgroundColor:UIColor.grayColor];
    [widthButton3 setBackgroundColor:UIColor.grayColor];
    [widthButton4 setBackgroundColor:UIColor.grayColor];
    [widthButton1 setBackgroundColor:UIColor.grayColor];
}

- (void)buttonTapped:(UIButton *)sender
{
    //I don't know how to tag each button here.
    switch(sender.tag){

    case 0:{
        NSLog(@"Photo1");
        
        [self button1Select];
        [delegate sliderDidSelectWidth:2.0];
        [self saveFloatToUserDefaults:2.0 forKey:@"lineWidth"];
        
    }
        break;
    case 1:{
        NSLog(@"Photo2");
        [self button2Select];
        [delegate sliderDidSelectWidth:4.0];
        [self saveFloatToUserDefaults:4.0 forKey:@"lineWidth"];


    }
        break;
    case 2:{
        NSLog(@"Photo3");
        [self button3Select];
        [delegate sliderDidSelectWidth:6.0];
        [self saveFloatToUserDefaults:6.0 forKey:@"lineWidth"];


    }
        break;
    case 3:{
        NSLog(@"Photo4");
        [self button4Select];
        [delegate sliderDidSelectWidth:8.0];
        [self saveFloatToUserDefaults:8.0 forKey:@"lineWidth"];


    }
        break;
    case 4:{
        NSLog(@"Photo5");
        [self button5Select];
        [delegate sliderDidSelectWidth:12.0];
        [self saveFloatToUserDefaults:12.0 forKey:@"lineWidth"];


    }
        break;
}
}

-(void)currentColor:(UIColor*)currentColor {
    
   // widthButton1.backgroundColor = currentColor;
}


-(void) saveFloatToUserDefaults:(float)x forKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:x forKey:key];
    [userDefaults synchronize];
}

-(float) loadFloatFromUserDefaultsForKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults floatForKey:key];
}




-(void)LoadColorsAtStart
{
    NSUserDefaults *prefers = [NSUserDefaults standardUserDefaults];
    self.tColor5 = [UIColor colorWithRed:[prefers floatForKey:@"cr5"] green:[prefers floatForKey:@"cg5"] blue:[prefers floatForKey:@"cb5"] alpha:[prefers floatForKey:@"ca5"]];
    
     self.tColor2 = [UIColor colorWithRed:[prefers floatForKey:@"cr2"] green:[prefers floatForKey:@"cg2"] blue:[prefers floatForKey:@"cb2"] alpha:[prefers floatForKey:@"ca2"]];
    
    self.tColor3 = [UIColor colorWithRed:[prefers floatForKey:@"cr3"] green:[prefers floatForKey:@"cg3"] blue:[prefers floatForKey:@"cb3"] alpha:[prefers floatForKey:@"ca3"]];
    
    self.tColor4 = [UIColor colorWithRed:[prefers floatForKey:@"cr4"] green:[prefers floatForKey:@"cg4"] blue:[prefers floatForKey:@"cb4"] alpha:[prefers floatForKey:@"ca4"]];
    
    self.tColor6 = [UIColor colorWithRed:[prefers floatForKey:@"cr6"] green:[prefers floatForKey:@"cg6"] blue:[prefers floatForKey:@"cb6"] alpha:[prefers floatForKey:@"ca6"]];
    
    
    
    
    [prefers synchronize];
    
   
    
    NSLog(@"I have extracted colors");
    
}


-(float) loadCurrentToolFromUserDefaultsForKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults floatForKey:key];
}


-(void)currentColorIndicator:(ColorButton*)colorBtn
{
    
    
    
    CAShapeLayer *line = [CAShapeLayer layer];
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



@end
