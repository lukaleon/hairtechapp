//
//  AppDelegate.m
//  HairTech
//
//  Created by Admin on 06/11/2012.
//  Copyright (c) 2012 Admin. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
//#import "MyCustomLayout.h"
#import "MAThemeKit.h"
#import "Flurry.h"


/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)



#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation AppDelegate

//MyCustomLayout *mycustomLayout;
//ViewController *viewController;

@synthesize myGlobalName;
@synthesize globalIndex;
@synthesize checkwindow;
@synthesize checkEntrywindow;
@synthesize loadviewCheckButton;
@synthesize OkButtonInSubView;
@synthesize globalDate;
@synthesize dashedCurve;


@synthesize databasePath;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    ViewController *controller = (ViewController *)navigationController.topViewController;
    


   //[Flurry setCrashReportingEnabled:YES];
    //note: iOS only allows one crash reporting tool per app; if using another, set to: NO
   //[Flurry startSession:@"9Q5QWZMPWC3M62DZD75S"];
    //your code

    //[Flurry logEvent:@"App_Launched"];

    sleep(1);

       NSDictionary *defaultsDict =
    [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"FirstLaunch", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsDict];
    
    
    
    
    NSDictionary *defaultsDictInstr = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"FirstPopCurve1", nil];
    
      NSDictionary *defaultsDictLine = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"FirstPopLine1", nil];
    
     [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsDictInstr];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsDictLine];
    
    //Data base methods
   self.databaseName = @"Technique.db";
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    
    self.databasePath = [documentDir stringByAppendingPathComponent:self.databaseName];
    
    [self createAndCheckDatabase];
    
   
    
/*
    
    
    UIColor *barColor = [UIColor colorWithRed:238.0/255.0 green:239.0/255.0 blue:243.0/255.0 alpha:1];
    
    UIColor *barTextColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
    
    
    [navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
   
    navigationController.navigationBar.clipsToBounds = YES;

    [MAThemeKit setupThemeWithPrimaryColor:[MAThemeKit colorWithR:255 G:255 B:255] secondaryColor:[MAThemeKit colorWithR:250 G:250 B:250] fontName:@"HelveticaNeue-Light" lightStatusBar:YES];
    // Use the rgb values BEFORE they are divided by 255.0, like you would see in photoshop's color picker
    UIColor *colorWithRGB = [MAThemeKit colorWithR:0 G:184 B:156];
    
    // Use the normal hex string representing the color
    UIColor *colorWithHex = [MAThemeKit colorWithHexString:@"00b89c"];
    // Override point for customization after application launch.
    navigationController.view.backgroundColor=[UIColor whiteColor];
*/
    dashedCurve =NO;
 
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"didEnterBackground" object:self];
   
    /*UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillTerminate:)
     name:UIApplicationWillTerminateNotification object:app];
*/
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"Saving on terminating");
    [self.myviewdelegate saveImageWhenterminate];
    
   
    
          // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) createAndCheckDatabase

{
    
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:databasePath];
    if(success) return;
    
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseName];
    
    NSError *err = nil;
    success = [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:&err];
    
}

/*
-(void) createAndCheckDatabase

{
BOOL success;
NSFileManager *fileManager = [NSFileManager defaultManager];
success = [fileManager fileExistsAtPath:self.databasePath];

if(success) return;

//else move database into documents folder
NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath]
                                 stringByAppendingPathComponent:@"Technique.db"];

[fileManager copyItemAtPath:databasePathFromApp toPath:self.databasePath error:nil];
}
*/
@end
