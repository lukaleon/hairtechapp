//
//  ViewController.m
//  HairTech
//
//  Created by Lion on 11/29/12.
//  Copyright (c) 2012 Admin. All rights reserved.
//
#import "EntryViewController.h"
#import "REFrostedViewController.h"
#import "ViewController.h"
#import "LoadingViewController.h"
//#import "Cell.h"
#import "MySubView.h"
#import "AppDelegate.h"
#import "MyCustomLayout.h"
#import "HapticHelper.h"
#import "NameViewController.h"
#import "TODetailTableViewController.h"
#import "Hairtech-Bridging-Header.h"
#import "Hairtech-Swift.h"
#import "TemporaryDictionary.h"
#import "ReusableView.h"
#import "DiagramFile.h"
#import "iCloud.h"
#import "iCloudDocument.h"
#import "CustomActivityIndicator.h"

#import "WSCoachMarksView.h"
#import "iCloudDocument.h"
#import <QuickLook/QuickLook.h>
#import <QuickLookThumbnailing/QuickLookThumbnailing.h>
#import "DocumentManager.h"
#import "MyDoc.h"

//NSString *kEntryViewControllerID = @"EntryViewController";    // view controller storyboard id
NSString *kCellID = @"cellID";                          // UICollectionViewCell storyboard id
NSString *nameOfTechniqueforControllers;

#define TRANSFORM_CELL_VALUE CGAffineTransformMakeScale(0.8, 0.8)
#define ANIMATION_SPEED 0.2



#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

#define colorCombination1 [UIColor colorNamed:@"blue"];
#define colorCombination2 [UIColor colorNamed:@"blue"];
#define colorCombination3 [UIColor colorNamed:@"blue"];
#define colorCombination4 [UIColor colorNamed:@"blue"];
#define colorCombination5 [UIColor colorNamed:@"blue"];
#define colorCombination6 [UIColor colorNamed:@"blue"];




@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,UICollectionViewDelegateFlowLayout>
{

    UIActionSheet *actionSheet;
    UITapGestureRecognizer* tapRecognizer;
    NSMutableArray *arrayOfTechnique;
    sqlite3 *techniqueDB;
    NSString *dbPathString;
    NSMutableArray *imgName;
    NSInteger *lastAddedItem;
    NSMutableString *foothumb;
    NSMutableString *foothumb1;
    NSMutableString *foothumb2;
    NSMutableString *foothumb3;
    NSMutableString *foothumb4;
    NSMutableString *foothumb5;
    NSMutableString *foobig1;
    NSMutableString *foobig2;
    NSMutableString *foobig3;
    NSMutableString *foobig4;
    NSMutableString *foobig5;
    UILabel *current_technique;
    UIImage *imageForCell;
    NSString *myString;
    NSArray *cell_sysPaths;
    NSString *cell_docDirectory;
    NSString *cell_filePath;
    BOOL *tap;
    int i;
    NSString*tempstring;
    NSIndexPath*indexpathtemp;
    
    NSMutableString *rfoothumb;
    NSMutableString *rfoothumb1;
    NSMutableString *rfoothumb2;
    NSMutableString *rfoothumb3;
    NSMutableString *rfoothumb4;
    NSMutableString *rfoothumb5;
    NSMutableString *rfoobig1;
    NSMutableString *rfoobig2;
    NSMutableString *rfoobig3;
    NSMutableString *rfoobig4;
    NSMutableString *rfoobig5;
   
    
    NSMutableArray *fileObjectList;
    UIRefreshControl *refreshControl;
    
    
    
}

@end

@implementation ViewController
@synthesize techniqueToRename;
@synthesize fileNameList;
@synthesize dateList;
@synthesize datesDict;
BOOL isDeletionModeActive; // TO UNCOMMENT LATER


#pragma mark -didRecieveMemoryWarning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    tapRecognizer = nil;
}


#pragma mark - Load Methods

-(void)viewDidLoad
{
    [super viewDidLoad];
   
    filesArray = [NSMutableArray array];
    arrayOfFileDictionaries = [NSMutableArray array];
    dateList = [NSMutableArray array];
    datesDict = [NSMutableDictionary dictionary];

    [self updateFiles]; // get files in dir
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

//    if (appDelegate.fileImported){
//        [self performSelector:@selector(openEntry)];
//        appDelegate.fileImported = NO;
//    }
    
  /*  [[CKContainer defaultContainer] fetchUserRecordIDWithCompletionHandler:^(CKRecordID * _Nullable recordID, NSError * _Nullable error) {
        if (error) {
            [self showAlertWithMessage:@"To continue using the app, you need to enable iCloud Sync"];
           // NSLog(@"Error fetching user record ID: %@", error);
        } else {
            //[self startAnimating];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self iCloudSetup];
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
               //     [self stopAnimatingRefresh];
                });
            });
//           [self showAlertWithMessage:@"User is signed in to iCloud"];
            NSLog(@"User is signed in to iCloud");
        }
    }];*/
    
    
    [self setupLongPressGestures];
    self.view.backgroundColor = [UIColor colorNamed:@"grey"];
    //self.view.backgroundColor = [UIColor colorWithRed:250/250 green:250/250 blue:250/250 alpha:1];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = [UIColor colorNamed:@"navBar"];
        appearance.shadowColor =  [UIColor clearColor];
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorNamed:@"textWhiteDeepBlue"], NSFontAttributeName:[UIFont fontWithName:@"AvenirNext-Bold" size:18]};
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
        [self.navigationController prefersStatusBarHidden];
        
        
    }
    [self registerNotificationObservers];

    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.navigationItem.title = @"Collection";
    
    // Bottom Border
    //[super viewDidLoad];
    [self.sidemenuButton setAlpha:0];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MY_CELL"];
    
    [self.toolbar_view setClipsToBounds:YES];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
 
    [self setupNavigationBar];
    [self addNewTechniqueButton];

    self.isSelectionActivated = NO;
    
    i = 0;
    //tap = NO;

    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.collectionView removeGestureRecognizer:tapRecognizer];
    //[self reloadMyCollection];
//    [[NSNotificationCenter defaultCenter]
//         postNotificationName:@"stopAnimatingRefresh"
//         object:self];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //[self.collectionView  reloadData];
    longpresscell.enabled = YES;
    
//    // Present Welcome Screen
//    if ([self appIsRunningForFirstTime] == YES || [[iCloud sharedCloud] checkCloudAvailability] == NO || [[NSUserDefaults standardUserDefaults] boolForKey:@"userCloudPref"] == NO) {
//      //  [self performSegueWithIdentifier:@"showWelcome" sender:self];
//        return;
//    }
    
    /* --- Force iCloud Update ---
     This is done automatically when changes are made, but we want to make sure the view is always updated when presented
  
    [[iCloud sharedCloud] updateFiles];
     */
     
}



-(void)registerNotificationObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"showPop"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification2:)
                                                 name:@"hideAllBars"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification3:)
                                                 name:@"showDeletePop"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shareDiagram)
                                                 name:@"shareDiagram"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(insertExportedDataFromAppDelegate)
                                                 name:@"insertExportedDataFromAppDelegate"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startAnimating)
                                                 name:@"startAnimating"
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(stopAnimatingRefresh)
//                                                 name:@"stopAnimatingRefresh"
//                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(openEntry)
                                                 name:@"openEntry"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadMyCollection)
                                                 name:@"reloadCollection"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(populateAndReload)
                                                 name:@"populate"
                                               object:nil];
    
    
    // Register for the NSUbiquitousKeyValueStoreDidChangeExternallyNotification notification
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFavoriteCellsFromCloud:) name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:[NSUbiquitousKeyValueStore defaultStore]];
    
}

- (BOOL)appIsRunningForFirstTime {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        // App already launched
        return NO;
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // This is the first launch ever
        return YES;
    }
}


