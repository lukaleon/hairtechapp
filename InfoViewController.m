//
//  ViewController+infoViewController.m
//  hairtech
//
//  Created by Alexander Prent on 06.10.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import "InfoViewController.h"

@implementation InfoViewController  

-(void)viewWillAppear:(BOOL)animated{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"App Info";
    self.shareBtn.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
}



- (IBAction)share:(id)sender {
    NSString *textToShare;
    textToShare = [NSString stringWithFormat:@"https://apps.apple.com/ua/app/hairtech-head-sheets/id625740630"];
    NSMutableArray *itemsToShare = [NSMutableArray arrayWithObjects:textToShare, nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[ UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact,UIActivityTypeMessage,UIActivityTypePostToWeibo];
    activityViewController.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:activityViewController animated: YES completion: nil];
    UIPopoverPresentationController * popoverPresentationController = activityViewController.popoverPresentationController;
    popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popoverPresentationController.sourceView = self.view;
    popoverPresentationController.sourceRect = CGRectMake(685,60,10,1);
}
@end
