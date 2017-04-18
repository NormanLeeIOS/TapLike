//
//  FlyFlowersView.m
//  TapLike
//
//  Created by 李亚坤 on 2017/4/17.
//  Copyright © 2017年 NoramanLee. All rights reserved.
//

#import "FlyFlowersView.h"

@interface FlyFlowersView () <CAAnimationDelegate>

@property (nonatomic, strong) UIImageView *flower;
@property (nonatomic, copy)   NSArray *imageStrArr;

@end

@implementation FlyFlowersView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSInteger index = [[self getRandomNumberFrom:0 to:4 times:1] integerValue];
        _flower = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imageStrArr[index]]];
        [_flower setFrame:CGRectMake(0, 0, 36, 36)];
        [self addSubview:_flower];
    }
    return self;
}

- (NSArray *)imageStrArr
{
    if (!_imageStrArr) {
        _imageStrArr = [NSArray arrayWithObjects:@"kuaile", @"shoucang", @"shoushi", @"xingxing", @"good", nil];
    }
    return _imageStrArr;
}

- (void)startAnimateWithAnimator:(UIDynamicAnimator *)animator
{
    // 重力
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] init];
    gravity.magnitude = 0.1;
    [gravity addItem:self];
    [animator addBehavior:gravity];
    
    // 初速度
    NSNumber *dxAngle = [self getRandomNumberFrom:-300 to:200 times:0.01];
    NSNumber *magnitude = [self getRandomNumberFrom:400 to:500 times:0.001];
    UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[self] mode:UIPushBehaviorModeInstantaneous];
    push.active = YES;
    push.pushDirection = CGVectorMake([dxAngle doubleValue], -15.0f);
    push.magnitude = [magnitude doubleValue];
    [animator addBehavior:push];
    
    // 消失
    NSNumber *duration = [self getRandomNumberFrom:50 to:100 times:0.01];
    CAKeyframeAnimation *dismis = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    dismis.values = @[@1.0, @0.5, @0];
    dismis.keyTimes = @[@0, @0.8, @1.0];
    dismis.duration = [duration doubleValue];
    dismis.repeatCount = 1;
    dismis.fillMode = kCAFillModeBoth;
    dismis.removedOnCompletion = NO;
    dismis.delegate = self;
    [self.layer addAnimation:dismis forKey:@"dismiss"];
    
    // 旋转
    NSNumber *angle = [self getRandomNumberFrom:-314 to:314 times:0.01];
    CAKeyframeAnimation *rotate = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.values = @[@0, angle];
    rotate.keyTimes = @[@0, @1.0];
    rotate.duration = 2;
    rotate.repeatCount = 1;
    rotate.fillMode = kCAFillModeBoth;
    rotate.removedOnCompletion = NO;
    [self.layer addAnimation:rotate forKey:@"rotate"];
    
    // 放大
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.values = @[@0.5, @1];
    scale.keyTimes = @[@0, @1.0];
    scale.duration = [duration doubleValue];
    scale.repeatCount = 1;
    scale.fillMode = kCAFillModeBoth;
    scale.removedOnCompletion = NO;
    [self.layer addAnimation:scale forKey:@"scale"];
}

- (NSNumber *)getRandomNumberFrom:(NSInteger)from
                               to:(NSInteger)to
                            times:(double)times
{
    return @((from + arc4random() % (to - from + 1)) * times);
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([anim isEqual:[self.layer animationForKey:@"dismiss"]]) {
        [self removeFromSuperview];
    }
}

@end