-(void)viewDidAppear:(BOOL)animated
{
    
    
    
    [super viewDidAppear:animated];
    
    if(filesArray.count == 0){
        [self removeOrangeLayer];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    [self.collectionView  reloadData];
    
    
    NSUserDefaults *sharedDefaults = [NSUserDefaults standardUserDefaults];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger countValue = [defaults integerForKey:@"Array"];
    
    if ([sharedDefaults boolForKey:@"FirstLaunch"])
    {
        [self saveFloatToUserDefaults:0.0 forKey:@"eraserPressed"];
        
       // [self openSubView:self];
        [self copyDemoDiagramFromBundle];
        [self copyEntryImageDiagramFromBundle];
        [self updateFiles];
        
        [sharedDefaults setBool:NO forKey:@"FirstLaunch"];
        [sharedDefaults synchronize];
        
        // [prefs synchronize];
    }	// Do any additional setup after loading the view.
    else if(countValue == 1)
    {
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ( ![userDefaults valueForKey:@"version"] )
    {
        [self saveFloatToUserDefaults:0.0 forKey:@"eraserPressed"];
        
        // Adding version number to NSUserDefaults for first version:
        [userDefaults setFloat:[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue] forKey:@"version"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] floatForKey:@"version"] == [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue] )
    {
        // Same Version so dont run the function
    }
    else
    {
        // Call Your Function;
        // Update version number to NSUserDefaults for other versions:
        [userDefaults setFloat:[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue] forKey:@"version"];
    }
    
    UIViewController* whatsNewController = [WhatsNewObjcWrapper getWhatsNewViewController];
    
    whatsNewController.modalInPresentation = YES;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // cheking if there is old version techniques
    FMDBDataAccess *db = [[FMDBDataAccess alloc] init];
    self.techniques = [db getCustomers];
    
    
    
    if([self appIsRunningForFirstTime]){
        [self.navigationController presentViewController:whatsNewController animated:true completion:^{
            
            [self copyDemoDiagramFromBundle];
            [self copyEntryImageDiagramFromBundle];
            [self updateFiles];
            
            if(self.techniques.count > 0){
                [self showCoachMark];
            }
            
        }];
    }
    
}

-(void)copyDemoDiagramFromBundle
{
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSString * filePath = [documentDir stringByAppendingPathComponent:@"Classic Bob Demo.htapp"];
    
    BOOL success;

    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:filePath];
    if(success) return;
    
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Classic Bob Demo.htapp"];
    
    NSError *err = nil;
    success = [fileManager copyItemAtPath:databasePathFromApp toPath:filePath error:&err];
}
-(void)copyEntryImageDiagramFromBundle
{
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSString * filePath = [documentDir stringByAppendingPathComponent:@"Classic Bob Demo.png"];
    
    BOOL success;

    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:filePath];
    if(success) return;
    
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Classic Bob Demo.png"];
    
    NSError *err = nil;
    success = [fileManager copyItemAtPath:databasePathFromApp toPath:filePath error:&err];
}

-(void)showCoachMark{
    
    
    UIView *leftBarButtonView = self.navigationItem.leftBarButtonItem.customView;
    CGRect frame = [leftBarButtonView convertRect:leftBarButtonView.bounds toView:self.view];
    CGPoint origin = frame.origin;
    
    CGFloat startY;
    CGFloat startX;
    CGFloat width;
    CGFloat height;
    CGPoint arrowHeadPoint;
    CGFloat lblStart;

    arrowHeadPoint = CGPointMake(origin.x + 65, origin.y + 22);

    
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
        startY = 1;
        startX = 15;
        width = 60;
        height = 60;
        lblStart = 70;
        
        
    }else {
        width = height = 60;
        startY = 48;
        startX = 6;
        lblStart = 0;
       // origin = CGPointMake(origin.x - 20, origin.y - 35);
    }

    
    // Setup coach marks
    NSArray *coachMarks = @[
        @{
            @"rect": [NSValue valueWithCGRect:(CGRect){{origin.x - 10,origin.y-10},{width,height}}],
            @"caption": @"Here, you can access diagrams from previous versions of Hairtechapp.",
            @"shape": @"circle"
        }
        ];
    
    WSCoachMarksView *coachMarksView = [[WSCoachMarksView alloc] initWithFrame:self.navigationController.view.bounds coachMarks:coachMarks startPoint:arrowHeadPoint labelStrt:lblStart];
    [self.navigationController.view addSubview:coachMarksView];
    [coachMarksView start];
}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:okAction];
    
    // Present the alert on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}


-(void)updateFiles{
    filesArray = [DocumentManager getArrayOfFilesInDirectory];
    [datesDict removeAllObjects]; // remove all objects before storing new objects in dict
  
    int i = 0;
    for(NSString * name in filesArray){
        NSDate *updated = [self getMetadata:name];
        [datesDict setValue:updated forKey:name];  // store dates in coresponding key (fileNames)
        i++;
    }
    
    if(filesArray.count == 0){
        [self removeOrangeLayer];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    [self.collectionView reloadData];
}

#pragma mark - Configure Methods

-(void) saveFloatToUserDefaults:(float)x forKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:x forKey:key];
    [userDefaults synchronize];
}

-(void)openInfoController{
    
   TODetailTableViewController  * viewController = [self.storyboard  instantiateViewControllerWithIdentifier:@"tableView"];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)addNewTechniqueButton {
    self.addHeadsheet = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addHeadsheet addTarget:self
               action:@selector(openSubView:)
     forControlEvents:UIControlEventTouchUpInside];
    self.addHeadsheet.backgroundColor = [UIColor clearColor];
    self.addHeadsheet.adjustsImageWhenHighlighted = NO;
    UIImage *img = [UIImage imageNamed:@"addnewtech.png"];
    [self.addHeadsheet setImage:img forState:UIControlStateNormal];
    [self.addHeadsheet setImage:[UIImage imageNamed:@"addnewtech.png"] forState:UIControlStateHighlighted];
   // [button setBackgroundColor:[UIColor whiteColor]];
    self.addHeadsheet.frame = CGRectMake(self.view.frame.origin.x + self.view.frame.size.width/2 - 25,
                              self.view.frame.origin.y + self.view.frame.size.height - 100, 50 , 50);
    self.addHeadsheet.layer.masksToBounds = YES;
    self.addHeadsheet.layer.cornerRadius = self.addHeadsheet.frame.size.height / 2;
    [self.view addSubview:self.addHeadsheet];
}

- (void)setupNavigationBar{
    
    [self setupInfoButton:@"info_b.png" selector:@"openInfoController"];
    [self setupRightNavigationItem:@"Select" selector:@"selectionActivated"];
}




#pragma mark - iCloud Methods



