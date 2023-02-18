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
#import "TemporaryDictionary.h"
#import "ReusableView.h"
#import "DiagramFile.h"
#import "iCloud.h"
#import "iCloudDocument.h"
//#import "Flurry.h"

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
    
    [self iCloudSetup:^(BOOL finished) {
//        UIActivityIndicatorView  *av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
//        av.frame = CGRectMake(round((self.view.frame.size.width - 25) / 2), round((self.view.frame.size.height - 25) / 2), 25, 25);
//        av.tag  = 1;
//        [self.view addSubview:av];
//        [av startAnimating];
//
        if(finished){
//            [av stopAnimating];

        }
    }];
    
    

    [self setupLongPressGestures];
    
    self.view.backgroundColor = [UIColor colorNamed:@"grey"];
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
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.navigationItem.title = @"Collection";
    
    // Bottom Border
//[super viewDidLoad];
    [self.sidemenuButton setAlpha:0];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MY_CELL"];
   
    [self.toolbar_view setClipsToBounds:YES];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    
//    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nono:)];
//    tapRecognizer.delegate = self;
    [self setupNavigationBar];
    self.isSelectionActivated = NO;

   
    
    
    
    i = 0;
    tap = NO;
    [self addNewTechniqueButton];
    
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
}




-(void)viewDidDisappear:(BOOL)animated
{
    [self.collectionView removeGestureRecognizer:tapRecognizer];
    [self reloadMyCollection];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [DiagramFile setSharedInstance:nil];

    [super viewWillAppear:YES];
   
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [self.collectionView  reloadData];
    longpresscell.enabled = YES;
    
    
    // Present Welcome Screen
    if ([self appIsRunningForFirstTime] == YES || [[iCloud sharedCloud] checkCloudAvailability] == NO || [[NSUserDefaults standardUserDefaults] boolForKey:@"userCloudPref"] == NO) {
      //  [self performSegueWithIdentifier:@"showWelcome" sender:self];
        return;
    }
    
    /* --- Force iCloud Update ---
     This is done automatically when changes are made, but we want to make sure the view is always updated when presented */
    
    [[iCloud sharedCloud] updateFiles];
    
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
    
    NSUserDefaults *sharedDefaults = [NSUserDefaults standardUserDefaults];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger countValue = [defaults integerForKey:@"Array"];
    
    if ([sharedDefaults boolForKey:@"FirstLaunch"])
    {
        [self saveFloatToUserDefaults:0.0 forKey:@"eraserPressed"];
        
        [self openSubView:self];
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString * key =  [[NSUserDefaults standardUserDefaults] objectForKey:@"order"];
        [self sortCollectionView:key];
    });
   
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
   
//    if(fileNameList.count == 0){
//        self.navigationItem.rightBarButtonItem.enabled = NO;
//    }
}




#pragma mark - iCloud Methods

-(void) iCloudSetup:(myCompletion) compblock{

    
    [[iCloud sharedCloud] setDelegate:self]; // Set this if you plan to use the delegate
    [[iCloud sharedCloud] setVerboseLogging:YES]; // We want detailed feedback about what's going on with iCloud, this is OFF by default
    [[iCloud sharedCloud] setupiCloudDocumentSyncWithUbiquityContainer:nil]; // You must call this setup method before performing any document operations
    
    // Setup File List
    if (fileNameList == nil) fileNameList = [NSMutableArray array];
    if (fileObjectList == nil) fileObjectList = [NSMutableArray array];
    
    // Display an Edit button in the navigation bar for this view controller.
   // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Create refresh control
    if (refreshControl == nil) refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshCloudList) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    
    // Subscribe to iCloud Ready Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCloudListAfterSetup) name:@"iCloud Ready" object:nil];
    
    compblock(YES);
}

- (void)iCloudDidFinishInitializingWitUbiquityToken:(id)cloudToken withUbiquityContainer:(NSURL *)ubiquityContainer {
    NSLog(@"Ubiquity container initialized. You may proceed to perform document operations.");
}

