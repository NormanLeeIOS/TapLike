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

@interface TapLikeView ()

@property (nonatomic, strong) UIView *tapLikeBgView;
@property (nonatomic, strong) UIImageView *tapLikeImageView;
@property (nonatomic, strong) NSTimer *burstTimer;

@end

@implementation TapLikeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        [self addResponse];
    }
    return self;
}

#pragma mark - Properties

- (UIImageView *)tapLikeImageView
{
    if (!_tapLikeImageView) {
        _tapLikeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zan_btn"]];
        [_tapLikeImageView setFrame:CGRectMake((self.frame.size.width - TapLikeWidth)/2.0,
                                               (self.frame.size.height - TapLikeHeight)/2.0,
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

#pragma mark - initUI

- (void)initUI
{
    [self addSubview:self.tapLikeBgView];
    [self addSubview:self.tapLikeImageView];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(showTheLoveWithTap)]) {
        [self.delegate showTheLoveWithTap];
    }
}

- (void)pressGestureResponse:(UILongPressGestureRecognizer *)longPressGesture
{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(showTheLoveWithPress)]) {
//        [self.delegate showTheLoveWithPress];
//    }
    
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


@end