/*
-(void)iCloudSetup{
    
    
    [[iCloud sharedCloud] setDelegate:self]; // Set this if you plan to use the delegate
    [[iCloud sharedCloud] setVerboseLogging:YES]; // We want detailed feedback about what's going on with iCloud, this is OFF by default
    [[iCloud sharedCloud] setupiCloudDocumentSyncWithUbiquityContainer:nil]; // You must call this setup method before performing any document operations
    
    // Setup File List
    if (fileNameList == nil) fileNameList = [NSMutableArray array];
    if (fileObjectList == nil) fileObjectList = [NSMutableArray array];
    
    // Display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Create refresh control
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (refreshControl == nil) refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refreshCloudList) forControlEvents:UIControlEventValueChanged];
        [self.collectionView addSubview:refreshControl];
    });
    
    // Subscribe to iCloud Ready Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCloudListAfterSetup) name:@"iCloud Ready" object:nil];
    
}

- (void)iCloudDidFinishInitializingWitUbiquityToken:(id)cloudToken withUbiquityContainer:(NSURL *)ubiquityContainer {
    NSLog(@"Ubiquity container initialized. You may proceed to perform document operations.");
}

- (void)iCloudAvailabilityDidChangeToState:(BOOL)cloudIsAvailable withUbiquityToken:(id)ubiquityToken withUbiquityContainer:(NSURL *)ubiquityContainer {
    if (!cloudIsAvailable) {
       
        [self showAlertWithMessage:@"iCloud is no longer available. Make sure that you are signed into a valid iCloud account."];

        //[self performSegueWithIdentifier:@"showWelcome" sender:self];
    }
}
-(void)iCloudFileUpdateDidBegin{
    NSLog(@"iCloudFileUpdateDidBegin");
   // [self startAnimating];
}

- (void)iCloudFilesDidChange:(NSMutableArray *)files withNewFileNames:(NSMutableArray *)fileNames {
    
    
    // Get the query results
 
    fileNameList = fileNames; // A list of the file names
    fileObjectList = files; // A list of NSMetadata objects with detailed metadata
    [datesDict removeAllObjects]; // remove all objects before storing new objects in dict

    // store dates in coresponding key (fileNames)
    int i = 0;
    for(NSString * name in fileNameList){
        NSDate *updated = [[iCloud sharedCloud] fileModifiedDate:name];
        [datesDict setValue:updated forKey:name];
        i++;
    }

    [refreshControl endRefreshing];
    
    NSString * key =  [[NSUserDefaults standardUserDefaults] objectForKey:@"order"];
    [self sortCollectionView:key];
    
      NSLog(@"iCloudFilesDidChange");
}
- (void)iCloudFileUpdateDidEnd{
    NSLog(@"iCloudFilesDidEnd");
}


- (void)refreshCloudList {
    
    [[iCloud sharedCloud] updateFiles];
    
}

- (void)refreshCloudListAfterSetup {
    // Reclaim delegate and then update files
    [[iCloud sharedCloud] setDelegate:self];
    [[iCloud sharedCloud] updateFiles];
}

-(void)sortCollection{
    NSLog(@"sort collection from icloud");
       NSString * key =  [[NSUserDefaults standardUserDefaults] objectForKey:@"order"];
        [self sortCollectionView:key];
}

- (void)loadFavoriteCellsFromCloud:(NSNotification *)notification {
    NSLog(@"load favorites");
    NSUbiquitousKeyValueStore *ubiquitousKeyValueStore = [NSUbiquitousKeyValueStore defaultStore];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *userInfo = notification.userInfo;
    NSNumber *changeReason = userInfo[NSUbiquitousKeyValueStoreChangeReasonKey];

    if (changeReason) {
        if ([changeReason intValue] == NSUbiquitousKeyValueStoreServerChange || [changeReason intValue] == NSUbiquitousKeyValueStoreInitialSyncChange) {
            for(NSString * fileName in fileNameList){
                 iCloud data has changed, retrieve the new data using objectForKey:
                NSString * value = [ubiquitousKeyValueStore objectForKey:fileName];
                [defaults setObject:value forKey:fileName];
            }
        }
    }
    [defaults synchronize];
}

-(void)startAnimating{
    NSLog(@"animate refresh ....");

  //  [CustomActivityIndicator.shared show:self.view];
    
  //  self.view.userInteractionEnabled = false;
//    [CustomActivityIndicator.shared show:self.view backgroundColor:UIColor.darkGrayColor size:35.0 duration:1.0];
    
//    [CustomActivityIndicator.shared show:self.view backgroundColor:UIColor.darkGrayColor textColor:UIColor.whiteColor labelText:@"Updating data" duration:2.0];
}

-(void)stopAnimatingRefresh{
   // self.view.userInteractionEnabled = true;
    NSLog(@"animate stop ....");
   // [CustomActivityIndicator.shared hide:self.view duration:1.0];

}

*/

#pragma mark - Add New Technique

//-(void)MySubViewController:(MySubView *) controller didAddCustomer:(Technique *) technique
//{
//    [self.collectionView reloadData];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//-(void)populateAndReload{
//    [self.collectionView reloadData];
//}


-(void)openEntry
{
    [self updateFiles];

    // Create and show the activity indicator
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    activityIndicator.center = self.view.center;
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];

//        // Create a delay of 2 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // Remove the activity indicator after the delay
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];

            
    _fileNameForOpenEntry  =  [[NSUserDefaults standardUserDefaults] objectForKey:@"newCreatedFileName"];
       
        [MyDoc documentNamed:_fileNameForOpenEntry withCompletion:^(MyDoc * _Nonnull doc) {
            

            NewEntryController *newEntryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewEntryController"];
            NSString * techniqueName = [_fileNameForOpenEntry stringByDeletingPathExtension];
            newEntryVC.document = doc;
            newEntryVC.navigationItem.title = techniqueName;
            [self.navigationController pushViewController:newEntryVC animated:true];
            // stop spinner
        }];
        
        
            
    /*
    [[iCloud sharedCloud] retrieveCloudDocumentWithName:_fileNameForOpenEntry completion:^(iCloudDocument *cloudDocument, NSData *documentData, NSError *error) {

    NewEntryController *newEntryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewEntryController"];
        
    fileTitle = cloudDocument.fileURL.lastPathComponent;
            
    //Extracting extension from filename to get technique name
    NSString * techniqueName = [[fileTitle lastPathComponent] stringByDeletingPathExtension];
    newEntryVC.navigationItem.title = techniqueName;
    newEntryVC.document = [[iCloud sharedCloud] getDocument];
    newEntryVC.openedFromDrawingView = NO;
    [newEntryVC setTechniqueID:techniqueName];
    [newEntryVC setTechniqueID: techniqueName];
    [HapticHelper generateFeedback:FeedbackType_Impact_Light];

    [self.navigationController pushViewController: newEntryVC animated:YES];

    }];*/
        });
     
}


#pragma mark - Collection View methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize  newsize;
    newsize = CGSizeMake(CGRectGetWidth(self.view.frame), (CGRectGetHeight(self.view.frame)));
    if ( UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad){
//        newsize.width = 246;
//        newsize.height = 380;
       newsize.width = 240;
       newsize.height = 345;
        return newsize;
   }
   else
   {
//        newsize.width = ((self.view.frame.size.width / 100) * 80);
//        newsize.height = ((self.view.frame.size.height / 100) * 68);
       newsize.width = self.view.frame.size.width / 2.18 ;
       newsize.height = newsize.width *  1.84;
       
        return newsize;
    }
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
//    if(arrayOfTechnique.count==0)
//    {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setInteger:0 forKey:@"Array"];
//        [defaults synchronize];
//    }
//    else
//    {
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setInteger:1 forKey:@"Array"];
//        [defaults synchronize];
//    }
    
   // return [fileNameList count];
    return filesArray.count;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        self.reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
//        NSString *title = [[NSString alloc]initWithFormat:@"Recipe Group #%i", indexPath.section + 1];
//        headerView.title.text = title;
//        UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
        //headerView.backgroundImage.image = headerImage;
        self.reusableView.delegate = self;

        reusableview = self.reusableView;
    }
 
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
 
        reusableview = footerview;
    }
        
    return reusableview;
}

/*- (UIImage *)iconForFile:(NSString *)documentName {
    UIDocumentInteractionController *controller = [UIDocumentInteractionController interactionControllerWithURL:[[[iCloud sharedCloud] ubiquitousDocumentsDirectoryURL] URLByAppendingPathComponent:documentName]];
    
//    CGSize size;
//    size.width = 200;
//    size.height = 300;
//    
//    NSURL * url = [[[iCloud sharedCloud] ubiquitousDocumentsDirectoryURL] URLByAppendingPathComponent:documentName];
//    
//    
//    QLThumbnailGenerationRequest *request = [[QLThumbnailGenerationRequest alloc] initWithFileAtURL:url size:size scale:3 representationTypes:QLThumbnailGenerationRequestRepresentationTypeIcon];
//    
//    
    
    
    if (controller) {
        return [controller.icons lastObject]; // arbitrary selection--gives you the largest icon in this case
        
        
    }
    
    return nil;
}
*/


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"cellForItemAtIndexPath");
    
    
    
    
    if(filesArray.count == 0){
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    if(self.isSelectionActivated)
    {
        [cell.favorite setHidden:YES];

        [cell setIsCheckHidden:NO];
    }
    else {
        [cell.favorite setHidden:NO];

        [cell setIsCheckHidden:YES];
    }
    
    [cell hideBar];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell.contentView.layer setCornerRadius:15.0f];
        cell.clipsToBounds = YES;
        cell.contentView.layer.masksToBounds = YES;
        cell.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0,0);
        cell.layer.shadowRadius = 3.0f;
        cell.layer.shadowOpacity = 0.1f;
        cell.layer.masksToBounds = NO;

    NSString *fileName = [filesArray objectAtIndex:indexPath.row];
      
   /* __block NSString *documentStateString = @"";
    [[iCloud sharedCloud] documentStateForFile:fileName completion:^(UIDocumentState *documentState, NSString *userReadableDocumentState, NSError *error) {
        if (!error) {
            documentStateString = userReadableDocumentState;
        }
    }];

    NSDate * updated = [datesDict valueForKey:fileName];
    
    NSString *fileDetail = [NSString stringWithFormat:@"%@", [MHPrettyDate prettyDateFromDate:updated withFormat:MHPrettyDateFormatNoTime]];
    
    */
    NSDate * updated = [datesDict valueForKey:fileName];
    NSString *fileDetail = [NSString stringWithFormat:@"%@", [MHPrettyDate prettyDateFromDate:updated withFormat:MHPrettyDateFormatNoTime]];

    // Configure the cell...
    cell.dateLabel.text = [[fileName lastPathComponent] stringByDeletingPathExtension];
    