- (void)iCloudAvailabilityDidChangeToState:(BOOL)cloudIsAvailable withUbiquityToken:(id)ubiquityToken withUbiquityContainer:(NSURL *)ubiquityContainer {
    if (!cloudIsAvailable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iCloud Unavailable" message:@"iCloud is no longer available. Make sure that you are signed into a valid iCloud account." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        [self performSegueWithIdentifier:@"showWelcome" sender:self];
    }
}

- (void)iCloudFilesDidChange:(NSMutableArray *)files withNewFileNames:(NSMutableArray *)fileNames {
    // Get the query results
    NSLog(@"Files: %@", fileNames);
    
    fileNameList = fileNames; // A list of the file names
    fileObjectList = files; // A list of NSMetadata objects with detailed metadata
    [refreshControl endRefreshing];
    
        if(fileNameList.count == 0){
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    
    [self.collectionView reloadData];
}

- (void)refreshCloudList {
    [[iCloud sharedCloud] updateFiles];
}

- (void)refreshCloudListAfterSetup {
    // Reclaim delegate and then update files
    [[iCloud sharedCloud] setDelegate:self];
    [[iCloud sharedCloud] updateFiles];
}


#pragma mark - Add New Technique

-(void)MySubViewController:(MySubView *) controller didAddCustomer:(Technique *) technique
{
    [self.collectionView reloadData];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   // appDelegate.globalIndex = [self.techniques indexOfObject:technique];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)populateAndReload{
    [self.collectionView reloadData];
}


-(void)openEntry
{
    //[self refreshCloudList];

    _fileNameForOpenEntry  = [[NSUserDefaults standardUserDefaults] objectForKey:@"newCreatedFileName"];
    
    NSLog(@"naame %@", _fileNameForOpenEntry);
    
    NewEntryController *newEntryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewEntryController"];

    
    [[iCloud sharedCloud] retrieveCloudDocumentWithName:_fileNameForOpenEntry completion:^(UIDocument *cloudDocument, NSData *documentData, NSError *error) {
        if (!error) {
            
           fileText = [[NSString alloc] initWithData:documentData encoding:NSUTF8StringEncoding];
           fileTitle = cloudDocument.fileURL.lastPathComponent;
            
           //Extracting extension from filename to get technique name
           NSString * techniqueName = [[fileTitle lastPathComponent] stringByDeletingPathExtension];

            // Put data file into object
            DiagramFile * diagram =  [DiagramFile sharedInstance];
            [diagram storeFileDataInObject:documentData fileName:techniqueName error:nil];
           
            
        
            [[iCloud sharedCloud] documentStateForFile:fileTitle completion:^(UIDocumentState *documentState, NSString *userReadableDocumentState, NSError *error) {
                if (!error) {
                    if (*documentState == UIDocumentStateInConflict) {
                        [self performSegueWithIdentifier:@"conflictVC" sender:self];
                      //  [self performSegueWithIdentifier:@"showConflict" sender:self];
                      //  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                    } else
                    {
                        newEntryVC.navigationItem.title = techniqueName;
                        newEntryVC.genderType = [diagram  maleFemale];
                        [newEntryVC setTechniqueID:techniqueName];
                        [newEntryVC setTechniqueID: techniqueName];
                    
                        [self.navigationController pushViewController: newEntryVC animated:YES];
                    }
                    
                } else {
                    NSLog(@"Error retrieveing document state: %@", error);
                }
            }];
            
            
        } else {
            NSLog(@"Error retrieveing document: %@", error);
        }
    }];

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
    
    return [fileNameList count];
   // return filesArray.count;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        self.headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
//        NSString *title = [[NSString alloc]initWithFormat:@"Recipe Group #%i", indexPath.section + 1];
//        headerView.title.text = title;
//        UIImage *headerImage = [UIImage imageNamed:@"header_banner.png"];
        //headerView.backgroundImage.image = headerImage;
        self.headerView.delegate = self;

        reusableview = self.headerView;
    }
 
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
 
        reusableview = footerview;
    }
        
    return reusableview;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
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

   // NSMutableDictionary * dictOfData = [self openFileAtPath:[filesArray objectAtIndex:indexPath.row] error:nil];
   
    NSError * outError;
    NSString *fileName = [fileNameList objectAtIndex:indexPath.row];
    //NSNumber *filesize = [[iCloud sharedCloud] fileSize:fileName];
    NSDate *updated = [[iCloud sharedCloud] fileModifiedDate:fileName];
    NSData * data = [[iCloud sharedCloud] docData:fileName];
    
    NSMutableDictionary * dictionary = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:&outError];
    [arrayOfFileDictionaries addObject:dictionary];
    
    
    __block NSString *documentStateString = @"";
    [[iCloud sharedCloud] documentStateForFile:fileName completion:^(UIDocumentState *documentState, NSString *userReadableDocumentState, NSError *error) {
        if (!error) {
            documentStateString = userReadableDocumentState;
        }
    }];
    
