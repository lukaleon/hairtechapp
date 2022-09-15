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
//#import "Flurry.h"

NSString *kEntryViewControllerID = @"EntryViewController";    // view controller storyboard id
NSString *kCellID = @"cellID";                          // UICollectionViewCell storyboard id
NSString *nameOfTechniqueforControllers;

#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.3

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

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
   
    
}

@end

@implementation ViewController


BOOL isDeletionModeActive; // TO UNCOMMENT LATER


-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"disapear");

       [self.collectionView removeGestureRecognizer:tapRecognizer];
    
    [self reloadMyCollection];
    
}


/*
-(void)dbOpenMethod{
    
    NSLog(@"DATA_BASE_WAS_Opened");

    
    
    sqlite3_stmt *statement;
    
    if (sqlite3_open([dbPathString UTF8String], &techniqueDB)==SQLITE_OK) {
        [arrayOfTechnique removeAllObjects];
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM TECHNIQUES"];
        const char* query_sql = [querySql UTF8String];
        
        if (sqlite3_prepare(techniqueDB, query_sql, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                NSString *techniquenamestr = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                NSString *dateString = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                NSString *techniqueImage = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                NSString *namethumb1 = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                NSString *namethumb2 = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                NSString *namethumb3 = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                NSString *namethumb4 = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                NSString *namethumb5 = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
                NSString *namebig1 = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)];
                NSString *namebig2 = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 10)];
                NSString *namebig3 = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 11)];
                NSString *namebig4 = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 12)];
                NSString *namebig5 = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 13)];
                
                Technique *technique = [[Technique alloc]init];
                
                [technique setTechniquename:techniquenamestr];
                [technique setDate:dateString];
                
                [technique setTechniqueimage:techniqueImage];
                [technique setTechniqueimagethumb1:namethumb1];
                [technique setTechniqueimagethumb2:namethumb2];
                [technique setTechniqueimagethumb3:namethumb3];
                [technique setTechniqueimagethumb4:namethumb4];
                [technique setTechniqueimagethumb5:namethumb5];
                [technique setTechniqueimagebig1:namebig1];
                [technique setTechniqueimagebig2:namebig2];
                [technique setTechniqueimagebig3:namebig3];
                [technique setTechniqueimagebig4:namebig4];
                [technique setTechniqueimagebig5:namebig5];
                
                [arrayOfTechnique addObject:technique];
                lastAddedItem = [arrayOfTechnique count];
                
            }
            

        }
        sqlite3_close(techniqueDB);

    }
    
    [[self collectionView]reloadData];
    if(arrayOfTechnique.count==0){
        [self.editButtonOutlet setEnabled:NO];
    }
    else{
        [self.editButtonOutlet setEnabled:YES];
        
    }

}
*/
-(void) saveFloatToUserDefaults:(float)x forKey:(NSString *)key {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:x forKey:key];
    [userDefaults synchronize];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    NSLog(@"DDDIIIDDDDAPPPEARA");

    [super viewDidAppear:animated];
    

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    NSUserDefaults *sharedDefaults = [NSUserDefaults standardUserDefaults];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger countValue = [defaults integerForKey:@"Array"];
    
    if ([sharedDefaults boolForKey:@"FirstLaunch"])
    {
        [self saveColorsToDefaults];
        
        [self saveFloatToUserDefaults:2.0 forKey:@"lineWidth"];
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
        [self saveColorsToDefaults];
        [self saveFloatToUserDefaults:2.0 forKey:@"lineWidth"];
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
    

  }

-(void)saveColorsToDefaults{
    
    UIColor *dottedLine =  [UIColor colorWithRed:35.0/255.0 green:145.0/255.0 blue:72.0/255.0 alpha:1.0];
    UIColor *penColor =  [UIColor colorWithRed:128.0/255.0 green:0.0/255.0 blue:128.0/255.0 alpha:1.0];
    UIColor *arrowColor =  [UIColor colorWithRed:242.0/255.0 green:56.0/255.0 blue:56.0/255.0 alpha:1.0];
    UIColor *blueLine =  [UIColor colorWithRed:17.0/255.0 green:104.0/255.0 blue:217.0/255.0 alpha:1.0];
    UIColor *solidLine =  [UIColor colorWithRed:41.0/255.0 green:47.0/255.0 blue:64.0/255.0 alpha:1.0];

    
    const CGFloat  *components2 = CGColorGetComponents(dottedLine.CGColor);
    const CGFloat  *components3 = CGColorGetComponents(arrowColor.CGColor);
    const CGFloat  *components4 = CGColorGetComponents(solidLine.CGColor);
    const CGFloat  *components5 = CGColorGetComponents(blueLine.CGColor);
    const CGFloat  *components6 = CGColorGetComponents(penColor.CGColor);
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
//    [prefs setFloat:components1[0]  forKey:@"cr"];
 //   [prefs setFloat:components1[1]  forKey:@"cg"];
  //  [prefs setFloat:components1[2]  forKey:@"cb"];
   // [prefs setFloat:components1[3]  forKey:@"ca"];
    
    [prefs setFloat:components2[0]  forKey:@"cr2"];
    [prefs setFloat:components2[1]  forKey:@"cg2"];
    [prefs setFloat:components2[2]  forKey:@"cb2"];
    [prefs setFloat:components2[3]  forKey:@"ca2"];
    
    [prefs setFloat:components3[0]  forKey:@"cr3"];
    [prefs setFloat:components3[1]  forKey:@"cg3"];
    [prefs setFloat:components3[2]  forKey:@"cb3"];
    [prefs setFloat:components3[3]  forKey:@"ca3"];
    
    [prefs setFloat:components4[0]  forKey:@"cr4"];
    [prefs setFloat:components4[1]  forKey:@"cg4"];
    [prefs setFloat:components4[2]  forKey:@"cb4"];
    [prefs setFloat:components4[3]  forKey:@"ca4"];
    
   [prefs setFloat:components5[0]  forKey:@"cr5"];
    [prefs setFloat:components5[1]  forKey:@"cg5"];
    [prefs setFloat:components5[2]  forKey:@"cb5"];
    [prefs setFloat:components5[3]  forKey:@"ca5"];
    
    [prefs setFloat:components6[0]  forKey:@"cr6"];
    [prefs setFloat:components6[1]  forKey:@"cg6"];
    [prefs setFloat:components6[2]  forKey:@"cb6"];
    [prefs setFloat:components6[3]  forKey:@"ca6"];

    
    [prefs synchronize];
    NSLog(@"I just saved colors");
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    //[self dbOpenMethod];
   // [self dbCreateMethod];
 //[self reloadMyCollection];
    [self.collectionView  reloadData];

    NSLog(@"VIEWILLAPPEAR-SHOW_SHOW_SHOW");
    
    
    
   
}




-(void)setupAppearance{
    
    
    
    
}


