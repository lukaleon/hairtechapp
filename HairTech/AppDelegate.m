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
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"setLightModeAsDefaultTest"]) {
        [self setLightModeAsDefault];
        [self saveWidthOfLinesToDefaults:1.6 forKey:@"lineWidth"];
        [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"setLightModeAsDefaultTest"];
   }
    [self getCurrentMode];
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    //ViewController *controller = (ViewController *)navigationController.topViewController;
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
    NSLog(@"enter background");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didEnterBackground" object:self];
   
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appDidTerminate" object:self];

    //NSLog(@"Saving on terminating");
    //[self.myviewdelegate saveImageWhenterminate];
    
   
    
          // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{

        if ([url.scheme isEqualToString:@"file"] && [url.pathExtension isEqualToString:@"htapp"]) {
            NSLog(@"OPEN FILE %@", url);
            
            self.dict = options;
            NSData *data = [NSData dataWithContentsOfURL:url];
            if([self readFromData:data ofType:@"diagram.htapp" error:nil]){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"setButtonImageFromAppDelegate" object:self];
            }

            return YES;
            
        }
    return NO;
}
- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName
error:(NSError **)outError {
    if ([typeName isEqualToString:typeName]) {
        NSDictionary *readDict =
        [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:outError];
        
        UIImage *image1 = [readDict objectForKey:@"image1"];
        NSDictionary * dict = [readDict objectForKey:@"jsonLeft"];
        NSString * fileName = [readDict objectForKey:@"name"];
        NSLog(@"file name %@", fileName);
        [self writeStringToFile:dict];
        
//        NSArray *thumbpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,                                                NSUserDomainMask, YES);
//        NSString *thumbdocumentsDirectory = [thumbpaths objectAtIndex:0];
//        NSString *thumbpath = [thumbdocumentsDirectory stringByAppendingPathComponent:@"diag2.png"];
//        NSData * thumbdata = UIImagePNGRepresentation(image1);
//        [thumbdata writeToFile:thumbpath atomically:YES];

        self.imageBtn = image1;
        NSLog(@"image name %@", image1);
//        image1text = [readDict objectForKey:@"Image1Text"];
//        image2 = [readDict objectForKey:@"Image2"];
//        image2text = [readDict objectForKey:@"Image2Text"];
//        image3 = [readDict objectForKey:@"Image3"];
//        image3text = [readDict objectForKey:@"Image3Text"];
    }
    outError = NULL;
    return YES;
}
- (void)writeStringToFile:(NSDictionary*)arr {
    NSError * error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"file.json"];
    NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    [[jsonString dataUsingEncoding:NSUTF8StringEncoding] writeToFile:appFile atomically:NO];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:appFile]) {
        [[NSFileManager defaultManager] createFileAtPath:appFile contents:nil attributes:nil];
    }
    
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
-(void)saveWidthOfLinesToDefaults:(float)x forKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:x forKey:key];
    [userDefaults synchronize];
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
@end