//   [self loadImageWithURL:fileName completion:^(UIImage *image) {
//        cell.image.image = image;
//
//    }];
    NSLog(@"filename %@", fileName);
    cell.image.image = [self iconForFile:fileName];
    
    cell.viewModeLabel.text = fileDetail;
    
    
   // Configure favorite cells
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults objectForKey:fileName] isEqualToString:@"favorite"]){
    
        cell.isFavorite = YES;
        [cell.favorite setImage:[UIImage imageNamed:@"star.fill"]];
    }else {
        cell.isFavorite = NO;
        [cell.favorite setImage:[UIImage imageNamed:@"star.tr"]];
    }
    
    


        CGSize  newsize;
        newsize = CGSizeMake(CGRectGetWidth(cell.frame), (CGRectGetHeight(cell.frame)));
        CGRect screenRect = [[UIScreen mainScreen] bounds];

    [self addGestureRecognizersToCell:cell];
    cell.newVersionDiagram = YES;
    cell.image.frame = CGRectMake(0, -15, cell.frame.size.width , cell.frame.size.height);
    
    if ([cv.indexPathsForSelectedItems containsObject:indexPath]) {
        [cv selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        // Select Cell
        [self selectCell:cell];
        indexOfSelectedCell = indexPath;
        [self setupRightNavigationItem:@"Cancel" selector:@"removeOrangeLayer"];
        [self setupInfoButton:@"trash_edited" selector:@"showConfirmationPopOver"];
        
    }
    else {
        // Set cell to non-highlight
        [self selectCell:cell];
        
    }
    

    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    Cell *cell = (Cell *)[collectionView  cellForItemAtIndexPath:indexPath];

    
    if(!self.isSelectionActivated){
        
        NSString * name = [filesArray objectAtIndex:indexPath.row];
        
        [MyDoc documentNamed:name withCompletion:^(MyDoc * _Nonnull doc) {
            

            NewEntryController *newEntryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewEntryController"];
            NSString * techniqueName = [name stringByDeletingPathExtension];
            newEntryVC.document = doc;
            newEntryVC.navigationItem.title = techniqueName;
            [self.navigationController pushViewController:newEntryVC animated:true];
            // stop spinner
        }];
        
        
        
        
        
 
/*
        [[iCloud sharedCloud] retrieveCloudDocumentWithName:[fileNameList objectAtIndex:indexPath.row] completion:^(iCloudDocument *cloudDocument, NSData *documentData, NSError *error) {
            
            if (!error) {
                fileText = [[NSString alloc] initWithData:documentData encoding:NSUTF8StringEncoding];
                fileTitle = cloudDocument.fileURL.lastPathComponent;
                
                [[iCloud sharedCloud] documentStateForFile:fileTitle completion:^(UIDocumentState *documentState, NSString *userReadableDocumentState, NSError *error) {
                    if (!error) {
                        if (*documentState == UIDocumentStateInConflict) {
                           
                        } else {
                        NewEntryController *newEntryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewEntryController"];
                            [[iCloud sharedCloud] setDocument:cloudDocument];
                            
                        fileTitle = cloudDocument.fileURL.lastPathComponent;
                                
                        //Extracting extension from filename to get technique name
                        NSString * techniqueName = [[fileTitle lastPathComponent] stringByDeletingPathExtension];
                        newEntryVC.navigationItem.title = techniqueName;
                            
                        newEntryVC.document = cloudDocument;
                        newEntryVC.openedFromDrawingView = NO;
                        [newEntryVC setTechniqueID:techniqueName];
                        [newEntryVC setTechniqueID: techniqueName];
                        [HapticHelper generateFeedback:FeedbackType_Impact_Light];
                        [self.navigationController pushViewController: newEntryVC animated:YES];

                        }
                    } else {
                        NSLog(@"Error retrieveing document state: %@", error);
                    }
                }];
            } else {
                NSLog(@"Error retrieveing document: %@", error);
            }
            
            
        }];*/
    }
    else{
        [self selectCell:cell];
        indexOfSelectedCell = indexPath;
        [self setupRightNavigationItem:@"Cancel" selector:@"removeOrangeLayer"];
        [HapticHelper generateFeedback:FeedbackType_Impact_Light];
    }
}


 -(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
     Cell * cell = (Cell *)[collectionView cellForItemAtIndexPath:indexPath];
     [self selectCell:cell];
}

- (void)userDidSwipe:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture Swipe Handled");
    }
}


typedef void(^ImageCompletion)(UIImage *image);

- (void)loadImageWithURL:(NSString *)name completion:(ImageCompletion)completion {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *cloudURL = [appDelegate applicationCloudFolder:name];
        NSData *data = [NSData dataWithContentsOfURL:cloudURL];
        
        NSError* err;
        NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:&err];
        unarchiver.requiresSecureCoding = NO;
        UIImage * image = [UIImage imageWithData:[unarchiver decodeObjectForKey:@"imageEntry"]];
        [unarchiver finishDecoding];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            completion(image);
        });
        
    });
}

-(NSDate*)getMetadata:(NSString*)filename{
    NSURL *filePath = [[DocumentManager documentDirectory] URLByAppendingPathComponent:filename];
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[filePath path] error:nil];
    NSDate *modificationDate = [fileAttributes objectForKey:NSFileModificationDate];
    
//    NSString *fileDetail = [NSString stringWithFormat:@"%@", [MHPrettyDate prettyDateFromDate:modificationDate withFormat:MHPrettyDateFormatNoTime]];
    return modificationDate;
}

- (UIImage *)iconForFile:(NSString *)documentName {
//    UIDocumentInteractionController *controller = [UIDocumentInteractionController interactionControllerWithURL:[[[iCloud sharedCloud] ubiquitousDocumentsDirectoryURL] URLByAppendingPathComponent:documentName]];
//    if (controller) {
//        return [controller.icons lastObject]; // arbitrary selection--gives you the largest icon in this case
//    }
//
//    return nil;
    documentName = [documentName stringByDeletingPathExtension];
    documentName = [documentName stringByAppendingString:@".png"];
    NSURL * fileURL = [[DocumentManager  documentDirectory] URLByAppendingPathComponent:documentName];
    // Load the image from the file URL
    UIImage *image = [UIImage imageWithContentsOfFile:fileURL.path];
    
    if (image) {
        // Do something with the image
        return image;

    }
    
    return nil;
    
}

#pragma mark - Cell Selection Methods

- (void)setupLongPressGestures{
     longpresscell = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressCell:)];
    longpresscell.minimumPressDuration = 0.3;
    [self.collectionView addGestureRecognizer:longpresscell];
}