-(void)viewDidLoad
{
   
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = [UIColor colorWithRed:67.0f/255.0f green:150.0f/255.0f blue:203.0f/255.0f alpha:1.0f];
        appearance.shadowColor =  [UIColor colorWithRed:67.0f/255.0f green:150.0f/255.0f blue:203.0f/255.0f alpha:1.0f];
       // appearance.shadowImage = [UIImage imageWithColor:[UIColor whiteColor]];
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = self.navigationController.navigationBar.standardAppearance;
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
   
    
    
    

self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
   UIColor *barTextColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];

    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:barTextColor];
    
    
    self.navigationItem.title=@"My Library";
    
    UIImage*settingImg=[UIImage imageNamed:@"trash.png"];
    
    
    /*UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithImage:settingImg style:UIBarButtonItemStylePlain target:self action:@selector(activateDeleteMode:)];
    */
    UIBarButtonItem*addNewTechnique=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openSubView:)];

   /*   IMPORTANTE IMPORTANTE
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(activateDeleteMode:)];
    //addButton.tintColor=barTextColor;
    
    
   self.navigationItem.rightBarButtonItem = deleteButton;*/
    self.navigationItem.leftBarButtonItem = addNewTechnique;
    
    
    // Bottom Border
    UIColor *borderColor = [UIColor colorWithRed:0.72 green:0.72 blue:0.72 alpha:1];

    
    
    //[KGStatusBar dismiss];

    [super viewDidLoad];
    
  
 
    if ( IDIOM != IPAD ) {
        
        [self.sidemenuButton setAlpha:0];
    }
    
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MY_CELL"];
  
    
    //UINib *cellNib = [UINib nibWithNibName:@"NibCell" bundle:nil];
    //[self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"MY_CELL"];

    
    self.techniques = [[NSMutableArray alloc] init];
    
    FMDBDataAccess *db = [[FMDBDataAccess alloc] init];
    
    self.techniques = [db getCustomers];


    

    self.menuViewController = [[DEMOMenuViewController alloc] init];
    self.menuViewController.ViewController = self;

    
    [self.toolbar_view setClipsToBounds:YES];
    UIColor *mycolor2 = [UIColor colorWithRed:67.0f/255.0f green:150.0f/255.0f blue:203.0f/255.0f alpha:1.0f];
    
    self.view.backgroundColor = mycolor2;
    self.toolbar_view.backgroundColor = mycolor2;
    
    
    
    //[self.view setBackgroundColor:[UIColor underPageBackgroundColor]];

    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    //  self.collectionView.collectionViewLayout = [[MyCustomLayout alloc] init];
   //[self.collectionView setBackgroundColor:[UIColor colorWithRed:179.0/255.0 green:179.0/255.0 blue:185.0/255.0 alpha:0.8]];
    //tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapRecognizer.delegate=self;
      
      i=0;
    tap=NO;
    
    [self populateCustomers];
    NSLog(@"Array-Count  %d",[self.techniques count]);

    /* Long press gesture for editings technique name*/
    /* To be done in next versions*/
    
    
    
    
   /* UILongPressGestureRecognizer *lpgr
    = [[UILongPressGestureRecognizer alloc]
       initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = .2; //seconds
    lpgr.delegate = self;
   // lpgr.delaysTouchesBegan = YES;
    [self.collectionView addGestureRecognizer:lpgr];
*/
    

    }


/************************ NEW CODE ******************************/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize  newsize;
    newsize = CGSizeMake(CGRectGetWidth(self.view.frame), (CGRectGetHeight(self.view.frame)));
  
    if ( IDIOM == IPAD ) {
        
        newsize.width = 246;
        newsize.height = 380;
        return newsize;
        
        
    } else
    {
        
      
        newsize.width = ((self.view.frame.size.width / 100) * 80);
    newsize.height = ((self.view.frame.size.height / 100) * 80);
        NSLog(@"I'm genering new cell size!!!!!" );
        
           return newsize;
       
    }
    
    
 
}





/************************ END OF NEW CODE ******************************/

/*
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
   if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
   
    CGPoint p = [gestureRecognizer locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    } else  {
        // get the cell at indexPath (the one you long pressed)
        UICollectionViewCell* cell =
        [self.collectionView cellForItemAtIndexPath:indexPath];
        
        NSLog(@"GESTURE LONG PRESS");
        
        renameIndexPath = indexPath;
        
        Technique *tech = [self.techniques objectAtIndex:[indexPath row]];
        HMPopUpView *hmPopUp = [[HMPopUpView alloc] initWithTitle:@"Rename Technique" okButtonTitle:@"Ok" cancelButtonTitle:@"Cancel" delegate:self];
        
        [hmPopUp configureHMPopUpViewWithBGColor:[UIColor colorWithRed:74.0/255.0 green:76.0/255.0 blue:88.0/255.0 alpha:1.000] titleColor: [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.000] buttonViewColor:[UIColor colorWithRed:74.0/255.0 green:76.0/255.0 blue:88.0/255.0 alpha:1.000] buttonBGColor:[UIColor colorWithRed:74.0/255.0 green:76.0/255.0 blue:88.0/255.0 alpha:1.000] buttonTextColor: [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.000]];
     
        [HapticHelper generateFeedback:FeedbackType_Impact_Medium ];

        [hmPopUp showInView:self.view];
        [hmPopUp setTextFieldText:tech.techniquename];
        
    }
   }
       else if
           (gestureRecognizer.state==UIGestureRecognizerStateEnded)
       {
           return;
       }
}*/






























/************************************************************************************/
-(void)changeTechniqueName{

/*
    NSLog(@"I'm changing technique name");
    
    FMDBDataAccess *db = [[FMDBDataAccess alloc] init];
    
    [db updateCustomer:technique];
    [self populateCustomers];
    
    [self.collectionView reloadData];    
    
    
    */
    
}

-(void) populateCustomers
{
    self.techniques = [[NSMutableArray alloc] init];
    
    FMDBDataAccess *db = [[FMDBDataAccess alloc] init];
    
    self.techniques = [db getCustomers];
    NSLog(@"TECHNIQUES IN DATABASE = %d",self.techniques.count);
    
     
}

-(void)MySubViewController:(MySubView *) controller didAddCustomer:(Technique *) technique
{
    
    NSLog(@"addCustomerViewController");
    
    FMDBDataAccess *db = [[FMDBDataAccess alloc] init];
    
    [db insertCustomer:technique];
    
    [self populateCustomers];
    
    [self.collectionView reloadData];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.globalIndex = [self.techniques indexOfObject:technique];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidDisappear{
}

- (void)viewDidUnload {
    
    [self setEditButtonOutlet:nil];
    [self setCollectionView:nil];
    [super viewDidUnload];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    tapRecognizer = nil;
    self.menuViewController.ViewController = nil;
}

-(void)openEntry
{
 AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"AppDelegate MYGlobalNameREAL = %@",appDelegate.NameForTechnique);
    
   
    __block NSUInteger index = NSUIntegerMax;
    
    [self.techniques enumerateObjectsUsingBlock: ^ (Technique* technique, NSUInteger idx, BOOL* stop) {
        if([technique.techniquename isEqualToString:appDelegate.NameForTechnique])
        {
            index = idx;
            *stop = YES;
        }
    }];
    
Technique *technique = [self.techniques objectAtIndex:index];
    
    //Technique *technique = [self.techniques objectAtIndex:indexpathtemp.row];

    NSLog(@"INDEX_FOR_ITEM = %d",index);
    NSLog(@"INDEX_FOR_ITEM_WITH_ROW= %d",indexpathtemp.row);
                                  
    

    indexpathtemp=NULL;
    
      EntryViewController *entryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EntryViewController"];
    
    appDelegate.myGlobalName = technique.techniquename;
    
    self.sendImagenameToControllers = technique.techniquename;
    
    entryViewController.stringFromTextfield = self.sendImagenameToControllers;

    NSLog(@"AppDelegate MYGlobalName = %@",technique.techniquename);
    
    entryViewController.delegate1=self;
    
    
    [self.navigationController pushViewController: entryViewController animated:YES];
    
    
}

