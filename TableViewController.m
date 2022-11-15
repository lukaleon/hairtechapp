//
//  TableViewCellsViewController.m
//  iPhoneMK Sample App
//
//  Created by Michael Kamprath on 2/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TableViewController.h"
#import "MKSwitchControlTableViewCell.h"
#import "MKIconCheckmarkTableViewCell.h"
#import "MKSocialShareTableViewCell.h"


#define SECTIONID_MKSwitchControlTableViewCell  0
#define SECTIONID_MKIconCheckmarkTableViewCell2  1
#define SECTIONID_MKVolumeUnits               2

#define SECTIONID_MKSocialShareTableViewCell    3
#define SECTIONID_MKParentalGate                4


@interface TableViewController ()

- (void)switchControlValueChanged:(id)sender;

@end

@implementation TableViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.title = @"App Info";
        //self.tabBarItem.image = [UIImage imageNamed:@"third"];
        if ( [self respondsToSelector:@selector(edgesForExtendedLayout)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self.tableView setSeparatorColor:[UIColor colorNamed:@"grey"]];

    self.radioButtonArray = [NSMutableArray new];
    for (int i = 0; i < 30; i ++) {
        UIButton *radioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [radioButton setImage:[UIImage imageNamed:@"radio_not_selected.png"] forState:UIControlStateNormal];
        [radioButton setImage:[UIImage imageNamed:@"radio_selected.png"] forState:UIControlStateSelected];
        [radioButton setFrame:CGRectMake(0, 0, 44, 44)];
        [radioButton addTarget:self action:@selector(radioButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.radioButtonArray addObject:radioButton];
    }
    

        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

        
        [[self.radioButtonArray objectAtIndex:0] setSelected:[prefs boolForKey:@"Gramms"]];
        [[self.radioButtonArray objectAtIndex:1] setSelected:[prefs boolForKey:@"Ounces"]];
        [[self.radioButtonArray objectAtIndex:2] setSelected:[prefs boolForKey:@"Mililiters"]];
        [[self.radioButtonArray objectAtIndex:3] setSelected:[prefs boolForKey:@"Parts"]];

    
    
////////////////////////////////////////////////////////////////////////////
    
    self.volumeButtonArray = [NSMutableArray new];
    for (int i = 0; i < 30; i ++) {
        UIButton *radioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [radioButton setImage:[UIImage imageNamed:@"radio_not_selected.png"] forState:UIControlStateNormal];
        [radioButton setImage:[UIImage imageNamed:@"radio_selected.png"] forState:UIControlStateSelected];
        [radioButton setFrame:CGRectMake(0, 0, 44, 44)];
        [radioButton addTarget:self action:@selector(volumeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.volumeButtonArray addObject:radioButton];
    }
   // NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    
    [[self.volumeButtonArray objectAtIndex:0] setSelected:[prefs boolForKey:@"Percents"]];
    [[self.volumeButtonArray objectAtIndex:1] setSelected:[prefs boolForKey:@"Volumes"]];


    ///////////////////////////////////////////////////////////////////////
    
    
//    
//    
//       UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button1 addTarget:self
//                action:@selector(closeSettings:)
//      forControlEvents:UIControlEventTouchUpInside];
//    
//    //[button setTitle:@"" forState:UIControlStateNormal];
//    button1.frame = CGRectMake(-10.0, 0.0, 40.0, 40.0);
//    
//    UIImage *buttonImageNormal = [UIImage imageNamed:@"close_sett_btn.png"];
//    UIImage *strechableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:0 topCapHeight:0];
//    [button1 setBackgroundImage:strechableButtonImageNormal forState:UIControlStateNormal];
//    UIBarButtonItem *buttonSt = [[UIBarButtonItem alloc]initWithCustomView:button1];
//    
//    
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                                                                    target:nil action:nil];
//    negativeSpacer.width = -10;
//    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, buttonSt, nil]];
//
//    
//    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
//   
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     [NSDictionary dictionaryWithObjectsAndKeys:
//      [UIFont fontWithName:@"Avenir-Medium" size:14],
//      NSFontAttributeName, nil]];
//    
    [super viewDidLoad];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorNamed:@"deepblue"]}];
   
    
    
   // self.tableView.separatorColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:0.2];
  
    
   }
