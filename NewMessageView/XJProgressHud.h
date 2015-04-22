//
//  XJProgressHud.h
//  NewMessageView
//
//  Created by ZSXJ on 15/4/22.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JGProgressHUD.h"
/*
 The style maybe used in my project
 
 */

typedef NS_ENUM(NSInteger, XJProgressHudType) {
    //最简单形式的消息提示框
    XJSimpleMessageView = 0,
    //过程完成之后在底部显示消息提示框
    XJProgressMessageViewWithTips,
    //仅在底部显示一个提示框，比如快速发单之后
    XJBottomTipView,
    //加载的等待界面
    XJSimpleProgressView,
    //加载的等待界面，可以取消请求（需要根据具体情况调用取消请求的方法）
    XJInterActiveProgressView
};

typedef void(^HUDCancleBlock)();
@interface XJProgressHud : NSObject<JGProgressHUDDelegate>
#pragma mark  Properties
/*
 JGProgressHUDStyle _style;
 JGProgressHUDInteractionType _interaction;
 BOOL _zoom;
 BOOL _dim;
 BOOL _shadow;
 */

@property (nonatomic,copy)__block HUDCancleBlock hudBlock;
@property (nonatomic,assign)JGProgressHUDStyle style;
@property (nonatomic,assign)JGProgressHUDInteractionType interaction;
@property (nonatomic,assign)BOOL zoom;
@property (nonatomic,assign)BOOL dim;
@property (nonatomic,assign)BOOL shadow;
@property (nonatomic,weak)UIView *containerView;
@property (nonatomic,strong)JGProgressHUD *prototypeHUD;
@property (nonatomic,strong)JGProgressHUD *currentHUD;



//默认自动关闭，一般用来展示结果
- (void)showMessageView:(XJProgressHudType)mvType withTipMessage:(NSString *)msg succ:(BOOL)isSucc inView:(UIView *)containerView;
/**
 *  消息提示框（用来显示网络请求结果）
 *
 *  @param mvType     适用于XJSimpleMessageView/XJProgressMessageViewWithTips
 *  @param msg        Hud显示的提示消息
 *  @param configDict 应该包含zoom dim shadow interaction style 等参数
 */
- (void)showMessageView:(XJProgressHudType)mvType withTipMessage:(NSString *)msg succ:(BOOL)isSucc withConfigParams:(NSDictionary *)configDict;

//不自动关闭，用来展示过程
/**
 *  显示过程的ProgressHud，如果是XJInterActiveProgressView类型的，需要传入block才能执行取消的具体逻辑
 *
 *  @param mvType        类型：限于XJSimpleProgressView/XJInterActiveProgressView类型的ProgressHUD
 *  @param msg           代码的提示文字
 *  @param containerView 容器
 *  @param block         代码块中存放当用户点击取消后的具体逻辑
 */
- (void)startMessageView:(XJProgressHudType)mvType withTipMessage:(NSString *)msg inView:(UIView *)containerView optional:(HUDCancleBlock)block;
- (void)stopMessageView;

@end
