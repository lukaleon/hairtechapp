//
//  NSObject+DiagramFile.m
//  hairtech
//
//  Created by Alexander Prent on 10.02.2023.
//  Copyright © 2023 Admin. All rights reserved.
//

#import "DiagramFile.h"
#import "AppDelegate.h"

@implementation DiagramFile
@synthesize tempDict;

static DiagramFile *_sharedInstance = nil;
//static dispatch_once_t once_token = 0;

+(instancetype)sharedInstance {
  //  dispatch_once(&once_token, ^{
        if (_sharedInstance == nil) {
            _sharedInstance = [[DiagramFile alloc] init];

        }
    //});
    return _sharedInstance;
}

+(void)setSharedInstance:(DiagramFile *)instance {
    //once_token = 0; // resets the once_token so dispatch_once will run again
    _sharedInstance = instance;
}


-(void)openFileAtPath:(NSString*)fileName error:(NSError **)outError {
    
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [docDirectory stringByAppendingPathComponent:fileName];
    NSLog(@"dir %@",docDirectory );
    
    NSURL * url = [NSURL fileURLWithPath:filePath];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    tempDict = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:outError];
    
    self.techniqueName = [tempDict objectForKey:@"techniqueName"];
    self.uuid = [tempDict objectForKey:@"uuid"];
    self.maleFemale = [tempDict objectForKey:@"maleFemale"];
    self.note = [tempDict objectForKey:@"note"];

    self.imageLeft = [UIImage imageWithData:[tempDict objectForKey:@"imageLeft"]];
    self.imageRight = [UIImage imageWithData:[tempDict objectForKey:@"imageRight"]];
    self.imageTop = [UIImage imageWithData:[tempDict objectForKey:@"imageTop"]];
    self.imageFront = [UIImage imageWithData:[tempDict objectForKey:@"imageFront"]];
    self.imageBack = [UIImage imageWithData:[tempDict objectForKey:@"imageBack"]];


}

-(NSMutableDictionary*)openFileAtURL:(NSString*)fileName error:(NSError **)outError {
    
    NSLog(@"open file at URL %@ ", fileName);
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSURL *cloudURL = [appDelegate applicationCloudFolder:fileName];
    NSData *data = [NSData dataWithContentsOfURL:cloudURL];

    tempDict = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:outError];
    
    self.techniqueName = [tempDict objectForKey:@"techniqueName"];
    self.uuid = [tempDict objectForKey:@"uuid"];
    self.maleFemale = [tempDict objectForKey:@"maleFemale"];
    self.note = [tempDict objectForKey:@"note"];
    self.favorite = [tempDict objectForKey:@"favorite"];
    NSLog(@"test singleton %@, %@, %@ ", self.techniqueName, self.uuid, self.maleFemale);

    
    
    
    self.imageLeft = [UIImage imageWithData:[tempDict objectForKey:@"imageLeft"]];
    self.imageRight = [UIImage imageWithData:[tempDict objectForKey:@"imageRight"]];
    self.imageTop = [UIImage imageWithData:[tempDict objectForKey:@"imageTop"]];
    self.imageFront = [UIImage imageWithData:[tempDict objectForKey:@"imageFront"]];
    self.imageBack = [UIImage imageWithData:[tempDict objectForKey:@"imageBack"]];
    return tempDict;
}


-(void)saveDiagramToFile:(NSString*)techniqueName{
    
    NSLog(@"name is %@ ", techniqueName);
    NSMutableString * exportingFileName = [techniqueName mutableCopy];
    [exportingFileName appendString:@".htapp"];
    
    NSArray *sysPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirectory = [sysPaths objectAtIndex:0];
    NSString *filePath = [docDirectory stringByAppendingPathComponent:exportingFileName];
    NSData * data = [self dataOfType];

    // Save it into file system
    [data writeToFile:filePath atomically:YES];
}

-(void)saveDiagramToCloud:(NSString*)techniqueName{
    NSMutableString * fileName = [techniqueName mutableCopy];
    [fileName appendString:@".htapp"];
    
    AppDelegate *myAppDelegate = (AppDelegate *) [UIApplication
                                                  sharedApplication].delegate;
    NSURL *cloudFile = [myAppDelegate applicationCloudFolder:fileName];
    
    
    NSData * data = [self dataOfType];
    [data writeToURL:cloudFile atomically:YES];
    NSLog(@"Data saved to cloud %@", cloudFile);
}

- (NSData *)dataOfType{
    NSError *error = nil;
 
        //NSMutableDictionary* dictToSave = [[[NSUserDefaults standardUserDefaults] objectForKey:@"temporaryDictionary"] mutableCopy];

          //Return the archived data
        return [NSKeyedArchiver archivedDataWithRootObject:tempDict requiringSecureCoding:NO error:&error];
}
@end
