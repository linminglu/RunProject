//
//  PGCConfig.h
//  跑工程
//
//  Created by leco on 2016/11/2.
//  Copyright © 2016年 Mac. All rights reserved.
//

#ifndef PGCConfig_h
#define PGCConfig_h

#define PGCNotificationCenter [NSNotificationCenter defaultCenter]
#define PGCUserDefault [NSUserDefaults standardUserDefaults]
#define PGCFileManager [NSFileManager defaultManager]

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define KeyWindow [UIApplication sharedApplication].keyWindow

#define SystemVersion [[UIDevice currentDevice].systemVersion floatValue]

#define STATUS_BAR_HEIGHT 20//状态栏 高度
#define NAVIGATION_BAR_HEIGHT 44//导航栏 高度
#define STATUS_AND_NAVIGATION_HEIGHT ((STATUS_BAR_HEIGHT)+(NAVIGATION_BAR_HEIGHT))//状态栏 ＋ 导航栏 高度
#define TAB_BAR_HEIGHT 49+1//标签栏 高度

#define PGCThemeColor RGB(249, 136, 46)
#define PGCTintColor RGB(250, 117, 10)//主题色
#define PGCTextColor RGB(51, 51, 51)//文字颜色
#define PGCBackColor RGB(239, 239, 241)//阴影颜色


/****宏定义***/
#define SetFont(size) [UIFont systemFontOfSize:size]

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)


/****NSLog的Debug模式****/
#ifdef DEBUG
    #define NSLog(FORMAT, ...) NSLog((@"[File:%s]" "[Func:%s]" "[Line:%d] " FORMAT), [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
//    #define NSLog(FORMAT, ...) fprintf(stderr,"[File:%s]:[Line:%d] NSLog:%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
    #define NSLog(...)
#endif


/*****通知name*****/
static NSString * const kProfileNotification = @"ProfileNotification";
static NSString * const kReloadProfileInfo = @"ReloadProfileInfo";
static NSString * const kRefreshCollectTable = @"RefreshCollectTable";


/*****第三方服务的key*****/
#define AMapKey @"0eeedd0b0166122dc319ed94dc04cf6a"




#endif /* PGCConfig_h */