- (void)pressCell:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan){
        return;
    }
        CGPoint p = [gestureRecognizer locationInView:self.collectionView];
        NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:p];
        indexOfSelectedCell = indexPath;
        
        if(indexPath == nil){
            NSLog(@"couldn't find index");
        }else {
            Cell * cell = (Cell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            longpresscell.enabled = NO;
            
            [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            [self selectCell:cell];
            indexOfSelectedCell = indexPath;
            [self selectionActivatedFromLongPress];
            
        }
}

-(void)selectionActivated{
    self.isSelectionActivated = YES;
    [self setupRightNavigationItem:@"Cancel" selector:@"removeOrangeLayer"];
    self.navigationItem.leftBarButtonItem = nil;
    self.addHeadsheet.hidden = YES;
    [HapticHelper generateFeedback:FeedbackType_Impact_Light];
    [self.collectionView reloadData];
}

-(void)selectionActivatedFromLongPress{
    self.isSelectionActivated = YES;
    self.addHeadsheet.hidden = YES;
    [self setupRightNavigationItem:@"Cancel" selector:@"removeOrangeLayer"];
    //[self setupInfoButton:@"trash_edited" selector:@"showConfirmationPopOver"];
    self.navigationItem.leftBarButtonItem = nil;

    for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:0]; row++) {
        Cell * cell =   (Cell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        [cell setIsCheckHidden:NO];
        [cell.favorite setHidden:YES];
    }
    [HapticHelper generateFeedback:FeedbackType_Impact_Light];
}

-(void)setupRightNavigationItem:(NSString*)btnTitle selector:(NSString*)method{
    SEL selectorNew = NSSelectorFromString(method);

    UIBarButtonItem *sortBtn = [[UIBarButtonItem alloc]initWithTitle:btnTitle style:UIBarButtonItemStylePlain target:self action:selectorNew];
    NSDictionary * barButtonApperance = @{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0], NSForegroundColorAttributeName: [UIColor colorNamed:@"textWhiteDeepBlue"]};
    [sortBtn setTitleTextAttributes:barButtonApperance forState:UIControlStateNormal];
    [sortBtn setTitleTextAttributes:barButtonApperance forState:UIControlStateHighlighted];
    [sortBtn setTitleTextAttributes:barButtonApperance forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = sortBtn;
}

-(void)setupInfoButton:(NSString*)imgName selector:(NSString*)method{
    SEL selectorNew = NSSelectorFromString(method);

    UIButton *leftCustomButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftCustomButton addTarget:self
                         action:selectorNew
               forControlEvents:UIControlEventTouchUpInside];
    [leftCustomButton.widthAnchor constraintEqualToConstant:40].active = YES;
    [leftCustomButton.heightAnchor constraintEqualToConstant:40].active = YES;
    [leftCustomButton setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    
    UIBarButtonItem *rename = [[UIBarButtonItem alloc]initWithTitle:@"Rename" style:UIBarButtonItemStylePlain target:self action:@selector(renameTechnique)];
    NSDictionary * barButtonApperance = @{NSFontAttributeName : [UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0], NSForegroundColorAttributeName: [UIColor colorNamed:@"textWhiteDeepBlue"]};
    [rename setTitleTextAttributes:barButtonApperance forState:UIControlStateNormal];
    [rename setTitleTextAttributes:barButtonApperance forState:UIControlStateHighlighted];
    [rename setTitleTextAttributes:barButtonApperance forState:UIControlStateSelected];
    UIBarButtonItem * leftButtonItem =[[UIBarButtonItem alloc] initWithCustomView:leftCustomButton];

    if([method isEqualToString:@"showConfirmationPopOver"]){
        self.navigationItem.leftBarButtonItems = @[leftButtonItem, rename];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
    else {

        self.navigationItem.leftBarButtonItems = @[leftButtonItem];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    }
   
}

-(void)renameTechnique{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"showPop"
     object:self];
}

-(void)removeOrangeLayer{
    self.addHeadsheet.hidden = NO;
    self.navigationItem.rightBarButtonItems = nil;
    [self setupInfoButton:@"info_b.png" selector:@"openInfoController"];
    self.isSelectionActivated = NO;
    [self cancelCellSelection];
    [self setupRightNavigationItem:@"Select" selector:@"selectionActivated"];
}

-(void)renamePressed:(UITapGestureRecognizer *)gestureRecognizer{
    
    CGPoint tapPoint = [gestureRecognizer locationInView:self.collectionView];
    indexOfSelectedCell = [self.collectionView indexPathForItemAtPoint:tapPoint];
    Cell * cell = (Cell*)[self.collectionView cellForItemAtIndexPath:indexOfSelectedCell];
    techniqueToRename = cell.dateLabel.text;

    if(!self.isSelectionActivated){
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"showPop"
         object:self];
    }
}

-(void)deletePressed:(UITapGestureRecognizer *)gestureRecognizer{
    CGPoint tapPoint = [gestureRecognizer locationInView:self.collectionView];
    indexOfSelectedCell = [self.collectionView indexPathForItemAtPoint:tapPoint];
    Cell * cell = (Cell*)[self.collectionView cellForItemAtIndexPath:indexOfSelectedCell];
    
    NSMutableString * filePath = [cell.dateLabel.text mutableCopy];
    [filePath appendString:@".htapp"];
//    if(!self.isSelectionActivated){
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"showDeletePop"
         object:self];
  //  }
}
-(void)heartPressed:(UITapGestureRecognizer *)gestureRecognizer{
    
    CGPoint tapPoint = [gestureRecognizer locationInView:self.collectionView];
    indexOfFavoriteCell = [self.collectionView indexPathForItemAtPoint:tapPoint];
    Cell * cell = (Cell*)[self.collectionView cellForItemAtIndexPath:indexOfFavoriteCell];
   
    NSMutableString * filePath = [cell.dateLabel.text mutableCopy];
    [filePath appendString:@".htapp"];

//    NSError * outError;
//    NSData * data = [[iCloud sharedCloud] docData:filePath];
//    NSMutableDictionary * dictionary = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:&outError];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSUbiquitousKeyValueStore *cloudStore = [NSUbiquitousKeyValueStore defaultStore];
    
    if(cell.isFavorite){
        [defaults setObject:@"default" forKey:filePath];
        [cloudStore setObject:@"default" forKey:filePath];

        [cell.favorite setImage:[UIImage imageNamed:@"star.tr"]];
    }else {
        [defaults setObject:@"favorite" forKey:filePath];
        [cloudStore setObject:@"favorite" forKey:filePath];
        [cell.favorite setImage:[UIImage imageNamed:@"star.fill"]];
    }
    
    [defaults synchronize];
    [cloudStore synchronize];

   // NSData * newData = [NSKeyedArchiver archivedDataWithRootObject:dictionary requiringSecureCoding:NO error:&outError];
        
    //[self saveDataToCloudWhenFavoritePressed:newData fileName:filePath];
  //  [self reloadMyCollection];
    
    NSArray * itemsArray = [NSArray arrayWithObjects:indexOfFavoriteCell, nil];
    [self.collectionView reloadItemsAtIndexPaths:itemsArray];
    
//    NSLog(@" object for key %@", [cloudStore objectForKey:@"Alex.htapp"]);

}



