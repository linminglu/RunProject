//
//  PGCConfig.h
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#ifndef PGCConfig_h
#define PGCConfig_h

//app的版本号
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//app build版本号
#define kAppBuildVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//app的显示名称
#define kAppDisplayName [[NSBundle mainBundle].localizedInfoDictionary objectForKey:@"CFBundleDisplayName"]

//app的identifier
#define kAppBundleIdentifier [[NSBundle mainBundle] bundleIdentifier]

/****NSLog的Debug模式****/
#ifdef DEBUG
#define NSLog(FORMAT, ...) NSLog((@"[File:%s]" "[Func:%s]" "[Line:%d] " FORMAT), [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
//    #define NSLog(FORMAT, ...) fprintf(stderr,"[File:%s]:[Line:%d] NSLog:%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#define NSLog(...)
#endif

//尺寸相关
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

// 当前版本
#define FSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define DSystemVersion [[[UIDevice currentDevice] systemVersion] doubleValue]
#define SSystemVersion [[UIDevice currentDevice] systemVersion]

// UI相关
#define KeyWindow [UIApplication sharedApplication].keyWindow

#define STATUS_BAR_HEIGHT 20 // 状态栏 高度
#define NAVIGATION_BAR_HEIGHT 44 // 导航栏 高度
#define STATUS_AND_NAVIGATION_HEIGHT ((STATUS_BAR_HEIGHT)+(NAVIGATION_BAR_HEIGHT)) // 状态＋导航 高度
#define TAB_BAR_HEIGHT 49+1 // 标签栏 高度

#define SetFont(size) [UIFont systemFontOfSize:size]

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define PGCThemeColor RGB(249, 136, 46)
#define PGCTintColor RGB(250, 117, 10)//主题色
#define PGCTextColor RGB(51, 51, 51)//文字颜色
#define PGCBackColor RGB(239, 239, 241)//阴影颜色


#define PGCNotificationCenter [NSNotificationCenter defaultCenter]
#define PGCUserDefault [NSUserDefaults standardUserDefaults]
#define PGCFileManager [NSFileManager defaultManager]


/*****第三方服务的key*****/
#define AMapKey @"0eeedd0b0166122dc319ed94dc04cf6a"// 高德地图 app key

#define SHARE_APPKEY @"196fd48f2a09c"// shareSDK appKey
#define SHARE_SECRET @"5bfef51128e3fd5f50b7f12b20434ff0"// shareSDK app secret

#define WeChat_APPID @"wx3ce8d64947abe952"// 微信 appID

#define QQ_APPID @"1105771161"// QQ appID
#define QQ_APPKEY @"y7gmJXDT5FzG4aSm"// QQ appKey

#define GETUI_APPID @"xQANwMGyAN6MoCa8DyLrN6"// 个推appID
#define GETUI_APPKEY @"AOB4Kx7nyv65sqZHapchY7"// 个推appKey



#endif /* PGCConfig_h */
