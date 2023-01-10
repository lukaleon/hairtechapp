//
//  NSMutableDictionary+temporaryDictionary.m
//  hairtech
//
//  Created by Alexander Prent on 06.01.2023.
//  Copyright © 2023 Admin. All rights reserved.
//

#import "TemporaryDictionary.h"

@implementation TemporaryDictionary


-(void)storeDataInTemporaryDictionary:(NSData*)data error:(NSError **)outError{
   
        NSDictionary *readDict =
        [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class] fromData:data error:outError];
        
        self.imageEntry = [readDict objectForKey:@"imageEntry"];
        self.imageLeft = [readDict objectForKey:@"imageLeft"];
        self.imageRight = [readDict objectForKey:@"imageRight"];
        self.imageTop = [readDict objectForKey:@"imageTop"];
        self.imageFront = [readDict objectForKey:@"imageFront"];
        self.imageBack = [readDict objectForKey:@"imageBack"];

        self.dictLeft = [readDict objectForKey:@"jsonLeft"];
        self.dictRight = [readDict objectForKey:@"jsonRight"];
        self.dictTop = [readDict objectForKey:@"jsonTop"];
        self.dictFront = [readDict objectForKey:@"jsonFront"];
        self.dictBack = [readDict objectForKey:@"jsonBack"];
    
        self.unID = [readDict objectForKey:@"uuid"];
        self.techName = [readDict objectForKey:@"techniqueName"];
        self.maleFemale = [readDict objectForKey:@"maleFemale"];

}

@end