-(void)closeSettings:(id)sender{


    [self dismissViewControllerAnimated:YES completion:nil];


}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ( [MKSocialShareTableViewCell socialShareAvailable] ) {
        return 5;
    }
    else {
        return 4;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *)view;
    tableViewHeaderFooterView.textLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:20];
    tableViewHeaderFooterView.textLabel.textColor = [UIColor colorNamed:@"deepblue"];
    CGRect headerFrame = tableViewHeaderFooterView.frame;
    headerFrame = CGRectMake(10, -10, headerFrame.size.width, 40);
    tableViewHeaderFooterView.textLabel.frame = headerFrame;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    

    switch (section) {
        case SECTIONID_MKSwitchControlTableViewCell:
            return @"Contact";
            break;
        case SECTIONID_MKIconCheckmarkTableViewCell2:
            return @"Units";
            break;
        case SECTIONID_MKVolumeUnits:
            return @"Volume";
            break;

        case SECTIONID_MKSocialShareTableViewCell:
            return @"Social";
            break;
        case SECTIONID_MKParentalGate:
            return @"About";
            break;
        default:
            return nil;
            break;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    

    switch (section) {
        case SECTIONID_MKSwitchControlTableViewCell:
            return 2;
            break;
        case SECTIONID_MKIconCheckmarkTableViewCell2:
            return 4;
            break;
        case SECTIONID_MKSocialShareTableViewCell:
            return 2;
            break;
        case SECTIONID_MKParentalGate:
            return 1;
            break;
        case SECTIONID_MKVolumeUnits:
            return 2;
            break;

        default:
            return 0;
            break;
    }

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger sectionID = [indexPath indexAtPosition:0];
    
    if ( sectionID == SECTIONID_MKSwitchControlTableViewCell ) {
        static NSString *CellIdentifier = @"SwitchCell";
        
        MKSwitchControlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[MKSwitchControlTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.font =[UIFont fontWithName:@"Avenir" size:14];

        cell.switchControl.tag = [indexPath indexAtPosition:1];
        
        NSArray * weightTypes =@[@"Wella", @"Loreal"];
       
        cell.textLabel.text = [weightTypes objectAtIndex:indexPath.row];
        //cell.textLabel.text = [NSString stringWithFormat:@"Wella %d",cell.switchControl.tag+1];
        
        
        CGRect footerRect = CGRectMake(0, 0, 320, 40);
        CGRect footerSubRect = CGRectMake(0,-20, 320, 40);
        UILabel *tableFooter = [[UILabel alloc] initWithFrame:footerRect];
        
        UILabel *tableSubFooter = [[UILabel alloc] initWithFrame:footerSubRect];
        
        tableFooter.textColor = [UIColor grayColor];
        tableFooter.backgroundColor = [self.tableView backgroundColor];
        tableFooter.opaque = YES;
        tableFooter.font = [UIFont fontWithName:@"Avenir-Medium" size:13];
        tableFooter.text = @"Version 6.0.1";
        tableFooter.textAlignment =NSTextAlignmentCenter;

        self.tableView.tableFooterView = tableFooter;
        
        [cell addTarget:self action:@selector(switchControlValueChanged:)];
        return cell;
    }
    else if ( sectionID == SECTIONID_MKIconCheckmarkTableViewCell2 ) {
       

        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.font =[UIFont fontWithName:@"Avenir" size:14];
        NSArray * weightTypes =@[@"Gramms (g)", @"Ounces (oz)",@"Milliliters (ml)", @"Parts"];
        
        cell.textLabel.text = [weightTypes objectAtIndex:indexPath.row];
        cell.accessoryView = [self.radioButtonArray objectAtIndex:[indexPath row]];
        // Configure the cell.
        return cell;
        
        
        
    }
    else if ( sectionID == SECTIONID_MKVolumeUnits ) {
        
        
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.font =[UIFont fontWithName:@"Avenir" size:14];
        NSArray * weightTypes =@[@"Percents (%)", @"Volumes (vol)"];
        
        cell.textLabel.text = [weightTypes objectAtIndex:indexPath.row];
        cell.accessoryView = [self.volumeButtonArray objectAtIndex:[indexPath row]];
        // Configure the cell.
        return cell;
        
        
        
    }

    else if ( sectionID == SECTIONID_MKSocialShareTableViewCell ) {
   
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
           // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSArray *imageNames =@[@"Follow Us On Facebook", @"Follow Us On Twitter"];
        cell.textLabel.font =[UIFont fontWithName:@"AvenirNext-DemiBold" size:14];
        
        cell.textLabel.text = [imageNames objectAtIndex:[indexPath row]];
        cell.textLabel.textColor = [UIColor colorNamed:@"deepblue"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
        
    }
    
    
    else if ( sectionID == SECTIONID_MKParentalGate ) {
        static NSString* ParentGateCellIdentifier = @"ParentalGate";
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ParentGateCellIdentifier];
        
        if ( nil == cell ) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ParentGateCellIdentifier];
        }
        cell.textLabel.font =[UIFont fontWithName:@"Avenir" size:14];
        cell.textLabel.text = @"About TintaApp";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    else {
        return nil;
    }
    
    
    
}



