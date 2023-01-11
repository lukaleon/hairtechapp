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
        [self saveMagnetStateToDefaults:YES];
        [[NSUserDefaults standardUserDefaults] setObject:@"creationDate" forKey:@"order"];

        
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

-(void)getArrayOfFilesInDirectory{
    self.filesArrayAppDelegate = [NSMutableArray array];
    NSArray * dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] error:NULL];
    [self.filesArrayAppDelegate removeAllObjects];
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *extension = [[filename pathExtension] lowercaseString];
        if ([extension isEqualToString:@"htapp"]) {
            [self.filesArrayAppDelegate addObject:filename];
            NSLog(@"filename in appdelegate %@ ", filename );
        }
    }];
    
}
-(NSMutableDictionary*)getImportedFileData:(NSData*)data error:(NSError **)outError {

    NSMutableDictionary * tempDict = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:outError];
    
    return tempDict;
}
-(NSMutableDictionary*)openFileAtPath:(NSString*)fileName error:(NSError **)outError {

    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [docDirectory stringByAppendingPathComponent:fileName];
    
    NSURL * url = [NSURL fileURLWithPath:filePath];
    NSData *data = [NSData dataWithContentsOfURL:url];

    NSMutableDictionary * tempDict = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:outError];
    
    return tempDict;
}

-(NSString*)getNamesOfTechniquesInFiles:(NSString*)techNameImported{
    
    
            NSString *lastChar = [techNameImported substringFromIndex:[techNameImported length] - 1];

            unichar c = [lastChar characterAtIndex:0];
            NSCharacterSet *numericSet = [NSCharacterSet decimalDigitCharacterSet];
            if ([numericSet characterIsMember:c]) {
                
                int myInt = [lastChar intValue];
                techNameImported = [techNameImported substringToIndex:[techNameImported length] - 1];

                techNameImported = [techNameImported stringByAppendingFormat:@"%d", myInt + 1];
            }
            else {
                techNameImported = [techNameImported stringByAppendingFormat:@"%d", 1];
            }
    return techNameImported;
}

- (NSData *)dataOfType:(NSMutableDictionary*)dict{
    NSError *error = nil;
          //Return the archived data
        return [NSKeyedArchiver archivedDataWithRootObject:dict requiringSecureCoding:NO error:&error];
}
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{

        if ([url.scheme isEqualToString:@"file"] && [url.pathExtension isEqualToString:@"htapp"]) {
            
            NSString * fileName = [[url path] lastPathComponent];
            self.dict = options;
            NSData *data = [NSData dataWithContentsOfURL:url];
            /* CHECK FILE NAME FOR EXISTANCE IN FOLDER */
            
            [self getArrayOfFilesInDirectory];
            int i = 0;
            NSMutableDictionary * dict = [self getImportedFileData:data error:nil];

            for(NSString * name in self.filesArrayAppDelegate){
                if([fileName isEqualToString:name]){
                    NSLog(@"Name exists");

                    NSString * newIDName = [[NSUUID UUID] UUIDString];
                    NSMutableString * newIDWithExtension = [newIDName mutableCopy];
                    [newIDWithExtension appendString:@".htapp"];
                    fileName = newIDWithExtension;
                    [dict setObject:newIDName forKey:@"uuid"];
                    data = [self dataOfType:dict];

                }else {
                    NSLog(@"Name not exists");
                }
                NSMutableDictionary * dictOfData = [self openFileAtPath:[self.filesArrayAppDelegate objectAtIndex:i] error:nil];

                if([[dict objectForKey:@"techniqueName"] isEqualToString:[dictOfData objectForKey:@"techniqueName"]]){
                    NSLog(@"Name is the same");
                    NSString * newName = [self getNamesOfTechniquesInFiles:[dict objectForKey:@"techniqueName"]];
                    [dict setObject:newName forKey:@"techniqueName"];
                    data = [self dataOfType:dict];

                }else {
                    NSLog(@"Name is not the same");
                }
                i++;
                
            }
                    
            NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
            NSString *docDirectory = [sysPaths objectAtIndex:0];
            NSString *filePath = [docDirectory stringByAppendingPathComponent:fileName];
            [data writeToFile:filePath atomically:YES];
                
            [[NSNotificationCenter defaultCenter] postNotificationName:@"insertExportedDataFromAppDelegate" object:self];

            return YES;
            
        }
    return NO;
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


-(void)saveMagnetStateToDefaults:(BOOL)isVisible{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:isVisible  forKey:@"magnet"];
    [prefs synchronize];
}
@end
