//
//  FirstPageViewController.m
//  gestureR
//
//  Created by zhou on 16/7/13.
//  Copyright © 2016年 dev8. All rights reserved.
//

#import "FirstPageViewController.h"
#import "ViewController.h"

@implementation FirstPageViewController

-(instancetype)init{
    if (self = [super init]) {
        self.title = @"首页";
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    nextBtn.frame = CGRectMake(50, 100, 100, 50);
    [nextBtn setTitle:@"下一页" forState:UIControlStateNormal];
    nextBtn.backgroundColor = [UIColor greenColor];
    [nextBtn addTarget:self action:@selector(nextPage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
}

-(void)nextPage:(UIButton *)sender{
    ViewController *mainVC = [ViewController new];
    [self.navigationController pushViewController:mainVC animated:YES];
}

@end
