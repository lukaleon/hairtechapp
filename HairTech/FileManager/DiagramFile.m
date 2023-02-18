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
@synthesize diagramFileDictionary;


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



-(void)storeFileDataInObject:(NSData*)data fileName:(NSString*) fileName error:(NSError **)outError {
    
    diagramFileDictionary = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:outError];
    
    self.techniqueName = fileName;
    self.uuid = [diagramFileDictionary objectForKey:@"uuid"];
    self.maleFemale = [diagramFileDictionary objectForKey:@"maleFemale"];
    self.note = [diagramFileDictionary objectForKey:@"note"];

    self.imageEntry = [UIImage imageWithData:[diagramFileDictionary objectForKey:@"imageEntry"]];
    self.imageLeft = [UIImage imageWithData:[diagramFileDictionary objectForKey:@"imageLeft"]];
    self.imageRight = [UIImage imageWithData:[diagramFileDictionary objectForKey:@"imageRight"]];
    self.imageTop = [UIImage imageWithData:[diagramFileDictionary objectForKey:@"imageTop"]];
    self.imageFront = [UIImage imageWithData:[diagramFileDictionary objectForKey:@"imageFront"]];
    self.imageBack = [UIImage imageWithData:[diagramFileDictionary objectForKey:@"imageBack"]];
    
    self.dictLeft = [diagramFileDictionary objectForKey:@"jsonLeft"];
    self.dictRight = [diagramFileDictionary objectForKey:@"jsonRight"];
    self.dictTop = [diagramFileDictionary objectForKey:@"jsonTop"];
    self.dictFront = [diagramFileDictionary objectForKey:@"jsonFront"];
    self.dictBack = [diagramFileDictionary objectForKey:@"jsonBack"];
}

-(NSData*)dataFromDictionary{
    NSError * error;
    return [NSKeyedArchiver archivedDataWithRootObject:diagramFileDictionary requiringSecureCoding:NO error:&error];
}

@end
