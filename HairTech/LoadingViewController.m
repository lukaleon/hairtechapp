//
//  LoadingViewController.m
//  HairTech
//
//  Created by Lion on 12/13/12.
//  Copyright (c) 2012 Admin. All rights reserved.
//

#import "LoadingViewController.h"
#import "AppDelegate.h"
@interface LoadingViewController ()

@end

@implementation LoadingViewController

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
    
    
    [self performSelector:"gotoOrginalFirstScreen" withObject:nil afterDelay:1.0];

    
    NSUserDefaults *sharedDefaults = [NSUserDefaults standardUserDefaults];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   NSInteger countValue = [defaults integerForKey:@"Array"];
/*
    if ([sharedDefaults boolForKey:@"FirstLaunch"]||countValue == 0)
    {
        
    
        [self.openLibrary setEnabled:NO];
        [self.openLibrary setAlpha:0.7f];
        [sharedDefaults setBool:NO forKey:@"FirstLaunch"];
        [sharedDefaults synchronize];
       // [prefs synchronize];
    }	// Do any additional setup after loading the view.
    else if(countValue == 1)
    {
        [self.openLibrary setEnabled:YES];
        [self.openLibrary setAlpha:1.0f];
    
    }*/
}
- (void)gotoOrginalFirstScreen
{
    ViewController *controller = [[ViewController alloc] initWithNibName:@"OrginalController" bundle:nil];
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([[segue identifier] isEqualToString:@"createEntryView"])
    {
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.checkvalue = 1;
        
    }
}*/
@end
