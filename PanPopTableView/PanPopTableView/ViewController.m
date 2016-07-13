//
//  ViewController.m
//  gestureR
//
//  Created by zhou on 16/7/12.
//  Copyright © 2016年 dev8. All rights reserved.
//

#import "ViewController.h"
#import "PanPopTableView.h"
#import "City.h"
#import "ResultViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>{
    PanPopTableView *listView;
    CGRect frame;
    City *city;
    NSArray *currentCitys;
    
    NSMutableArray *stackCities;
}

@end

@implementation ViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.title = @"中国区域";
    }
    return self;
}

//使用重点用//--------------!!!!!!!!!!!!!!标出
//最大的层级是(瞎编的)：中国 > 四川 > 成都 > 水流 > 高兴 > 小二
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    [backButton setImage:[UIImage imageNamed:@"wp_nav_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"wp_nav_back_sel"] forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    frame = self.view.frame;
    frame.size.height -= 64;
    city = [City cities];
    currentCitys = @[city];
    stackCities = [NSMutableArray array];
    
    listView = [[PanPopTableView alloc] initWithFrame:frame];
    __weak typeof(self) weakSelf = self;
    listView.popReturn = ^(){
        [weakSelf backButtonClick:nil];//--------------!!!!!!!!!!!!!!
    };
    listView.delegate = self;
    listView.dataSource = self;
    [self.view addSubview:listView];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {//--------------!!!!!!!!!!!!!!
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [listView setIsEnableSystemPopReturn];//--------------!!!!!!!!!!!!!!
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {//--------------!!!!!!!!!!!!!!
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(void)backButtonClick:(UIButton *)sender{
    [listView frontPage];//--------------!!!!!!!!!!!!!!
    if (stackCities.count != 0) {
        currentCitys = [stackCities lastObject];
        [listView reloadData];
        [stackCities removeLastObject];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return currentCitys.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
    }
    City *c = currentCitys[indexPath.row];
    cell.textLabel.text = c.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    City *c = currentCitys[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (c.subCities) {
        [stackCities addObject:currentCitys];
        currentCitys = c.subCities;
        [listView reloadData];
    }else{
        ResultViewController *reVC = [[ResultViewController alloc] init];
        [self.navigationController pushViewController:reVC animated:YES];
    }
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    City *c = currentCitys[indexPath.row];
    if (c.subCities) {
        [listView nextPage];//--------------!!!!!!!!!!!!!!
    }
    return indexPath;
}

@end