#pragma mark -Create or Open Database
/*
- (void)createOrOpenDB
{
    NSLog(@"CREATED_OR_OPENED_DATABASE");
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    
    dbPathString = [docPath stringByAppendingPathComponent:@"Technique.db"];
    
    char *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPathString]) {
        const char *dbPath = [dbPathString UTF8String];
        
        //creat db here
        if (sqlite3_open(dbPath, &techniqueDB)==SQLITE_OK) {
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS TECHNIQUES (ID INTEGER PRIMARY KEY AUTOINCREMENT, TECHNIQUENAME TEXT, DATE TEXT,TECHNIQUEIMAGE TEXT ,TECHNIQUENAMETHUMB1 TEXT ,TECHNIQUENAMETHUMB2 TEXT,TECHNIQUENAMETHUMB3 TEXT,TECHNIQUENAMETHUMB4 TEXT,TECHNIQUENAMETHUMB5 TEXT,TECHNIQUENAMEBIG1 TEXT,TECHNIQUENAMEBIG2 TEXT,TECHNIQUENAMEBIG3 TEXT,TECHNIQUENAMEBIG4 TEXT,TECHNIQUENAMEBIG5 TEXT)";
            sqlite3_exec(techniqueDB, sql_stmt, NULL, NULL, &error);
            sqlite3_close(techniqueDB);
        }
     
    }
}*/


#pragma mark -didRecieveMemoryWarning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -Collection View methods
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //appDelegate.arraycount = arrayOfTechnique.count;

    if(arrayOfTechnique.count==0)
    {
        

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:0 forKey:@"Array"];
        [defaults synchronize];
        
        
    }
    else
    {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:1 forKey:@"Array"];
        [defaults synchronize];
    }
    

    
    
   return [self.techniques count];
}

-(void)updateCollectionView{
    
    
}


- (void)userDidSwipe:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        //handle the gesture appropriately
        
        NSLog(@"Gesture Swipe Handled");
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
   
   Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
 
    [cell hideBar];
    
    UISwipeGestureRecognizer* gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(userDidSwipe:)];
    [gestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [cell addGestureRecognizer:gestureRecognizer];
    
    
    
    UIColor *fillColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    cell.contentView.backgroundColor =  fillColor;
    [cell.contentView.layer setCornerRadius:15.0f];
    cell.clipsToBounds = YES;
    
    
   /* [cell.layer setBorderColor:fillColor.CGColor];
    
    [cell.layer setBorderWidth:1.0f];
    [cell.layer setBackgroundColor:fillColor.CGColor];
    
    
    [cell.layer setShadowOffset:CGSizeMake(0, 0)];
    [cell.layer setShadowColor:fillColor.CGColor];
    [cell.layer setShadowRadius:0.0f];
    [cell.layer setShadowOpacity:0.0];
    
    */
    
    
      Technique *technique = [self.techniques objectAtIndex:indexPath.row];

    
    //cell.labelOne.text = technique.techniquename;
    cell.dateLabel.text = technique.techniquename;
    
    //@autoreleasepool {
    
    NSMutableString *filenamethumb = @"%@/";
    NSMutableString *prefix = technique.techniquename;
    filenamethumb = [filenamethumb mutableCopy];
   [filenamethumb appendString: prefix];
    filenamethumb = [filenamethumb mutableCopy];
    [filenamethumb appendString: @"Entry"];
   filenamethumb = [filenamethumb mutableCopy];
   [filenamethumb appendString: @".png"];
   NSLog(@"CellForItemAtIndexPath: %@.",filenamethumb);
    
    NSLog(@"NAMEFROMMY_SUB_VIEW_techNAME: %@.",technique.techniquename);
    NSLog(@"NAMEFROMMY_SUB_VIEW: %@.",tempstring);
    
    if ([technique.techniquename isEqualToString:tempstring]){
    
        indexpathtemp = indexPath;
        
        NSLog(@"!!!!!!!!!!!!!!!!!!!!: %@.",technique.techniquename);
        NSLog(@"!!!!!!!!!!!!!!!!!!!!++++: %@.",tempstring);

    }

    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    
    NSString *filePath = [NSString stringWithFormat:filenamethumb, docDirectory];
    UIImage *tempimage = [[UIImage alloc] initWithContentsOfFile:filePath];
    
    
    
    /*
    cell_sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    cell_docDirectory = [cell_sysPaths objectAtIndex:0];
    cell_filePath = [NSString stringWithFormat:filenamethumb, cell_docDirectory];
    imageForCell = [[UIImage alloc]initWithContentsOfFile:cell_filePath];
    */
    
    
    cell.image.image = tempimage;
   
     if ( IDIOM == IPAD ) {
         
         
         [cell.dateLabel setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
         
     }else{
    
         
         CGSize  newsize;
         newsize = CGSizeMake(CGRectGetWidth(cell.frame), (CGRectGetHeight(cell.frame)));
         
         CGRect screenRect = [[UIScreen mainScreen] bounds];
         CGFloat screenWidth = screenRect.size.width;
         CGFloat screenHeight = screenRect.size.height;
         
         [cell.image setFrame:CGRectMake(0, 0, (screenWidth*80)/100, (screenHeight*80)/100)];
         [cell.contentView.layer setCornerRadius:15.0f];


    
        
        }
    
    return cell;
}

// the user tapped a collection item, load and set the image on the detail view controller
//





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"EntryViewController"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        
        EntryViewController* entryViewController = [[navigationController viewControllers] objectAtIndex:0];
        
        entryViewController.delegate1 = self;
    
    }
    if ([[segue identifier] isEqualToString:@"subView"])
    {
        [self openSubView];
      
}
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Before entryVC");

    EntryViewController *entryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EntryViewController"];
    
    NSLog(@"After entryVC");

    //entryVC.delegate1=self;
    
    
    Technique *technique = [self.techniques objectAtIndex:[indexPath row]];
    
    NSLog(@"After Technique*techniue");

    NSLog(@"Technique name= %@",technique.techniqueimagethumb1);

    NSMutableString *filenamethumb1 = @"%@/";
    NSMutableString *prefix= technique.techniqueimagethumb1;
    filenamethumb1 = [filenamethumb1 mutableCopy];
    [filenamethumb1 appendString: prefix];
    

    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:filenamethumb1, docDirectory];
    UIImage *tempimage = [[UIImage alloc] initWithContentsOfFile:filePath];
    
    /////---------Delegate image to EntryViewController button2 ---------/////////
    NSMutableString *filenamethumb2 = @"%@/";
    NSMutableString *prefix2= technique.techniqueimagethumb2;
    filenamethumb2 = [filenamethumb2 mutableCopy];
    [filenamethumb2 appendString: prefix2];
    
    
    NSLog(@"Результат: %@.",filenamethumb1);
    NSLog(@"Результат: %@.",filenamethumb2);
    NSArray *sysPaths2 = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory2 = [sysPaths2 objectAtIndex:0];
    NSString *filePath2 = [NSString stringWithFormat:filenamethumb2, docDirectory2];
    UIImage *tempimage2 = [[UIImage alloc] initWithContentsOfFile:filePath2];
    
    NSLog(@"DOCDIRECTORY %@.",docDirectory2);
    
    
    
    
    /////---------Delegate image to EntryViewController buttonTopHead---------/////////
    NSMutableString *filenamethumb3 = @"%@/";
    NSMutableString *prefix3= technique.techniqueimagethumb3;
    filenamethumb3 = [filenamethumb3 mutableCopy];
    [filenamethumb3 appendString: prefix3];
    
    NSLog(@"Результат: %@.",filenamethumb1);
    NSLog(@"Результат: %@.",filenamethumb2);
    NSArray *sysPaths3 = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory3 = [sysPaths3 objectAtIndex:0];
    NSString *filePath3 = [NSString stringWithFormat:filenamethumb3, docDirectory3];
    UIImage *tempimage3 = [[UIImage alloc] initWithContentsOfFile:filePath3];
    
    /////---------Delegate image to EntryViewController buttonFrontHead---------/////////
    NSMutableString *filenamethumb4 = @"%@/";
    NSMutableString *prefix4= technique.techniqueimagethumb4;
    filenamethumb4 = [filenamethumb4 mutableCopy];
    [filenamethumb4 appendString: prefix4];
    
    NSLog(@"Результат: %@.",filenamethumb1);
    NSLog(@"Результат: %@.",filenamethumb2);
    NSArray *sysPaths4 = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory4 = [sysPaths4 objectAtIndex:0];
    NSString *filePath4 = [NSString stringWithFormat:filenamethumb4, docDirectory4];
    UIImage *tempimage4 = [[UIImage alloc] initWithContentsOfFile:filePath4];
    
    /////---------Delegate image to EntryViewController buttonBackHead---------/////////
    NSMutableString *filenamethumb5 = @"%@/";
    NSMutableString *prefix5= technique.techniqueimagethumb5;
    filenamethumb5 = [filenamethumb5 mutableCopy];
    [filenamethumb5 appendString: prefix5];
    
    NSLog(@"Результат: %@.",filenamethumb1);
    NSLog(@"Результат: %@.",filenamethumb2);
    NSArray *sysPaths5 = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory5 = [sysPaths5 objectAtIndex:0];
    NSString *filePath5 = [NSString stringWithFormat:filenamethumb5, docDirectory5];
    UIImage *tempimage5 = [[UIImage alloc] initWithContentsOfFile:filePath5];
    
    self.image1 = tempimage;
    self.image2 = tempimage2;
    self.image3 = tempimage3;
    self.image4 = tempimage4;
    self.image5 = tempimage5;
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appDelegate.myGlobalName = technique.techniquename;
    
    self.sendImagenameToControllers = technique.techniquename;
    
    appDelegate.globalDate = technique.date;
    entryVC.stringFromTextfield = self.sendImagenameToControllers;
    
    entryVC.entryImage1= self.image1;
    entryVC.entryImage2 = self.image2;
    entryVC.entryImage3 = self.image3;
    entryVC.entryImage4 = self.image4;
    entryVC.entryImage5 = self.image5;
    
    NSLog(@"Результат: EntryViewController Button1 = %@.and Button2 %@.",filenamethumb1,filenamethumb2);
    

    


   
    Cell *cell = [collectionView  cellForItemAtIndexPath:indexPath];
    
    UIColor *fillColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
   cell.contentView.backgroundColor =  fillColor;
    
 //  [cell.layer setBorderColor:fillColor.CGColor];
   // [cell.contentView.layer setCornerRadius:5.0f];
    
    //[cell.contentView.layer setBorderWidth:4.0f];
    [cell.contentView.layer setCornerRadius:15.0f];
    
