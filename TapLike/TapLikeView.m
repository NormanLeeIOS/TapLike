//
//  TapLikeView.m
//  TapLike
//
//  Created by 李亚坤 on 2017/4/17.
//  Copyright © 2017年 NoramanLee. All rights reserved.
//

#import "TapLikeView.h"
#import "FlyFlowersView.h"

#define TapLikeBgWith   47.0
#define TapLikeBgHeight 47.0
#define TapLikeWidth    19.0
#define TapLikeHeight   18.0

@interface TapLikeView () <CAAnimationDelegate>

@property (nonatomic, strong) UIView *tapLikeBgView;
@property (nonatomic, strong) UIImageView *tapLikeImageView;
@property (nonatomic, strong) UILabel *countNumLaber;
@property (nonatomic, assign) NSInteger countNumber;
@property (nonatomic, strong) NSTimer *burstTimer;

@end

@implementation TapLikeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        [self addResponse];
        _countNumber = 0;
        [self refreshLabelNumber:_countNumber];
    }
    return self;
}

#pragma mark - public method

- (void)setCountNumber:(NSInteger)countNumber
{
    if (_countNumber != countNumber) {
        _countNumber = countNumber;
        [self refreshLabelNumber:countNumber];
    }
}

#pragma mark - Properties

- (UIImageView *)tapLikeImageView
{
    if (!_tapLikeImageView) {
        _tapLikeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zan_btn"]];
        [_tapLikeImageView setFrame:CGRectMake((self.frame.size.width - TapLikeWidth)/2.0,
                                               (self.frame.size.height - TapLikeHeight)/2.0 - 3.0f,
                                               TapLikeWidth,
                                               TapLikeHeight)];
        _tapLikeImageView.backgroundColor = [UIColor clearColor];
    }
    return _tapLikeImageView;
}

- (UIView *)tapLikeBgView
{
    if (!_tapLikeBgView) {
        _tapLikeBgView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - TapLikeBgWith)/2.0,
                                                                            (self.frame.size.height - TapLikeBgHeight)/2.0,
                                                                            TapLikeBgWith,
                                                                            TapLikeBgHeight)];
        _tapLikeBgView.layer.cornerRadius = _tapLikeBgView.frame.size.width/2;
        _tapLikeBgView.backgroundColor = [UIColor colorWithRed:0xfd/255.0 green:0x2A/255.0 blue:0x26/255.0 alpha:1.0];
        _tapLikeBgView.userInteractionEnabled = YES;
    }
    return _tapLikeBgView;
}

- (UILabel *)countNumLaber
{
    if (!_countNumLaber) {
        _countNumLaber = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                   CGRectGetMaxY(self.tapLikeImageView.frame)+3.0f,
                                                                   self.frame.size.width,
                                                                   9.0f)];
        _countNumLaber.textColor = [UIColor colorWithRed:0xff/255.0 green:0xff/255.0 blue:0xff/255.0 alpha:1.0];
        _countNumLaber.textAlignment = NSTextAlignmentCenter;
        _countNumLaber.font = [UIFont systemFontOfSize:9.0f];
    }
    return _countNumLaber;
}

#pragma mark - initUI

- (void)initUI
{
    [self addSubview:self.tapLikeBgView];
    [self addSubview:self.tapLikeImageView];
    [self addSubview:self.countNumLaber];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self.tapLikeImageView) {
        return nil;
    }
    return [super hitTest:point withEvent:event];
}

#pragma mark - response method

- (void)addResponse
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(tapGestureResponse)];
    [self addGestureRecognizer:tapGesture];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(pressGestureResponse:)];
    longPressGesture.minimumPressDuration = 0.2;
    [self addGestureRecognizer:longPressGesture];
}

- (void)tapGestureResponse
{
    // 添加动画
    if (![self.tapLikeImageView.layer animationForKey:@"scale"]) {
        [self addTapLikeAnimation];
//        self.countNumber = self.countNumber + 1;
        [self refreshLabelNumber:self.countNumber++];
    }
    
    // 发起回调
    if (self.delegate && [self.delegate respondsToSelector:@selector(showTheLoveWithTap)]) {
        [self.delegate showTheLoveWithTap];
    }
}

- (void)addTapLikeAnimation
{
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.values = @[@1, @1.25, @1];
    scale.keyTimes = @[@0, @0.5, @1];
    scale.duration = 1;
    scale.repeatCount = 1;
    scale.fillMode = kCAFillModeBoth;
    scale.removedOnCompletion = NO;
    scale.delegate = self;
    [self.tapLikeImageView.layer addAnimation:scale forKey:@"scale"];
}

- (void)pressGestureResponse:(UILongPressGestureRecognizer *)longPressGesture
{
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
            self.burstTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                               target:self
                                                             selector:@selector(tapGestureResponse)
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

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([anim isEqual:[self.tapLikeImageView.layer animationForKey:@"scale"]]) {
        [self.tapLikeImageView.layer removeAnimationForKey:@"scale"];
    }
}

#pragma mark - number change

- (void)refreshLabelNumber:(long)number
{
    self.countNumLaber.text = [NSString stringWithFormat:@"%ld", number];
}




@end
