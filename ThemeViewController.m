//
//  ViewController+infoViewController.m
//  hairtech
//
//  Created by Alexander Prent on 06.10.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import "ThemeViewController.h"
#import "TORoundedTableViewCell.h"
#import "TORoundedTableViewCapCell.h"
#import "TORoundedTableView.h"

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

@implementation ThemeViewController

-(void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = [UIColor colorNamed:@"grey"];
    self.navigationItem.title = @"App Info";
    [self.tableView setSeparatorColor:[UIColor colorNamed:@"grey"]];
    sectionOneItems = @[@"Auto",@"Light",@"Dark"];
    arrayOfCellIndexes = [NSMutableArray new];
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
-(UITableViewCell *)tableView:(TORoundedTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [self addRoundedCells:indexPath tableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [sectionOneItems objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if([cell.textLabel.text isEqual:[self getCurrentMode]]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    [arrayOfCellIndexes addObject:indexPath];
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    UIWindow * currentwindow = [[UIApplication sharedApplication] delegate].window;

    if(indexPath.row == 0){
   
        if (@available(iOS 13.0, *)) {
            currentwindow.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
        } else {
            // Fallback on earlier versions
        }
        [tableView cellForRowAtIndexPath:[arrayOfCellIndexes objectAtIndex:0]].accessoryType = UITableViewCellAccessoryCheckmark;
        [tableView cellForRowAtIndexPath:[arrayOfCellIndexes objectAtIndex:1]].accessoryType = UITableViewCellAccessoryNone;
        [tableView cellForRowAtIndexPath:[arrayOfCellIndexes objectAtIndex:2]].accessoryType = UITableViewCellAccessoryNone;
        [prefs setBool:YES forKey:@"Auto"];
        [prefs setBool: NO forKey:@"Light"];
        [prefs setBool: NO forKey:@"Dark"];
        [prefs synchronize];

    }
    if(indexPath.row == 1){
        
        if (@available(iOS 13.0, *)) {
            currentwindow.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        } else {
            // Fallback on earlier versions
        }
        [self.tableView cellForRowAtIndexPath:[arrayOfCellIndexes objectAtIndex:0]].accessoryType = UITableViewCellAccessoryNone;
        [tableView cellForRowAtIndexPath:[arrayOfCellIndexes objectAtIndex:1]].accessoryType = UITableViewCellAccessoryCheckmark;
        [tableView cellForRowAtIndexPath:[arrayOfCellIndexes objectAtIndex:2]].accessoryType = UITableViewCellAccessoryNone;
        [prefs setBool: YES forKey:@"Light"];
        [prefs setBool:NO forKey:@"Auto"];
        [prefs setBool: NO forKey:@"Dark"];
        [prefs synchronize];

    }
    if(indexPath.row == 2){
      
        if (@available(iOS 13.0, *)) {
            currentwindow.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
        } else {
            // Fallback on earlier versions
        }
        [tableView cellForRowAtIndexPath:[arrayOfCellIndexes objectAtIndex:0]].accessoryType = UITableViewCellAccessoryNone;
        [tableView cellForRowAtIndexPath:[arrayOfCellIndexes objectAtIndex:1]].accessoryType = UITableViewCellAccessoryNone;
        [tableView cellForRowAtIndexPath:[arrayOfCellIndexes objectAtIndex:2]].accessoryType = UITableViewCellAccessoryCheckmark;
        
        [prefs setBool: YES forKey:@"Dark"];
        [prefs setBool:NO forKey:@"Auto"];
        [prefs setBool: NO forKey:@"Light"];
        [prefs synchronize];

    }
  NSLog([prefs boolForKey:@"Auto"] ? @"Yes" : @"No");
    NSLog([prefs boolForKey:@"Light"] ? @"Yes" : @"No");
    NSLog([prefs boolForKey:@"Dark"] ? @"Yes" : @"No");
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger sectionID = [indexPath indexAtPosition:0];
    
        if ((indexPath.row != 0) && (indexPath.row != sectionOneItems.count - 1)){
            cell.backgroundColor = [UIColor colorNamed:@"whiteDark"];
        }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (UITableViewCell *)addRoundedCells:(NSIndexPath * _Nonnull)indexPath tableView:(TORoundedTableView * _Nonnull)tableView {
    
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
