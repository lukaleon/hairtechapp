//
//  ViewController.m
//  TORoundedTableViewExample
//
//  Created by Tim Oliver on 29/11/16.
//  Copyright © 2016 Tim Oliver. All rights reserved.
//

#import "TODetailTableViewController.h"

#import "TORoundedTableView.h"
#import "TORoundedTableViewCell.h"
#import "TORoundedTableViewCapCell.h"
#import "WhatsNewController.h"

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

@implementation TODetailTableViewController

#pragma mark - Rounded Table Configuration Example -

-(void)viewDidLoad{
   [self.tableView setSeparatorColor:[UIColor colorNamed:@"grey"]];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    sectionName = @[@"Get started",@"Contact", @"Follow"];
   // self.tableView.tableHeaderView = [self addLogoToHeader];
    self.tableView.tableFooterView = [self addFooterTitle];
    
    sectionOneItems = @[@"Help", @"Rate our app", @"Report an issue", @"Give us your feedback"];
    sectionTwoItems = @[@"Follow us", @"Visit our web site"];
   // [self.tableView registerNib:[UINib nibWithNibName:@"tableCell" bundle:nil]
     //  forCellReuseIdentifier:@"tableCell"];
    

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger sectionID = [indexPath indexAtPosition:0];
    if(sectionID == 1){
        if ((indexPath.row != 0) && (indexPath.row != sectionOneItems.count - 1)){
            cell.backgroundColor = [UIColor colorNamed:@"whiteDark"];
        }
    }
}

- (UIView *)addLogoToHeader {
   UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
    UIImageView *thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    thumbnail.image = [UIImage imageNamed:@"ht_logo_new"];
    thumbnail.contentMode = UIViewContentModeScaleAspectFit;
    [header addSubview:thumbnail];
    
    
//    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
//    collectionView.backgroundColor = [UIColor yellowColor];
//    [header addSubview:collectionView];
    return header;
}
-(UIView*)addFooterTitle{
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 60)];
    title.text = @"Version 6.0.1";
    title.font = [UIFont fontWithName:@"AvenirNext-Bold" size:10];
    title.textColor = [UIColor colorNamed:@"smallText"];
    title.textAlignment = NSTextAlignmentCenter;
    
//    UIImageView *thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 20, 20)];
//    CGPoint cntr = CGPointMake(footerView.center.x, title.center.y - 0);
//    thumbnail.image = [UIImage imageNamed:@"logo"];
//    thumbnail.tintColor = [UIColor colorNamed:@"smallText"];
//    thumbnail.center = cntr;
//    [UIView animateWithDuration:1.0
//                     animations:^{
//                       // CGAffineTransform CGAffineTransformRotate(CGAffineTransform t, CGFloat 180);
//        thumbnail.transform = CGAffineTransformRotate(thumbnail.transform, 90);
//                     }];
   
   // [footerView addSubview:thumbnail];
    return title;
}
- (UITableViewCell *)tableView:(TORoundedTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    /*
     Because the first and last cells in a section (dubbed the 'cap' cells) do a lot of extra work on account of the rounded corners,
     for ultimate efficiency, it is recommended to create those ones separately from the ones in the middle of the section.
    */
    
    // Create identifiers for standard cells and the cells that will show the rounded corners
    static NSString *cellIdentifier     = @"Cell";
    static NSString *capCellIdentifier  = @"CapCell";

    
    // Work out if this cell needs the top or bottom corners rounded (Or if the section only has 1 row, both!)
    BOOL isTop = (indexPath.row == 0);
    BOOL isBottom = indexPath.row == ([tableView numberOfRowsInSection:indexPath.section] - 1);
    
    // Create a common table cell instance we can configure
    UITableViewCell *cell = nil;
    
    // If it's a non-cap cell, dequeue one with the regular identifier
    if (!isTop && !isBottom) {
        TORoundedTableViewCell *normalCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (normalCell == nil) {
            normalCell = [[TORoundedTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        
        cell = normalCell;
    }
    else {
        // If the cell is indeed one that needs rounded corners, dequeue from the pool of cap cells
        TORoundedTableViewCapCell *capCell = [tableView dequeueReusableCellWithIdentifier:capCellIdentifier];
        if (capCell == nil) {
            capCell = [[TORoundedTableViewCapCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:capCellIdentifier];
        }
        
        // Configure the cell to set the appropriate corners as rounded
        capCell.topCornersRounded = isTop;
        capCell.bottomCornersRounded = isBottom;
        cell = capCell;
    }

    // Configure the cell's label
    //cell.textLabel.text = [NSString stringWithFormat:@"Cell %ld", indexPath.row+1];

    // iOS 13 changed the behaviour of table views, so keep the labels clear here for ease of configuration
    if (@available(iOS 13.0, *)) {} else {
        cell.textLabel.backgroundColor = [UIColor whiteColor];
        cell.textLabel.opaque = YES;
    }
    cell.textLabel.font = [self fontSizeiPad:19 iPhone:17];
    cell.textLabel.textColor = [UIColor colorNamed:@"textColor"];
    [cell setIndentationLevel:10];
    [cell setIndentationWidth:2];
    

    if(indexPath.section == 1){
       // UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        cell.textLabel.text = [sectionOneItems objectAtIndex:indexPath.row];
        rowsInSection = sectionOneItems.count;

        return cell;

    }

    if (indexPath.section == 2) {
        //UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        cell.textLabel.text = [sectionTwoItems objectAtIndex:indexPath.row];
        rowsInSection = sectionTwoItems.count;
        return cell;
    }
    if (indexPath.section == 0) {
        
        tableCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
        //[cell2.collectionView registerClass:[collectionCell class] forCellWithReuseIdentifier:@"collectionCell"];
        cell2.collectionView.delegate = self;
        cell2.collectionView.dataSource = self;
        cell2.backgroundColor = [UIColor clearColor];
        return cell2;
    }
    else {
        return nil;
    }
    // Return the cell
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Play the deselection animation
    
    if ( indexPath.section == 2 && indexPath.row == 0 ) {
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *URL = [NSURL URLWithString:@"http://instagram.com/hairtechapp"];
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            if (success) {
                 NSLog(@"Opened url");
            }
        }];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if ( indexPath.section == 2 && indexPath.row == 1 ) {
        
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *URL = [NSURL URLWithString:@"http://hairtechapp.com"];
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Opened url");
            }
        }];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - General Table View Configuration -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        rowsInSection = 1;
    }if (section == 1){
        rowsInSection = sectionOneItems.count;
    }
    if (section == 2){
        rowsInSection = sectionTwoItems.count;    }
    return rowsInSection;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * title = [sectionName objectAtIndex:section];
     return title;
}

