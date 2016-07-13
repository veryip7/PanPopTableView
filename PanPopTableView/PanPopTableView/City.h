//
//  City.h
//  gestureR
//
//  Created by zhou on 16/7/12.
//  Copyright © 2016年 dev8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSArray *subCities;

+(City *)cities;

@end
