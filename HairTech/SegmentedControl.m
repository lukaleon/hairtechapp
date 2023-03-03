//
//  SegmentedControl.m
//  hairtech
//
//  Created by Alexander Prent on 02.03.2023.
//  Copyright © 2023 Admin. All rights reserved.
//

#import "SegmentedControl.h"

@implementation SegmentedControl

- (instancetype)initWithValue: (NSString *)value {
    
    if (self = [super init]) {
        if([value isEqualToString:@"techniqueName"]){
            self.selectedSegmentIndex = 0;
        }
        if([value isEqualToString:@"creationDate"]){
            self.selectedSegmentIndex = 1;
        }
        if([value isEqualToString:@"favorite"]){
            self.selectedSegmentIndex = 2;
        }
        [self sendActionsForControlEvents:UIControlEventValueChanged];


        return self;
    }
    
    return nil;
}

@end
