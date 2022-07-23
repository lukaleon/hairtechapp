//
//  HelpViewController.m
//  HairTech
//
//  Created by Lion on 2/27/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "HelpViewController.h"
#import <QuartzCore/QuartzCore.h>"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
   [self.view setBackgroundColor:[UIColor underPageBackgroundColor]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeHelpView:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)followMe:(id)sender
{
    NSString *launchUrl = @"http://www.facebook.com/pages/Tri/445206905502545";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: launchUrl]];
}
@end
