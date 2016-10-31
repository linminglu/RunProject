//
//  PGCDefineHeader.h
//  跑工程
//
//  Created by leco on 2016/10/27.
//  Copyright © 2016年 Mac. All rights reserved.
//

#ifndef PGCDefineHeader_h
#define PGCDefineHeader_h


#define PGCKeyWindow [UIApplication sharedApplication].keyWindow

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds

//屏幕高度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//屏幕宽度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//状态栏高度
#define STATUS_BAR_HEIGHT 20
//NavBar高度
#define NAVIGATION_BAR_HEIGHT 44
//状态栏 ＋ 导航栏 高度
#define STATUS_AND_NAVIGATION_HEIGHT ((STATUS_BAR_HEIGHT) + (NAVIGATION_BAR_HEIGHT))
//标签栏
#define TAB_BAR_HEIGHT 49 + 1

/****宏定义***/
#define SetFont(size) [UIFont systemFontOfSize:size]

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define SystemVersion [[UIDevice currentDevice].systemVersion floatValue]


#define NSLog(FORMAT, ...) NSLog((@"%s[Line:%d] " FORMAT), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


/* NSLog的Debug模式 */
#ifdef DEBUG
#define PGCLog(FORMAT, ...) fprintf(stderr,"%s:%d NSLog:%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
#define PGCLog(...)
#endif

// APP的主题色
#define PGCTintColor RGB(250, 117, 10)
#define PGCThemeColor RGB(249, 136, 46)
// APP的文字颜色
#define PGCTextColor RGB(51, 51, 51)
// APP的阴影颜色
#define PGCBackColor RGB(240, 240, 240)

#endif /* PGCDefineHeader_h */