-(void)selectCell:(Cell*)cell {

        if (cell.selected){
            [cell setIsHidden:NO];
            cell.checker.hidden = NO;
            cell.cell_menu_btn.hidden = NO;
            cell.cell_rename_btn.hidden = NO;
            
            if(cell.newVersionDiagram == YES){
                cell.shareBtn.hidden = NO;
            }

        }else {
            [cell setIsHidden:YES];
            cell.checker.hidden = YES;
            cell.cell_menu_btn.hidden = YES;
            cell.cell_rename_btn.hidden = YES;
            cell.shareBtn.hidden = YES;

        }

}
-(void)cancelCellSelection{

    for (NSIndexPath *indexPath in [self.collectionView indexPathsForSelectedItems]) {
        [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
        Cell * cell = (Cell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [cell setIsHidden:YES];
        longpresscell.enabled = YES;
        [cell.favorite setHidden:NO];
    }
        for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:0]; row++) {
            Cell * cell2 =   (Cell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
            
            cell2.checkItem.hidden = YES;
            cell2.checker.hidden = YES;
            cell2.cell_menu_btn.hidden = YES;
            cell2.cell_rename_btn.hidden = YES;
            cell2.shareBtn.hidden = YES;

            longpresscell.enabled = YES;
            [cell2.favorite setHidden:NO];
    }
}




#pragma mark - Sharing Methods
-(void)shareDiagram{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

   // NSString *exportingFileName = [fileNameList objectAtIndex:[indexOfSelectedCell row]]; //iCloud
     NSString *exportingFileName = [filesArray objectAtIndex:[indexOfSelectedCell row]]; //Local

    
    Cell * cell = (Cell*)[self.collectionView cellForItemAtIndexPath:indexOfSelectedCell];
    
    NSURL *cloudURL = [[DocumentManager documentDirectory] URLByAppendingPathComponent:exportingFileName];


//    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
//    NSString *docDirectory = [sysPaths objectAtIndex:0];
//    NSString *filePath = [docDirectory stringByAppendingPathComponent:exportingFileName];
//    NSURL * cloudURL = [NSURL fileURLWithPath:filePath];
    
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems: @[cloudURL] applicationActivities:nil];
    
    activityViewController.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:activityViewController animated: YES completion: nil];
    UIPopoverPresentationController * popoverPresentationController = activityViewController.popoverPresentationController;
    popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popoverPresentationController.sourceView = self.view;
    popoverPresentationController.sourceRect = CGRectMake(cell.center.x, cell.center.y, 10, 1);
    

//    if(activityViewController.popoverPresentationController){
//        activityViewController.popoverPresentationController.sourceView = self.view;
//    }
//    [self presentViewController:activityViewController animated: YES completion: nil];
}


-(void)addDefaultValueForFavoriteCell:(NSString*)fileName{
    NSUserDefaults * defualts = [NSUserDefaults standardUserDefaults];
        [defualts setObject:@"default" forKey:fileName];
        [defualts synchronize];
    
    NSUbiquitousKeyValueStore *cloudStore = [NSUbiquitousKeyValueStore defaultStore];
    [cloudStore setObject:@"default" forKey:fileName];
    [cloudStore synchronize];
}

-(NSArray*)getArrayOfFilesInCloudForImport:(NSURL*)url{
    NSArray * dirContents =
    [[NSFileManager defaultManager] contentsOfDirectoryAtURL:url
                                  includingPropertiesForKeys:@[]
                                                     options:NSDirectoryEnumerationSkipsHiddenFiles
                                                       error:nil];
    
    NSLog(@"dir array count %lu", dirContents.count);
    for(NSString * name in dirContents){
        NSLog(@"dir array name %@", name);
        
    }
    return dirContents;
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

 
-(NSString*)currentDateFromFilePath:(NSString*)path{
    NSString * deviceLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSDictionary* fileAttribs = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    NSDate *date = [fileAttribs objectForKey:NSFileCreationDate]; //or NSFileModificationDate
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:deviceLanguage];
    [df setLocale:locale];

    [df setDateStyle:NSDateFormatterMediumStyle]; // day, Full month and year
    [df setTimeStyle:NSDateFormatterNoStyle];  // nothing
    NSString *dateString = [df stringFromDate:date];
    return dateString;
}
-(NSString*)currentDate{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterMediumStyle]; // day, Full month and year
    [df setTimeStyle:NSDateFormatterNoStyle];  // nothing
    NSString *dateString = [df stringFromDate:date];
    return dateString;
}
#pragma mark - File Opening Methods
//
//-(void)getArrayOfFilesInDirectory{
//
//
//
//    NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
//    NSString *filePath = ubiq.absoluteString;
//
//       if (ubiq) {
//           NSLog(@"AppDelegate: iCloud access done! ");
//           [self getArrayOfFilesInCloud:[self ubiquitousDocumentsDirectoryURL]];
//
//       } else {
//           NSLog(@"AppDelegate: No iCloud access (either you are using simulator or, if you are on your phone, you should check settings");
//       }
//
//}

-(void)getArrayOfFilesInCloud:(NSURL*)url{
    NSLog(@"get array of CLOUD");
    NSArray * dirs =
          [[NSFileManager defaultManager] contentsOfDirectoryAtURL:url
            includingPropertiesForKeys:@[]
                               options:NSDirectoryEnumerationSkipsHiddenFiles
                                 error:nil];
    
    [fileNameList removeAllObjects];
    
    
    [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *filename = (NSString *)obj;
        NSString *extension = [[filename pathExtension] lowercaseString];

        if ([extension isEqualToString:@"htapp"]) {
            [fileNameList addObject:[filename lastPathComponent]];
            
        }
    }];
   
}

-(NSMutableDictionary*)getDataFromFile:(NSData*)documentData{
    
    return [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:documentData error:nil];
}

#pragma mark - Sorting methods

-(void)sortCollectionView:(NSString*)key{

    [self sortCollectionViewFromSegments:key];
    [self.collectionView reloadData];
    
}

-(void)sortCollectionViewFromSegments:(NSString*)key{
    
    NSMutableArray * sortedArray;
    sortedArray = [self sortArrayByNameWithKey:key andArray:filesArray];
    filesArray = sortedArray;
    
}

-(NSMutableArray *)sortArrayByNameWithKey:(NSString *)sortingKey andArray:(NSMutableArray *)unsortedArray{
    
    NSMutableArray * sortedArray;
    
    if( [sortingKey isEqualToString:@"techniqueName"]){
            sortedArray = [[unsortedArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] mutableCopy];

    }
    if ([sortingKey isEqualToString:@"creationDate"]){
      //  if(dateList.count == unsortedArray.count){
            
  
          
//            // and sosrt by date
//            [unsortedArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//                NSUInteger index1 = [unsortedArray indexOfObject:obj1];
//                NSUInteger index2 = [unsortedArray indexOfObject:obj2];
//                NSDate *date1 = [sortedDates objectAtIndex:index1];
//                NSDate *date2 = [sortedDates objectAtIndex:index2];
//                return [date1 compare:date2];
//            }];
            
            
            [unsortedArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                
                NSString *firstObject = (NSString *)obj1;
                NSString *secondObject = (NSString *)obj2;
                
                NSDate *  firstObjectIsFavorite = [datesDict objectForKey:firstObject];
                NSDate *  secondObjectIsFavorite = [datesDict objectForKey:secondObject];
                return [secondObjectIsFavorite compare:firstObjectIsFavorite];
             
            }];
            
     
         sortedArray = unsortedArray;
        
    }
    
    if ([sortingKey isEqualToString:@"favorite"]){
            
            [unsortedArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];            
                NSString *firstObject = (NSString *)obj1;
                NSString *secondObject = (NSString *)obj2;
                
                NSString *  firstObjectIsFavorite = [[defaults objectForKey:firstObject] stringValue];
                NSString *  secondObjectIsFavorite = [[defaults objectForKey:secondObject] stringValue];
                
                if ([firstObjectIsFavorite isEqualToString:secondObjectIsFavorite]) {
                    return [firstObject compare:secondObject];
                } else if ([firstObjectIsFavorite isEqualToString:@"favorite"]) {
                    return NSOrderedAscending;
                } else {
                    return NSOrderedDescending;
                }
            }];
            
            sortedArray = unsortedArray;
        
    }
    
    return sortedArray.mutableCopy;
}


#pragma mark - OPEN FILES

-(NSMutableDictionary*)openFileAtPath:(NSString*)fileName error:(NSError **)outError {

    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [docDirectory stringByAppendingPathComponent:fileName];
    NSLog(@"dir %@",docDirectory );
    
    NSURL * url = [NSURL fileURLWithPath:filePath];
    NSData *data = [NSData dataWithContentsOfURL:url];

    NSMutableDictionary * tempDict = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:outError];
    
    return tempDict;
}


