//
//  City.m
//  gestureR
//
//  Created by zhou on 16/7/12.
//  Copyright © 2016年 dev8. All rights reserved.
//

#import "City.h"

@implementation City

-(instancetype)initWithName:(NSString *)name{
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

+(City *)cities{
    City *city1 = [[City alloc] initWithName:@"中国"];
    
    City *city2 = [[City alloc] initWithName:@"浙江"];
    City *city3 = [[City alloc] initWithName:@"四川"];
    City *city4 = [[City alloc] initWithName:@"广东"];
    City *city5 = [[City alloc] initWithName:@"河北"];
    
    City *city6 = [[City alloc] initWithName:@"宁波"];
    City *city7 = [[City alloc] initWithName:@"杭州"];
    City *city8 = [[City alloc] initWithName:@"温州"];
    
    City *city9 = [[City alloc] initWithName:@"成都"];
    City *city10 = [[City alloc] initWithName:@"南充"];
    City *city11 = [[City alloc] initWithName:@"攀枝花"];
    City *city12 = [[City alloc] initWithName:@"绵阳"];
    
    City *city13 = [[City alloc] initWithName:@"西湖"];
    City *city14 = [[City alloc] initWithName:@"萧山"];
    City *city15 = [[City alloc] initWithName:@"滨江"];
    City *city16 = [[City alloc] initWithName:@"淳安"];
    
    City *city17 = [[City alloc] initWithName:@"水流"];
    City *city18 = [[City alloc] initWithName:@"仪兴"];
    City *city19 = [[City alloc] initWithName:@"南效"];
    City *city20 = [[City alloc] initWithName:@"定充"];
    City *city21 = [[City alloc] initWithName:@"工程"];
    
    City *city22 = [[City alloc] initWithName:@"高兴"];
    City *city23 = [[City alloc] initWithName:@"高水"];
    City *city24 = [[City alloc] initWithName:@"高山"];
    
    City *city25 = [[City alloc] initWithName:@"小二"];
    City *city26 = [[City alloc] initWithName:@"张三"];
    
    City *city27 = [[City alloc] initWithName:@"one"];
    City *city28 = [[City alloc] initWithName:@"two"];
    City *city29 = [[City alloc] initWithName:@"three"];
    City *city30 = [[City alloc] initWithName:@"four"];
    City *city31 = [[City alloc] initWithName:@"five"];
    City *city32 = [[City alloc] initWithName:@"six"];
    City *city33 = [[City alloc] initWithName:@"seven"];
    City *city34 = [[City alloc] initWithName:@"eight"];
    City *city35 = [[City alloc] initWithName:@"nine"];
    City *city36 = [[City alloc] initWithName:@"ten"];
    City *city37 = [[City alloc] initWithName:@"eleven"];
    City *city38 = [[City alloc] initWithName:@"twule"];
    City *city39 = [[City alloc] initWithName:@"thirteen"];
    
    city1.subCities = @[city2, city4, city5, city3, city27, city28, city29, city30, city31, city32, city33, city34, city35, city36, city37, city38, city39];
    city2.subCities = @[city6, city7, city8];
    city3.subCities = @[city9, city10, city11, city12];
    city7.subCities = @[city13, city14, city15, city16];
    city9.subCities = @[city17, city18, city19, city20, city21];
    city17.subCities = @[city22, city23, city24];
    city22.subCities = @[city25, city26];
    
    return city1;
}

@end
