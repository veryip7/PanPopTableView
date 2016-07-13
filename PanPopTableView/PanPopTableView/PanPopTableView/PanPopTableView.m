//
//  PanPopTableView.m
//  gestureR
//
//  Created by zhou on 16/7/12.
//  Copyright © 2016年 dev8. All rights reserved.
//

#import "PanPopTableView.h"

#define POSFACTOR 4.0
#define POPLEFT 40
#define SHADOWVIEWMAXALPHA 0.12
#define CURIMGLEFTALPHA 0.3
#define LEFTOFFSET 25

@interface PanPopTableView ()<UIGestureRecognizerDelegate>{
    UIPanGestureRecognizer *panGesture;
    NSUInteger panHash;//通过hash识别手势
    CGPoint panStart;//记录pan手势开始的坐标点
    BOOL isPop;//是否是滑动返回
    BOOL isTable;//是否是tableView在滚动
    UIImageView *originImg;//滑动返回时，左边底部显示的图片，由screenshotOfSelf取得。
    UIView *shadowView;//originImg上的透明层
    NSMutableArray *stackInfo;//info栈，保存上一页的数据截图，以及contentOffset信息。
    UIImageView *curImg;//滑动返回时，使用当前截图，否者，tableView在设置frame的过程中抖动厉害。
    CGFloat contentOffsetY;//记录上一页的contentOffset的Y值
    CGFloat systemVersion;
}

@end

@implementation PanPopTableView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCommonUI];
    }
    return self;
}

-(void)setIsEnableSystemPopReturn{
    if (systemVersion < 7.0 || !self.popReturn) {
        if (stackInfo) {
            [stackInfo removeAllObjects];
        }
        return;
    }
    BOOL isFirstPage = stackInfo.count > 0 ? NO : YES;
    id delegateController = self.delegate;
    UINavigationController *navi = nil;
    if (delegateController) {
        if ([delegateController isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = (UIViewController *)delegateController;
            navi = vc.navigationController;
        }else if([delegateController isKindOfClass:[UINavigationController class]]){
            navi = (UINavigationController *)delegateController;
        }else{
            return;
        }
        if ([navi respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            navi.interactivePopGestureRecognizer.enabled = isFirstPage;
        }
    }
}

-(void)nextPage{
    if (systemVersion < 7.0 || !self.popReturn) {
        if (stackInfo) {
            [stackInfo removeAllObjects];
        }
        return;
    }
    UIView *superView = [self superview];
    if (superView && originImg.tag != 111) {
        originImg.tag = 111;
        [superView insertSubview:originImg aboveSubview:self];
        [superView insertSubview:curImg aboveSubview:originImg];
    }
    UIImage *image = [self screenshotOfSelf];
    NSNumber *offsetY = [NSNumber numberWithFloat:self.contentOffset.y];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:image, @"oldImage", offsetY, @"contentOffsetY", nil];
    [stackInfo addObject:info];
    originImg.image = image;
    [self setIsEnableSystemPopReturn];
}

-(void)frontPage{
    if (systemVersion < 7.0 || !self.popReturn) {
        if (stackInfo) {
            [stackInfo removeAllObjects];
        }
        return;
    }
    if (stackInfo.count > 0) {
        [stackInfo removeLastObject];
    }
    [self setIsEnableSystemPopReturn];//移除后，启用或禁用滑动返回
}

-(UIImage *)screenshotOfSelf{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);//YES表示不可见部分不透明
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        CGRect rect = self.frame;
        rect.origin.y = 0;
        rect.origin.x = 0;
        [self drawViewHierarchyInRect:rect afterScreenUpdates:YES];//用self.bounds有问题
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)addShowdowToView:(UIView *)view{
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:CURIMGLEFTALPHA].CGColor;//最大透明度为CURIMGLEFTALPHA
    view.layer.shadowOffset = CGSizeMake(-7, 2);
    view.layer.shadowOpacity = 0.4f;
    view.layer.shadowRadius = 2.0f;
}

