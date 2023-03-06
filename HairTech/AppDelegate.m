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
#import "iCloud.h"

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
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"version08"]) {
        [self setupDefaultColors];
        [self setLightModeAsDefault];
        [self saveWidthOfLinesToDefaults:1.2 forKey:@"lineWidth"];
        self.firstTimeAfeterUpdate = YES;
        [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:@"version08"];
        [[NSUserDefaults standardUserDefaults] setObject:@"creationDate" forKey:@"order"];
        [[NSUserDefaults standardUserDefaults] setObject:self.colorCollection forKey:@"colorCollection"];
        [[NSUserDefaults standardUserDefaults] setBool:YES  forKey:@"grid"];
       
        [self saveMagnetStateToDefaults:YES];

    } else {
        self.firstTimeAfeterUpdate = NO;
    }

    [self getCurrentMode];
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
//    ViewController *controller = (ViewController *)navigationController.topViewController;
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
    
    self.databasePath = [documentDir stringByAppendingPathComponent:self.databaseName];
    
   [self createAndCheckDatabase];
   
    dashedCurve =NO;
    
    
    // arrayOfCloudFiles = [self getArrayOfFilesInCloud:[self ubiquitousDocumentsDirectoryURL]];
   

    return YES;
}






- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"AppDelegate resign  Active");

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"AppDelegate enter background");
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
    NSLog(@"AppDelegate  Enter Foreground");
    
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



#pragma mark - Importing Methods

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

-(void)addDefaultValueForFavoriteCell:(NSString*)fileName{
    NSUserDefaults * defualts = [NSUserDefaults standardUserDefaults];
        [defualts setObject:@"default" forKey:fileName];
        [defualts synchronize];
    
    NSUbiquitousKeyValueStore *cloudStore = [NSUbiquitousKeyValueStore defaultStore];
    [cloudStore setObject:@"default" forKey:fileName];
    [cloudStore synchronize];
}