//    [cell.layer setShadowOffset:CGSizeMake(0, 0)];
//    [cell.layer setShadowColor:fillColor.CGColor];
//    [cell.layer setShadowRadius:2.0f];
//    [cell.layer setShadowOpacity:1.0];
    
    
    
    
    //[self.delegate1 setImagesInEC:self didFinishWithItem1:self.image1 didFinishWithItem2:self.image2 didFinishWithItem3:self.image3 didFinishWithItem4:self.image4 didFinishWithItem5:self.image5];
    
    [self.navigationController pushViewController: entryVC animated:YES];

   
    }




/*
- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5];
}

*/

-(void)openSubView:(id)sender
    {
       MySubView *mysubview  = [self.storyboard instantiateViewControllerWithIdentifier:@"subView"];
        mysubview.delegate = self;
        [self presentViewController:mysubview animated:YES completion:nil];
       // [Flurry logEvent:@"New_Technique_Gonna_Be_Created"];
 
    }
#pragma mark -passItemBack Method

-(void) passItemBack:(MySubView *)controller didFinishWithItem:(NSString*)item{

   tempstring=item;

    NSLog(@"Name for technique PASSITEMBACK = %@",item);

    
}

#pragma mark -Save and Reload methods
- (void) saveData:(NSString *)namefortech{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    ////////------SAVE DATA TO THE DATABASE-------------------------///////
    
   
    NSLog(@"Name for technique PASSITEMBACK-APPDELEGATE = %@",namefortech);

    self.convertedLabel = namefortech;
    
    NSLog(@"Name for technique in SAVE DATA METHOD = %@",self.convertedLabel);
    
    NSMutableString *bfcol =@"Entry";
    foothumb =self.convertedLabel;
    foothumb = [self.convertedLabel mutableCopy];
    [foothumb appendString:bfcol];
    foothumb= [foothumb mutableCopy];
    [foothumb appendString:@".png"];
    NSLog(@"Результат in vc: %@.",foothumb);
    
    
    
    /////-----------Name for  thumbimage1 ---------------//////////
    
    self.convertedLabel =namefortech;
    NSMutableString *bf1 =@"thumb1";
    foothumb1 =self.convertedLabel;
    foothumb1 = [self.convertedLabel mutableCopy];
    [foothumb1 appendString:bf1];
    foothumb1= [foothumb1 mutableCopy];
    [foothumb1 appendString:@".png"];
    NSLog(@"Результат in vc: %@.",foothumb1);
    /////-----------Name for  thumbimage2 ---------------//////////
    
    self.convertedLabel =namefortech;
    
    NSMutableString *bf2 =@"thumb2";
    foothumb2 =self.convertedLabel;
    foothumb2 = [self.convertedLabel mutableCopy];
    [foothumb2 appendString:bf2];
    foothumb2= [foothumb2 mutableCopy];
    [foothumb2 appendString:@".png"];
    NSLog(@"Результат in vc: %@.",foothumb2);
    
    /////-----------Name for  thumbimage3 ---------------//////////
    self.convertedLabel =namefortech;
    NSMutableString *bf3 =@"thumb3";
    foothumb3 =self.convertedLabel;
    foothumb3 = [self.convertedLabel mutableCopy];
    [foothumb3 appendString:bf3];
    foothumb3= [foothumb3 mutableCopy];
    [foothumb3 appendString:@".png"];
    NSLog(@"Результат in vc: %@.",foothumb3);
    
    /////-----------Name for  thumbimage1 ---------------//////////
    self.convertedLabel =namefortech;
    NSMutableString *bf4 =@"thumb4";
    foothumb4 =self.convertedLabel;
    foothumb4 = [self.convertedLabel mutableCopy];
    [foothumb4 appendString:bf4];
    foothumb4= [foothumb4 mutableCopy];
    [foothumb4 appendString:@".png"];
    NSLog(@"Результат in vc: %@.",foothumb4);
    
    /////-----------Name for  thumbimage5 ---------------//////////
    self.convertedLabel =namefortech;
    NSMutableString *bf5 =@"thumb5";
    foothumb5 =self.convertedLabel;
    foothumb5 = [self.convertedLabel mutableCopy];
    [foothumb5 appendString:bf5];
    foothumb5= [foothumb5 mutableCopy];
    [foothumb5 appendString:@".png"];
    NSLog(@"Результат in vc: %@.",foothumb5);
    
    /////-----------Name for  bigimage1 ---------------//////////
    self.convertedLabel =namefortech;
    NSMutableString *bfb1 =@"big1";
    foobig1 =self.convertedLabel;
    foobig1 = [self.convertedLabel mutableCopy];
    [foobig1 appendString:bfb1];
    foobig1= [foobig1 mutableCopy];
    [foobig1 appendString:@".png"];
    NSLog(@"Результат in vc: %@.",foobig1);
    
    /////-----------Name for  bigimage2---------------//////////
    self.convertedLabel =namefortech;
    NSMutableString *bfb2 =@"big2";
    foobig2 =self.convertedLabel;
    foobig2 = [self.convertedLabel mutableCopy];
    [foobig2 appendString:bfb2];
    foobig2= [foobig2 mutableCopy];
    [foobig2 appendString:@".png"];
    NSLog(@"Результат in vc: %@.",foobig2);
    
    /////-----------Name for  bigimage3---------------//////////
    self.convertedLabel =namefortech;
    NSMutableString *bfb3 =@"big3";
    foobig3 =self.convertedLabel;
    foobig3 = [self.convertedLabel mutableCopy];
    [foobig3 appendString:bfb3];
    foobig3= [foobig3 mutableCopy];
    [foobig3 appendString:@".png"];
    NSLog(@"Результат: %@.",foobig3);
    
    /////-----------Name for  bigimage4---------------//////////
    self.convertedLabel =namefortech;
    NSMutableString *bfb4 =@"big4";
    foobig4 =self.convertedLabel;
    foobig4 = [self.convertedLabel mutableCopy];
    [foobig4 appendString:bfb4];
    foobig4= [foobig4 mutableCopy];
    [foobig4 appendString:@".png"];
    NSLog(@"Результат: %@.",foobig4);
    
    /////-----------Name for  bigimage5---------------//////////
    self.convertedLabel =namefortech;
    NSMutableString *bfb5 =@"big5";
    foobig5 =self.convertedLabel;
    foobig5 = [self.convertedLabel mutableCopy];
    [foobig5 appendString:bfb5];
    foobig5= [foobig5 mutableCopy];
    [foobig5 appendString:@".png"];
    NSLog(@"Результат: %@.",foobig5);
    
    
   /*
    char *error;
    if (sqlite3_open([dbPathString UTF8String], &techniqueDB)==SQLITE_OK) {
        NSString *inserStmt = [NSString stringWithFormat:@"INSERT INTO TECHNIQUES(TECHNIQUENAME,DATE,TECHNIQUEIMAGE,TECHNIQUENAMETHUMB1,TECHNIQUENAMETHUMB2,TECHNIQUENAMETHUMB3,TECHNIQUENAMETHUMB4,TECHNIQUENAMETHUMB5,TECHNIQUENAMEBIG1,TECHNIQUENAMEBIG2,TECHNIQUENAMEBIG3,TECHNIQUENAMEBIG4,TECHNIQUENAMEBIG5) values ('%s', '%s','%s', '%s','%s', '%s','%s', '%s','%s', '%s','%s', '%s','%s' )",[self.label.text UTF8String], [self.label.text UTF8String],[foothumb UTF8String],[foothumb1 UTF8String],[foothumb2 UTF8String],[foothumb3 UTF8String],[foothumb4 UTF8String],[foothumb5 UTF8String],[foobig1 UTF8String],[foobig2 UTF8String],[foobig3 UTF8String],[foobig4 UTF8String],[foobig5 UTF8String]];
        
        const char *insert_stmt = [inserStmt UTF8String];
        
        if (sqlite3_exec(techniqueDB, insert_stmt, NULL, NULL, &error)==SQLITE_OK) {
            NSLog(@"Technique added");
            
            Technique *technique = [[Technique alloc]init];
            
            [technique setTechniquename:namefortech];
            [technique setDate:namefortech];
            [technique setTechniqueimage:foothumb];
            [technique setTechniqueimagethumb1:foothumb1];
            [technique setTechniqueimagethumb2:foothumb2];
            [technique setTechniqueimagethumb3:foothumb3];
            [technique setTechniqueimagethumb4:foothumb4];
            [technique setTechniqueimagethumb5:foothumb5];
            [technique setTechniqueimagebig1:foobig1];
            [technique setTechniqueimagebig2:foobig2];
            [technique setTechniqueimagebig3:foobig3];
            [technique setTechniqueimagebig4:foobig4];
            [technique setTechniqueimagebig5:foobig5];
            
            [arrayOfTechnique addObject:technique];
           lastAddedItem = [arrayOfTechnique count];
            

            
        }
        sqlite3_close(techniqueDB);
        
    }
    /////////------END OF SAVING METHOD ---------------------------////////
    [[self collectionView ] reloadData];
*/
    
}

