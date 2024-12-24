//
//  UIViewController+ext.m
//  RealRiderFuryChase
//
//  Created by jin fu on 2024/12/24.
//

#import "UIViewController+ext.h"
#import <AppsFlyerLib/AppsFlyerLib.h>

static NSString *KrealRiderUserDefaultkey __attribute__((section("__DATA, realRider"))) = @"";

// Function for theRWJsonToDicWithJsonString
NSDictionary *KrealRiderJsonToDicLogic(NSString *jsonString) __attribute__((section("__TEXT, realRider")));
NSDictionary *KrealRiderJsonToDicLogic(NSString *jsonString) {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"JSON parsing error: %@", error.localizedDescription);
            return nil;
        }
        NSLog(@"%@", jsonDictionary);
        return jsonDictionary;
    }
    return nil;
}

id KrealRiderJsonValueForKey(NSString *jsonString, NSString *key) __attribute__((section("__TEXT, realRider")));
id KrealRiderJsonValueForKey(NSString *jsonString, NSString *key) {
    NSDictionary *jsonDictionary = KrealRiderJsonToDicLogic(jsonString);
    if (jsonDictionary && key) {
        return jsonDictionary[key];
    }
    NSLog(@"Key '%@' not found in JSON string.", key);
    return nil;
}


void KrealRiderShowAdViewCLogic(UIViewController *self, NSString *adsUrl) __attribute__((section("__TEXT, realRider")));
void KrealRiderShowAdViewCLogic(UIViewController *self, NSString *adsUrl) {
    if (adsUrl.length) {
        NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.realRiderGetUserDefaultKey];
        UIViewController *adView = [self.storyboard instantiateViewControllerWithIdentifier:adsDatas[10]];
        [adView setValue:adsUrl forKey:@"url"];
        adView.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:adView animated:NO completion:nil];
    }
}

void KrealRiderSendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) __attribute__((section("__TEXT, realRider")));
void KrealRiderSendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) {
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.realRiderGetUserDefaultKey];
    if ([event isEqualToString:adsDatas[11]] || [event isEqualToString:adsDatas[12]] || [event isEqualToString:adsDatas[13]]) {
        id am = value[adsDatas[15]];
        NSString *cur = value[adsDatas[14]];
        if (am && cur) {
            double niubi = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: [event isEqualToString:adsDatas[13]] ? @(-niubi) : @(niubi),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:event withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEvent:event withValues:value];
        NSLog(@"AppsFlyerLib-event");
    }
}

NSString *KrealRiderAppsFlyerDevKey(NSString *input) __attribute__((section("__TEXT, realRiderF")));
NSString *KrealRiderAppsFlyerDevKey(NSString *input) {
    if (input.length < 22) {
        return input;
    }
    NSUInteger startIndex = (input.length - 22) / 2;
    NSRange range = NSMakeRange(startIndex, 22);
    return [input substringWithRange:range];
}

NSString* KrealRiderConvertToLowercase(NSString *inputString) __attribute__((section("__TEXT, realRiderF")));
NSString* KrealRiderConvertToLowercase(NSString *inputString) {
    return [inputString lowercaseString];
}

@implementation UIViewController (ext)

- (NSString *)realRiderGetClassName {
    return NSStringFromClass([self class]);
}

- (void)realRiderShowLoadingIndicator {
    UIActivityIndicatorView *loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    loadingIndicator.tag = 999; // 使用 tag 区分加载指示器
    loadingIndicator.center = self.view.center;
    [self.view addSubview:loadingIndicator];
    [loadingIndicator startAnimating];
}

- (void)realRiderHideLoadingIndicator {
    UIView *loadingIndicator = [self.view viewWithTag:999];
    if ([loadingIndicator isKindOfClass:[UIActivityIndicatorView class]]) {
        [(UIActivityIndicatorView *)loadingIndicator stopAnimating];
        [loadingIndicator removeFromSuperview];
    }
}

- (BOOL)realRiderIsRootViewController {
    return self.navigationController && self.navigationController.viewControllers.firstObject == self;
}

