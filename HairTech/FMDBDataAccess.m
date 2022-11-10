//
//  FMDBDataAccess.m
//  Chanda
//
//  Created by Mohammad Azam on 10/25/11.
//  Copyright (c) 2011 HighOnCoding. All rights reserved.
//

#import "FMDBDataAccess.h"


@implementation FMDBDataAccess


-(BOOL) updateCustomer:(Technique *)customer
{
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    
    [db open];
    
    BOOL success = [db executeUpdate:[NSString stringWithFormat:@"UPDATE TECHNIQUES SET TECHNIQUENAME = '%@', DATA = '%@',TECHNIQUEIMAGE = '%@',TECHNIQUENAMETHUMB1 = '%@',TECHNIQUENAMETHUMB2 = '%@',TECHNIQUENAMETHUMB3 = '%@',TECHNIQUENAMETHUMB4 = '%@',TECHNIQUENAMETHUMB5 = '%@',TECHNIQUENAMEBIG1 = '%@',TECHNIQUENAMEBIG2 = '%@',TECHNIQUENAMEBIG3 = '%@',TECHNIQUENAMEBIG4 = '%@',TECHNIQUENAMEBIG5 = '%@',", customer.techniquename,customer.date,customer.techniqueimage,customer.techniqueimagethumb1,customer.techniqueimagethumb2,customer.techniqueimagethumb3,customer.techniqueimagethumb4,customer.techniqueimagethumb5,customer.techniqueimagebig1,customer.techniqueimagebig2,customer.techniqueimagebig3,customer.techniqueimagebig4,customer.techniqueimagebig5]];
    
    [db close];
    
    return success; 
}


-(BOOL) deleteCustomer:(Technique *) customer
{

    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    
    [db open];
    
//BOOL success =   [db executeUpdate:@"DELETE FROM customers WHERE id = ?", [NSNumber numberWithInt:customer.customerId]];
    NSLog(@"DELETE_FROM_DATABASE BY id = %d",customer.techniqueId);
    
    

    
    BOOL success =   [db executeUpdate:@"DELETE FROM TECHNIQUES WHERE id = ?",[NSNumber numberWithInt:customer.techniqueId]];

    [db close];
    
    return success;
    
return YES;
}

-(BOOL) insertCustomer:(Technique *) customer
{
    // insert customer into database
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    [db open];
    
    BOOL success =  [db executeUpdate:@"INSERT INTO TECHNIQUES (TECHNIQUENAME,DATE,TECHNIQUEIMAGE,TECHNIQUENAMETHUMB1,TECHNIQUENAMETHUMB2,TECHNIQUENAMETHUMB3,TECHNIQUENAMETHUMB4,TECHNIQUENAMETHUMB5,TECHNIQUENAMEBIG1,TECHNIQUENAMEBIG2,TECHNIQUENAMEBIG3,TECHNIQUENAMEBIG4,TECHNIQUENAMEBIG5) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?);",
                     customer.techniquename,customer.date,customer.techniqueimage,customer.techniqueimagethumb1,customer.techniqueimagethumb2,customer.techniqueimagethumb3,customer.techniqueimagethumb4,customer.techniqueimagethumb5,customer.techniqueimagebig1,customer.techniqueimagebig2,customer.techniqueimagebig3,customer.techniqueimagebig4,customer.techniqueimagebig5, nil];
    
    [db close];
    
    return success; 
    
    return YES; 
}

//-(void)insertColumn:(Technique*)customer{
//    BOOL success;
//     
//    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
//    if (![db open])
//    {
//        NSLog(@"open failed");
//        return;
//    }
//    if (![db columnExists:@"version" inTableWithName:@"TECHNIQUES"])
//    {
//        success = [db executeUpdate:@"ALTER TABLE TECHNIQUES ADD COLUMN version TEXT"];
//        NSAssert(success, @"alter table failed: %@", [db lastErrorMessage]);
//    }
////    NSString *insertSQL = @"INSERT INTO TECHNIQUES (version) VALUE (?)";
////    success = [db executeUpdate:insertSQL,customer.version];
////    NSAssert(success, @"insert failed: %@", [db lastErrorMessage]);
//     
//    [db close];
//}

-(NSMutableArray *) getCustomers
{
    NSMutableArray *techniques = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    
    [db open];
    
   // FMResultSet *results = [db executeQuery:@"SELECT * FROM customers"];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM TECHNIQUES ORDER BY TECHNIQUENAME"];
  
    while([results next])

    {
        Technique *technique = [[Technique alloc] init];
        
        technique.techniqueId = [results intForColumn:@"id"];
        technique.techniquename = [results stringForColumn:@"TECHNIQUENAME"];
        technique.date = [results stringForColumn:@"DATE"];
        technique.techniqueimage = [results stringForColumn:@"TECHNIQUEIMAGE"];
        technique.techniqueimagethumb1 = [results stringForColumn:@"TECHNIQUENAMETHUMB1"];
        technique.techniqueimagethumb2 = [results stringForColumn:@"TECHNIQUENAMETHUMB2"];
        technique.techniqueimagethumb3 = [results stringForColumn:@"TECHNIQUENAMETHUMB3"];
        technique.techniqueimagethumb4 = [results stringForColumn:@"TECHNIQUENAMETHUMB4"];
        technique.techniqueimagethumb5 = [results stringForColumn:@"TECHNIQUENAMETHUMB5"];
        technique.techniqueimagebig1 = [results stringForColumn:@"TECHNIQUENAMEBIG1"];
        technique.techniqueimagebig2 = [results stringForColumn:@"TECHNIQUENAMEBIG2"];
        technique.techniqueimagebig3 = [results stringForColumn:@"TECHNIQUENAMEBIG3"];
        technique.techniqueimagebig4 = [results stringForColumn:@"TECHNIQUENAMEBIG4"];
        technique.techniqueimagebig5 = [results stringForColumn:@"TECHNIQUENAMEBIG5"];
        [techniques addObject:technique];
        
    }
    
    [db close];
  
    return techniques;

}


-(void)insertColumnTime{
    BOOL success;

    FMDatabase *db = [FMDatabase databaseWithPath:[Utility getDatabasePath]];
    if (![db open])
    {
        NSLog(@"open failed");
        return;
    }

    if (![db columnExists:@"time" inTableWithName:@"TECHNIQUES"])
    {
        success = [db executeUpdate:@"ALTER TABLE TECHNIQUES ADD COLUMN time TEXT"];
        NSAssert(success, @"alter table failed: %@", [db lastErrorMessage]);
    }

//    NSString *insertSQL = @"INSERT INTO  TECHNIQUES  (time)  VALUES (?)";
//    success = [db executeUpdate:insertSQL, @"2022"];
//    NSAssert(success, @"insert failed: %@", [db lastErrorMessage]);

    [db close];
    
}
@end
