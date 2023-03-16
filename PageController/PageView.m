//
//  IntroViewController.m
//  PageViewController
//
//  Created by Imanou on 19/09/2017.
//  Copyright © 2017 Imanou. All rights reserved.
//

#import "PageView.h"

@interface PageView ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *smallLabel;


@end

@implementation PageView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addImage];
    [self addBottomView];
    [self addMainLabel];
    [self addSmallLabel];
}

-(void)addImage{
    CGFloat imageWidthConstant;
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        imageWidthConstant = 460;
    }
    else{
        imageWidthConstant = 360;
    }
    self.imageview = [[UIImageView alloc]
                              initWithFrame:CGRectMake(self.view.frame.origin.x,
                                                       self.view.frame.origin.y,
                                                       self.view.frame.size.width,
                                                       self.view.frame.size.width * 1.3)];


    [self.imageview setImage:[UIImage imageNamed:self.imageName]];
    [self.imageview setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:self.imageview];
   
    self.imageview.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.imageview.centerXAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerXAnchor] setActive:YES];
    [[self.imageview.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:30] setActive:YES];
    [[self.imageview.widthAnchor constraintEqualToConstant:imageWidthConstant] setActive:YES];
    [[self.imageview.heightAnchor constraintEqualToAnchor:self.imageview.widthAnchor multiplier:1.3] setActive:YES];
    

  
}

-(void)addBottomView{
    CGFloat startOfFrame = self.imageview.frame.origin.y + self.imageview.frame.size.height;
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,
                                                              startOfFrame,
                                                              self.view.frame.size.width,
                                                              self.view.frame.size.height - startOfFrame)];
    self.bottomView.backgroundColor = [UIColor colorNamed:@"whiteDark"];
    [self.view addSubview:self.bottomView];
    self.bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.bottomView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:0]setActive:YES];
    [[self.bottomView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor]setActive:YES];
    [[self.bottomView.topAnchor constraintEqualToAnchor:self.imageview.bottomAnchor]setActive:YES];
    
}
-(void)addMainLabel{
    CGFloat fontsize;
    CGFloat sideMargin;
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        fontsize = 30;
        sideMargin = 120;
    }else{
        fontsize = 22;
        sideMargin = 40;
    }
    self.textLabel = [[UILabel alloc]init];
    self.textLabel.textColor = [UIColor colorNamed:@"textWhiteDeepBlue"];
    self.textLabel.text = self.text;
    self.textLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:fontsize];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self.bottomView addSubview:self.textLabel];
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.textLabel setNumberOfLines:0];
    
    [[self.textLabel.centerXAnchor constraintEqualToAnchor:self.bottomView.safeAreaLayoutGuide.centerXAnchor] setActive:YES];
    [[self.textLabel.topAnchor constraintEqualToAnchor:self.bottomView.safeAreaLayoutGuide.topAnchor constant:20] setActive:YES];
    [[self.textLabel.widthAnchor constraintEqualToConstant:self.view.frame.size.width - 20] setActive:YES];
}
-(void)addSmallLabel{
    CGFloat fontsize;
    CGFloat sideMargin;
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        fontsize = 19;
        sideMargin = 120;
    }else{
        fontsize = 14;
        sideMargin = 40;
    }
    self.smallLabel = [[UILabel alloc]init];
    self.smallLabel.textColor = [UIColor colorNamed:@"textWhiteDeepBlue"];
    self.smallLabel.text = self.smallText;
    self.smallLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:fontsize];
    self.smallLabel.textAlignment = NSTextAlignmentCenter;
    [self.bottomView addSubview:self.smallLabel];
    self.smallLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.smallLabel setNumberOfLines:0];
    
    [[self.smallLabel.centerXAnchor constraintEqualToAnchor:self.bottomView.safeAreaLayoutGuide.centerXAnchor] setActive:YES];
    [[self.smallLabel.topAnchor constraintEqualToAnchor:self.textLabel.safeAreaLayoutGuide.bottomAnchor constant:7] setActive:YES];
    [[self.smallLabel.widthAnchor constraintEqualToConstant:self.view.frame.size.width - sideMargin] setActive:YES];
}
- (void)hideTextLabel
{
    NSLog(@"set alpha to zero");
    self.textLabel.alpha = 0.2;
}
@end