//    NSString *fileDetail = [NSString stringWithFormat:@"%@ bytes, updated %@.\n%@", filesize, [MHPrettyDate prettyDateFromDate:updated withFormat:MHPrettyDateFormatWithTime], documentStateString];
   
    NSString *fileDetail = [NSString stringWithFormat:@"%@", [MHPrettyDate prettyDateFromDate:updated withFormat:MHPrettyDateFormatNoTime]];
    
   // NSString *fileDetail = [NSString stringWithFormat:@"%@",documentStateString];
    
    // Configure the cell...
    cell.dateLabel.text = [[fileName lastPathComponent] stringByDeletingPathExtension];

    cell.image.image = [UIImage imageWithData:[dictionary objectForKey:@"imageEntry"]];

   //  cell.image.image = [self iconForFile:fileName]; // Uncomment this line to enable file icons for each cell

    cell.viewModeLabel.text = fileDetail;

    if([[dictionary objectForKey:@"favorite"] isEqualToString:@"favorite"]){
        cell.isFavorite = YES;
        [cell.favorite setImage:[UIImage imageNamed:@"star.fill"]];
    }else {
        cell.isFavorite = NO;
        [cell.favorite setImage:[UIImage imageNamed:@"star.tr"]];
    }
    
    
    if ([documentStateString isEqualToString:@"Document is in conflict"]) {
        cell.backgroundColor = [UIColor redColor];
    }
    

    
 /*   NSMutableDictionary * dictOfData = [self openFileAtURL:[filesArray objectAtIndex:indexPath.row] error:nil];
    
    NSLog(@"File name in dir %@", [filesArray objectAtIndex:indexPath.row]);

    
    cell.image.image = [UIImage imageWithData:[dictOfData objectForKey:@"imageEntry"]];
    cell.dateLabel.text = [dictOfData objectForKey:@"techniqueName"];
    cell.cellIndex = indexPath;
    cell.viewModeLabel.text = [dictOfData objectForKey:@"creationDate"];
    cell.UUIDcell = [dictOfData objectForKey:@"techniqueName"];
    
    if([[dictOfData objectForKey:@"favorite"] isEqualToString:@"favorite"]){
        cell.isFavorite = YES;
        [cell.favorite setImage:[UIImage imageNamed:@"star.fill"]];
    }else {
        cell.isFavorite = NO;

        [cell.favorite setImage:[UIImage imageNamed:@"star.tr"]];
    }*/
    

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
    NewEntryController *newEntryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewEntryController"];
    Cell *cell = (Cell *)[collectionView  cellForItemAtIndexPath:indexPath];

    
    if(!self.isSelectionActivated){
        
        [[iCloud sharedCloud] retrieveCloudDocumentWithName:[fileNameList objectAtIndex:indexPath.row] completion:^(UIDocument *cloudDocument, NSData *documentData, NSError *error) {
            if (!error) {
                
               fileText = [[NSString alloc] initWithData:documentData encoding:NSUTF8StringEncoding];
               fileTitle = cloudDocument.fileURL.lastPathComponent;
                
               //Extracting extension from filename to get technique name
               NSString * techniqueName = [[fileTitle lastPathComponent] stringByDeletingPathExtension];

                // Put data file into object
                DiagramFile * diagram =  [DiagramFile sharedInstance];
                [diagram storeFileDataInObject:documentData fileName:techniqueName error:nil];
               
                [[iCloud sharedCloud] documentStateForFile:fileTitle completion:^(UIDocumentState *documentState, NSString *userReadableDocumentState, NSError *error) {
                    if (!error) {
                        if (*documentState == UIDocumentStateInConflict) {
                            [self performSegueWithIdentifier:@"conflictVC" sender:self];
                          //  [self performSegueWithIdentifier:@"showConflict" sender:self];
                          //  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                        } else
                        {
                            newEntryVC.navigationItem.title = techniqueName;
                            newEntryVC.genderType = [diagram  maleFemale];
                            [newEntryVC setTechniqueID:techniqueName];
                            [newEntryVC setTechniqueID: techniqueName];
                            [self.navigationController pushViewController: newEntryVC animated:YES];
                        }
                        
                    } else {
                        NSLog(@"Error retrieveing document state: %@", error);
                    }
                }];
                
            } else {
                NSLog(@"Error retrieveing document: %@", error);
            }
        }];
        
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





-(void)updateCollectionView{
}
- (void)userDidSwipe:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture Swipe Handled");
    }
}



