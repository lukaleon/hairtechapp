//
//  ViewController.h
//  TORoundedTableViewExample
//
//  Created by Tim Oliver on 29/11/16.
//  Copyright © 2016 Tim Oliver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tableCell.h"
#import "collectionCell.h"

@interface TODetailTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSArray * sectionName;
    NSUInteger rowsInSection;
    NSArray * sectionOneItems;
    NSArray * sectionTwoItems;
}
@end

