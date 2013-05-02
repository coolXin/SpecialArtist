//
//  PasswordModifyController.h
//  Artist
//
//  Created by cuibaoyin on 13-4-2.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordModifyController : UIViewController<UITextFieldDelegate,ServerRequestParamDelegate>
{
    MBProgressHUD *progressHud;
    MBProgressHUD *textHud;
    ServerRequestParam *serverRequest;

    UITextField *password_old;
    UITextField *password_new;
    UITextField *affirm_new;
}

@end
