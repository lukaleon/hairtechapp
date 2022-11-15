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

@implementation TODetailTableViewController

#pragma mark - Rounded Table Configuration Example -

-(void)viewDidLoad{
   [self.tableView setSeparatorColor:[UIColor colorNamed:@"grey"]];
    self.tableView.separatorInset = UIEdgeInsetsZero;
   sectionName = @[@"Contact", @"Get started", @"Follow Us", @"Rate App"];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.row != 0) && (indexPath.row != sectionName.count-1)){
        cell.backgroundColor = [UIColor colorNamed:@"whiteDark"];
    }
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
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %ld", indexPath.row+1];

    // iOS 13 changed the behaviour of table views, so keep the labels clear here for ease of configuration
    if (@available(iOS 13.0, *)) {} else {
        cell.textLabel.backgroundColor = [UIColor whiteColor];
        cell.textLabel.opaque = YES;
    }

    cell.textLabel.font =[UIFont fontWithName:@"AvenirNext-DemiBold" size:14];
    cell.textLabel.textColor = [UIColor colorNamed:@"textColor"];
    [cell setIndentationLevel:10];
    [cell setIndentationWidth:2];
    // Return the cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Play the deselection animation
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - General Table View Configuration -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionName.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return sectionName.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * title = [sectionName objectAtIndex:section];
     return title;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString * title;
    if (section == sectionName.count -1 ){
        title = [NSString stringWithFormat: @"Version 6.0.1"];
    }
    return title;
    //        return [NSString stringWithFormat:@"This is the footer for section %ld", (long)section];
    
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *)view;
    tableViewHeaderFooterView.textLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:18];
    tableViewHeaderFooterView.textLabel.textColor = [UIColor colorNamed:@"textColor"];
    tableViewHeaderFooterView.textLabel.text = [tableViewHeaderFooterView.textLabel.text capitalizedString];
}
@end
