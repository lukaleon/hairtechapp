//
//  CloudKitManager.m
//  CloudKit-demo
//
//  Created by Maksim Usenko on 3/16/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

#import "CloudKitManager.h"
#import <CloudKit/CloudKit.h>
#import <UIKit/UIKit.h>
#import "Technique.h"

NSString * const kTechniquesRecord = @"Techniques";

@implementation CloudKitManager

+ (CKDatabase *)publicCloudDatabase {
    return  [[CKContainer containerWithIdentifier:@"iCloud.com.hair.hairtech"] publicCloudDatabase];

}

// Retrieve existing records
+ (void)fetchAllTechniquesWithCompletionHandler:(CloudKitCompletionHandler)handler {
    
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    CKQuery *query = [[CKQuery alloc] initWithRecordType:kTechniquesRecord predicate:predicate];
    
    [[self publicCloudDatabase] performQuery:query
                                inZoneWithID:nil
                           completionHandler:^(NSArray *results, NSError *error) {
        
                               if (!handler) return;
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   handler ([self arrayOfTechniques:results], error);
                               });
    }];
}

// add a new record
+ (void)createRecord:(NSData *)recordDic  recordID:(NSString*)recordUUID completionHandler:(CloudKitCompletionHandler)handler {
    
    
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:recordUUID];
    
    CKRecord *record = [[CKRecord alloc] initWithRecordType:@"Technique" recordID:recordID];
    
    
    
    
     [record setValue:recordDic forKey:@"technique"];
    
    
    
   // [[recordDic allKeys] enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        
//        if ([key isEqualToString:CloudTechniqueFields.uniqueId]) {
//            NSString *path = [[NSBundle mainBundle] pathForResource:recordDic[key] ofType:@"png"];
//            NSData *data = [NSData dataWithContentsOfFile:path];
//            record[key] = data;
//        } else {
//            record[key] = recordDic[key];
//        }
//    }];
    
    [[self publicCloudDatabase] saveRecord:record completionHandler:^(CKRecord *record, NSError *error) {
        
        if (!handler) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            handler (@[record], error);
        });
    }];
}

// updating the record by recordId
+ (void)updateRecordDataWithId:(NSString *)recordId text:(NSString *)text completionHandler:(CloudKitCompletionHandler)handler {
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:recordId];
    [[self publicCloudDatabase] fetchRecordWithID:recordID completionHandler:^(CKRecord *record, NSError *error) {
        
        if (!handler) return;
        
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler (nil, error);
            });
            return;
        }
        
        record[CloudTechniqueFields.uniqueId] = text;
        [[self publicCloudDatabase] saveRecord:record completionHandler:^(CKRecord *record, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler (@[record], error);
            });
        }];
    }];
}

// remove the record
+ (void)removeRecordWithId:(NSString *)recordId completionHandler:(CloudKitCompletionHandler)handler {
    
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:recordId];
    [[self publicCloudDatabase] deleteRecordWithID:recordID completionHandler:^(CKRecordID *recordID, NSError *error) {
        
        if (!handler) return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            handler (nil, error);
        });
    }];
}

+ (NSMutableArray *)arrayOfTechniques:(NSArray *)techniques {
    if (techniques.count == 0) return nil;
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    [techniques enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Technique *technique  = [[Technique alloc] initWithInputData:obj];
        [temp addObject:technique];
    }];
    
    return [NSMutableArray arrayWithArray:temp];
}

@end
