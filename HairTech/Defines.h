//
//  Defines.h
//  UIViewLifeCycleExample
//
//  Created by Paul Taykalo on 10/10/11.
//  Copyright 2011 Stanfy. All rights reserved.
//

#import <Foundation/Foundation.h>

#define METHOD_INFO NSLog(@"%@", [NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding]);

#define SIMULATE_MEMORY_WARNING    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]]