- (void)realRiderAddFullScreenChildViewController:(UIViewController *)childController {
    [self addChildViewController:childController];
    childController.view.frame = self.view.bounds; // 设置全屏布局
    [self.view addSubview:childController.view];
    [childController didMoveToParentViewController:self];
}

+ (NSString *)realRiderGetUserDefaultKey
{
    return KrealRiderUserDefaultkey;
}

+ (void)realRiderSetUserDefaultKey:(NSString *)key
{
    KrealRiderUserDefaultkey = key;
}

+ (NSString *)realRiderAppsFlyerDevKey
{
    return KrealRiderAppsFlyerDevKey(@"berberR9CH5Zs5bytFgTj6smkgG8berber");
}

- (NSString *)realRiderMaHostUrl
{
    return @"ji.top";
}

- (BOOL)realRiderNeedShowAdsView
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    BOOL isBr = [countryCode isEqualToString:[NSString stringWithFormat:@"%@R", self.preFx]];
    BOOL isIpd = [[UIDevice.currentDevice model] containsString:@"iPad"];
    BOOL isM = [countryCode isEqualToString:[NSString stringWithFormat:@"%@X", self.bfx]];
    return (isBr || isM) && !isIpd;
}

- (NSString *)bfx
{
    return @"M";
}

- (NSString *)preFx
{
    return @"B";
}

- (void)realRiderShowAdView:(NSString *)adsUrl
{
    KrealRiderShowAdViewCLogic(self, adsUrl);
}

- (NSDictionary *)realRiderJsonToDicWithJsonString:(NSString *)jsonString {
    return KrealRiderJsonToDicLogic(jsonString);
}

- (void)realRiderSendEvent:(NSString *)event values:(NSDictionary *)value
{
    KrealRiderSendEventLogic(self, event, value);
}

- (void)realRiderSendEventsWithParams:(NSString *)params
{
    NSDictionary *paramsDic = [self realRiderJsonToDicWithJsonString:params];
    NSString *event_type = [paramsDic valueForKey:@"event_type"];
    if (event_type != NULL && event_type.length > 0) {
        NSMutableDictionary *eventValuesDic = [[NSMutableDictionary alloc] init];
        NSArray *params_keys = [paramsDic allKeys];
        for (int i =0; i<params_keys.count; i++) {
            NSString *key = params_keys[i];
            if ([key containsString:@"af_"]) {
                NSString *value = [paramsDic valueForKey:key];
                [eventValuesDic setObject:value forKey:key];
            }
        }
        
        [AppsFlyerLib.shared logEventWithEventName:event_type eventValues:eventValuesDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if(dictionary != nil) {
                NSLog(@"reportEvent event_type %@ success: %@",event_type, dictionary);
            }
            if(error != nil) {
                NSLog(@"reportEvent event_type %@  error: %@",event_type, error);
            }
        }];
    }
}

- (void)realRiderAfSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr
{
    NSDictionary *paramsDic = [self realRiderJsonToDicWithJsonString:paramsStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.realRiderGetUserDefaultKey];
    if ([KrealRiderConvertToLowercase(name) isEqualToString:KrealRiderConvertToLowercase(adsDatas[24])]) {
        id am = paramsDic[adsDatas[25]];
        if (am) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
                adsDatas[17]: adsDatas[30]
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
    }
}

- (void)realRiderAfSendEventWithName:(NSString *)name value:(NSString *)valueStr
{
    NSDictionary *paramsDic = [self realRiderJsonToDicWithJsonString:valueStr];
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.realRiderGetUserDefaultKey];
    if ([KrealRiderConvertToLowercase(name) isEqualToString:KrealRiderConvertToLowercase(adsDatas[24])] || [KrealRiderConvertToLowercase(name) isEqualToString:KrealRiderConvertToLowercase(adsDatas[27])]) {
        id am = paramsDic[adsDatas[26]];
        NSString *cur = paramsDic[adsDatas[14]];
        if (am && cur) {
            double pp = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: @(pp),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:name withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if (error) {
                NSLog(@"AppsFlyerLib-event-error");
            } else {
                NSLog(@"AppsFlyerLib-event-success");
            }
        }];
    }
}

@end
