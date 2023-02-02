
#import "ColorViewController.h"
#import "ASValueTrackingSlider.h"
#import "HapticHelper.h"
#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad


@interface ColorViewController ()

@end

@implementation ColorViewController

@synthesize delegate;
@synthesize widthButton1;
@synthesize widthButton2;
@synthesize widthButton3;
@synthesize widthButton4;
@synthesize widthButton5;
@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize lineSeparator;
@synthesize currentTool;
@synthesize editBtn;
@synthesize scrollText;
@synthesize startButton;

- (id)initWithFrame:(CGRect)frame isSelected:(BOOL)isSelected color:(UIColor *)currentColor currentTool:(NSString*)currentTool
{
    self = [super initWithFrame:frame];
    if (self) {

        self.frame = frame;
        self.colorCollection = [[NSUserDefaults standardUserDefaults] objectForKey:@"colorCollection"];
        
        _isTextSelected = isSelected;
        self.currentPenColor = currentColor;
        _currentToolName = currentTool;
        arrayOfCircles = [NSMutableArray array];
        editMode = NO;
        [self configure];
        [self indicateCurrentColorAtStart];
        [self animateScrollViewBounce];
   


    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{

    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}


-(void)animateScrollViewBounce{
    [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self->scrollText.contentOffset = CGPointMake(10  , 0);

    } completion:NULL];
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self->scrollText.contentOffset = CGPointMake(0 , 0);

    } completion:NULL];
}

- (void)penColorString:(int)count {
    
    
    for (int i=0; i<=count; i++) {
        
        if (CGColorEqualToColor(self.currentPenColor.CGColor, [GzColors colorFromHex:[self.colorCollection objectAtIndex:i]].CGColor))
        {
            [self currentColorIndicator:[self.buttonCollection objectAtIndex:i]];
        }
    }
}
- (void)textColorString:(int)count {
    for (int i=0; i<=count; i++) {
        if (CGColorEqualToColor(self.currentPenColor.CGColor,[GzColors colorFromHex:[self.colorCollection objectAtIndex:i]].CGColor))
        {
            [self currentColorIndicator:[self.buttonCollection objectAtIndex:i]];
            
        }
    }
    

}

- (void)indicateCurrentColorAtStart {
    CGColorRef colorRef = self.currentPenColor.CGColor;
    NSString *colorString = [CIColor colorWithCGColor:colorRef].stringRepresentation;
    NSLog(@"PEN COLOR STRING = %@", colorString);
   
    if(!_isTextSelected){
        [self penColorString:11];
    } else {
        [self textColorString:11];
    }
}


- (void)configure
{
    if(!_isTextSelected){
//        [self createSimplyfiedOrdenatedColorsArray];
        [self loadColorButtons];

    } else {
        
      //  [self createSimplyfiedOrdenatedColorsArrayForText];
        
        [self loadColorButtonsForText];

    }
    [self LoadColorsAtStart];
    
    NSLog(@"LINE WIDTH %f " , [self loadFloatFromUserDefaultsForKey:@"lineWidth"]);
    
    if([self loadFloatFromUserDefaultsForKey:@"lineWidth"] == [self getRoundedFloat:1.600000] )
    {
        [self button1Select];
    }
    if([self loadFloatFromUserDefaultsForKey:@"lineWidth"] == [self getRoundedFloat:2.400000] )
    {
        [self button2Select];
    }
    if([self loadFloatFromUserDefaultsForKey:@"lineWidth"] == [self getRoundedFloat:3.600000] )
    {
        [self button3Select];
    }
//    if([self loadFloatFromUserDefaultsForKey:@"lineWidth"] == [self getRoundedFloat:4.80000] )
//    {
//        [self button4Select];
//    }
//    if([self loadFloatFromUserDefaultsForKey:@"lineWidth"] == [self getRoundedFloat:6.600000] )
//    {
//        [self button5Select];
//    }
    
}


