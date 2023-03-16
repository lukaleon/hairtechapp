//
//  ViewController.m
//  TORoundedTableViewExample
//
//  Created by Tim Oliver on 29/11/16.
//  Copyright © 2016 Tim Oliver. All rights reserved.
//

#import "TODetailTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TORoundedTableView.h"
#import "TORoundedTableViewCell.h"
#import "TORoundedTableViewCapCell.h"
#import "WhatsNewController.h"
#import "PageViewController.h"
#import "ContainerViewController.h"
#import "OldCollectionView.h"
#import "WebBrowserViewController.h"

#define SECTIONID_CollectionView 0
#define SECTIONID_General 1
#define SECTIONID_GetStarted 2
#define SECTIONID_Follow 3



@implementation TODetailTableViewController

#pragma mark - Rounded Table Configuration Example -

-(void)viewDidLoad{
    
    self.techniques = [[NSMutableArray alloc] init];
    FMDBDataAccess *db = [[FMDBDataAccess alloc] init];
    self.techniques = [db getCustomers];
    
    NSLog(@"view did load");
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
   [self.tableView setSeparatorColor:[UIColor colorNamed:@"grey"]];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layer.cornerRadius = 20;
    sectionName = @[@"Get started",@"General",@"Contact", @"Follow"];
   // self.tableView.tableHeaderView = [self addLogoToHeader];
    self.tableView.tableFooterView = [self addFooterTitle];
    
    sectionOneItems = @[@"Rate our app", @"Report an issue", @"Visit our website"];
    sectionTwoItems = @[@"Follow us on Instagram", @"Follow us on Facebook"];
    sectionThemeItems = @[@"Auto", @"Light", @"Dark"];
    self.themeButtonArray = [NSMutableArray new];
    arrayOfCellIndexes = [NSMutableArray new];

   // [self.tableView registerNib:[UINib nibWithNibName:@"tableCell" bundle:nil]
     //  forCellReuseIdentifier:@"tableCell"];
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"view will appear");
    FMDBDataAccess *db = [[FMDBDataAccess alloc] init];
    self.techniques = [db getCustomers];

    [self.tableView reloadData];

}
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"view did appear");
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger sectionID = [indexPath indexAtPosition:0];
    if(sectionID == 2){
        if ((indexPath.row != 0) && (indexPath.row != sectionOneItems.count - 1)){
            cell.backgroundColor = [UIColor colorNamed:@"whiteDark"];
        }
    }
    if(sectionID == 1){
        if ((indexPath.row != 0) && (indexPath.row != sectionThemeItems.count - 1)){
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
    title.text = @"Version 8.0.1";
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
- (UITableViewCell *)addRoundedCells:(NSIndexPath * _Nonnull)indexPath tableView:(TORoundedTableView * _Nonnull)tableView style:(UITableViewCellStyle)style {
    static NSString *cellIdentifier     = @"Cell";
    static NSString *capCellIdentifier  = @"CapCell";
    
    
    // Work out if this cell needs the top or bottom corners rounded (Or if the section only has 1 row, both!)
    BOOL isTop = (indexPath.row == 0);
    BOOL isBottom = indexPath.row == ([tableView numberOfRowsInSection:indexPath.section] - 1);
    
    // Create a common table cell instance we can configure
    UITableViewCell *cell = nil;
    
    // If it's a non-cap cell, dequeue one with the regular identifier
    if (!isTop && !isBottom) {
     //   TORoundedTableViewCell *normalCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
       // if (normalCell == nil) {
        TORoundedTableViewCell *normalCell = [[TORoundedTableViewCell alloc] initWithStyle:style reuseIdentifier:cellIdentifier];
//        }
        
        cell = normalCell;
    }
    else {
        // If the cell is indeed one that needs rounded corners, dequeue from the pool of cap cells
//        TORoundedTableViewCapCell *capCell = [tableView dequeueReusableCellWithIdentifier:capCellIdentifier];
//        if (capCell == nil) {
        TORoundedTableViewCapCell * capCell = [[TORoundedTableViewCapCell alloc] initWithStyle:style reuseIdentifier:capCellIdentifier];
//        }
        
        // Configure the cell to set the appropriate corners as rounded
        capCell.topCornersRounded = isTop;
        capCell.bottomCornersRounded = isBottom;
        cell = capCell;
    }
    /*
     Because the first and last cells in a section (dubbed the 'cap' cells) do a lot of extra work on account of the rounded corners,
     for ultimate efficiency, it is recommended to create those ones separately from the ones in the middle of the section.
    */
    
    // Create identifiers for standard cells and the cells that will show the rounded corners

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
    return cell;
}

- (NSString*)getCurrentMode {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString * modeString;
    if([prefs boolForKey:@"Auto"] == YES){
        modeString = @"Auto";
    }
    if([prefs boolForKey:@"Light"] == YES){
        modeString = @"Light";
    }
    if([prefs boolForKey:@"Dark"] == YES){
        modeString = @"Dark";
    }
    return modeString;
}

- (UITableViewCell *)tableView:(TORoundedTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if(indexPath.section == SECTIONID_General){
        UITableViewCell * cell = [self addRoundedCells:indexPath tableView:tableView style:UITableViewCellStyleValue1];
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"Theme";
        cell.detailTextLabel.text = [self getCurrentMode];
        rowsInSection = sectionThemeItems.count;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
        //cell.accessoryView = [self.themeButtonArray objectAtIndex:[indexPath row]];
        //[cell addSubview:[self.themeButtonArray objectAtIndex:[indexPath row]]];
        //[arrayOfCellIndexes addObject:indexPath];
        return cell;

    }
    if(indexPath.section == SECTIONID_GetStarted){
        UITableViewCell * cell = [self addRoundedCells:indexPath tableView:tableView style:UITableViewCellStyleDefault];
        cell.textLabel.text = [sectionOneItems objectAtIndex:indexPath.row];
        rowsInSection = sectionOneItems.count;
        return cell;

    }

    if (indexPath.section == SECTIONID_Follow) {
        UITableViewCell * cell = [self addRoundedCells:indexPath tableView:tableView style:UITableViewCellStyleDefault];
        cell.textLabel.text = [sectionTwoItems objectAtIndex:indexPath.row];
        rowsInSection = sectionTwoItems.count;
        return cell;
    }
    if (indexPath.section == SECTIONID_CollectionView) {
        tableCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
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
    if (indexPath.section == SECTIONID_General && indexPath.row == 0){
        WhatsNewController *whatsnew = [self.storyboard instantiateViewControllerWithIdentifier:@"themeview"];
        //  whatsnew.label.text = @"This is hairtech app";
        whatsnew.view.backgroundColor = [UIColor colorNamed:@"whiteDark"];
        [self.navigationController pushViewController:whatsnew animated:YES];
    }
    
    if ( indexPath.section == SECTIONID_GetStarted && indexPath.row == 0 ) {
        
//    [self presentViewController:webView animated:YES completion:nil];
//        [self performSegueWithIdentifier:@"showWeb" sender:self];
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *URL = [NSURL URLWithString:@"https://apps.apple.com/us/app/hairtech-head-sheets/id625740630?action=write-review"];
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Opened url");
            }
        }];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    }

    if ( indexPath.section == SECTIONID_GetStarted && indexPath.row == 1 ) {
        
//        UIApplication *application = [UIApplication sharedApplication];
//        NSURL *URL = [NSURL URLWithString:@"https://apps.apple.com/us/app/hairtech-head-sheets/id625740630?action=write-review"];
//        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
//            if (success) {
//                NSLog(@"Opened url");
//            }
//        }];
        [self sendEmail];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
    
    if ( indexPath.section == SECTIONID_GetStarted && indexPath.row == 2) {
        UIApplication *application = [UIApplication sharedApplication];
                NSURL *URL = [NSURL URLWithString:@"https://hairtechapp.com"];
                [application openURL:URL options:@{} completionHandler:^(BOOL success) {
                    if (success) {
                        NSLog(@"Opened url");
                    }
                }];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
   

    if ( indexPath.section == SECTIONID_Follow && indexPath.row == 0 ) {
//        WhatsNewController *whatsnew = [self.storyboard instantiateViewControllerWithIdentifier:@"whatsnew"];
//        [self.navigationController presentViewController:whatsnew animated:YES completion:nil];
//        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        UIApplication *application = [UIApplication sharedApplication];
              NSURL *URL = [NSURL URLWithString:@"http://instagram.com/hairtechapp"];
              [application openURL:URL options:@{} completionHandler:^(BOOL success) {
                  if (success) {
                       NSLog(@"Opened url");
                  }
              }];

              [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    }
    if ( indexPath.section == 3 && indexPath.row == 1 ) {
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *URL = [NSURL URLWithString:@"https://www.facebook.com/HairtechApp"];
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Opened url");
            }
        }];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
#pragma mark SEND MAIL

-(void)sendEmail {
        // From within your active view controller
        if([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
            mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send
        
            [mailCont setSubject:@"Issue report"];
            [mailCont setToRecipients:[NSArray arrayWithObject:@"hello@hairtechapp.com"]];
            
            NSString *emailBody = @"</p> <p><i>(Please, describe your problem in details. Attaching a screenshot or video showing the issue would help us better understand an issue.)</i></p><p><b>Hello Hairtechapp team. I'm having an issue with:</b>";

            [mailCont setMessageBody:emailBody isHTML:YES];
            [self presentViewController:mailCont animated:YES completion:nil];
        }
    }

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }
#pragma mark - General Table View Configuration -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    

    switch (section) {
        case SECTIONID_CollectionView:
            return 1;
            break;
        case SECTIONID_General:
            return 1;
            break;
        case SECTIONID_GetStarted:
            return 3;
            break;
        case SECTIONID_Follow:
            return 2;
            break;
        default:
            return 0;
            break;
    }

    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * title = [sectionName objectAtIndex:section];
     return title;
}
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
        if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
            return newSize.height;
        }else {
            return 200;
            
        }
    }
    return 55;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if(self.techniques.count == 0){
        return 2;
    }
    else {
        return 3;
    }
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
        
    if(self.techniques.count == 0){ // if no old version techniques - show 2 cells
        if (indexPath.row == 0){
            
            cell.contentView.backgroundColor = [UIColor colorNamed:@"yellowTest"];
            cell.label.text = @"How to use Hairtechapp";
            cell.image.image = [UIImage imageNamed:@"preview_cell1"];
            cell.image.backgroundColor = [UIColor colorNamed:@"blueTest"];
            [[cell.image.widthAnchor constraintEqualToConstant:cell.frame.size.width] setActive:YES];
            [[cell.image.heightAnchor constraintEqualToConstant:cell.frame.size.height] setActive:YES];
            
            
            
        }
        if (indexPath.row == 1){
            cell.image.image = [UIImage imageNamed:@"guideicon"];
            cell.image.backgroundColor = [UIColor colorNamed:@"blueTest"];
            cell.label.text = @"User guide";
            [[cell.image.widthAnchor constraintEqualToConstant:cell.frame.size.width] setActive:YES];
            [[cell.image.heightAnchor constraintEqualToConstant:cell.frame.size.height] setActive:YES];
        }
        
    }
    else{ // if old version techniques exist  - show 3 cells
        
        if (indexPath.row == 0){
            
            cell.contentView.backgroundColor = [UIColor colorNamed:@"blueTest"];
            cell.image.image = [UIImage imageNamed:@"Archive"];
            cell.label.text = @"Archived diagrams";
            [[cell.image.widthAnchor constraintEqualToConstant:cell.frame.size.width] setActive:YES];
            [[cell.image.heightAnchor constraintEqualToConstant:cell.frame.size.height] setActive:YES];
            
        }
        if (indexPath.row == 1){
            
            cell.contentView.backgroundColor = [UIColor colorNamed:@"blueTest"];
            cell.label.text = @"How to use Hairtechapp";
            cell.image.image = [UIImage imageNamed:@"preview_cell1"];
            cell.image.backgroundColor = [UIColor colorNamed:@"blueTest"];
            [[cell.image.widthAnchor constraintEqualToConstant:cell.frame.size.width] setActive:YES];
            [[cell.image.heightAnchor constraintEqualToConstant:cell.frame.size.height] setActive:YES];
            
        }
        if (indexPath.row == 2){
            cell.image.image = [UIImage imageNamed:@"guideicon"];
            cell.image.backgroundColor = [UIColor colorNamed:@"blueTest"];
            [[cell.image.widthAnchor constraintEqualToConstant:cell.frame.size.width] setActive:YES];
            [[cell.image.heightAnchor constraintEqualToConstant:cell.frame.size.height] setActive:YES];
          //  cell.contentView.backgroundColor = [UIColor colorNamed:@"redTest"];
            cell.label.text = @"User guide";
        }
    }
    [cell.contentView.layer setCornerRadius:25.0];
    cell.clipsToBounds = YES;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    OldCollectionView *oldCollection = [self.storyboard instantiateViewControllerWithIdentifier:@"OldCollection"];
    ContainerViewController *pageVc = [self.storyboard instantiateViewControllerWithIdentifier:@"containervc"];

  //  collectionCell *cell = (collectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    whatsnew.view.backgroundColor = cell.contentView.backgroundColor;
