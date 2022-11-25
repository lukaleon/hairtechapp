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
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"App Version is %@",version);
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"setLightModeAsDefaultFromVersion601"]) {
        [self setLightModeAsDefault];
        [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"setLightModeAsDefaultFromVersion601"];
   }
    [self getCurrentMode];
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    ViewController *controller = (ViewController *)navigationController.topViewController;
    navigationController.navigationBar.tintColor = [UIColor colorNamed:@"textWhiteDeepBlue"];
    [[UINavigationBar appearance] setTintColor:[UIColor colorNamed:@"textWhiteDeepBlue"]];
  

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
    NSLog(@"docs",documentPaths);

    
    self.databasePath = [documentDir stringByAppendingPathComponent:self.databaseName];
    
   [self createAndCheckDatabase];
   
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

- (void)getCurrentMode {
    NSLog(@"current mode ");
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    UIWindow * currentwindow = [[UIApplication sharedApplication] delegate].window;
    if([prefs boolForKey:@"Auto"] == YES){
        currentwindow.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
    }
    if([prefs boolForKey:@"Light"] == YES){
        currentwindow.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    if([prefs boolForKey:@"Dark"] == YES){
        currentwindow.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
    }
    NSLog([prefs boolForKey:@"Auto"] ? @"Yes" : @"No");
      NSLog([prefs boolForKey:@"Light"] ? @"Yes" : @"No");
      NSLog([prefs boolForKey:@"Dark"] ? @"Yes" : @"No");
}
-(void)setLightModeAsDefault{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    UIWindow * currentwindow = [[UIApplication sharedApplication] delegate].window;
    currentwindow.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    [prefs setBool:NO forKey:@"Auto"];
    [prefs setBool:YES forKey:@"Light"];
    [prefs setBool:NO forKey:@"Dark"];
    [prefs synchronize];
}
-(void) createAndCheckDatabase

{
    NSLog(@"createAndcheckDataBase");
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:databasePath];
    if(success) return;
    
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseName];
    
    NSError *err = nil;
    success = [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:&err];
    
    
    FMDBDataAccess *db = [[FMDBDataAccess alloc] init];
    
    
    
//
//    BOOL success;
//    FMDatabase *db = [FMDatabase databaseWithPath:databasePath];
//    if (![db open])
//    {
//        NSLog(@"open failed");
//        return;
//    }
//    if (![db columnExists:@"placeName" inTableWithName:@"MYPLACES"])
//    {
//        success = [db executeUpdate:@"ALTER TABLE MYPLACES ADD COLUMN placeName TEXT"];
//        NSAssert(success, @"alter table failed: %@", [db lastErrorMessage]);
//    }
//    NSString *insertSQL = @"INSERT INTO  MYPLACES  (placeID, placeName)  VALUES (?, ?)";
//    success = [db executeUpdate:insertSQL, placeIDValue, placeNameValue];
//    NSAssert(success, @"insert failed: %@", [db lastErrorMessage]);
//    [db close];
//
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
