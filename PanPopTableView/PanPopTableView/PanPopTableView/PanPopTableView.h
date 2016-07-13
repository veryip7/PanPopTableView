//
//  PanPopTableView.h
//  gestureR
//
//  Created by zhou on 16/7/12.
//  Copyright © 2016年 dev8. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *iOS7.0以上有效，iOS7.0以下没有滑动返回效果，如果要禁用，可以在tableView初始化时不设置popReturn回调block。
 */
@interface PanPopTableView : UITableView

/*
 *当进入当前tableView的下一页数据时调用该方法，用以添加相关数据及设置等，当通过tableView:didSelectRowAtIndexPath:方法进入下一页数据显示时，它最好在下面这个代理方法中被调用，以防止返回时会看到cell选中的颜色。
 *-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 *  if(符合进入下一页的条件){
 *      [listTableView nextPage];
 *  }
 *  return indexPath;
 *}
 */
-(void)nextPage;

/*
 *当返回上一页数据时(如点击返回按钮或滑动返回)，需要调用该方法以通知tableView删除相应数据及设置，或者当加载下一页时调用了nextPage方法，但是由于最终数据加载失败，没能成功进入下一页时，也需要调用该方法清除数据。
 */
-(void)frontPage;

/*
 *初始化tableView时，需要设置该block，以实现滑动返回时刷新数据，不设置则不能滑动返回，它里面可以直接调用点击返回按钮刷新数据所做的操作。
 */
@property(nonatomic, copy) void(^popReturn)();

/*
 *关于系统的滑动返回
 *1.使用了该类的控制器，需要在viewDidLoad函数中设置代理<UIGestureRecognizerDelegate>，否则系统的滑动返回会失效，但不需要实现任何代理方法:
 *  __weak typeof (self) weakSelf = self;
 *  if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
 *      self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
 *  }
 *2.在当前界面通过push方法进入下一页面时，由于在当前界面，系统的滑动返回可能处理禁用状态，因此需要在viewWillDisappear(最好在此方法中)启用系统滑动返回：
 *  if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
 *      self.navigationController.interactivePopGestureRecognizer.enabled = YES;
 *  }
 *3.当通过pop方法移除控制器进入当前页面时，需要在viewDidAppear(一定要在此方法中)中调用该方法，自动设置是否需要禁用系统的滑动返回。
 */
-(void)setIsEnableSystemPopReturn;

@end
