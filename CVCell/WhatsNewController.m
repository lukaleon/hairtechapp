//
//  ViewController+WhatsNewController.m
//  hairtech
//
//  Created by Alexander Prent on 18.11.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import "WhatsNewController.h"

@implementation WhatsNewController
-(void)viewDidLoad{
    [super viewDidLoad];
}

- (IBAction)closeView:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)prefersStatusBarHidden {
    return true;
}
@end
