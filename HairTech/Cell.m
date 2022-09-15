
#define MARGIN 2

#import "Cell.h"
#import <QuartzCore/QuartzCore.h>
#import "SpringboardLayoutAttributes.h" // TO UNCOMMENT LATER
#import "AppDelegate.h"
static UIImage *deleteButtonImg;

@implementation Cell


    - (id)initWithCoder:(NSCoder *)aDecoder
    {
        self = [super initWithCoder:aDecoder];
        if (self)
        {

            [self.layer setBorderColor:[UIColor colorWithRed:225.0/255.0f green:225.0f/255.0f blue:225.0f/255.0f alpha:1.0f].CGColor];
            
            [self.layer setMasksToBounds:NO];
            //[self.layer setBorderWidth:3.0f];
            [self.layer setBackgroundColor:[[UIColor clearColor]CGColor]];
            [self.layer setCornerRadius:15.0f];
            [self.layer setOpacity:1.0f];
            
            [self.layer setShadowOffset:CGSizeMake(0, 2)];
            [self.layer setShadowColor:[[UIColor blackColor] CGColor]];
            [self.layer setShadowRadius:8.0f];
            [self.layer setShadowOpacity:0.9];
            
           // [self.cell_menu_btn setBackgroundImage:[UIImage imageNamed:@"btn_cell_menu_fl.png"] forState:UIControlStateNormal];
            /*
            self.barImage =[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height/9)];
            //self.eraserPointer.image=[UIImage imageNamed:@"eraser_pointer.png"];
            self.barImage.backgroundColor = [UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:0.02f];
            
            [self addSubview:self.barImage];
            */
          self.renameBtn.enabled=NO;
          self.deleteBtn.enabled=NO;
            

            
        
        
          
            
            tapCount = 1;
        }
        
        
    return self;
}







/*
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    [self.selectedBackgroundView setBackgroundColor:[UIColor blueColor]];
    
}
*/
- (void)setColor:(UIColor *)color {
    [self.dateLabel setBackgroundColor:color];
}




- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    //[super setEditing:editing animated:animated];
    
    static NSString * animationKey = @"editing";
    
    if (editing) {
        
        if ([self.layer animationForKey:animationKey] == nil) {
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
            
            animation.duration = 0.6f;
            animation.repeatCount = HUGE_VAL;
            
            CGFloat digree = M_PI / 180 * 0.8;
            
            animation.values = @[@0, @(digree), @0, @(-digree), @(0)];
            
            [self.layer addAnimation:animation forKey:animationKey];
        }
        
    } else {
        [self.layer removeAnimationForKey:animationKey];
    }
    
  //  _editing = editing;
//}

}
- (IBAction)showEditMenu:(id)sender {

    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"hideAllBars"
     object:self];

    
    tapCount=tapCount+1;

    if(tapCount % 2 ==0){
        [self showBar];
    }
    else{
       [self hideBar];
        tapCount=1;

    }
    
    
}
- (IBAction)renamePressed:(id)sender {
    //[self hideBar];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.cellNameForDelete = self.dateLabel.text;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"showPop"
     object:self];
}
- (IBAction)deletePressed:(id)sender {
    
   // [self hideBar];
   
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.cellNameForDelete = self.dateLabel.text;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"showDeletePop"
     object:self];
}
-(void)showBar{
    [self.menuBar setBackgroundColor:[UIColor whiteColor]];
    [self.menuBarExpanded setBackgroundColor:[UIColor whiteColor]];
    [self.renameBtn setBackgroundColor:[UIColor whiteColor]];
    [self.deleteBtn setBackgroundColor:[UIColor whiteColor]];
    [self.deleteBtn.layer setCornerRadius:15.0];
    [self.renameBtn.layer setCornerRadius:15.0];
    [self.menuBarExpanded.layer setCornerRadius:15.0];
    [self.menuBar.layer setCornerRadius:15.0];

    self.renameBtn.enabled=YES;
    self.deleteBtn.enabled =YES;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.renameBtn.frame = CGRectMake(self.menuBarExpanded.frame.origin.x,
                                                           (self.menuBarExpanded.frame.origin.y+self.menuBarExpanded.frame.size.height),self.menuBarExpanded.frame.size.width/2,self.menuBarExpanded.frame.size.height );
                         
                         self.deleteBtn.frame = CGRectMake(self.menuBarExpanded.frame.size.width/2,
                                                           (self.menuBarExpanded.frame.origin.y+self.menuBarExpanded.frame.size.height),self.menuBarExpanded.frame.size.width/2,self.menuBarExpanded.frame.size.height );
                         self.menuBarExpanded.frame =CGRectMake(self.menuBarExpanded.frame.origin.x,(self.menuBarExpanded.frame.origin.y+self.menuBarExpanded.frame.size.height),self.menuBarExpanded.frame.size.width,self.menuBarExpanded.frame.size.height );
                         
                     }];
    
  //  [self.cell_menu_btn setBackgroundImage:[UIImage imageNamed:@"btn_cell_menu.png"] forState:UIControlStateNormal];
    [self.cell_menu_btn setBackgroundColor:[UIColor whiteColor]];
    [self.cell_menu_btn.layer setCornerRadius:15.0];
    
}
-(void)hideBar{
    [self.menuBar setBackgroundColor:[UIColor whiteColor]];
    [self.menuBarExpanded setBackgroundColor:[UIColor whiteColor]];
    [self.renameBtn setBackgroundColor:[UIColor whiteColor]];
    [self.deleteBtn setBackgroundColor:[UIColor whiteColor]];
    [self.deleteBtn.layer setCornerRadius:15.0];
    [self.renameBtn.layer setCornerRadius:15.0];
    [self.menuBarExpanded.layer setCornerRadius:15.0];
    [self.menuBar.layer setCornerRadius:15.0];
    self.renameBtn.enabled=NO;
    self.deleteBtn.enabled =NO;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.renameBtn.frame = CGRectMake(self.menuBar.frame.origin.x,
                                                           self.menuBar.frame.origin.y,self.menuBar.frame.size.width/2,self.menuBar.frame.size.height );
                         
                         self.deleteBtn.frame = CGRectMake(self.menuBar.frame.size.width/2,
                                                           self.menuBar.frame.origin.y,self.menuBar.frame.size.width/2,self.menuBar.frame.size.height );
                         self.menuBarExpanded.frame =CGRectMake(self.menuBar.frame.origin.x,self.menuBar.frame.origin.y,self.menuBar.frame.size.width,self.menuBar.frame.size.height );
                         
                     }];
    
    //[self.cell_menu_btn setBackgroundImage:[UIImage imageNamed:@"btn_cell_menu_fl.png"] forState:UIControlStateNormal];
    [self.cell_menu_btn setBackgroundColor:[UIColor whiteColor]];
    [self.cell_menu_btn.layer setCornerRadius:15.0];

}

@end
