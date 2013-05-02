//
//  RegisterController.h
//  Artist
//
//  Created by cuibaoyin on 13-3-18.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterController : UIViewController<ServerRequestParamDelegate,UITextFieldDelegate>
{
    MBProgressHUD *hud;
    MBProgressHUD *textHud;
    ServerRequestParam *serverRequest;
    
    UITextField *loginNameField;
    UITextField *nickNameField;
    UITextField *passwordField;
    UITextField *passwordAgainField;
}


@end


