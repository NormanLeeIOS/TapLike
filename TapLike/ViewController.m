//
//  ViewController.m
//  TapLike
//
//  Created by 李亚坤 on 2017/4/16.
//  Copyright © 2017年 NoramanLee. All rights reserved.
//

#import "ViewController.h"
#import "FlyFlowersView.h"
#import "TapLikeView.h"

#define FLOWERWIDTH 36.0

@interface ViewController () <TapLikeViewDelegate>
@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic, strong) TapLikeView *tapLikeView;

@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.tapLikeView];
}


#pragma mark - property

- (TapLikeView *)tapLikeView
{
    if (!_tapLikeView) {
        _tapLikeView = [[TapLikeView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 80.0,
                                                                    self.view.frame.size.height - 80.0,
                                                                    60.0,
                                                                    60.0)];
        _tapLikeView.delegate = self;
    }
    return _tapLikeView;
}

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        //创建物理仿真器（ReferenceView:参照视图，设置仿真范围）
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}

#pragma mark - TapLikeViewDelegate

- (void)showTheLoveWithTap
{
    FlyFlowersView *heart = [[FlyFlowersView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-50.0-FLOWERWIDTH/2.0,
                                                                             self.view.frame.size.height-90.0-FLOWERWIDTH/2.0,
                                                                             FLOWERWIDTH,
                                                                             FLOWERWIDTH)];
    [self.view addSubview:heart];
    [heart startAnimateWithAnimator:self.animator];
}

- (void)showTheLoveWithPress
{
    
}

@end