-(void)initCommonUI{
    systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion < 7.0) {
        return;
    }
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pop:)];
    [self addGestureRecognizer:panGesture];
    panHash = panGesture.hash;
    panGesture.delegate = self;
    isPop = NO;
    isTable = NO;
    stackInfo = [NSMutableArray array];
    
    CGRect frame = self.frame;
    frame.origin.x = -frame.size.width / POSFACTOR;
    originImg = [[UIImageView alloc] initWithFrame:frame];
    originImg.hidden = YES;
    shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    shadowView.backgroundColor = [UIColor blackColor];
    shadowView.alpha = SHADOWVIEWMAXALPHA;
    [originImg addSubview:shadowView];
    
    curImg = [[UIImageView alloc] initWithFrame:self.frame];
    [self addShowdowToView:curImg];
}

-(void)pop:(UIPanGestureRecognizer *)gr{
    if (stackInfo.count == 0 || !self.popReturn) {
        return;
    }
    CGPoint endPoint = [gr locationInView:self];
    if (gr.state == UIGestureRecognizerStateBegan) {
        panStart = [gr locationInView:self];
        isPop = NO;
        isTable = NO;
        CGRect frame = self.frame;
        frame.origin.x = -frame.size.width / POSFACTOR;
        originImg.frame = frame;
        originImg.image = nil;
        curImg.frame = self.frame;
        curImg.image = nil;
    }else if(gr.state == UIGestureRecognizerStateEnded){
        panStart = CGPointZero;
        isTable = NO;
        self.scrollEnabled = YES;
        if (isPop) {
            isPop = NO;
            [self endAnimation:endPoint];
        }
    }else if(gr.state == UIGestureRecognizerStateChanged){
        CGFloat xDis = endPoint.x - panStart.x;
        CGFloat yDis = endPoint.y > panStart.y ? endPoint.y - panStart.y : panStart.y - endPoint.y;
        CGFloat factor = xDis == 0 ? 0 : yDis / xDis;
        if ((panStart.x < POPLEFT && xDis > 2 && factor < 1 && !isTable) || isPop) {
            if (isPop) {
                [self dealPopAnimation:endPoint];
            }else{
                isPop = YES;
                self.scrollEnabled = NO;
                curImg.hidden = NO;
                curImg.image = [self screenshotOfSelf];
                originImg.hidden = NO;
                originImg.image = [stackInfo lastObject][@"oldImage"];
            }
        }else if(panStart.x < POPLEFT && factor >= 1 && !isPop){
            isTable = YES;
        }
    }
}

-(void)dealPopAnimation:(CGPoint)endPoint{
    CGRect curFrame = curImg.frame;
    curFrame.origin.x = endPoint.x - LEFTOFFSET;
    curImg.frame = curFrame;
    
    CGRect originImgFrame = originImg.frame;
    originImgFrame.origin.x = (endPoint.x - self.frame.size.width) / POSFACTOR;
    originImg.frame = originImgFrame;
    
    //移动过程中阴影变化
    CGFloat factor = 1 - endPoint.x / self.frame.size.width;
    CGFloat alpha = SHADOWVIEWMAXALPHA * factor;//最大透明度为SHADOWVIEWMAXALPHA
    shadowView.alpha = alpha;
    CGFloat curImgLeftAlpha = CURIMGLEFTALPHA * factor;
    curImg.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:curImgLeftAlpha].CGColor;
}

-(void)endAnimation:(CGPoint)endPoint{
    if (endPoint.x < self.frame.size.width / 2.0 + LEFTOFFSET) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            curImg.frame = self.frame;
        } completion:^(BOOL finished) {
            [self completeHide];
        }];
    }else{
        NSNumber *offsetY = [stackInfo lastObject][@"contentOffsetY"];
        contentOffsetY = [offsetY floatValue];
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect rect = curImg.frame;
            rect.origin.x = self.frame.size.width;
            curImg.frame = rect;
            shadowView.alpha = 0;
            CGRect oRect = originImg.frame;
            oRect.origin.x = 0;
            originImg.frame = oRect;
            if (self.popReturn) {
                self.popReturn();
            }
            [self setContentOffset:CGPointMake(0, contentOffsetY)];
        } completion:^(BOOL finished) {
            [self layoutIfNeeded];
            [self completeHide];
        }];
    }
}

-(void)completeHide{
    originImg.hidden = YES;
    curImg.hidden = YES;
    curImg.image = nil;
}

#pragma -mark UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (gestureRecognizer.hash == panHash) {
        return YES;
    }else{
        return NO;
    }
}

@end