- (UIImage *)iconForFile:(NSString *)documentName {
//    UIDocumentInteractionController *controller = [UIDocumentInteractionController interactionControllerWithURL:[[[iCloud sharedCloud] ubiquitousDocumentsDirectoryURL] URLByAppendingPathComponent:documentName]];
//    NSMutableDictionary * dictOfData = [self openFileAtURL:documentName error:nil];
//
//
//    if (controller) {
//        return [UIImage imageWithData:[dictOfData objectForKey:@"imageEntry"]]; // arbitrary selection--gives you the largest icon in this case
//    }
//
//    return nil;
   
   
        
    
    
    UIDocumentInteractionController *controller = [UIDocumentInteractionController interactionControllerWithURL:[[[iCloud sharedCloud] ubiquitousDocumentsDirectoryURL] URLByAppendingPathComponent:documentName]];
    if (controller) {
        return [controller.icons lastObject]; // arbitrary selection--gives you the largest icon in this case
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

    NSError * outError;
    NSData * data = [[iCloud sharedCloud] docData:filePath];
    NSMutableDictionary * dictionary = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:&outError];
//    NSLog(@"array count %lu", arrayOfFileDictionaries.count);
//    NSMutableDictionary * dictionary = [arrayOfFileDictionaries objectAtIndex:indexOfFavoriteCell.row];
    
    if(cell.isFavorite){
        [dictionary setObject:@"default" forKey:@"favorite"];
        [cell.favorite setImage:[UIImage imageNamed:@"star.tr"]];
    }else {
        [dictionary setObject:@"favorite" forKey:@"favorite"];
        [cell.favorite setImage:[UIImage imageNamed:@"star.fill"]];
    }
    
    NSData * newData = [NSKeyedArchiver archivedDataWithRootObject:dictionary requiringSecureCoding:NO error:&outError];
    
//    [arrayOfFileDictionaries replaceObjectAtIndex:indexOfFavoriteCell.row withObject:dictionary];
    
    [self saveDataToCloudWhenFavoritePressed:newData fileName:filePath];
    [self reloadMyCollection];
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

    NSString *exportingFileName = [filesArray objectAtIndex:[indexOfSelectedCell row]];
    Cell * cell = (Cell*)[self.collectionView cellForItemAtIndexPath:indexOfSelectedCell];


    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [docDirectory stringByAppendingPathComponent:exportingFileName];
    NSURL * url = [NSURL fileURLWithPath:filePath];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems: @[url] applicationActivities:nil];
    
    activityViewController.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:activityViewController animated: YES completion: nil];
    UIPopoverPresentationController * popoverPresentationController = activityViewController.popoverPresentationController;
    popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popoverPresentationController.sourceView = self.view;
    popoverPresentationController.sourceRect = CGRectMake(cell.center.x, cell.center.y, 10, 1);
    
//
//    if(activityViewController.popoverPresentationController){
//        activityViewController.popoverPresentationController.sourceView = self.view;
//    }
//    [self presentViewController:activityViewController animated: YES completion: nil];
}


