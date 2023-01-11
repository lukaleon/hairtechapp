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
    if ([key isEqualToString:@"creationDate"]){
        self.segmentedControl.selectedSegmentIndex = 1;
        [self.delegate sortCollectionView:@"favorite"];
        self.segmentedControlValue = @"favorite";
    }
    
    }
- (IBAction)segmentChange:(UISegmentedControl*)sender {

    switch (self.segmentedControl.selectedSegmentIndex){
        case 0:
            [self.delegate sortCollectionView:@"techniqueName"];
            [[NSUserDefaults standardUserDefaults] setObject:@"techniqueName" forKey:@"order"];
            break;
        case 1:
            [self.delegate sortCollectionView:@"creationDate"];
            [[NSUserDefaults standardUserDefaults] setObject:@"creationDate" forKey:@"order"];
            break;
        case 2:
            [self.delegate sortCollectionView:@"favorite"];
            [[NSUserDefaults standardUserDefaults] setObject:@"favorite" forKey:@"order"];
            break;
        default:
            break;
    }
}
@end