-(NSArray*)getArrayOfFilesInCloud:(NSURL*)url{
    NSArray * dirContents =
    [[NSFileManager defaultManager] contentsOfDirectoryAtURL:url
                                  includingPropertiesForKeys:@[]
                                                     options:NSDirectoryEnumerationSkipsHiddenFiles
                                                       error:nil];
    
    NSLog(@"dir array count %lu", dirContents.count);
    for(NSString * name in dirContents){
        NSLog(@"dir array name %@", name);
        
    }
    return  dirContents;
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{

        if ([url.scheme isEqualToString:@"file"] && [url.pathExtension isEqualToString:@"htapp"]) {
            
            NSString * fileName = [[url path] lastPathComponent];
            NSString *nameWithoutExtension = [[[url path] lastPathComponent] stringByDeletingPathExtension];

            NSString *uniqueFileName = [self createUniqueFileName:fileName];

            NSURL *fileURL = [[[iCloud sharedCloud] ubiquitousDocumentsDirectoryURL] URLByAppendingPathComponent:uniqueFileName];

            NSData *fileData = [NSData dataWithContentsOfURL:url];
            NSError *error = nil;
            BOOL success = [fileData writeToURL:fileURL options:NSDataWritingAtomic error:&error];
            if (success) {
                
                [[NSUserDefaults standardUserDefaults] setObject:uniqueFileName forKey:@"newCreatedFileName"];
                [self addDefaultValueForFavoriteCell:uniqueFileName];

                [[NSNotificationCenter defaultCenter]
                    postNotificationName:@"populate"
                    object:self];
               
                [[NSNotificationCenter defaultCenter]
                    postNotificationName:@"reloadCollection"
                    object:self];
               
                [[NSNotificationCenter defaultCenter]
                    postNotificationName:@"openEntry"
                    object:self];
                
            } else {
                // There was an error saving the file
                NSLog(@"Error saving file: %@", error);
            }
            
            
            
            
            
            //            NSData *data = [NSData dataWithContentsOfURL:url];
//
//            iCloudDocument * document = [[iCloudDocument alloc] initWithFileURL:url];
//
//
//            ViewController * vc = [[ViewController alloc]init];
//            vc.importedFileName = fileName;
//            vc.importedFileData = data;
//            vc.importedDoc = document;
//            [vc insertExportedDataFromAppDelegate:fileName data:document];
            
            return YES;
            
        }
    return NO;
}

- (NSString *)createUniqueFileName:(NSString *)fileName {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *basePath = [fileName stringByDeletingLastPathComponent];
    NSString *fileExtension = [fileName pathExtension];
    NSString *fileNameWithoutExtension = [fileName stringByDeletingPathExtension];
    NSString *uniqueFileName = fileName;
    
    NSURL *fileURL = [[self ubiquitousDocumentsDirectoryURL] URLByAppendingPathComponent:uniqueFileName];
    
    int i = 1;
    while ([fileManager fileExistsAtPath:fileURL.path]) {
        
        uniqueFileName = [NSString stringWithFormat:@"%@%@_%d.%@", basePath, fileNameWithoutExtension, i, fileExtension];
        fileURL = [[self ubiquitousDocumentsDirectoryURL] URLByAppendingPathComponent:uniqueFileName];
        i++;
    }
    
    return uniqueFileName;
}
#pragma mark - Cloud Init Methods

-(NSURL *)applicationCloudFolder:(NSString *)fileName
{    
    // append our file name
    NSLog(@"file name app delegate %@", fileName);
   // NSURL * cloudDocuments = [[self ubiquitousDocumentsDirectoryURL] URLByAppendingPathComponent:fileName];
    NSURL * cloudRootUrl = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    NSURL * cloudDocuments = [cloudRootUrl URLByAppendingPathComponent:@"Documents"];
    cloudDocuments = [cloudDocuments URLByAppendingPathComponent:fileName];

    return cloudDocuments;
}

-(NSURL*)ubiquitousDocumentsDirectoryURL {
    return [[self ubiquitousContainerURL] URLByAppendingPathComponent:@"Documents"];
}
-(NSURL*)ubiquitousContainerURL {
    return [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
}

#pragma mark - Defaults Settings

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

-(void)setupDefaultColors{
    self.colorCollection = [NSArray arrayWithObjects:
                            
                            Black,
                            RoyalBlue,
                            Red,
                            Green,
                            DarkRed,
                            DarkSlateGray,
                           
                            DeepPink,
                            Purple,
                            OrangeRed,
                            Orange,
                            DarkBlue,
                            Yellow,
                            nil];
    
    NSLog(@"save color to defaults and cloud at first launch");
    
    [[NSUserDefaults standardUserDefaults] setObject:DarkSlateGray forKey:@"penToolColor"];
    [[NSUserDefaults standardUserDefaults] setObject:RoyalBlue forKey:@"curveToolColor"];
    [[NSUserDefaults standardUserDefaults] setObject:Green forKey:@"dashToolColor"];
    [[NSUserDefaults standardUserDefaults] setObject:Red forKey:@"arrowToolColor"];
    [[NSUserDefaults standardUserDefaults] setObject:RoyalBlue forKey:@"lineToolColor"];
    [[NSUserDefaults standardUserDefaults] setObject:Black forKey:@"textToolColor"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    NSUbiquitousKeyValueStore *cloudStore = [NSUbiquitousKeyValueStore defaultStore];

    [cloudStore setObject:DarkSlateGray forKey:@"penToolColor"];
    [cloudStore setObject:RoyalBlue forKey:@"curveToolColor"];
    [cloudStore setObject:Green forKey:@"dashToolColor"];
    [cloudStore setObject:Red forKey:@"arrowToolColor"];
    [cloudStore setObject:RoyalBlue forKey:@"lineToolColor"];
    [cloudStore setObject:Black forKey:@"textToolColor"];
    [cloudStore setString:@"testValue" forKey:@"testKey"];

    [cloudStore synchronize];

}

@end