-(NSString*)getNamesOfTechniquesInFiles:(NSString*)techNameImported{
    
    for(int i = 0; i < filesArray.count; i++){
        NSMutableDictionary * dictOfData = [self openFileAtPath:[filesArray objectAtIndex:i] error:nil];
        NSString * nameFromDict = [dictOfData objectForKey:@"techniqueName"];
        if([techNameImported isEqualToString:nameFromDict]){
            NSString *lastChar = [nameFromDict substringFromIndex:[nameFromDict length] - 1];
            
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
            
        }
    }
    return techNameImported;
}

-(void)insertExportedDataFromAppDelegate{
    
   // [self getArrayOfFilesInDirectory];
    [self.collectionView reloadData];
    NewEntryController *newEntryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewEntryController"];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableString * newTechniqueName = [appDelegate.importedTechniqueName mutableCopy];
    [newTechniqueName appendString:@".htapp"];
    
    NSLog(@"techtech %@", newTechniqueName);
    
    NSMutableDictionary * dictOfData = [self openFileAtPath:newTechniqueName error:nil];
    
    newEntryVC.navigationItem.title = [dictOfData objectForKey:@"techniqueName"];
    [newEntryVC setTechniqueID:[dictOfData objectForKey:@"techniqueName"]];
    newEntryVC.techniqueType = [dictOfData objectForKey:@"maleFemale"];
     
    [self.navigationController pushViewController:newEntryVC animated:YES];
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
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
   // [self deleteItemsAtURLs:dirContents queue:q]; //delete item ia iCloud Dir
}

-(NSMutableDictionary*)getDataFromFile:(NSData*)documentData{
    
    return [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:documentData error:nil];
}

#pragma mark - Sorting methods

-(void)sortCollectionView:(NSString*)key{
    NSLog(@"sort collection");
    [self sortCollectionViewFromSegments:key];
    [arrayOfFileDictionaries removeAllObjects];
    [self.collectionView reloadData];
}

-(void)sortCollectionViewFromSegments:(NSString*)key{
    NSMutableArray * tempArray = [NSMutableArray array];
for(int i = 0; i < fileNameList.count; i++){
    NSMutableDictionary * dictOfData = [arrayOfFileDictionaries objectAtIndex:i];
    [tempArray addObject:dictOfData];
}
NSArray * sortedArray;

sortedArray = [self sortArrayByNameWithKey:key andArray:tempArray];

 /* Creating new sordted array of file names*/
    [fileNameList removeAllObjects];
    for(int i = 0; i < sortedArray.count; i++){
        NSMutableDictionary * dictOfDataSorted = [sortedArray objectAtIndex:i];
        NSMutableString * stringWithWxtension = [[dictOfDataSorted objectForKey:@"techniqueName"] mutableCopy];
    [stringWithWxtension appendString:@".htapp"];
    [fileNameList addObject:stringWithWxtension];
    NSLog(@"filenamelist %@", stringWithWxtension);
}

}

-(NSMutableArray *)sortArrayByNameWithKey:(NSString *)sortingKey andArray:(NSMutableArray *)unsortedArray{
    
    NSArray * sortedArray;
    
    if( [sortingKey isEqualToString:@"techniqueName"]){
        NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:sortingKey
                                                                     ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
        sortedArray =  [unsortedArray sortedArrayUsingDescriptors:sortDescriptors].mutableCopy;
    }
    if ([sortingKey isEqualToString:@"creationDate"]){
        NSSortDescriptor *lastDescriptor = [[NSSortDescriptor alloc] initWithKey:sortingKey ascending:NO selector:@selector(compare:)];
        NSArray *descriptors = [NSArray arrayWithObjects: lastDescriptor, nil];
        sortedArray =  [unsortedArray sortedArrayUsingDescriptors:descriptors].mutableCopy;
    }
    if ([sortingKey isEqualToString:@"favorite"]){
        NSSortDescriptor *lastDescriptor = [[NSSortDescriptor alloc] initWithKey:sortingKey ascending:NO selector:@selector(compare:)];
        NSArray *descriptors = [NSArray arrayWithObjects: lastDescriptor, nil];
        sortedArray =  [unsortedArray sortedArrayUsingDescriptors:descriptors].mutableCopy;
    }
    
    return sortedArray.mutableCopy;
}