//    whatsnew.label.text = @"This is hairtech app";
//      ContainerViewController *pageview = [self.storyboard instantiateViewControllerWithIdentifier:@"containervc"];
//      pageview.modalPresentationStyle = UIModalPresentationFullScreen;
//    pageview.view.backgroundColor = cell.contentView.backgroundColor;
    
    if(self.techniques.count == 0){
        if(indexPath.row == 0){
            [self.navigationController presentViewController:pageVc animated:YES completion:nil];
        }
        if(indexPath.row == 1){
            [self performSegueWithIdentifier:@"showWeb" sender:self];
        }
    }
    else {
        if(indexPath.row == 1){
            [self.navigationController presentViewController:pageVc animated:YES completion:nil];
        }
        if(indexPath.row == 0){
            [self.navigationController pushViewController:oldCollection animated:YES];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize newSize;
    if(UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        newSize = CGSizeMake(CGRectGetWidth(collectionView.frame)/3.55,(CGRectGetHeight (collectionView.frame)-4));
    }else
    {
        newSize = CGSizeMake(CGRectGetWidth(collectionView.frame)/2.7,(CGRectGetHeight (collectionView.frame)-4));
    }
    
    return CGSizeMake(newSize.width,newSize.width * 1.3);
}

-(UIFont*)fontSizeiPad:(CGFloat)ipadSize iPhone:(CGFloat)iphoneSize{
    UIFont * font;
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
    font =  [UIFont fontWithName:@"AvenirNext-DemiBold" size:ipadSize];
    }else{
    font =  [UIFont fontWithName:@"AvenirNext-DemiBold" size:iphoneSize];
    }
    return font;
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if([segue.identifier isEqualToString:@"showDetail"]) {
//
//    }
//    if([segue.identifier isEqualToString:@"showOldCollection"]) {
//
//    }
//}
@end
