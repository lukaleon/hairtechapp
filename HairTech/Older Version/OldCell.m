#define MARGIN 2

#import "OldCell.h"
#import <QuartzCore/QuartzCore.h>
#import "SpringboardLayoutAttributes.h" // TO UNCOMMENT LATER
#import "AppDelegate.h"
#import "HapticHelper.h"
static UIImage *deleteButtonImg;

@implementation OldCell

@synthesize checkItem;
@synthesize checker;
@synthesize isCheckHidden;

    - (id)initWithCoder:(NSCoder *)aDecoder
    {
        self = [super initWithCoder:aDecoder];
        if (self)
        {
          self.renameBtn.enabled = NO;
            self.deleteBtn.enabled = NO;
            tapCount = 1;
            self.editView.hidden = YES;
        }
    return self;
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.selected = NO;
}

-(void)setIsCheckHidden:(BOOL)isCheckHidden{
    checkItem.hidden = isCheckHidden;
}

-(void)setCheckItem:(UIImageView *)checkImage{
    checkItem = checkImage;
}
- (void)setIsHidden:(BOOL)isHidden
{
    NSLog(@"set hiddden NO");
    self.editView.hidden = isHidden;
}

- (void)setColor:(UIColor *)color {
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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.cellPath = self.cellIndex;
    [self deleteAndRenamePressed];
    
}
- (IBAction)renamePressed:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.cellNameForDelete = self.dateLabel.text;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"showPopOld"
     object:self];
}


-(IBAction)sharePressed:(id)sender{
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"shareDiagramOld"
     object:self];
    
}
- (void)deleteAndRenamePressed{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.cellNameForDelete = self.dateLabel.text;
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"showDeletePopOld"
     object:self];
    
}
-(void)showBar{
     [self.menuBar setBackgroundColor:[UIColor whiteColor]];
     [self.menuBarExpanded setBackgroundColor:[UIColor whiteColor]];
    
    [self.menuBarExpanded.layer setShadowOffset:CGSizeMake(0, 1)];
    [self.menuBarExpanded.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.menuBarExpanded.layer setShadowRadius:2.0f];
    [self.menuBarExpanded.layer setShadowOpacity:0.1];
    //    [self.renameBtn setBackgroundColor:[UIColor whiteColor]];
//    [self.deleteBtn setBackgroundColor:[UIColor whiteColor]];
//    [self.deleteBtn.layer setCornerRadius:15.0];
//    [self.renameBtn.layer setCornerRadius:15.0];
  //  [self.menuBarExpanded.layer setCornerRadius:15.0];
 //   [self.menuBar.layer setCornerRadius:15.0];

    self.renameBtn.enabled=YES;
    self.deleteBtn.enabled =YES;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.renameBtn.frame = CGRectMake(self.menuBarExpanded.frame.origin.x + 20,
                                                           (self.menuBarExpanded.frame.origin.y+self.menuBarExpanded.frame.size.height), 120, 40);
                         
                         self.deleteBtn.frame = CGRectMake(self.menuBarExpanded.frame.size.width/2,
                                                           (self.menuBarExpanded.frame.origin.y+self.menuBarExpanded.frame.size.height),120,40);
                         self.menuBarExpanded.frame =CGRectMake(self.menuBarExpanded.frame.origin.x,(self.menuBarExpanded.frame.origin.y+self.menuBarExpanded.frame.size.height),self.menuBarExpanded.frame.size.width,self.menuBarExpanded.frame.size.height );
                         
                     }];
    
  //  [self.cell_menu_btn setBackgroundImage:[UIImage imageNamed:@"btn_cell_menu.png"] forState:UIControlStateNormal];
//    [self.cell_menu_btn setBackgroundColor:[UIColor whiteColor]];
//    [self.cell_menu_btn.layer setCornerRadius:15.0];
    
}
-(void)hideBar{
//    [self.menuBar setBackgroundColor:[UIColor whiteColor]];
//    [self.menuBarExpanded setBackgroundColor:[UIColor whiteColor]];
//    [self.renameBtn setBackgroundColor:[UIColor whiteColor]];
//    [self.deleteBtn setBackgroundColor:[UIColor whiteColor]];
//    [self.deleteBtn.layer setCornerRadius:15.0];
//    [self.renameBtn.layer setCornerRadius:15.0];
    [self.menuBarExpanded.layer setShadowOffset:CGSizeMake(0, 0)];
    [self.menuBarExpanded.layer setShadowColor:[[UIColor clearColor] CGColor]];
    [self.menuBarExpanded.layer setShadowRadius:0.0f];
    [self.menuBarExpanded.layer setShadowOpacity:0.0];
    
    //[self.menuBarExpanded.layer setCornerRadius:15.0];
   // [self.menuBar.layer setCornerRadius:15.0];
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
//    [self.cell_menu_btn setBackgroundColor:[UIColor whiteColor]];
//    [self.cell_menu_btn.layer setCornerRadius:15.0];

}
@end