- (void)reloadMyCollection
{

[[self collectionView ] reloadData];


}




/*
- (void)activateDeleteMode:(id)sender
{

    if (tap==YES){
   NSLog(@"Да крантно");
        
        [self.collectionView removeGestureRecognizer:tapRecognizer];
         
 
        UIColor *mycolor2 = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f];
    
       [self.editButtonOutlet setTintColor:mycolor2];
       // self.label.text = @"MY LIBRARY";
        [self.addTechnique setEnabled:YES];
        NSLog(@"The barbutton was tapped TAP ==NO" );
        
        for (Cell *cell in [self.collectionView visibleCells]) {
            [cell setEditing:NO animated:NO];
        }
        
        tap=NO;
         }
   
   else
    {
        
        for (Cell *cell in [self.collectionView visibleCells]) {
            [cell setEditing:YES animated:YES];
        }

        
        NSLog(@"Кратности нет");
        UIColor *mycolor = [UIColor colorWithRed:163.0f/255.0f green:187.0f/255.0f blue:211.0f/255.0f alpha:1.0f];
  
        [self.editButtonOutlet setTintColor:mycolor];
        //self.label.text = @"TAP TECHNIQUE TO DELETE";
        NSLog(@"The barbutton was tapped TAP == YES" );
        [self.addTechnique setEnabled:NO];
        //[self reloadMyCollection];
        tap=YES;

        
        [self.collectionView addGestureRecognizer:tapRecognizer];
    }
   // [self showConfirmationPopOver];

 
    

    
}*/
/*
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    
    
}
*/


#pragma mark -Delete Cells From CollectionView
/*
- (void)handleTapGesture:(UITapGestureRecognizer *)sender
{
    
  
   if (tap==YES)
 {
       
       if (sender.state == UIGestureRecognizerStateEnded){

    //if (CGRectIntersectsRect(cell.frame, rect)) {

    CGPoint initialPinchPoint = [sender locationInView:self.collectionView];
 
           self.tappedCellPath = [self.collectionView indexPathForItemAtPoint:initialPinchPoint];
            if (self.tappedCellPath!=nil)
        {
        //////----------------------------------------
            Cell *cell = [self.collectionView cellForItemAtIndexPath:self.tappedCellPath];
             [HapticHelper generateFeedback:FeedbackType_Impact_Medium ];
            [self colorCellFrame:cell];
            [self showConfirmationPopOver];
            tap=YES;
    }
    }
       

}
//}
 
}
*/
/*
- (BOOL) isDeletionModeActiveForCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
{
    NSLog(@"RETURN DELETE MODE");
    return isDeletionModeActive;

}
*/

