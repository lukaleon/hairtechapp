//
//  NSObject+LayersData.h
//  hairtech
//
//  Created by Alexander Prent on 29.09.2022.
//  Copyright © 2022 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LayersData : NSObject
@property (assign, nonatomic) NSString * layerID;

@property (assign, nonatomic) CGPoint startPoint;
@property (assign, nonatomic) CGPoint endPoint;
@property (assign, nonatomic) CGPoint controlPoint;
@property (strong, nonatomic) UIColor * color;
@property (assign, nonatomic) CGFloat lineWidth;
@property (assign, nonatomic) CGFloat fontSize;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) NSString * text;
@property (assign, nonatomic) NSString * type;
@property (assign, nonatomic) NSArray * grafittiPoints;
@property (assign, nonatomic) NSString * imageDirection;


@end

NS_ASSUME_NONNULL_END
