//
//  UserInfoModyController.h
//  Artist
//
//  Created by cuibaoyin on 13-4-2.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoModyController : UIViewController<ServerRequestParamDelegate,UITextFieldDelegate>
{
    int sexMark;
    ServerRequestParam *serverRequest;
    MBProgressHUD *progressHud;
    MBProgressHUD *textHud;
    UITextField *nickNameLabel;
    UITextField *phoneNameLabel;
    UIButton *manBtn;
    UIButton *womenBtn;
}

@end