-(void)colorCellFrame:(UICollectionViewCell*)cell
{
    
    UIColor *fillColor = [UIColor colorWithRed:30.0/255.0 green:135.0/255.0 blue:220.0/255.0 alpha:1.0];
    cell.contentView.backgroundColor =  fillColor;
    [cell.layer setBorderColor:fillColor.CGColor];
     [cell.layer setBorderWidth:4.0f];
    [cell.layer setBackgroundColor:fillColor.CGColor];
    [cell.layer setCornerRadius:15.0f];
    //[self.layer setOpacity:0.7f];
    
    [cell.layer setShadowOffset:CGSizeMake(0, 0)];
    [cell.layer setShadowColor:fillColor.CGColor];
    [cell.layer setShadowRadius:5.0f];
    [cell.layer setShadowOpacity:1.0];
    /*
    UIColor *fillColor = [UIColor colorWithRed:250.0/255.0 green:195.0/255.0 blue:50.0/255.0 alpha:0.9];

    cell.contentView.BackgroundColor =  fillColor;
    [cell.layer setBorderColor:[UIColor colorWithRed:250.0/255.0 green:195.0/255.0 blue:50.0/255.0 alpha:0.9].CGColor];
    [cell.contentView.layer setCornerRadius:5.0f];
     */
}

-(void)colorBackCellFrame{
   /*
    Cell *cell = [self.collectionView cellForItemAtIndexPath:self.tappedCellPath];

    UIColor *fillColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.8];

    //cell.contentView.BackgroundColor =  fillColor;
    [cell.layer setBorderColor:[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:0.7f].CGColor];
    //[cell.layer setBorderColor:[UIColor colorWithRed:220.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:0.8].CGColor];
   // [cell.contentView.layer setCornerRadius:5.0f];
    
    
    [cell.layer setBorderWidth:3.0f];
    [cell.layer setBackgroundColor:[[UIColor whiteColor]CGColor]];
    [cell.layer setCornerRadius:5.0f];
    [cell.layer setOpacity:1.0f];
    
    [cell.layer setShadowOffset:CGSizeMake(0, 2)];
    //[self.layer setShadowColor:[[UIColor darkGrayColor] CGColor]];
    [cell.layer setShadowColor:[[UIColor blackColor] CGColor]];
    
    [cell.layer setShadowRadius:8.0f];
    [cell.layer setShadowOpacity:0.9];
    
    */
    
    Cell *cell = [self.collectionView cellForItemAtIndexPath:self.tappedCellPath];
    
    UIColor *fillColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    cell.contentView.backgroundColor =  fillColor;
    
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
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSLog(@"AppDelegate MYGlobalNameREAL = %@",appDelegate.cellNameForDelete);
        
        
        __block NSUInteger index = NSUIntegerMax;
        
        [self.techniques enumerateObjectsUsingBlock: ^ (Technique* technique, NSUInteger idx, BOOL* stop) {
            if([technique.techniquename isEqualToString:appDelegate.cellNameForDelete])
            {
                index = idx;
                *stop = YES;
            }
        }];
        
        Technique *technique = [self.techniques objectAtIndex:index];
        FMDBDataAccess *db = [[FMDBDataAccess alloc] init];
        [db deleteCustomer:technique];
        NSLog(@"Techniques count = %d",self.techniques.count);
        
        [self removeImage:technique.techniquename];

        [self populateCustomers];
        NSLog(@"Techniques count = %d",self.techniques.count);
        [[self collectionView ] reloadData];
        [self checkArrayCount];


        }
    
    
  
    
    else {
       // [ self.editButtonOutlet setEnabled:YES];

        for (Cell *cell in [self.collectionView visibleCells]) {
            [cell setEditing:NO animated:NO];
        }
      //  isDeletionModeActive = NO;
       MyCustomLayout *layout = (MyCustomLayout *)self.collectionView.collectionViewLayout;
       [layout invalidateLayout];
 
        self.navigationItem.title=@"My Library";
    [self.addTechnique setEnabled:YES];
   }
    }

-(void)checkArrayCount
{
    NSLog(@"Array count  = %d", arrayOfTechnique.count);

    
    if (arrayOfTechnique.count==0)
    {

        NSLog(@"Array count  = %d", arrayOfTechnique.count);
        
        isDeletionModeActive = NO;
        MyCustomLayout *layout = (MyCustomLayout *)self.collectionView.collectionViewLayout;
        [layout invalidateLayout];
        

        [self.collectionView removeGestureRecognizer:tapRecognizer];
        
        self.navigationItem.title=@"My Library";
       [self.editButtonOutlet setEnabled:NO];
        [self.addTechnique setEnabled:YES];
        tap = NO;
    }
}

