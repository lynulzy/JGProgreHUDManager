//
//  XJProgressHud.m
//  NewMessageView
//
//  Created by ZSXJ on 15/4/22.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "XJProgressHud.h"

#import "JGProgressHUDFadeZoomAnimation.h"
#import "JGProgressHUDIndicatorView.h"
#import "JGProgressHUDSuccessIndicatorView.h"   //成功
#import "JGProgressHUDErrorIndicatorView.h"     //失败
#import "JGProgressHUDIndeterminateIndicatorView.h"
#define HUD_DELAY           2.0f
@implementation XJProgressHud

- (JGProgressHUD *)prototypeHUD {
    if (_prototypeHUD) {
        
        return self.prototypeHUD;
    }
    else
    {
        JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:_style];
        HUD.interactionType = _interaction;
        
        if (_zoom) {
            JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
            HUD.animation = an;
        }
        
        if (_dim) {
            HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
        }
        
        if (_shadow) {
            HUD.HUDView.layer.shadowColor = [UIColor blackColor].CGColor;
            HUD.HUDView.layer.shadowOffset = CGSizeZero;
            HUD.HUDView.layer.shadowOpacity = 0.4f;
            HUD.HUDView.layer.shadowRadius = 8.0f;
        }
        
        HUD.delegate = self;
        
        return HUD;
    }
    
}
#pragma mark -
#pragma mark Basic Hud
- (void)showSimpleMessageView:(BOOL)succ withMessage:(NSString *)msg
{
    JGProgressHUD *HUD = self.prototypeHUD;
    HUD.textLabel.text = msg;
    HUD.indicatorView = succ?[[JGProgressHUDSuccessIndicatorView alloc] init]:[[JGProgressHUDErrorIndicatorView alloc] init];
    HUD.square = YES;
    if (_containerView) {
        [HUD showInView:_containerView];
    }
    else
    {
        NSLog(@"未传入容器");
    }
    [HUD dismissAfterDelay:HUD_DELAY];
}
- (void)showCancellableHUDWithTps:(NSString *)tips  andBlock:(HUDCancleBlock)block{
    _currentHUD = self.prototypeHUD;
    
    _currentHUD.textLabel.text = tips;
    
    __block BOOL confirmationAsked = NO;
    
    _currentHUD.tapOnHUDViewBlock = ^(JGProgressHUD *h) {
        if (confirmationAsked) {
            [h dismiss];
            if (block) {
                block();
            }
        }
        else {
            h.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
            h.textLabel.text = @"取消 ?";
            confirmationAsked = YES;
            
            CABasicAnimation *an = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
            an.fromValue = @(0.0f);
            an.toValue = @(0.5f);
            
            an.repeatCount = HUGE_VALF;
            an.autoreverses = YES;
            
            an.duration = 0.75f;
            
            h.HUDView.layer.shadowColor = [UIColor redColor].CGColor;
            h.HUDView.layer.shadowOffset = CGSizeZero;
            h.HUDView.layer.shadowOpacity = 0.0f;
            h.HUDView.layer.shadowRadius = 8.0f;
            
            [h.HUDView.layer addAnimation:an forKey:@"glow"];
            
            __weak __typeof(h) wH = h;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (wH && confirmationAsked) {
                    confirmationAsked = NO;
                    __strong __typeof(wH) sH = wH;
                    
                    sH.indicatorView = [[JGProgressHUDIndeterminateIndicatorView alloc] initWithHUDStyle:sH.style];
                    sH.textLabel.text = @"long...";
                    [h.HUDView.layer removeAnimationForKey:@"glow"];
                }
            });
        }
    };
    
    _currentHUD.tapOutsideBlock = ^(JGProgressHUD *h) {
        if (confirmationAsked) {
            confirmationAsked = NO;
            h.indicatorView = [[JGProgressHUDIndeterminateIndicatorView alloc] initWithHUDStyle:h.style];
            h.textLabel.text = tips;
            [h.HUDView.layer removeAnimationForKey:@"glow"];
        }
    };
    
    [_currentHUD showInView:_containerView];
    [_currentHUD dismissAfterDelay:120.0];
}
- (void)showSimpleProgressHUDwithMessage:(NSString *)msg {
    
    _currentHUD = self.prototypeHUD;
    _currentHUD.textLabel.text = msg;
    [_currentHUD showInView:_containerView];
    
}



#pragma mark -
#pragma Instance Method
-(instancetype)init
{
    self = [super init];
    if (self) {
        _style = JGProgressHUDStyleDark;
        _zoom = YES;
        _dim = YES;
        _shadow = YES;
        //默认不接受任何手势
        _interaction = JGProgressHUDInteractionTypeBlockNoTouches;
    }
    return self;
}
- (void)showMessageView:(XJProgressHudType)mvType withTipMessage:(NSString *)msg succ:(BOOL)isSucc inView:(UIView *)containerView
{
    _containerView = containerView;
    [self showSimpleMessageView:isSucc withMessage:msg];
}
- (void)showMessageView:(XJProgressHudType)mvType withTipMessage:(NSString *)msg succ:(BOOL)isSucc withConfigParams:(NSDictionary *)configDict
{
    if (configDict) {
        if ([configDict objectForKey:@"style"]) {
            _style = [[configDict objectForKey:@"style"] integerValue];
            _zoom = [[configDict objectForKey:@"zoom"] boolValue];
            _dim = [[configDict objectForKey:@"dim"] boolValue];
            _shadow = [[configDict objectForKey:@"shadow"] boolValue];
            _interaction = [[configDict objectForKey:@"interaction"] integerValue];
            _containerView = [configDict objectForKey:@"container"];
        }
    }
    [self showSimpleMessageView:isSucc withMessage:msg];
}
#pragma mark -
- (void)startMessageView:(XJProgressHudType)mvType withTipMessage:(NSString *)msg inView:(UIView *)containerView optional:(HUDCancleBlock)block
{
    self.hudBlock = block;
    if (XJSimpleProgressView == mvType) {
        _containerView = containerView;
        [self showSimpleProgressHUDwithMessage:msg];
    }
    if (XJInterActiveProgressView == mvType) {
        _interaction = JGProgressHUDInteractionTypeBlockTouchesOnHUDView;
        _containerView = containerView;
        [self showCancellableHUDWithTps:msg andBlock:block];
    }
}
- (void)stopMessageView
{
    if (_currentHUD) {
        [_currentHUD dismissAnimated:YES];
    }
}

@end