- (IBAction)radioButtonPressed:(UIButton *)button{
    

    [button setSelected:YES];
    // Unselect all others.
    for (UIButton *other in self.radioButtonArray) {
        if (other != button) {
            other.selected=NO;
        }
    }
    
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if(button == [self.radioButtonArray objectAtIndex:0]){
    
    [prefs setBool:YES forKey:@"Gramms"];
    [prefs setBool: NO forKey:@"Ounces"];
    [prefs setBool:NO  forKey:@"Mililiters"];
    [prefs setBool:NO  forKey:@"Parts"];


}
    if(button == [self.radioButtonArray objectAtIndex:1]){
        [prefs setBool:NO forKey:@"Gramms"];
        [prefs setBool: YES forKey:@"Ounces"];
        [prefs setBool:NO  forKey:@"Mililiters"];
        [prefs setBool:NO  forKey:@"Parts"];

}
    if(button == [self.radioButtonArray objectAtIndex:2]){
        [prefs setBool:NO forKey:@"Gramms"];
        [prefs setBool: NO forKey:@"Ounces"];
        [prefs setBool:YES  forKey:@"Mililiters"];
        [prefs setBool:NO  forKey:@"Parts"];

    }
    if(button == [self.radioButtonArray objectAtIndex:3]){
        [prefs setBool:NO forKey:@"Gramms"];
        [prefs setBool: NO forKey:@"Ounces"];
        [prefs setBool:NO  forKey:@"Mililiters"];
        [prefs setBool:YES  forKey:@"Parts"];
        
    }
    
        [prefs synchronize];
}



- (IBAction)volumeButtonPressed:(UIButton *)button{
    
    
    [button setSelected:YES];
    // Unselect all others.
    for (UIButton *other in self.volumeButtonArray) {
        if (other != button) {
            other.selected=NO;
        }
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        if(button == [self.volumeButtonArray objectAtIndex:0]){
            
            [prefs setBool:YES forKey:@"Percents"];
            [prefs setBool: NO forKey:@"Volumes"];
            
        }
        if(button == [self.volumeButtonArray objectAtIndex:1]){
            [prefs setBool:NO forKey:@"Percents"];
            [prefs setBool: YES forKey:@"Volumes"];
            
        }
    }
    


}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    if ( indexPath.section == SECTIONID_MKSocialShareTableViewCell && indexPath.row == 0 ) {
        
       // NSIndexPath *selectedIndexPath = [tableView indexPathForSelectedRow];

        NSURL *url = [ [ NSURL alloc ] initWithString:@"http://facebook.com/TintaApp"];
        
        if (![[UIApplication sharedApplication] openURL:url]){
            NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
    if(indexPath.section == SECTIONID_MKSocialShareTableViewCell && indexPath.row == 1 ){
        
            NSURL *url = [ [ NSURL alloc ] initWithString:@"http://twitter.com/hairtechapp"];
            
            if (![[UIApplication sharedApplication] openURL:url]){
                NSLog(@"%@%@",@"Failed to open url:",[url description]);
            }
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    
    
    if(indexPath.section == SECTIONID_MKParentalGate && indexPath.row == 0 ){
        
        NSURL *url = [ [ NSURL alloc ] initWithString:@"http://tinta.hairtechapp.com"];
        
        if (![[UIApplication sharedApplication] openURL:url]){
            NSLog(@"%@%@",@"Failed to open url:",[url description]);
        }
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }

}





#pragma mark - MKSwitchControlTableViewCell Support

- (void)switchControlValueChanged:(id)sender {
    
    if ( [sender isKindOfClass:[UISwitch class]] ) {
        UISwitch* cellSwitch = (UISwitch*)sender;
        
        NSUInteger pathArray[2];
        pathArray[0] = 0;
        pathArray[1] = cellSwitch.tag;
        
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathWithIndexes:pathArray length:2]];
        
        if (cellSwitch.on) {
           // cell.textLabel.textColor = [UIColor redColor];
            [cellSwitch setOnTintColor:[UIColor colorWithRed:255.0/255.0 green:108.0/255.0 blue:64.0/255.0 alpha:1.0]];
        }
        else {
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }
}

@end