- (void)removeImage:(NSString*)fileName {
    
    NSMutableString *filenamethumb = fileName;
    filenamethumb = [filenamethumb mutableCopy];
    [filenamethumb appendString: @"Entry"];
    filenamethumb = [filenamethumb mutableCopy];
    [filenamethumb appendString: @".png"];
    NSLog(@"Результат видалення entryScreenCapture 1: %@.",filenamethumb);
    
    NSMutableString *filenamethumb1 = fileName;
    filenamethumb1 = [filenamethumb1 mutableCopy];
    [filenamethumb1 appendString: @"thumb1"];
    filenamethumb1 = [filenamethumb1 mutableCopy];
    [filenamethumb1 appendString: @".png"];
    NSLog(@"Результат видалення маленької 1: %@.",filenamethumb1);
    
    NSMutableString *filenamethumb2 = fileName;
    filenamethumb2 = [filenamethumb2 mutableCopy];
    [filenamethumb2 appendString: @"thumb2"];
    filenamethumb2 = [filenamethumb2 mutableCopy];
    [filenamethumb2 appendString: @".png"];
    NSLog(@"Результат видалення маленької 2: %@.",filenamethumb2);
    
    NSMutableString *filenamethumb3 = fileName;
    filenamethumb3 = [filenamethumb3 mutableCopy];
    [filenamethumb3 appendString: @"thumb3"];
    filenamethumb3 = [filenamethumb3 mutableCopy];
    [filenamethumb3 appendString: @".png"];
    NSLog(@"Результат видалення маленької 3: %@.",filenamethumb3);

    
    NSMutableString *filenamethumb4 = fileName;
    filenamethumb4 = [filenamethumb4 mutableCopy];
    [filenamethumb4 appendString: @"thumb4"];
    filenamethumb4 = [filenamethumb4 mutableCopy];
    [filenamethumb4 appendString: @".png"];
    NSLog(@"Результат видалення маленької 4: %@.",filenamethumb4);
    
    
    NSMutableString *filenamethumb5 = fileName;
    filenamethumb5 = [filenamethumb5 mutableCopy];
    [filenamethumb5 appendString: @"thumb5"];
    filenamethumb5 = [filenamethumb5 mutableCopy];
    [filenamethumb5 appendString: @".png"];
    NSLog(@"Результат видалення маленької 5: %@.",filenamethumb5);
    
    NSMutableString * filenamebig1 = fileName;
    filenamebig1 = [filenamebig1 mutableCopy];
    [filenamebig1 appendString: @"big1"];
    filenamebig1 = [filenamebig1 mutableCopy];
    [filenamebig1 appendString: @".png"];
    
    NSLog(@"Результат видалення великоиї картинки1: %@.",filenamebig1);
    
    NSMutableString * filenamebig2 = fileName;
    filenamebig2 = [filenamebig2 mutableCopy];
    [filenamebig2 appendString: @"big2"];
    filenamebig2 = [filenamebig2 mutableCopy];
    [filenamebig2 appendString: @".png"];
    
    NSLog(@"Результат видалення великоиї картинки2: %@.",filenamebig2);
    
    NSMutableString * filenamebig3 = fileName;
    filenamebig3 = [filenamebig3 mutableCopy];
    [filenamebig3 appendString: @"big3"];
    filenamebig3 = [filenamebig3 mutableCopy];
    [filenamebig3 appendString: @".png"];
    
    NSLog(@"Результат видалення великоиї картинки2: %@.",filenamebig3);
    
    NSMutableString * filenamebig4 = fileName;
    filenamebig4 = [filenamebig4 mutableCopy];
    [filenamebig4 appendString: @"big4"];
    filenamebig4 = [filenamebig4 mutableCopy];
    [filenamebig4 appendString: @".png"];
    
    NSLog(@"Результат видалення великоиї картинки2: %@.",filenamebig4);
    
    NSMutableString * filenamebig5 = fileName;
    filenamebig5 = [filenamebig5 mutableCopy];
    [filenamebig5 appendString: @"big5"];
    filenamebig5 = [filenamebig5 mutableCopy];
    [filenamebig5 appendString: @".png"];
    
    NSLog(@"Результат видалення великоиї картинки5: %@.",filenamebig5);


    NSMutableString * filenamebig0 = fileName;
    filenamebig0 = [filenamebig0 mutableCopy];
    [filenamebig0 appendString: @"EntryBig"];
    filenamebig0 = [filenamebig0 mutableCopy];
    [filenamebig0 appendString: @".png"];
    
    NSLog(@"Результат видалення великоиї картинки5: %@.",filenamebig0);


    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,   YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fullPath0 = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:filenamethumb]];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:filenamethumb1]];
    NSString *fullPath2 = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:filenamethumb2]];
    NSString *fullPath3 = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:filenamethumb3]];
    NSString *fullPath4 = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:filenamethumb4]];
    NSString *fullPath5 = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:filenamethumb5]];
    
    
    NSString *fullPathbig1 = [documentsDirectory stringByAppendingPathComponent:
                          [NSString stringWithFormat:filenamebig1]];
    NSString *fullPathbig2 = [documentsDirectory stringByAppendingPathComponent:
                              [NSString stringWithFormat:filenamebig2]];
    NSString *fullPathbig3 = [documentsDirectory stringByAppendingPathComponent:
                              [NSString stringWithFormat:filenamebig3]];
    NSString *fullPathbig4 = [documentsDirectory stringByAppendingPathComponent:
                              [NSString stringWithFormat:filenamebig4]];
    NSString *fullPathbig5 = [documentsDirectory stringByAppendingPathComponent:
                              [NSString stringWithFormat:filenamebig5]];
    
    NSString *fullPathbig0 = [documentsDirectory stringByAppendingPathComponent:
                              [NSString stringWithFormat:filenamebig0]];
    


    [fileManager removeItemAtPath: fullPath0 error:NULL];
    [fileManager removeItemAtPath: fullPath error:NULL];
    [fileManager removeItemAtPath: fullPath2 error:NULL];
    [fileManager removeItemAtPath: fullPath3 error:NULL];
    [fileManager removeItemAtPath: fullPath4 error:NULL];
    [fileManager removeItemAtPath: fullPath5 error:NULL];

    
    [fileManager removeItemAtPath:fullPathbig1 error:NULL];
    [fileManager removeItemAtPath:fullPathbig2 error:NULL];
    [fileManager removeItemAtPath:fullPathbig3 error:NULL];
    [fileManager removeItemAtPath:fullPathbig4 error:NULL];
    [fileManager removeItemAtPath:fullPathbig5 error:NULL];
    [fileManager removeItemAtPath:fullPathbig0 error:NULL];


    NSError *error = nil;
    if(![fileManager removeItemAtPath: fullPath error:&error]) {
        NSLog(@"Delete failed:%@", error);
    } else {
        NSLog(@"image removed: %@", fullPath);
    }
    
    NSString *appFolderPath = [[NSBundle mainBundle] resourcePath];
    NSLog(@"Directory Contents:\n%@", [fileManager directoryContentsAtPath: appFolderPath]);
}

/*
-(void)deleteData:(NSString *)deleteQuery
{
    char *error;
    
    if (sqlite3_exec(techniqueDB, [deleteQuery UTF8String], NULL, NULL, &error)==SQLITE_OK) {
        NSLog(@"Person deleted");
    }
    [Flurry logEvent:@"Technique_deleted"];
}

*/


- (IBAction)showSideMenu:(id)sender{
    
    //[Flurry logEvent:@"Side_Menu_Opened"];
 // self.menuViewController = [[REFrostedViewController alloc] init];
[self.menuViewController presentFromViewController:self animated:YES completion:nil];

}


