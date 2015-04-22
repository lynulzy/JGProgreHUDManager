//
//  ViewController.m
//  NewMessageView
//
//  Created by ZSXJ on 15/4/22.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

#import "ViewController.h"
#import "JGProgressHUD.h"
#import "JGProgressHUDFadeZoomAnimation.h"

#import "JGProgressHUDIndicatorView.h"
#import "JGProgressHUDSuccessIndicatorView.h"
#import "XJProgressHud.h"
@interface ViewController ()

@end

@implementation ViewController
{
    JGProgressHUDStyle _style;
    JGProgressHUDInteractionType _interaction;
    BOOL _zoom;
    BOOL _dim;
    BOOL _shadow;
    
    
    XJProgressHud *progressHUD;
}

//- (JGProgressHUD *)prototypeHUD {
//    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:_style];
//    HUD.interactionType = _interaction;
//    
//    if (_zoom) {
//        JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
//        HUD.animation = an;
//    }
//    
//    if (_dim) {
//        HUD.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
//    }
//    
//    if (_shadow) {
//        HUD.HUDView.layer.shadowColor = [UIColor blackColor].CGColor;
//        HUD.HUDView.layer.shadowOffset = CGSizeZero;
//        HUD.HUDView.layer.shadowOpacity = 0.4f;
//        HUD.HUDView.layer.shadowRadius = 8.0f;
//    }
//    
//    HUD.delegate = self;
//    
//    return HUD;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
    showView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:showView];
    [[[XJProgressHud alloc] init] showMessageView:XJSimpleMessageView withTipMessage:@"测试一下" succ:YES inView:showView];
    
    UIView *showView2 = [[UIView alloc] initWithFrame:CGRectMake(200, 0, 320-200, 350)];
    showView2.backgroundColor = [UIColor colorWithRed:0.82f green:0.78f blue:0.77f alpha:1.00f];
    [self.view addSubview:showView2];
    
    /*style zoom dim shadow interaction container*/
    NSDictionary *dict = @{@"style":@"1",
                           @"zoom":@"0",
                           @"dim":@"0",
                           @"shadow":@"0",
                           @"interaction":@"2",
                           @"container":showView2
                           };
    [[[XJProgressHud alloc] init] showMessageView:1 withTipMessage:@"Hello world" succ:NO withConfigParams:dict];
    
    
    
    UIView *showView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 230, 200)];
    showView3.backgroundColor = [UIColor redColor];
    [self.view addSubview:showView3];
    progressHUD=  [[XJProgressHud alloc] init];
    [progressHUD startMessageView:XJInterActiveProgressView withTipMessage:@"时间略长,点击取消" inView:showView3 optional:^{
        NSLog(@"在这里执行取消的逻辑");
    }];
//    [self aTask];
}
- (void)aTask
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [progressHUD stopMessageView];
    });
}
#pragma mark -
#pragma mark ShowHud
//- (void)showSuccessHUD {
//    _style = JGProgressHUDStyleDark;
//    JGProgressHUD *HUD = self.prototypeHUD;
//    
//    HUD.textLabel.text = @"成功";
//    HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
//    
//    HUD.square = YES;
//    
//    [HUD showInView:self.view];
//    
//    [HUD dismissAfterDelay:3.0];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