- (void)setIsTextSelected:(BOOL)isTextSelected
{
     _isTextSelected = isTextSelected;
    textSelected = isTextSelected;
    NSLog(@"BOOL in setter %s", textSelected ? "true" : "false");

}
-(void)setFontSizee:(CGFloat)fontSize{
    _fontSizee = fontSize;
    NSLog(@"FONT SIZE = %f", _fontSizee);
}
-(void)setCurrentTextColorForIndicator:(UIColor*)currentTextColorForIndicator{
    _currentTextColorForIndicator = currentTextColorForIndicator;
}
//- (void)viewDidUnload

//{
//    [super viewDidUnload];
//    // Release any retained subviews of the main view.
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


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
}
-(void) createSimplyfiedOrdenatedColorsArrayForText{
    self.colorCollectionForText = [NSArray arrayWithObjects:
                            
                            Black,
                            RoyalBlue,
                            Red,
                            Green,
                            DarkRed,
                            DarkSlateGray,
                            nil];
}
- (void)addHorizontalLine {
    CAShapeLayer *line = [CAShapeLayer layer];
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    [linePath moveToPoint: CGPointMake(0,50)];
    [linePath addLineToPoint:CGPointMake(240,50)];
    line.path = linePath.CGPath;
    line.fillColor = nil;
    line.opacity = 0.1;
    line.strokeColor = [UIColor grayColor].CGColor;
    [self.layer addSublayer:line];
}

-(void)loadColorButtons{
    UIColor *color = [UIColor grayColor];
    CGColorRef gray = color.CGColor;
    self.layer.cornerRadius = 15;
    self.layer.shadowColor = gray;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowRadius = 7;
    self.layer.shadowOpacity = 0.2;
    self.layer.masksToBounds = NO;
    //[self setBackgroundColor: [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    [self setBackgroundColor:[UIColor colorNamed:@"whiteDark"]];

    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 36, self.frame.size.width,self.frame.size.height)];
    scroll.contentSize = CGSizeMake(200, 320);
    [self addSubview:scroll];
    [scroll setScrollEnabled:NO];

    CGFloat screenWidth = self.frame.size.width * 2;
    CGSize actualContentSize = CGSizeMake(3000, 100);

    [scroll setContentSize:CGSizeMake(screenWidth, actualContentSize.height)];
    [scroll setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];



    [self addWidthButtons];
    [self addHorizontalLine];
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
                colorButton.frame = CGRectMake(16+(j*36), 32+(i*36), 26, 26);
                [colorButton addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
                [colorButton setSelected:NO];
                [colorButton setNeedsDisplay];
                [colorButton setBackgroundColor:[GzColors colorFromHex:[self.colorCollection objectAtIndex:colorNumber]]];
                [colorButton setHexColor:[self.colorCollection objectAtIndex:colorNumber]];
                
                colorButton.layer.cornerRadius = 13;
                colorButton.layer.masksToBounds = YES;
                
                colorButton.layer.borderColor = [UIColor colorWithRed:140.0f/255.0f green:140.0f/255.0f blue:140.0f/255.0f alpha:0.7f].CGColor;
                colorButton.layer.borderWidth = 0.0f;
            
                
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
    
    [[NSUserDefaults standardUserDefaults] setObject:self.colorCollection forKey:@"colorCollection"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma  mark Text View

-(void)decreaseFontSize:(UIButton*)button{
    if (self.fontSizee >= 8 ){
        self.fontSizee = self.fontSizee - 4;
        [delegate textSettingsDidSelectFontSize:self.fontSizee];
    }
    if(button.highlighted){
    [button setHighlighted:NO];
    } else {
        [button setHighlighted:YES];
    }
}
-(void)increaseFontSize:(UIButton*)button{
    
    if(button.highlighted) {
        if (self.fontSizee <= 60){
            self.fontSizee = self.fontSizee + 4;
            [delegate textSettingsDidSelectFontSize:self.fontSizee];
        }
    [button setHighlighted:NO];
}
else {
    [button setHighlighted:YES];
}

}
-(void)addNewTextView:(UIButton*)button{
    if(button.highlighted)
        [button setHighlighted:NO];
    else
        [button setHighlighted:YES];
    [self.delegate addTextFromTextSettings];
}

- (UIButton*)fontButton:(NSString*)selector imageName1:(NSString*)imgName imageName2:(NSString*)imgName2 startX:(CGFloat)startX width:(CGFloat)btnWidth yAxe:(CGFloat)yAxe
{
    SEL selectorNew = NSSelectorFromString(selector);
     UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:selectorNew
     forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor orangeColor];
    button.adjustsImageWhenHighlighted = NO;
    UIImage *img = [UIImage imageNamed:imgName];
    [button setImage:img forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imgName2] forState:UIControlStateHighlighted];
    [button setBackgroundColor:[UIColor colorNamed:@"cellText"]];
    button.frame = CGRectMake(startX, self.frame.origin.y + yAxe, btnWidth, btnWidth);
    button.layer.cornerRadius = btnWidth / 2;
    button.layer.masksToBounds = YES;
    button.layer.borderColor = [UIColor colorWithRed:140.0f/255.0f green:140.0f/255.0f blue:140.0f/255.0f alpha:0.7f].CGColor;
    button.layer.borderWidth = 0.0f;
    [self addSubview:button];
    return button;
}
- (CAShapeLayer*)addLineSeparator:(CGFloat)x1 y1:(CGFloat)y1 x2:(CGFloat)x2 y2:(CGFloat)y2 {
    CAShapeLayer *line = [CAShapeLayer layer];
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    self.rectView = [[UIView alloc]initWithFrame:CGRectMake(x1, y1, x2, y2)];
    self.rectView.backgroundColor = [UIColor clearColor];
    [linePath moveToPoint:CGPointMake(x2/2, y1)];
    [linePath addLineToPoint:CGPointMake(x2/2 ,y2)];
    line.path=linePath.CGPath;
    line.fillColor =nil;
    line.opacity = 0.4;
    line.lineWidth = 1.0;
    line.strokeColor = [UIColor grayColor].CGColor;
                     
    [self addSubview:self.rectView];
    [self.rectView.layer addSublayer:line];
    return line;
}