//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    NSString * title;
//    if (section == sectionName.count -1 ){
//        title = [NSString stringWithFormat: @"Version 6.0.1"];
//    }
//    return title;
//    //        return [NSString stringWithFormat:@"This is the footer for section %ld", (long)section];
//
//}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *)view;
    tableViewHeaderFooterView.textLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:22];
    tableViewHeaderFooterView.textLabel.textColor = [UIColor colorNamed:@"textColor"];
    tableViewHeaderFooterView.textLabel.text = [tableViewHeaderFooterView.textLabel.text capitalizedString];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
       CGSize newSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds)/3.55,(CGRectGetHeight ([UIScreen mainScreen].bounds) / 3.55));
        if (IDIOM == IPAD){
            return newSize.height;
        }else {
            return 200;
            
        }
    }
    return 55;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 3;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
 //   collectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    collectionCell *cell = (collectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];

    CGRect rect = CGRectMake(cell.label.frame.origin.x, cell.label.frame.origin.y, cell.label.frame.size.width, (cell.frame.size.height) / 2.5);
    cell.backgroundColor = [UIColor clearColor];
    //cell.label.backgroundColor = [UIColor yellowColor];

    cell.label.numberOfLines = 0;
    cell.label.frame = rect;
    cell.label.font = [self fontSizeiPad:17 iPhone:14];
        if (indexPath.row == 0){
            cell.contentView.backgroundColor = [UIColor colorNamed:@"yellowTest"];
            cell.label.text = @"How to use Hairtechapp";
            //cell.image.image = [UIImage imageNamed:@"ht_logo_new"];
        }
        if (indexPath.row == 1){
            cell.contentView.backgroundColor = [UIColor colorNamed:@"redTest"];
            cell.label.text = @"What's new";

        }
        if (indexPath.row == 2){
            cell.contentView.backgroundColor = [UIColor colorNamed:@"blueTest"];
            cell.label.text = @"Great features inside";

        }
    [cell.contentView.layer setCornerRadius:25.0];
    cell.clipsToBounds = YES;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WhatsNewController *whatsnew = [self.storyboard instantiateViewControllerWithIdentifier:@"whatsnew"];
    collectionCell *cell = (collectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    whatsnew.view.backgroundColor = cell.contentView.backgroundColor;
    whatsnew.label.text = @"This is hairtech app";
    [self presentViewController:whatsnew animated:YES completion:nil];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize newSize;
    if(IDIOM == IPAD){
        newSize = CGSizeMake(CGRectGetWidth(collectionView.frame)/3.55,(CGRectGetHeight (collectionView.frame)-4));
    }else
    {
        newSize = CGSizeMake(CGRectGetWidth(collectionView.frame)/2.7,(CGRectGetHeight (collectionView.frame)-4));
    }
    
    return CGSizeMake(newSize.width,newSize.width * 1.3);
}

-(UIFont*)fontSizeiPad:(CGFloat)ipadSize iPhone:(CGFloat)iphoneSize{
    UIFont * font;
    if (IDIOM == IPAD){
    font =  [UIFont fontWithName:@"AvenirNext-DemiBold" size:ipadSize];
    }else{
    font =  [UIFont fontWithName:@"AvenirNext-DemiBold" size:iphoneSize];
    }
    return font;
}


@end
