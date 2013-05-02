//
//  LoginController.h
//  Artist
//
//  Created by cuibaoyin on 13-3-18.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OauthorController.h"
#import "OpenAPIOperation.h"
#import "MyCustomTextField.h"

@interface LoginController : UIViewController<UITextFieldDelegate,OauthorControllerDelegate,OpenAPIOperationDelegate,ServerRequestParamDelegate>
{
    float positionOfNameField;
    float positionOfPasswordField;
    MyCustomTextField *userLoginNameField;
    MyCustomTextField *userPasswordField;
    
    ServerRequestParam *serverRequest;
    MBProgressHUD *myHud;
    MBProgressHUD *textHud;
}

@end
