//
//  OauthorController.h
//  Artist
//
//  Created by cuibaoyin on 13-3-13.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenAPIOperation.h"
@protocol OauthorControllerDelegate;

typedef enum
{
    QQLogin_Oauthor = 0,
    SinaWeiBo_Oauthor,
}OauthorType;

@interface OauthorController : UIViewController<UIWebViewDelegate>
{
    UIWebView *oauthorWebView;
    OauthorType selectedType;
    MBProgressHUD *hud;
    NSMutableDictionary *userDic;
}

@property(assign, nonatomic) id<OauthorControllerDelegate>delegate;

- (id)initWithOauthorType:(OauthorType)type;

@end

@protocol OauthorControllerDelegate <NSObject>

- (void)oauthorSuccessWithType:(OauthorType)type withUserDic:(NSMutableDictionary *)dic;
- (void)oauthorFailed;

@end