/*-(NSMutableArray *)sortArrayByDateWithKey:(NSString *)sortingKey andArray:(NSMutableArray *)unsortedArray{
    NSSortDescriptor *lastDescriptor = [[NSSortDescriptor alloc] initWithKey:sortingKey ascending:YES selector:@selector(compare:)];
    NSArray *descriptors = [NSArray arrayWithObjects: lastDescriptor, nil];
    return [unsortedArray sortedArrayUsingDescriptors:descriptors].mutableCopy;
}*/

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

    NSMutableDictionary * tempDict = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:outError];
    
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
        nameView.fileNameList = fileNameList;
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


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {

    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        
        [[iCloud sharedCloud] deleteDocumentWithName:[fileNameList objectAtIndex:indexOfSelectedCell.row] completion:^(NSError *error) {
            if (error) {
                NSLog(@"Error deleting document: %@", error);
            } else {
                
                [fileObjectList removeObjectAtIndex:indexOfSelectedCell.row];
                [fileNameList removeObjectAtIndex:indexOfSelectedCell.row];
                [[iCloud sharedCloud] updateFiles];
                
                if(fileNameList.count == 0){
                    [self removeOrangeLayer];
                    [self.collectionView  reloadData];
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                }
                if(fileNameList.count > 0){
                    
                    // [ self.editButtonOutlet setEnabled:YES];
                    
                    for (Cell *cell in [self.collectionView visibleCells]) {
                        [cell setEditing:NO animated:NO];
                    }
                    //  isDeletionModeActive = NO;
                    MyCustomLayout *layout = (MyCustomLayout *)self.collectionView.collectionViewLayout;
                    [layout invalidateLayout];
                    [self.addTechnique setEnabled:YES];
                    [actionSheet dismissWithClickedButtonIndex:actionSheet.cancelButtonIndex animated:YES];
                }
            }
        }];
        
  
    }
   
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
    
    // Save new file name to techniqueName inDictionary
    NSError * outError;
    NSData * data = [[iCloud sharedCloud] docData:currentFileName];
    NSMutableDictionary * dictionary = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:&outError];
    [dictionary setObject:txtField forKey:@"techniqueName"];
    NSData * newData = [NSKeyedArchiver archivedDataWithRootObject:dictionary requiringSecureCoding:NO error:&outError];
    [self saveDataToCloudWhenFavoritePressed:newData fileName:currentFileName];
    
    
    [[iCloud sharedCloud] renameOriginalDocument:currentFileName withNewName:newName completion:^(NSError *error) {
        [self reloadMyCollection];
    }];
     
}

-(BOOL)checkEnteredName:(NSString*)txtField{
    
    NSMutableString * newName = [txtField mutableCopy];
    [newName appendString:@".htapp"];
    BOOL techniqueExist;

    for(int i = 0; i < fileNameList.count; i++){
        if([newName isEqualToString:[fileNameList objectAtIndex:i]]){
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



- (NSData *)dataOfType{
    NSError *error = nil;
 
        NSMutableDictionary* dictToSave = [[[NSUserDefaults standardUserDefaults] objectForKey:@"temporaryDictionary"] mutableCopy];

          //Return the archived data
        return [NSKeyedArchiver archivedDataWithRootObject:dictToSave requiringSecureCoding:NO error:&error];
}



#pragma mark  - STORE NEW DATA IN CLOUD

- (void)saveDataToCloudWhenFavoritePressed:(NSData*)data fileName:(NSString*)fileName{
   
    [[iCloud sharedCloud] saveAndCloseDocumentWithName:fileName withContent:data completion:^(UIDocument *cloudDocument, NSData *documentData, NSError *error) {
        if (!error) {
            NSLog(@"iCloud Document, %@, saved with text: %@", cloudDocument.fileURL.lastPathComponent, [[NSString alloc] initWithData:documentData encoding:NSUTF8StringEncoding]);
        } else {
            NSLog(@"iCloud Document save error: %@", error);
        }
    }];

}

@end
