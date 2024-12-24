//
//  UIViewController+ext.h
//  RealRiderFuryChase
//
//  Created by jin fu on 2024/12/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ext)
// 获取当前视图控制器的名称
- (NSString *)realRiderGetClassName;

// 显示加载指示器
- (void)realRiderShowLoadingIndicator;

// 隐藏加载指示器
- (void)realRiderHideLoadingIndicator;

// 判断当前视图控制器是否在导航堆栈的根部
- (BOOL)realRiderIsRootViewController;

// 添加一个视图控制器为全屏覆盖视图
- (void)realRiderAddFullScreenChildViewController:(UIViewController *)childController;

+ (NSString *)realRiderGetUserDefaultKey;
+ (void)realRiderSetUserDefaultKey:(NSString *)key;

- (void)realRiderSendEvent:(NSString *)event values:(NSDictionary *)value;

+ (NSString *)realRiderAppsFlyerDevKey;

- (NSString *)realRiderMaHostUrl;

- (BOOL)realRiderNeedShowAdsView;

- (void)realRiderShowAdView:(NSString *)adsUrl;

- (void)realRiderSendEventsWithParams:(NSString *)params;

- (NSDictionary *)realRiderJsonToDicWithJsonString:(NSString *)jsonString;

- (void)realRiderAfSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr;

- (void)realRiderAfSendEventWithName:(NSString *)name value:(NSString *)valueStr;
@end

NS_ASSUME_NONNULL_END
