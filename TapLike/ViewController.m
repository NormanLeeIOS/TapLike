//
//  ViewController.m
//  TapLike
//
//  Created by 李亚坤 on 2017/4/16.
//  Copyright © 2017年 NoramanLee. All rights reserved.
//

#import "ViewController.h"
#import "DMHeartFlyView.h"
#import "FlyFlowersView.h"

@interface ViewController ()

@property (nonatomic, assign) CGFloat heartSize;
@property (nonatomic, strong) NSTimer *burstTimer;
@property (nonatomic, strong) UIDynamicAnimator *animator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.heartSize = 36;
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showTheLove)];
    [self.view addGestureRecognizer:tapGesture];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(longPressGesture:)];
    longPressGesture.minimumPressDuration = 0.2;
    [self.view addGestureRecognizer:longPressGesture];
}


#pragma mark - property

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        //创建物理仿真器（ReferenceView:参照视图，设置仿真范围）
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    }
    return _animator;
}

#pragma mark - method

- (void)showTheLove
{
    
//    DMHeartFlyView* heart = [[DMHeartFlyView alloc]initWithFrame:CGRectMake(0, 0, _heartSize, _heartSize)];
//    [self.view addSubview:heart];
//    CGPoint fountainSource = CGPointMake(20 + _heartSize/2.0, self.view.bounds.size.height - _heartSize/2.0 - 10);
//    heart.center = fountainSource;
//    [heart animateInView:self.view];

    FlyFlowersView *heart = [[FlyFlowersView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60.0,
                                                                             self.view.frame.size.height - 60.0,
                                                                             self.heartSize,
                                                                             self.heartSize)];
    [self.view addSubview:heart];
    [heart startAnimateWithAnimator:self.animator];
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)longPressGesture
{
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
            self.burstTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                               target:self
                                                             selector:@selector(showTheLove)
                                                             userInfo:nil
                                                              repeats:YES];
            break;
        case UIGestureRecognizerStateEnded:
            [self.burstTimer invalidate];
            self.burstTimer = nil;
            break;
        default:
            break;
    }
}

@end