- (void) receiveTestNotification:(NSNotification *)notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
    if ([[notification name] isEqualToString:@"showPop"])
    {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSLog(@"AppDelegate MYGlobalNameREAL = %@",appDelegate.cellNameForDelete);
        
        
        __block NSUInteger index = NSUIntegerMax;
        
        [self.techniques enumerateObjectsUsingBlock: ^ (Technique* technique, NSUInteger idx, BOOL* stop) {
            if([technique.techniquename isEqualToString:appDelegate.cellNameForDelete])
            {
                index = idx;
                *stop = YES;
            }
        }];
        renameIndexPath = index;

        Technique *tech = [self.techniques objectAtIndex:index];
        
        
        
        
        
        
        
       // Technique *tech = [self.techniques objectAtIndex:[indexPath row]];
    HMPopUpView *hmPopUp = [[HMPopUpView alloc] initWithTitle:@"Rename Technique" okButtonTitle:@"Ok" cancelButtonTitle:@"Cancel" delegate:self];
    
    [hmPopUp configureHMPopUpViewWithBGColor:[UIColor colorWithRed:74.0/255.0 green:76.0/255.0 blue:88.0/255.0 alpha:1.000] titleColor: [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.000] buttonViewColor:[UIColor colorWithRed:74.0/255.0 green:76.0/255.0 blue:88.0/255.0 alpha:1.000] buttonBGColor:[UIColor colorWithRed:74.0/255.0 green:76.0/255.0 blue:88.0/255.0 alpha:1.000] buttonTextColor: [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.000]];
    
    [HapticHelper generateFeedback:FeedbackType_Impact_Medium ];
    
    [hmPopUp showInView:self.view];
    [hmPopUp setTextFieldText:tech.techniquename];
        
     
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



-(void)renameTechniqueDelegate:(NSString*)txtField{
   
    Technique *technique = [self.techniques objectAtIndex:renameIndexPath];
    FMDBDataAccess *db = [[FMDBDataAccess alloc] init];
    [db deleteCustomer:technique];
    [self populateCustomers];
    
    
    
   
   
    
    
    NSLog(@"techme %@", technique.techniqueimagethumb1);

    NSMutableString *bfcol0 =@"Entry";
    rfoothumb =txtField;
    rfoothumb = [txtField mutableCopy];
    [rfoothumb appendString:bfcol0];
    rfoothumb= [rfoothumb mutableCopy];
    [rfoothumb appendString:@".png"];
    NSLog(@"RESULT: %@.",rfoothumb);
    
    NSMutableString *bfcol1 =@"thumb1";
    rfoothumb1 =txtField;
    rfoothumb1 = [txtField mutableCopy];
    [rfoothumb1 appendString:bfcol1];
    rfoothumb1= [rfoothumb1 mutableCopy];
    [rfoothumb1 appendString:@".png"];
    NSLog(@"Результат: %@.",rfoothumb1);
    
    NSMutableString *bfcol2 =@"thumb2";
    rfoothumb2 =txtField;
    rfoothumb2 = [txtField mutableCopy];
    [rfoothumb2 appendString:bfcol2];
    rfoothumb2= [rfoothumb2 mutableCopy];
    [rfoothumb2 appendString:@".png"];
    NSLog(@"Результат: %@.",rfoothumb2);
                 
    NSMutableString *bfcol3 =@"thumb3";
    rfoothumb3 =txtField;
    rfoothumb3 = [txtField mutableCopy];
    [rfoothumb3 appendString:bfcol3];
    rfoothumb3= [rfoothumb3 mutableCopy];
    [rfoothumb3 appendString:@".png"];
    NSLog(@"Результат: %@.",rfoothumb3);
                 
    NSMutableString *bfcol4 =@"thumb4";
    rfoothumb4 =txtField;
    rfoothumb4 = [txtField mutableCopy];
    [rfoothumb4 appendString:bfcol4];
    rfoothumb4= [rfoothumb4 mutableCopy];
    [rfoothumb4 appendString:@".png"];
    NSLog(@"Результат: %@.",rfoothumb4);
                 
    NSMutableString *bfcol5 =@"thumb5";
    rfoothumb5 =txtField;
    rfoothumb5 = [txtField mutableCopy];
    [rfoothumb5 appendString:bfcol5];
    rfoothumb5= [rfoothumb5 mutableCopy];
    [rfoothumb5 appendString:@".png"];
    NSLog(@"Результат: %@.",rfoothumb5);
                 
    NSMutableString *bfcol_1 =@"big1";
    rfoobig1 =txtField;
    rfoobig1 = [txtField mutableCopy];
    [rfoobig1 appendString:bfcol_1];
    rfoobig1= [rfoobig1 mutableCopy];
    [rfoobig1 appendString:@".png"];
    NSLog(@"Результат: %@.",rfoobig1);
                 
    NSMutableString *bfcol_2 =@"big2";
    rfoobig2 =txtField;
    rfoobig2 = [txtField mutableCopy];
    [rfoobig2 appendString:bfcol_2];
    rfoobig2= [rfoobig2 mutableCopy];
    [rfoobig2 appendString:@".png"];
    NSLog(@"Результат: %@.",rfoobig2);
                 
    NSMutableString *bfcol_3 =@"big3";
    rfoobig3 =txtField;
    rfoobig3 = [txtField mutableCopy];
    [rfoobig3 appendString:bfcol_3];
    rfoobig3= [rfoobig3 mutableCopy];
    [rfoobig3 appendString:@".png"];
    NSLog(@"Результат: %@.",rfoobig3);
                 
    NSMutableString *bfcol_4 =@"big4";
    rfoobig4 =txtField;
    rfoobig4 = [txtField mutableCopy];
    [rfoobig4 appendString:bfcol_4];
    rfoobig4= [rfoobig4 mutableCopy];
    [rfoobig4 appendString:@".png"];
    NSLog(@"Результат: %@.",rfoobig4);
                 
    NSMutableString *bfcol_5 =@"big5";
    rfoobig5 =txtField;
    rfoobig5 = [txtField mutableCopy];
    [rfoobig5 appendString:bfcol_5];
    rfoobig5= [rfoobig5 mutableCopy];
    [rfoobig5 appendString:@".png"];
    NSLog(@"Результат: %@.",rfoobig5);
    
    
    
   
    

    [self changeFileName:technique.techniquename to:txtField];
    [self changeFileName:technique.techniqueimage to:rfoothumb];
    [self changeFileName:technique.techniqueimagethumb1 to:rfoothumb1];
    [self changeFileName:technique.techniqueimagethumb2 to:rfoothumb2];
    [self changeFileName:technique.techniqueimagethumb3 to:rfoothumb3];
    [self changeFileName:technique.techniqueimagethumb4 to:rfoothumb4];
    [self changeFileName:technique.techniqueimagethumb5 to:rfoothumb5];
    [self changeFileName:technique.techniqueimagebig1 to:rfoobig1];
    [self changeFileName:technique.techniqueimagebig2 to:rfoobig2];
    [self changeFileName:technique.techniqueimagebig3 to:rfoobig3];
    [self changeFileName:technique.techniqueimagebig4 to:rfoobig4];
    [self changeFileName:technique.techniqueimagebig5 to:rfoobig5];
    
    technique.techniquename = txtField;
    //technique.date = self.textField.text;
    //technique.date = @"new_version";
    technique.techniqueimage=rfoothumb;
    technique.techniqueimagethumb1=rfoothumb1;
    technique.techniqueimagethumb2=rfoothumb2;
    technique.techniqueimagethumb3=rfoothumb3;
    technique.techniqueimagethumb4=rfoothumb4;
    technique.techniqueimagethumb5=rfoothumb5;
    technique.techniqueimagebig1=rfoobig1;
    technique.techniqueimagebig2=rfoobig2;
    technique.techniqueimagebig3=rfoobig3;
    technique.techniqueimagebig4=rfoobig4;
    technique.techniqueimagebig5=rfoobig5;
    
    [db insertCustomer:technique];
    [self populateCustomers];
    [self.collectionView reloadData];
    
 
    
    
}


-(BOOL) validate:(Technique *)c
{
    if([c.techniquename length] == 0)
    {
        return NO;
    }
    
    return YES;
}



-(void)changeFileName:(NSString *)filename to:(NSString*)newFileName
{
    NSError *error;
    
    // Create file manager
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [documentPaths objectAtIndex:0];
    
    // Point to Document directory
    //   NSString *documentsDirectory = [NSDocumentDirectory()
    //      stringByAppendingPathComponent:@"Documents"];
    
    NSString *filePath2 = [documentsDirectory
                           stringByAppendingPathComponent:newFileName];
    
    
    NSString *filePath =[documentsDirectory
                         stringByAppendingPathComponent:filename];
    // Attempt the move
    if ([fileMgr moveItemAtPath:filePath toPath:filePath2 error:&error] != YES)
        NSLog(@"Unable to move file: %@", [error localizedDescription]);
    
    // Show contents of Documents directory
    NSLog(@"Documents directory: %@",
          [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
}



-(BOOL)checkEnteredName:(NSString*)txtField{
    
    NSMutableString *bfcol1 =@"thumb1";
    rfoothumb1 = txtField;
    rfoothumb1 = [txtField mutableCopy];
    [rfoothumb1 appendString:bfcol1];
    rfoothumb1= [rfoothumb1 mutableCopy];
    [rfoothumb1 appendString:@".png"];
    NSLog(@"Результат in textfield: %@.",rfoothumb1);
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *foofile = [documentsPath stringByAppendingPathComponent:rfoothumb1];
    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
    return fileExist;
}





@end
