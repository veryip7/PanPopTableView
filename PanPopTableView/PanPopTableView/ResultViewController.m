//
//  ResultViewController.m
//  gestureR
//
//  Created by zhou on 16/7/13.
//  Copyright © 2016年 dev8. All rights reserved.
//

#import "ResultViewController.h"

@implementation ResultViewController

-(instancetype)init{
    if (self = [super init]) {
        self.title = @"最张页面";
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 250, 50)];
    lb.backgroundColor = [UIColor clearColor];
    lb.text = @"欢迎来到空白页";
    [self.view addSubview:lb];
}

@end
