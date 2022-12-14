//
//  FMDBDataAccess.h
//  Chanda
//
//  Created by Mohammad Azam on 10/25/11.
//  Copyright (c) 2011 HighOnCoding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h" 
#import "FMResultSet.h" 
#import "Utility.h" 
#import "Technique.h"
#import "FMDatabaseAdditions.h"

@interface FMDBDataAccess : NSObject
{
    
}

-(NSMutableArray *) getCustomers;
-(NSMutableArray *) getBrands;

-(BOOL) insertCustomer:(Technique *) customer;
-(BOOL) deleteCustomer:(Technique *) customer;
-(BOOL) updateCustomer:(Technique *) customer;
-(void) insertColumnUUID:(NSString*)uniqueID;
//-(void) insertColumn:(Technique *) customer;

@end