-(void)loadColorButtonsForText{
    CGRect sizeRect = [UIScreen mainScreen].bounds;
    CGFloat screenPartitionIdx;
    CGFloat lastButtonStart;
    CGFloat scrollWidth;
    CGFloat scrollStart;
    CGFloat originOfButtons;
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        screenPartitionIdx = sizeRect.size.width / 14;
        originOfButtons = screenPartitionIdx * 2;
        lastButtonStart = screenPartitionIdx * 10.5;
       
        scrollWidth = screenPartitionIdx * 6;
        scrollStart = screenPartitionIdx * 4.5;

    } else {
        scrollWidth = 204;
        screenPartitionIdx = sizeRect.size.width / 11;
        originOfButtons = screenPartitionIdx / 2.4;
        scrollStart = screenPartitionIdx * 3;
        lastButtonStart = screenPartitionIdx * 9;


    }
    self.layer.cornerRadius = 15;
    //[self setBackgroundColor: [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    [self setBackgroundColor:[UIColor colorNamed:@"whiteDark"]];

    button1 =  [self fontButton:@"decreaseFontSize:" imageName1:@"a-sm.png" imageName2:@"a-sm-tr.png" startX:originOfButtons width: 34 yAxe:11];
   button2 = [self fontButton:@"increaseFontSize:" imageName1:@"a-big.png" imageName2:@"a-big-tr.png" startX:  button1.frame.origin.x + screenPartitionIdx width:34 yAxe:11];
    
    //lineSeparator = [self addLineSeparator:button2.frame.origin.x + screenPartitionIdx   y1:0 x2:button2.frame.origin.x + screenPartitionIdx   y2:self.frame.size.height ];
    lineSeparator = [self addLineSeparator:button2.frame.origin.x + button2.frame.size.width / 1.5   y1:0 x2:screenPartitionIdx y2:self.frame.size.height];
    
      //lineCoordinateX = button2.frame.origin.x + button2.frame.size.width + screenPartitionIdx / 2;
    lineCoordinateX = self.rectView.center.x + screenPartitionIdx / 2;
    
    
    scrollText = [[UIScrollView alloc] initWithFrame:CGRectMake(scrollStart, 0, scrollWidth, self.frame.size.height)];
    scrollText.contentSize = CGSizeMake(scrollWidth, 40);
    [self addSubview:scrollText];
    [scrollText setScrollEnabled:YES];

    CGFloat screenWidth = scrollWidth * 2;
    CGSize actualContentSize = CGSizeMake(scrollWidth * 2, 40);

    [scrollText setContentSize:CGSizeMake(screenWidth, actualContentSize.height)];
    [scrollText setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    scrollText.showsHorizontalScrollIndicator = NO;
    scrollText.pagingEnabled = YES;
    
  
    
    if (self.buttonCollection != nil) {
        for (ColorButton *colorButton in self.buttonCollection) {
            [colorButton removeFromSuperview];
        }
        self.buttonCollection = nil;
    }
        self.buttonCollection = [[NSMutableArray alloc]init];
    int colorNumber = 0;
    
        for (int j=0; j<=11; j++) {
            ColorButton *colorButton = [ColorButton buttonWithType:UIButtonTypeCustom];
            colorButton.frame = CGRectMake((j*screenPartitionIdx), self.frame.origin.y + 15 , 26, 26);
            [colorButton addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
            [colorButton setSelected:NO];
            [colorButton setNeedsDisplay];
            [colorButton setBackgroundColor:[GzColors colorFromHex:[self.colorCollection objectAtIndex:colorNumber]]];
            [colorButton setHexColor:[self.colorCollection objectAtIndex:colorNumber]];
            colorButton.layer.cornerRadius = 13;
            colorButton.layer.masksToBounds = YES;
            colorButton.layer.borderColor = [UIColor colorWithRed:140.0f/255.0f green:140.0f/255.0f blue:140.0f/255.0f alpha:0.7f].CGColor;
            colorButton.layer.borderWidth = 0.0f;
            colorNumber ++;
            [self.buttonCollection addObject:colorButton];
            [scrollText addSubview:colorButton];
            lastColorButtonX = colorButton.frame.origin.x;
            
        }
    
   button3 =  [self fontButton:@"addNewTextView:" imageName1:@"addText.png" imageName2:@"addTextSelected.png" startX:lastButtonStart width:28 yAxe:14];

    [self.delegate addTextFromTextSettings];

    }


- (void)indicateSelctedButton:(ColorButton *)btn {
    btn.layer.borderWidth = 0.0f;
    btn.layer.borderColor = [UIColor darkGrayColor].CGColor ;
    [self currentColorIndicator:btn];
}

-(void)buttonPushed:(id)sender{
    
    
    ColorButton *btn = (ColorButton *)sender;
    
        if (!_isTextSelected){
            for(int i=0; i< self.buttonCollection.count; i++) {
                [[self.buttonCollection objectAtIndex:i] setSelected:NO];
                [line removeFromSuperlayer];
            }
            
                [delegate colorPopoverControllerDidSelectColor:btn.hexColor];
                [self indicateSelctedButton:btn];
        } else {
            for(int i=0; i< self.buttonCollection.count; i++) {
                [[self.buttonCollection objectAtIndex:i] setSelected:NO];
                [line removeFromSuperlayer];
            }
            // btn.selected = YES;
            [delegate colorPopoverDidSelectTextColor:btn.hexColor];
            [self indicateSelctedButton:btn];
        }
    
    
    
}

-(void)addWidthButtons{
    
    
    // Add width button 2 first as it is in the middle of the view
 

    
    widthButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [widthButton2 addTarget:self
               action:@selector(buttonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    widthButton2.tag = 1;
    widthButton2.frame = CGRectMake((self.frame.size.width / 2) - 10, 18, 20.0, 20.0);
    UIImage *btnWidth2 = [UIImage imageNamed:@"width2"];
    [widthButton2 setBackgroundImage:btnWidth2 forState:UIControlStateNormal];
    widthButton2.tintColor =  [UIColor colorNamed:@"cellText"];
    widthButton2.adjustsImageWhenHighlighted = NO;
    [self addSubview:widthButton2];

    
    
    widthButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [widthButton1 addTarget:self
               action:@selector(buttonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    widthButton1.tag = 0;
    widthButton1.frame = CGRectMake((self.frame.size.width / 2) - 50, 18.0, 20.0, 20.0);
   
    UIImage *btnWidth1 = [UIImage imageNamed:@"width1"];
    [widthButton1 setBackgroundImage:btnWidth1 forState:UIControlStateNormal];
    widthButton1.tintColor =  [UIColor colorNamed:@"cellText"];
    widthButton1.adjustsImageWhenHighlighted = NO;
    [self addSubview:widthButton1];

    widthButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [widthButton3 addTarget:self
               action:@selector(buttonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    widthButton3.tag = 2;
    widthButton3.frame = CGRectMake((self.frame.size.width / 2) + 30, 18, 20.0, 20.0);
    UIImage *btnWidth3 = [UIImage imageNamed:@"width3"];
    [widthButton3 setBackgroundImage:btnWidth3 forState:UIControlStateNormal];
    ///widthButton3.backgroundColor = [UIColor clearColor];
    widthButton3.tintColor =  [UIColor colorNamed:@"cellText"];
    widthButton3.adjustsImageWhenHighlighted = NO;

    [self addSubview:widthButton3];

    
//    widthButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [widthButton4 addTarget:self
//               action:@selector(buttonTapped:)
//     forControlEvents:UIControlEventTouchUpInside];
//    widthButton4.tag = 3;
//    widthButton4.frame = CGRectMake(140.0, 18, 20.0, 20.0);
//    UIImage *btnWidth4 = [UIImage imageNamed:@"width4"];
//    [widthButton4 setBackgroundImage:btnWidth4 forState:UIControlStateNormal];
//    widthButton4.tintColor =  [UIColor colorNamed:@"cellText"];
//    widthButton4.adjustsImageWhenHighlighted = NO;
//
//    [self addSubview:widthButton4];
//
//    widthButton5 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [widthButton5 addTarget:self
//               action:@selector(buttonTapped:)
//     forControlEvents:UIControlEventTouchUpInside];
//    widthButton5.tag = 4;
//    widthButton5.frame = CGRectMake(170.0, 18, 20.0, 20.0);
//    UIImage *btnWidth5 = [UIImage imageNamed:@"width5"];
//    [widthButton5 setBackgroundImage:btnWidth5 forState:UIControlStateNormal];
//    widthButton5.tintColor =  [UIColor colorNamed:@"cellText"];
//    widthButton5.adjustsImageWhenHighlighted = NO;
//    [self addSubview:widthButton5];
}
/*
[self extractRGBforBlack:tColor5];
[self extractRGBforBlue:tColor2];
[self extractRGBforRed:tColor3];
[self extractRGBforLine:tColor4];
[self extractRGBforPen:tColor6];
*/

-(void)button1Select{
    NSLog(@"buttonWidth 1 slected");
    [widthButton1 setSelected:YES];
    [widthButton2 setSelected:NO];
    [widthButton3 setSelected:NO];
    [widthButton4 setSelected:NO];
    [widthButton5 setSelected:NO];
    
    if([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==0.0){
        [widthButton1 setTintColor:self.penColor];
    }
    if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==2.0){
        [widthButton1 setTintColor:self.curveColor];
    }
    if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==3.0){
        [widthButton1 setTintColor:self.lineColor];
    }
    
   if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==5.0){
        [widthButton1 setTintColor:self.arrowColor];
    }
    
   if([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==1.0){
        [widthButton1 setTintColor:self.dashColor];
    }
    [widthButton2 setTintColor:[UIColor colorNamed:@"cellText"]];
    [widthButton3 setTintColor:[UIColor colorNamed:@"cellText"]];
    [widthButton4 setTintColor:[UIColor colorNamed:@"cellText"]];
    [widthButton5 setTintColor:[UIColor colorNamed:@"cellText"]];
    [HapticHelper generateFeedback:FeedbackType_Impact_Light];

}

-(void)button2Select{
    NSLog(@"buttonWidth 2 slected");

    [widthButton1 setSelected:NO];
    [widthButton2 setSelected:YES];
    [widthButton3 setSelected:NO];
    [widthButton4 setSelected:NO];
    [widthButton5 setSelected:NO];
    
    if([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==0.0){
        [widthButton2 setTintColor:self.penColor];
    }
    if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==2.0){
        [widthButton2 setTintColor:self.curveColor];
    }
    if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==3.0){
        [widthButton2 setTintColor:self.lineColor];
    }
    
   if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==5.0){
        [widthButton2 setTintColor:self.arrowColor];
    }
    
   if([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==1.0){
        [widthButton2 setTintColor:self.dashColor];
    }
    [widthButton1 setTintColor:[UIColor colorNamed:@"cellText"]];
    [widthButton3 setTintColor:[UIColor colorNamed:@"cellText"]];
    [widthButton4 setTintColor:[UIColor colorNamed:@"cellText"]];
    [widthButton5 setTintColor:[UIColor colorNamed:@"cellText"]];
    [HapticHelper generateFeedback:FeedbackType_Impact_Light];

}

-(void)button3Select{
    NSLog(@"buttonWidth 3 slected");

    [widthButton1 setSelected:NO];
    [widthButton2 setSelected:NO];
    [widthButton3 setSelected:YES];
    [widthButton4 setSelected:NO];
    [widthButton5 setSelected:NO];
    if([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==0.0){
        [widthButton3 setTintColor:self.penColor];
    }
    if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==2.0){
        [widthButton3 setTintColor:self.curveColor];
    }
    if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==3.0){
        [widthButton3 setTintColor:self.lineColor];
    }
    
   if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==5.0){
        [widthButton3 setTintColor:self.arrowColor];
    }
    
   if([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==1.0){
        [widthButton3 setTintColor:self.dashColor];
    }
    [widthButton2 setTintColor:[UIColor colorNamed:@"cellText"]];
    [widthButton1 setTintColor:[UIColor colorNamed:@"cellText"]];
    [widthButton4 setTintColor:[UIColor colorNamed:@"cellText"]];
    [widthButton5 setTintColor:[UIColor colorNamed:@"cellText"]];
    [HapticHelper generateFeedback:FeedbackType_Impact_Light];

}
/*
-(void)button4Select{
    
    [widthButton1 setSelected:NO];
    [widthButton2 setSelected:NO];
    [widthButton3 setSelected:NO];
    [widthButton4 setSelected:YES];
    [widthButton5 setSelected:NO];
    if([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==0.0){
        [widthButton4 setTintColor:self.penColor];
    }
    if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==2.0){
        [widthButton4 setTintColor:self.curveColor];
    }
    if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==3.0){
        [widthButton4 setTintColor:self.lineColor];
    }
    
   if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==5.0){
        [widthButton4 setTintColor:self.arrowColor];
    }
    
   if([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==1.0){
        [widthButton4 setTintColor:self.dashColor];
    }
    
    [widthButton2 setTintColor:[UIColor colorNamed:@"cellText"]];
    [widthButton3 setTintColor:[UIColor colorNamed:@"cellText"]];
    [widthButton1 setTintColor:[UIColor colorNamed:@"cellText"]];
    [widthButton5 setTintColor:[UIColor colorNamed:@"cellText"]];
}

-(void)button5Select{
    [widthButton1 setSelected:NO];
    [widthButton2 setSelected:NO];
    [widthButton3 setSelected:NO];
    [widthButton4 setSelected:NO];
    [widthButton5 setSelected:YES];
    if([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==0.0){
        [widthButton5 setTintColor:self.penColor];
    }
    if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==2.0){
        [widthButton5 setTintColor:self.curveColor];
    }
    if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==3.0){
        [widthButton5 setTintColor:self.lineColor];
    }
    
   if ([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==5.0){
        [widthButton5 setTintColor:self.arrowColor];
    }
    
   if([self loadCurrentToolFromUserDefaultsForKey:@"currentTool"]==1.0){
        [widthButton5 setTintColor:self.dashColor];
    }
    [widthButton2 setTintColor:[UIColor colorNamed:@"cellText"]];
    [widthButton3 setTintColor:[UIColor colorNamed:@"cellText"]];
    [widthButton4 setTintColor:[UIColor colorNamed:@"cellText"]];
    [widthButton1 setTintColor:[UIColor colorNamed:@"cellText"]];
}
*/
- (float)getRoundedFloat:(CGFloat)value{
    
    float new = [[NSString stringWithFormat:@"%.4f",value]floatValue];
    return new;
}

- (void)buttonTapped:(UIButton *)sender
{
    switch(sender.tag){
    case 0:{
        NSLog(@"Photo1");
        [self button1Select];
        float new = [self getRoundedFloat:1.600000];
        [delegate sliderDidSelectWidth:new];
        [self saveFloatToUserDefaults:new forKey:@"lineWidth"];
    }
        break;
    case 1:{
        NSLog(@"Photo2");
        [self button2Select];
        float new = [self getRoundedFloat:2.400000];
        [delegate sliderDidSelectWidth:new];
        [self saveFloatToUserDefaults:new forKey:@"lineWidth"];
    }
        break;
    case 2:{
        NSLog(@"Photo3");
        [self button3Select];
        float new = [self getRoundedFloat:3.600000];

        [delegate sliderDidSelectWidth:new];
        [self saveFloatToUserDefaults:new forKey:@"lineWidth"];
    }
        break;
//    case 3:{
//        NSLog(@"Photo4");
//        [self button4Select];
//        float new = [self getRoundedFloat:4.800000];
//        [delegate sliderDidSelectWidth:new];
//        [self saveFloatToUserDefaults:new forKey:@"lineWidth"];
//    }
//        break;
//    case 4:{
//        NSLog(@"Photo5");
//        [self button5Select];
//        float new = [self getRoundedFloat:6.600000];
//        [delegate sliderDidSelectWidth:new];
//        [self saveFloatToUserDefaults:new forKey:@"lineWidth"];
//    }
//        break;
}
}

-(void)currentColor:(UIColor*)currentColor {
    
   //widthButton1.backgroundColor = currentColor;
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
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    self.penColor = [GzColors colorFromHex:[defaults objectForKey:@"penToolColor"]];
    self.curveColor = [GzColors colorFromHex:[defaults objectForKey:@"curveToolColor"]];
    self.dashColor = [GzColors colorFromHex:[defaults  objectForKey:@"dashToolColor"]];
    self.arrowColor = [GzColors colorFromHex:[defaults  objectForKey:@"arrowToolColor"]];
    self.lineColor = [GzColors colorFromHex:[defaults objectForKey:@"lineToolColor"]];
    
}


-(float) loadCurrentToolFromUserDefaultsForKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults floatForKey:key];
}


-(void)currentColorIndicator:(ColorButton*)colorBtn
{
        line = [CAShapeLayer layer];
        UIBezierPath *linePath=[UIBezierPath bezierPath];
        [linePath moveToPoint: CGPointMake(9,13)];
        [linePath addLineToPoint:CGPointMake(12,16)];
        [linePath moveToPoint: CGPointMake(12,16)];
        [linePath addLineToPoint:CGPointMake(17,11)];
        line.path = linePath.CGPath;
        line.fillColor = nil;
        line.lineCap = kCALineCapRound;
        line.lineJoin = kCALineJoinRound;
        line.opacity = 1;
        line.lineWidth = 2.2;
        line.strokeColor = [UIColor whiteColor].CGColor;
        [colorBtn.layer addSublayer:line];
}

-(void)addCircleIndicator:(ColorButton*)colorBtn
{
        circle = [CAShapeLayer layer];
        UIBezierPath *circlePath=[UIBezierPath bezierPath];
        circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(5,  5 , 18, 18)];
        circle.path=circlePath.CGPath;
   // circle.fillColor = [UIColor colorNamed:@"colorIndicator"].CGColor;
        circle.fillColor = nil;
        circle.lineCap = kCALineCapRound;
        circle.lineJoin = kCALineJoinRound;
        circle.opacity = 1;
        circle.lineWidth = 3;
        circle.strokeColor =  [UIColor colorNamed:@"colorIndicator"].CGColor;
        [colorBtn.layer addSublayer:circle];
        [arrayOfCircles addObject:circle];
}

@end
