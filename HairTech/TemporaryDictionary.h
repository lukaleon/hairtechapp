//
//  NSMutableDictionary+temporaryDictionary.h
//  hairtech
//
//  Created by Alexander Prent on 06.01.2023.
//  Copyright © 2023 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface  TemporaryDictionary : NSMutableDictionary
{
    
}
@property UIImage *imageEntry;
@property UIImage *imageLeft;
@property UIImage *imageRight;
@property UIImage *imageTop;
@property UIImage *imageFront;
@property UIImage *imageBack;

@property NSDictionary * dictLeft;
@property NSDictionary * dictRight;
@property NSDictionary * dictTop;
@property NSDictionary * dictFront;
@property NSDictionary * dictBack;

@property NSString * unID;
@property NSString * techName;
@property NSString * maleFemale;

@end

NS_ASSUME_NONNULL_END
