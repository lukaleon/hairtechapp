//
//  DEMOMenuViewController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOMenuViewController.h"
#import "ViewController.h"
//#import "Flurry.h"

@interface DEMOMenuViewController ()

//@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (strong, readwrite, nonatomic) UIView *myView;

@end

@implementation DEMOMenuViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myView = [[UIView alloc] init];
    self.myView.backgroundColor = [UIColor clearColor];
    
    
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 300, 20)];
    
    [topLabel setTextColor:[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0f]];
    [topLabel setBackgroundColor:[UIColor clearColor]];

    [topLabel setFont:[UIFont fontWithName: @"Helvetica" size: 16.0f]];
   // topLabel.font=[UIFont fontWithName: @"Helvetica" size: 16.0f];
    
   // [topLabel setText:@"HAIRTECH V.1.4"];
    ////////////////////////////////////
    
    /////////////////////////////
    UIButton *button0 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button0 addTarget:self
               action:@selector(goToSupportPage:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [button0 setTitle:@"GO TO SUPPORT PAGE" forState:UIControlStateNormal];
    
    [button0.titleLabel setFont:[UIFont fontWithName: @"Helvetica" size: 17.0f]];
    
    [button0 setTitleColor:[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    [button0 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    button0.frame = CGRectMake(5.0, 200.0, 220.0, 45.0);
    
    ////////////////////////////////////
    
    ////////////////////////////////////
    
    UILabel *Label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, 300, 50)];
    
    [Label2 setTextColor:[UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0f]];
    [Label2 setBackgroundColor:[UIColor clearColor]];
    //[Label2 sizeToFit];
    Label2.numberOfLines=0;
    


    [Label2 setFont:[UIFont fontWithName: @"Helvetica" size: 16.0f]];
    [Label2 setText:@"Draw, store and share haircutting techniques."];
    ////////////////////////////////////
    ////////////////////////////////////
    
    UILabel *Label3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 250, 300, 70)];
    
    [Label3 setTextColor:[UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0f]];
    [Label3 setBackgroundColor:[UIColor clearColor]];
    //[Label2 sizeToFit];
    Label3.numberOfLines=0;
    
    
    
    [Label3 setFont:[UIFont fontWithName: @"Helvetica" size: 16.0f]];
    [Label3 setText:@"It is great to hear your Feedback and Comments as well as Feature Requests and Bug Reports"];

    ////////////////////////////////////
    
    
    /////////////////////////////
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 addTarget:self
               action:@selector(rateHairtech:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [button2 setTitle:@"RATE HAIRTECH!" forState:UIControlStateNormal];
    
    [button2.titleLabel setFont:[UIFont fontWithName: @"Helvetica" size: 17.0f]];
    
    [button2 setTitleColor:[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    button2.frame = CGRectMake(5.0, 320.0, 170.0, 45.0);

    
    ////////////////////////////////////
    ////////////////////////////////////
    
    UILabel *Label4 = [[UILabel alloc] initWithFrame:CGRectMake(20, 360, 300, 70)];
    
    [Label4 setTextColor:[UIColor colorWithRed:235/255.0f green:235/255.0f blue:235/255.0f alpha:1.0f]];
    [Label4 setBackgroundColor:[UIColor clearColor]];
    //[Label2 sizeToFit];
    Label4.numberOfLines=0;
    
    
    
    [Label4 setFont:[UIFont fontWithName: @"Helvetica" size: 16.0f]];
    [Label4 setText:@"Like Hairtech? Want to keep it alive? Great ratings motivate us!"];

    ////////////////////////////////////
    UIImage *image_f = [UIImage imageNamed:@"facebook.png"];
    UIImage *image_t = [UIImage imageNamed:@"twitter.png"];
    UIImage *image_p = [UIImage imageNamed:@"pinterest.png"];
    
    UIImageView *imageView_f = [[UIImageView alloc] initWithImage:image_f];
    UIImageView *imageView_t = [[UIImageView alloc] initWithImage:image_t];
    UIImageView *imageView_p= [[UIImageView alloc] initWithImage:image_p];

    /////////////////////////////
    UIButton *facebook = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [facebook addTarget:self
                action:@selector(likeOnFacebook:)
      forControlEvents:UIControlEventTouchUpInside];
   [facebook setBackgroundImage:imageView_f.image forState:UIControlStateNormal];

    facebook.frame = CGRectMake(20.0, 460.0, 50.0,50.0);
    //////////////////////////////
    
    
    /////////////////////////////
    UIButton *twitter = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [twitter addTarget:self
                action:@selector(followTwitter:)
      forControlEvents:UIControlEventTouchUpInside];
    [twitter setBackgroundImage:imageView_t.image forState:UIControlStateNormal];
    
    twitter.frame = CGRectMake(80, 460.0, 50.0, 50.0);

    //////////////////////////////  /////////////////////////////
    
    
    UIButton *pinterest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pinterest addTarget:self
                  action:@selector(followPinterest:)
        forControlEvents:UIControlEventTouchUpInside];
    [pinterest setBackgroundImage:imageView_p.image forState:UIControlStateNormal];
    
    pinterest.frame = CGRectMake(140.0, 460.0, 50.0, 50.0);


    //////////////////////////////
    [self.myView addSubview:topLabel];
    [self.myView addSubview:button0];
    [self.myView addSubview:Label2];
    [self.myView addSubview:Label3];
    [self.myView addSubview:Label4];
    [self.myView addSubview:button2];
    
     [self.myView addSubview:facebook];
     [self.myView addSubview:twitter];
     [self.myView addSubview:pinterest];

    [self.view addSubview:self.myView];
}

-(IBAction)goToSupportPage:(id)sender{
    //[Flurry logEvent:@"GOT_SUPPORT_PAGE"];

    NSLog(@"UIBUTTON PRESSED");
    NSURL *url = [ [ NSURL alloc ] initWithString: @"http://hairtechapp.com/support.html" ];
    
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);

}

