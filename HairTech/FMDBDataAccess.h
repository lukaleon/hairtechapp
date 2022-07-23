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

@interface FMDBDataAccess : NSObject
{
    
}

-(NSMutableArray *) getCustomers;
-(NSMutableArray *) getBrands;

-(BOOL) insertCustomer:(Technique *) customer;
-(BOOL) deleteCustomer:(Technique *) customer;
-(BOOL) updateCustomer:(Technique *) customer;

@end
