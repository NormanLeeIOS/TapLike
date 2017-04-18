//
//  TapLikeView.h
//  TapLike
//
//  Created by 李亚坤 on 2017/4/17.
//  Copyright © 2017年 NoramanLee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TapLikeViewDelegate <NSObject>

- (void)showTheLoveWithTap;
- (void)showTheLoveWithPress;

@end

@interface TapLikeView : UIView

@property (nonatomic, weak) id<TapLikeViewDelegate> delegate;

@end