-(NSMutableDictionary*)openFileAtURL:(NSString*)fileName error:(NSError **)outError {
        
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSURL *cloudURL = [appDelegate applicationCloudFolder:fileName];
    NSData *data = [NSData dataWithContentsOfURL:cloudURL];

    NSError* err;
    NSKeyedUnarchiver* unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:&err];
    NSMutableDictionary* tempDict = [unarchiver decodeObjectOfClasses:[[NSSet alloc] initWithArray:@[[NSMutableDictionary class],[NSString class], [NSData class]]] forKey:NSKeyedArchiveRootObjectKey];

  
    
//    NSMutableDictionary * tempDict = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:outError];
//
    return tempDict;
}


- (void)addGestureRecognizersToCell:(Cell *)cell {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(renamePressed:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    
    UITapGestureRecognizer *tapFavorite = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(heartPressed:)];
    
    UITapGestureRecognizer *deleteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deletePressed:)];
    deleteTap.numberOfTapsRequired = 1;
    tapFavorite.numberOfTapsRequired = 1;
    [cell.cell_menu_btn addGestureRecognizer:deleteTap];
    [cell.favorite addGestureRecognizer:tapFavorite];
    [cell.dateLabel addGestureRecognizer:tapGestureRecognizer];
    cell.dateLabel.userInteractionEnabled = YES;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"subView"])
            {
                [self openSubView];
            }
    }

-(void)openSubView:(id)sender
    {
 
        [HapticHelper generateFeedback:FeedbackType_Impact_Light];
        MySubView *mysubview  = [self.storyboard instantiateViewControllerWithIdentifier:@"subView"];
        //mysubview.delegate = self;
        NameViewController *nameView  = [self.storyboard instantiateViewControllerWithIdentifier:@"NameViewController"];
        nameView.fileNameList = filesArray;
        nameView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        nameView.modalPresentationStyle = UIModalPresentationFullScreen;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:nameView];
        [self presentViewController:nc animated:YES completion:nil];

    }
//#pragma mark - passItemBack Method
//
//-(void) passItemBack:(MySubView *)controller didFinishWithItem:(NSString*)item{
//   tempstring = item;
//   NSLog(@"text From subView %@", item);
//}

#pragma mark - Save and Reload methods

- (void)reloadMyCollection
{
[self.collectionView reloadData];
}

-(void)colorCellFrame:(UICollectionViewCell*)cell
{
    
    UIColor *fillColor = [UIColor colorWithRed:30.0/255.0 green:135.0/255.0 blue:220.0/255.0 alpha:1.0];
    cell.contentView.backgroundColor =  fillColor;
    [cell.layer setBorderColor:fillColor.CGColor];
     [cell.layer setBorderWidth:4.0f];
    [cell.layer setBackgroundColor:fillColor.CGColor];
    [cell.layer setCornerRadius:15.0f];
    [cell.layer setShadowOffset:CGSizeMake(0, 0)];
    [cell.layer setShadowColor:fillColor.CGColor];
    [cell.layer setShadowRadius:5.0f];
    [cell.layer setShadowOpacity:1.0];
}

-(void)colorBackCellFrame{
   
    Cell *cell = [self.collectionView cellForItemAtIndexPath:self.tappedCellPath];
    UIColor *fillColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    cell.contentView.backgroundColor =  [UIColor colorNamed:@"blue"];
    [cell.layer setBorderColor:fillColor.CGColor];
    [cell.contentView.layer setCornerRadius:15.0f];
    [cell.layer setBorderWidth:1.0f];
    [cell.layer setBackgroundColor:fillColor.CGColor];
    [cell.layer setCornerRadius:15.0f];
    [cell.layer setShadowOffset:CGSizeMake(0, 0)];
    [cell.layer setShadowColor:fillColor.CGColor];
    [cell.layer setShadowRadius:0.0f];
    [cell.layer setShadowOpacity:0.0];
}


-(void)showConfirmationPopOver
{

    actionSheet = [[UIActionSheet alloc] initWithTitle:@"Confirm" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Delete" otherButtonTitles:@"Cancel", nil];
    actionSheet.delegate = self;
    //[actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    [actionSheet showInView:self.view];
}


- (void)updateFavoriteCellsData:(NSString*)fileName {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSUbiquitousKeyValueStore *cloudStore = [NSUbiquitousKeyValueStore defaultStore];
    [defaults removeObjectForKey:fileName];
    [defaults synchronize];

    [cloudStore synchronize];
}



-(void)removeEntryImage:(NSString*)imageName{
    
    imageName = [imageName stringByDeletingPathExtension];
    imageName = [imageName stringByAppendingString:@".png"];
    NSURL * fileURL = [[DocumentManager documentDirectory] URLByAppendingPathComponent:imageName];

   // NSURL * fileURL = [[[iCloud sharedCloud] ubiquitousDocumentsDirectoryURL] URLByAppendingPathComponent:imageName];
    // Remove the file at the URL
    NSError *error;
        BOOL success = [[NSFileManager defaultManager] removeItemAtURL:fileURL error:&error];
    if (!success) {
        NSLog(@"Error removing image: %@", error.localizedDescription);
    }
}

-(void)removeDocument:(NSString*)docName{
    
    NSURL * fileURL = [[DocumentManager documentDirectory] URLByAppendingPathComponent:docName];

    // Remove the file at the URL
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] removeItemAtURL:fileURL error:&error];
    [self updateFavoriteCellsData:docName];
    if (!success) {
        NSLog(@"Error removing image: %@", error.localizedDescription);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        
        
        NSString * documentName =  [filesArray objectAtIndex:indexOfSelectedCell.row];
        [self removeDocument:documentName];
        [self removeEntryImage:documentName];
        [self updateFavoriteCellsData:documentName];
        [datesDict removeObjectForKey:documentName];
        [self updateFiles];

        
        
        
        /* [[iCloud sharedCloud] setDocument:nil];

        [[iCloud sharedCloud] deleteDocumentWithName:[fileNameList objectAtIndex:indexOfSelectedCell.row] completion:^(NSError *error) {
            if (error) {
                NSLog(@"Error deleting document: %@", error);
            } else {
                
                NSLog(@"completinon of deleting document: %@", error);
                
                [[iCloud sharedCloud] updateFiles];
                
                [self updateFavoriteCellsData:[fileNameList objectAtIndex:indexOfSelectedCell.row]];
                [self removeEntryImageFromiCloud:[fileNameList objectAtIndex:indexOfSelectedCell.row]];
                [datesDict removeObjectForKey:[fileNameList objectAtIndex:indexOfSelectedCell.row]];
                [fileObjectList removeObjectAtIndex:indexOfSelectedCell.row];
                [fileNameList removeObjectAtIndex:indexOfSelectedCell.row];
              //  [dateList removeObjectAtIndex:indexOfSelectedCell.row];

                [self showDeletedView];
                
                NSLog(@"filenamelist %lu", fileNameList.count);
                
                if(fileNameList.count == 0){
                    [self removeOrangeLayer];
                    [self.collectionView  reloadData];
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                }
                
            }
    
        }];
        
*/
    }
   
}

- (void)showDeletedView {
    UILabel *deletedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    deletedLabel.text = @"Deleted";
    deletedLabel.textColor = [UIColor whiteColor];
    deletedLabel.textAlignment = NSTextAlignmentCenter;
    deletedLabel.backgroundColor = [UIColor darkGrayColor];
    deletedLabel.center = self.view.center;
    deletedLabel.layer.cornerRadius = 10;
    deletedLabel.clipsToBounds = YES;
    [self.view addSubview:deletedLabel];
    
    [UIView animateWithDuration:0.3 delay:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        deletedLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [deletedLabel removeFromSuperview];
    }];
}


- (NSMutableString *)getFileName:(NSString *)fileName prefix:(NSString*)prefix{
    NSMutableString *filenamethumb = [fileName mutableCopy];
    filenamethumb = [filenamethumb mutableCopy];
    [filenamethumb appendString: prefix];
    return filenamethumb;
}