-(IBAction)rateHairtech:(id)sender{
    
    //[Flurry logEvent:@"Rate_On_Appstore"];
    
   NSURL *url = [ [ NSURL alloc ] initWithString:@"http://appstore.com/hairtech"];
    
    if (![[UIApplication sharedApplication] openURL:url])
        
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    
}

-(IBAction)likeOnFacebook:(id)sender{
    
  //  [Flurry logEvent:@"likeOnFacebook"];
    
    NSURL *url = [ [ NSURL alloc ] initWithString:@"http://facebook.com/HairtechApp"];
    
    if (![[UIApplication sharedApplication] openURL:url])
        
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    
}
-(IBAction)followTwitter:(id)sender{
   
   // [Flurry logEvent:@"follow_Twitter"];
    
    NSURL *url = [ [ NSURL alloc ] initWithString:@"http://instagram.com/hairtechapp"];
    
    if (![[UIApplication sharedApplication] openURL:url])
        
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    
}
-(IBAction)followPinterest:(id)sender{
    
   // [Flurry logEvent:@"follow_Pinterest"];
    
    NSURL *url = [ [ NSURL alloc ] initWithString:@"http://pinterest.com/artisticad/hairdressing-design"];
    
    if (![[UIApplication sharedApplication] openURL:url])
        
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    
}
  /*
   
    self.tableView = [[UITableView alloc] init]; // Frame will be automatically set

    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled= NO;
   
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
       /* UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"avatar.jpg"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 1.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        */
    
    
    /*
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 0, 0)];
        label.text = @"HAIRTECH V. 1.4";
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
       // [view addSubview:imageView];
        [view addSubview:label];
        view;
    });
    [self.view addSubview:self.tableView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(goToSupportPage:)
     forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Show View" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0f] forState:UIControlStateNormal];

    [button setTitleColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f] forState:UIControlStateSelected];
    
    button.frame = CGRectMake(20.0, 0.0, 160.0, 40.0);
    [self.view addSubview:button];
    
    
}


-(IBAction)goToSupportPage:(id)sender{
    
    NSLog(@"UIBUTTON PRESSED");
    
}


#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"SUPPORT WEBSITE";
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        
    } else {
   
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0) {
        NSArray *titles = @[@"Draw, store and share", @"haircutting techniques"];
        cell.textLabel.text = titles[indexPath.row];
    } else {
        NSArray *titles = @[@"John Appleseed", @"John Doe", @"Test User"];
        cell.textLabel.text = titles[indexPath.row];
    }
    
    return cell;
}

*/
    

@end
