//
//  HelpViewController.h
//  HairTech
//
//  Created by Lion on 2/27/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HelpViewController;
@protocol HelpViewControllerDelegate <NSObject>


@end

@interface HelpViewController : UIViewController
- (IBAction)closeHelpView:(id)sender;
@property (weak, nonatomic) id<HelpViewControllerDelegate>delegate;
-(IBAction)followMe:(id)sender;
@end
