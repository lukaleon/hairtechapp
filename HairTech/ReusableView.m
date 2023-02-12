//
//  UICollectionReusableView+ReusableView.m
//  hairtech
//
//  Created by Alexander Prent on 10.01.2023.
//  Copyright © 2023 Admin. All rights reserved.
//

#import "ReusableView.h"

@implementation ReusableView

- (void)awakeFromNib{
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorNamed:@"orangeForSegmented"]} forState:UIControlStateSelected];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorNamed:@"textColor"]} forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFromCloud) name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:[NSUbiquitousKeyValueStore defaultStore]];

    
    [self.segmentedControl addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    NSString * key =  [[NSUserDefaults standardUserDefaults] objectForKey:@"order"];
    [self segmentChangeOnLoad:key];
    
}

- (void)segmentChangeOnLoad:(NSString*)key {

    if ([key isEqualToString:@"techniqueName"]){
        self.segmentedControl.selectedSegmentIndex = 0;
        [self.delegate sortCollectionView:@"techniqueName"];
        self.segmentedControlValue = @"techniqueName";
    }
    if ([key isEqualToString:@"creationDate"]){
        self.segmentedControl.selectedSegmentIndex = 1;
        [self.delegate sortCollectionView:@"creationDate"];
        self.segmentedControlValue = @"creationDate";
    }
    if ([key isEqualToString:@"favorite"]){
        self.segmentedControl.selectedSegmentIndex = 2;
        [self.delegate sortCollectionView:@"favorite"];
        self.segmentedControlValue = @"favorite";
    }
    }

-(void)loadFromCloud{
    [self segmentChangeFromCloud:[[NSUbiquitousKeyValueStore defaultStore] objectForKey:@"order"]];
}

-(void)segmentChangeFromCloud:(NSString*)key {

    if ([key isEqualToString:@"techniqueName"]){
        dispatch_async(dispatch_get_main_queue(), ^{

        self.segmentedControlValue = @"techniqueName";
        self.segmentedControl.selectedSegmentIndex = 0;
        [self.segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
        });

     
    }
    if ([key isEqualToString:@"creationDate"]){
        dispatch_async(dispatch_get_main_queue(), ^{

        self.segmentedControlValue = @"creationDate";
        self.segmentedControl.selectedSegmentIndex = 1;
        [self.segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
        });

    }
    if ([key isEqualToString:@"favorite"]){
        dispatch_async(dispatch_get_main_queue(), ^{
       
        self.segmentedControlValue = @"favorite";
        self.segmentedControl.selectedSegmentIndex = 2;
        [self.segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
        });
    }
    
    }
- (IBAction)segmentChange:(UISegmentedControl*)sender {

    switch (self.segmentedControl.selectedSegmentIndex){
        case 0:
            [self.delegate sortCollectionView:@"techniqueName"];
            [[NSUserDefaults standardUserDefaults] setObject:@"techniqueName" forKey:@"order"];
            [[NSUbiquitousKeyValueStore defaultStore] setObject:@"techniqueName" forKey:@"order"];
            [[NSUbiquitousKeyValueStore defaultStore] synchronize];
            break;
        case 1:
            [self.delegate sortCollectionView:@"creationDate"];
            [[NSUserDefaults standardUserDefaults] setObject:@"creationDate" forKey:@"order"];
            [[NSUbiquitousKeyValueStore defaultStore] setObject:@"creationDate" forKey:@"order"];
            [[NSUbiquitousKeyValueStore defaultStore] synchronize];
            break;
        case 2:
            [self.delegate sortCollectionView:@"favorite"];
            [[NSUserDefaults standardUserDefaults] setObject:@"favorite" forKey:@"order"];
            [[NSUbiquitousKeyValueStore defaultStore] setObject:@"favorite" forKey:@"order"];
            [[NSUbiquitousKeyValueStore defaultStore] synchronize];
            break;
        default:
            break;
    }
}
@end