-(NSURL*)ubiquitousDocumentsDirectoryURL {
    return [[self ubiquitousContainerURL] URLByAppendingPathComponent:@"Documents"];
}
-(NSURL*)ubiquitousContainerURL {
    return [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
}

#pragma mark - Rename And Delete

- (void) receiveTestNotification:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"showPop"])
    {
      //  Technique *tech = [self.techniques objectAtIndex:[indexOfSelectedCell row]];
        HMPopUpView *hmPopUp = [[HMPopUpView alloc] initWithTitle:@"Rename diagram" okButtonTitle:@"Ok" cancelButtonTitle:@"Cancel" okBtnColor:[UIColor colorNamed:@"orange"] delegate:self];
    
    [hmPopUp configureHMPopUpViewWithBGColor:[UIColor colorNamed:@"whiteDark"] titleColor: [UIColor colorNamed:@"textWhiteDeepBlue"] buttonViewColor:[UIColor colorNamed:@"whiteDark"] buttonBGColor:[UIColor colorNamed:@"whiteDark"] buttonTextColor: [UIColor colorNamed:@"textWhiteDeepBlue"]];
    
        
        Cell *cell = (Cell *)[self.collectionView  cellForItemAtIndexPath:indexOfSelectedCell];
        [hmPopUp showInView:self.view];
        [hmPopUp setTextFieldText:cell.dateLabel.text];
    }
}

- (void) receiveTestNotification2:(NSNotification *)notification
{
    
    if ([[notification name] isEqualToString:@"hideAllBars"])
    {
        for (Cell *cell in [self.collectionView visibleCells]) {
            [cell hideBar];
        }
        
    }
    
}


- (void) receiveTestNotification3:(NSNotification *)notification
{
    
    if ([[notification name] isEqualToString:@"showDeletePop"])
    {
        [self showConfirmationPopOver];
    }
}



- (NSMutableString*)getNameOnRenaming:(NSString *)txtField prefix:(NSString*)prefix{
    NSMutableString * filename = [txtField mutableCopy];
    filename = [filename mutableCopy];
    [filename appendString:prefix];
    return filename;
 }


-(void)renameEntryImageIniCloud:(NSString*)imageName newName:(NSString*)newName{
    
    imageName = [imageName stringByDeletingPathExtension];
    imageName = [imageName stringByAppendingString:@".png"];
    
    newName = [newName stringByDeletingPathExtension];
    newName = [newName stringByAppendingString:@".png"];
    
    
//    NSURL * fileURL = [[[iCloud sharedCloud] ubiquitousDocumentsDirectoryURL] URLByAppendingPathComponent:imageName];
//    // Append the new file name to the URL
//    NSURL *newFileURL = [[[iCloud sharedCloud] ubiquitousDocumentsDirectoryURL] URLByAppendingPathComponent:newName];

    NSURL * fileURL = [[DocumentManager documentDirectory] URLByAppendingPathComponent:imageName];
    // Append the new file name to the URL
    NSURL *newFileURL = [[DocumentManager documentDirectory] URLByAppendingPathComponent:newName];
    
    // Rename the file at the old URL to the new URL
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] moveItemAtURL:fileURL toURL:newFileURL error:&error];

    if (!success) {
        NSLog(@"Error renaming image: %@", error.localizedDescription);
    }
}
-(void)renameTechniqueDelegate:(NSString*)txtField{
    NSMutableString * currentFileName;
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   
    if(techniqueToRename != nil){
        currentFileName = [techniqueToRename mutableCopy];
        techniqueToRename = nil;
    }
    else{
        currentFileName = [appDelegate.cellNameForDelete mutableCopy];
    }
    
    [currentFileName appendString:@".htapp"];
    
    NSMutableString * newName = [txtField mutableCopy];
    [newName appendString:@".htapp"];
    
    NSLog(@"indexcell %ld", (long)indexOfSelectedCell.row);
    [self renameEntryImageIniCloud:currentFileName newName:newName];
    NSURL * currentURL = [[DocumentManager documentDirectory] URLByAppendingPathComponent:currentFileName];
    NSURL * newURL = [[DocumentManager documentDirectory] URLByAppendingPathComponent:newName];

    
    NSError *error = nil;
    [[NSFileManager defaultManager] moveItemAtURL:currentURL toURL:newURL error:&error];

    if (error) {
        NSLog(@"Error renaming file: %@", error.localizedDescription);
        
        
    } else {
        [self updateFiles];

        NSLog(@"File renamed successfully.");
    }
    

    
    
    
//    [[iCloud sharedCloud] renameOriginalDocument:currentFileName withNewName:newName completion:^(NSError *error) {
//       //[fileNameList replaceObjectAtIndex:indexOfSelectedCell.row withObject:newName];
//        [self updateFavoritesData:currentFileName newName:newName];
//        [[iCloud sharedCloud] setDocument:nil];
//
//      //  NSString * key =  [[NSUserDefaults standardUserDefaults] objectForKey:@"order"];
//        //[self sortCollectionView:key];
//
//    }];
     

}


-(void)updateFavoritesData:(NSString*)currentName newName:(NSString*)newName{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSUbiquitousKeyValueStore *cloudStore = [NSUbiquitousKeyValueStore defaultStore];
if([[defaults objectForKey:currentName] isEqualToString:@"favorite"]){
    
    [defaults setObject:@"favorite" forKey:newName];
    [defaults removeObjectForKey:currentName];

}else {
    [defaults setObject:@"default" forKey:newName];
    [defaults removeObjectForKey:currentName];
}
    [defaults synchronize];
    [cloudStore synchronize];
}
-(BOOL)checkEnteredName:(NSString*)txtField{
    
    NSMutableString * newName = [txtField mutableCopy];
    [newName appendString:@".htapp"];
    BOOL techniqueExist;

    for(int i = 0; i < filesArray.count; i++){
        if([newName isEqualToString:[filesArray objectAtIndex:i]]){
        techniqueExist = YES;
            break;
        }else {
        techniqueExist = NO;

        }
    }    return techniqueExist;
}

#pragma mark  - SYNCHRONIZATION



- (void)shouldAnimateIndicator:(BOOL)animate {
    if (animate) {
        [self.indicatorView startAnimating];
      //  self.indicatorView.hidden = NO;

    } else {
        [self.indicatorView stopAnimating];
        //self.indicatorView.hidden = YES;

    }

    self.collectionView.userInteractionEnabled = !animate;
    self.navigationController.navigationBar.userInteractionEnabled = !animate;
}
- (void)presentMessage:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"CloudKit", nil)
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                          otherButtonTitles:nil];
    [alert show];
}


/*
-(void)saveDiagramToFile:(NSString*)techniqueName{

    NSMutableString * exportingFileName = [techniqueName mutableCopy];
    [exportingFileName appendString:@".htapp"];
    
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [docDirectory stringByAppendingPathComponent:exportingFileName];
    NSData * data = [self dataOfType];

    // Save it into file system
    [data writeToFile:filePath atomically:YES];
   // NSURL * url = [NSURL fileURLWithPath:filePath];
}

*/
/*
- (NSData *)dataOfType{
    NSError *error = nil;
 
        NSMutableDictionary* dictToSave = [[[NSUserDefaults standardUserDefaults] objectForKey:@"temporaryDictionary"] mutableCopy];

          //Return the archived data
        return [NSKeyedArchiver archivedDataWithRootObject:dictToSave requiringSecureCoding:NO error:&error];
}
*/


#pragma mark  - STORE NEW DATA IN CLOUD



//- (void)saveDataToCloudWhenFavoritePressed:(NSData*)data fileName:(NSString*)fileName{
//
//    [[iCloud sharedCloud] saveAndCloseDocumentWithName:fileName withContent:data completion:^(UIDocument *cloudDocument, NSData *documentData, NSError *error) {
//        if (!error) {
//            NSLog(@"iCloud Document, %@, saved with text: %@", cloudDocument.fileURL.lastPathComponent, [[NSString alloc] initWithData:documentData encoding:NSUTF8StringEncoding]);
//        } else {
//            NSLog(@"iCloud Document save error: %@", error);
//        }
//    }];
//
//}

@end
