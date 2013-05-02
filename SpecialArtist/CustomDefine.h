//
//  CustomDefine.h
//  Artist
//
//  Created by cuibaoyin on 13-4-9.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#ifndef Artist_CustomDefine_h
#define Artist_CustomDefine_h

#define NavigationBar_HEIGHT 44
#define SCREEN_WIDTH                        [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT                       [UIScreen mainScreen].bounds.size.height
#define Application_Frame                   [UIScreen mainScreen].applicationFrame
#define Application_HEIGHT                [UIScreen mainScreen].applicationFrame.size.height

#define SAFE_RELEASE(x)               [x release];x=nil
#define IOS_VERSION                     [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion      [[UIDevice currentDevice] systemVersion]
#define CurrentLanguage              [[NSLocale preferredLanguages] objectAtIndex:0]
#define RGBACOLOR(r,g,b,a)         [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define ImageNamed(_pointer)     [UIImage imageNamed:[UIUtil imageName:_pointer]]
#define DocumentsDirectory         [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject]
#define isRetina                            [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO
#define isiPhone5                         [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO
#define isPad                                UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#endif

#ifdef DEBUG
#   define DLog(fmt, ...)               NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#if TARGET_OS_IPHONE
#endif

#if TARGET_IPHONE_SIMULATOR
#endif

//ARC
#if __has_feature(objc_arc)
#else
#endif