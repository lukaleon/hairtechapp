
#import "ColorViewController.h"
#import "ASValueTrackingSlider.h"
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



- (id)initWithFrame:(CGRect)frame isSelected:(BOOL)isSelected color:(UIColor *)currentColor
{
    self = [super initWithFrame:frame];
    if (self) {

        self.frame = frame;
        _isTextSelected = isSelected;
        self.currentPenColor = currentColor;
        [self configure];

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
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//
//
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//                if ([self respondsToSelector:@selector(setPreferredContentSize:)]) {
//                    self.preferredContentSize = CGSizeMake(240, 120);
//               } else {
//                  self.contentSizeForViewInPopover = CGSizeMake(240,120);
//                }
//    }
//    return self;
//}

- (void)penColorString:(int)count {
    for (int i=0; i<=count; i++) {
        if (CGColorEqualToColor(self.currentPenColor.CGColor,[GzColors colorFromHex:[self.colorCollection objectAtIndex:i]].CGColor))
        {
            [self currentColorIndicator:[self.buttonCollection objectAtIndex:i]];
        }
    }
}
- (void)textColorString:(int)count {
    for (int i=0; i<=count; i++) {
        if (CGColorEqualToColor(self.currentPenColor.CGColor,[GzColors colorFromHex:[self.colorCollectionForText objectAtIndex:i]].CGColor))
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
        [self textColorString:5];
    }
}

- (void)configure
{
    if(!_isTextSelected){
        [self createSimplyfiedOrdenatedColorsArray];
        [self loadColorButtons];

    } else {
        [self createSimplyfiedOrdenatedColorsArrayForText];
        [self loadColorButtonsForText];

    }
    [self LoadColorsAtStart];
   
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
    [self indicateCurrentColorAtStart];
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
    [linePath moveToPoint: CGPointMake(0,36)];
    [linePath addLineToPoint:CGPointMake(240,36)];
    line.path=linePath.CGPath;
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
    [self setBackgroundColor: [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 36, 240,80)];
    scroll.contentSize = CGSizeMake(200, 320);
    [self addSubview:scroll];
    [scroll setScrollEnabled:NO];
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
    [button setBackgroundColor:[UIColor blackColor]];
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
   // NSLog(@"SCREEN PARTIOTION IDX %f", screenPartitionIdx);
    CGFloat originOfButtons;
    if (IDIOM == IPAD){
        screenPartitionIdx = sizeRect.size.width / 14;
        originOfButtons = screenPartitionIdx * 2;
    } else {
        screenPartitionIdx = sizeRect.size.width / 11;
        originOfButtons = screenPartitionIdx / 2.4;
    }
    self.layer.cornerRadius = 15;
    [self setBackgroundColor: [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    button1 =  [self fontButton:@"decreaseFontSize:" imageName1:@"a-sm.png" imageName2:@"a-sm-tr.png" startX:originOfButtons width: 34 yAxe:11];
   button2 = [self fontButton:@"increaseFontSize:" imageName1:@"a-big.png" imageName2:@"a-big-tr.png" startX:  button1.frame.origin.x + screenPartitionIdx width:34 yAxe:11];
    
    //lineSeparator = [self addLineSeparator:button2.frame.origin.x + screenPartitionIdx   y1:0 x2:button2.frame.origin.x + screenPartitionIdx   y2:self.frame.size.height ];
    lineSeparator = [self addLineSeparator:button2.frame.origin.x + button2.frame.size.width / 1.5   y1:0 x2:screenPartitionIdx y2:self.frame.size.height];
    
      //lineCoordinateX = button2.frame.origin.x + button2.frame.size.width + screenPartitionIdx / 2;
    lineCoordinateX = self.rectView.center.x + screenPartitionIdx / 2;
    
    if (self.buttonCollection != nil) {
        for (ColorButton *colorButton in self.buttonCollection) {
            [colorButton removeFromSuperview];
        }
        self.buttonCollection = nil;
    }
        self.buttonCollection = [[NSMutableArray alloc]init];
    int colorNumber = 0;
    
        for (int j=0; j<=5; j++) {
            ColorButton *colorButton = [ColorButton buttonWithType:UIButtonTypeCustom];
            colorButton.frame = CGRectMake(lineCoordinateX + (j*screenPartitionIdx), self.frame.origin.y + 14, 28, 28);
            [colorButton addTarget:self action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
            [colorButton setSelected:NO];
            [colorButton setNeedsDisplay];
            [colorButton setBackgroundColor:[GzColors colorFromHex:[self.colorCollectionForText objectAtIndex:colorNumber]]];
            [colorButton setHexColor:[self.colorCollectionForText objectAtIndex:colorNumber]];
            colorButton.layer.cornerRadius = 14;
            colorButton.layer.masksToBounds = YES;
            colorButton.layer.borderColor = [UIColor colorWithRed:140.0f/255.0f green:140.0f/255.0f blue:140.0f/255.0f alpha:0.7f].CGColor;
            colorButton.layer.borderWidth = 0.0f;
            colorNumber ++;
            [self.buttonCollection addObject:colorButton];
            [self addSubview:colorButton];
            lastColorButtonX = colorButton.frame.origin.x;
        }
   button3 =  [self fontButton:@"addNewTextView:" imageName1:@"addText.png" imageName2:@"addTextSelected.png" startX:lastColorButtonX + screenPartitionIdx width:28 yAxe:14];
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
    [self addSubview:widthButton1];
    
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

    [self addSubview:widthButton2];

    
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

    [self addSubview:widthButton3];

    
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

    [self addSubview:widthButton4];
    
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
    [self addSubview:widthButton5];
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


@end
