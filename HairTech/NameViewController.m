//
//  ViewController+NameViewController.m
//  hairtech
//
//  Created by Alexander Prent on 05.11.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import "NameViewController.h"
#import "MySubView.h"


@implementation  NameViewController
-(void)viewDidLoad{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor colorNamed:@"deepblue"];
    [self setCloseButton];
    [self setAppearanceOfElements];
}
-(void)setCloseButton{
    UIButton *rightCustomButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightCustomButton addTarget:self
                          action:@selector(closeView)
               forControlEvents:UIControlEventTouchUpInside];
    [rightCustomButton.widthAnchor constraintEqualToConstant:30].active = YES;
    [rightCustomButton.heightAnchor constraintEqualToConstant:30].active = YES;

    [rightCustomButton setImage:[UIImage imageNamed:@"Close.png"] forState:UIControlStateNormal];
    UIBarButtonItem * rightButtonItem =[[UIBarButtonItem alloc] initWithCustomView:rightCustomButton];
    self.navigationItem.rightBarButtonItems = @[rightButtonItem];
}
-(void)setAppearanceOfElements{
    self.progressBar.layer.cornerRadius = 2;
    self.continue_btn.layer.cornerRadius = 22;
   // [self.continue_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    self.continue_btn.alpha = 0.6;
    self.continue_btn.enabled = NO;

    
}
- (IBAction)Continue:(id)sender {
    
     MySubView * mySubView = [self.storyboard instantiateViewControllerWithIdentifier:@"subView"];
    mySubView.maleOrFemale = self.genderType;
     [self.navigationController pushViewController:mySubView animated:YES];
}

-(void)closeView{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


-(void)dropShadow:(UIButton*)btn{
    btn.layer.shadowColor = [UIColor colorNamed:@"orange"].CGColor;
    btn.layer.shadowOffset = CGSizeMake(0,0);
    btn.layer.shadowRadius = 5.0f;
    btn.layer.shadowOpacity = 0.4f;
    btn.layer.masksToBounds = NO;
}
-(void)removeShadow:(UIButton*)btn{
    btn.layer.shadowOpacity = 0.0f;
}
- (IBAction)headPressed:(id)sender {
    UIButton * pressedButton = (UIButton*)sender;
    switch(pressedButton.tag)
    {
        case 1:
            self.fem_btn.selected = YES;
            self.male_btn.selected = NO;
            self.continue_btn.enabled = YES;
            self.continue_btn.alpha = 1.0;
            [self dropShadow:pressedButton];
            [self removeShadow:self.male_btn];
            self.genderType = @"version22";
            break;
        case 2:
            self.fem_btn.selected = NO;
            self.male_btn.selected = YES;
            self.continue_btn.enabled = YES;
            self.continue_btn.alpha = 1.0;
            [self dropShadow:pressedButton];
            [self removeShadow:self.fem_btn];
            self.genderType = @"men22";
            break;
    }
}
@end
