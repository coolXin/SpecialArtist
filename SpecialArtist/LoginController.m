//
//  LoginController.m
//  Artist
//
//  Created by cuibaoyin on 13-3-18.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import "LoginController.h"
#import "CustomNaviagtionBar.h"
#import "RegisterController.h"

@interface LoginController ()

@end

@implementation LoginController

- (id)init
{
    if (self = [super init])
    {
        serverRequest = [[ServerRequestParam alloc] init];
        serverRequest.delegate = self;
    }
    return self;
}

- (void)loadView
{
    [self setTitle:@"登录"];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navigationPic.png"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:14] forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *leftBar = [[CustomNaviagtionBar getInstance] barButtonItemImage:[UIImage imageNamed:@"backOff.png"] withPressedImage:[UIImage imageNamed:@"backOn.png"] withSize:CGSizeMake(41, 30)];
    [(UIButton *)leftBar.customView addTarget:self action:@selector(cancelLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:leftBar];
    
    CGRect frame = CGRectMake(0, 0, 320, Application_HEIGHT - 44);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    frame = CGRectMake(15, 15, 290, 30);
    UILabel *label_wooboo = [[UILabel alloc] initWithFrame:frame];
    label_wooboo.textAlignment = NSTextAlignmentLeft;
    label_wooboo.font = [UIFont boldSystemFontOfSize:17];
    label_wooboo.text = @"使用好艺术帐号登陆";
    [self.view addSubview:label_wooboo];
    
    frame.origin.y = frame.origin.y + frame.size.height + 15;
    frame.size.height = 38;
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loginInputBackground01.png" ofType:nil]];
    userLoginNameField = [self produceTextFieldWithLabelName:@"账号" withImage:image];
    userLoginNameField.frame = frame;
    [self.view addSubview:userLoginNameField];
    
    frame.origin.y = frame.origin.y + frame.size.height;
    image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loginInputBackground02.png" ofType:nil]];
    userPasswordField = [self produceTextFieldWithLabelName:@"密码" withImage:image];
    userPasswordField.frame = frame;
    userPasswordField.delegate = self;
    [self.view addSubview:userPasswordField];
    
    frame.origin.y = frame.origin.y + frame.size.height + 15;
    frame.size.width = 92;
    frame.size.height = 31;
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = frame;
    [submitBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loginOff.png" ofType:nil]] forState:UIControlStateNormal];
    [submitBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loginOn.png" ofType:nil]] forState:UIControlStateHighlighted];
    [submitBtn addTarget:self action:@selector(loginByWooboo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
    frame.origin.y = frame.origin.y - 10;
    frame.origin.x = frame.origin.x + frame.size.width + 80;
    frame.size.width = 130;
    frame.size.height = 30;
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = frame;
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [registerBtn setTitle:@"没有账号,快速注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [registerBtn setTitle:@"没有账号,快速注册" forState:UIControlStateHighlighted];
    [registerBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [registerBtn addTarget:self action:@selector(quickRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    frame = submitBtn.frame;
    frame.origin.y = frame.origin.y + frame.size.height + 15;
    frame.size.width = 290;
    frame.size.height = 30;
    UILabel *thirdUserLogin = [[UILabel alloc] initWithFrame:frame];
    thirdUserLogin.textAlignment = NSTextAlignmentLeft;
    thirdUserLogin.font = [UIFont boldSystemFontOfSize:17];
    thirdUserLogin.text = @"使用第三方账号登陆,无需注册";
    [self.view addSubview:thirdUserLogin];
    
    //QQ login button
    frame.origin.y = frame.origin.y + frame.size.height + 15;
    frame.origin.x = (320 - 80 * 2 - 30)/ 3 + 15;
    frame.size = CGSizeMake(80, 80);
    UIButton *qqLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qqLoginBtn.frame = frame;
    [qqLoginBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"login_qq.png" ofType:nil]] forState:UIControlStateNormal];
    [qqLoginBtn addTarget:self action:@selector(loginIndirectly:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqLoginBtn];
    
    //sina login button
    frame.origin.x = frame.origin.x + frame.size.width + (290 - 80 * 2)/ 3;
    UIButton *sinaLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sinaLoginBtn.frame = frame;
    sinaLoginBtn.tag = 1;
    [sinaLoginBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"login_sina.png" ofType:nil]] forState:UIControlStateNormal];
    [sinaLoginBtn addTarget:self action:@selector(loginIndirectly:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sinaLoginBtn];
    
    //qq login label
    frame = qqLoginBtn.frame;
    frame.origin.y = frame.origin.y + frame.size.height + 5;
    frame.size = CGSizeMake(80, 20);
    UILabel *qqLoginLabel = [[UILabel alloc] initWithFrame:frame];
    qqLoginLabel.textAlignment = NSTextAlignmentCenter;
    qqLoginLabel.font = [UIFont systemFontOfSize:15];
    qqLoginLabel.text = @"QQ登陆";
    [self.view addSubview:qqLoginLabel];
    
    //qq login label
    frame = sinaLoginBtn.frame;
    frame.origin.y = frame.origin.y + frame.size.height + 5;
    frame.size = CGSizeMake(80, 20);
    UILabel *sinaLoginLabel = [[UILabel alloc] initWithFrame:frame];
    sinaLoginLabel.textAlignment = NSTextAlignmentCenter;
    sinaLoginLabel.font = [UIFont systemFontOfSize:15];
    sinaLoginLabel.text = @"微博登陆";
    [self.view addSubview:sinaLoginLabel];
    
    myHud = [[MBProgressHUD alloc] initWithView:self.view];
    myHud.labelText = @"登录中...";
    [self.view addSubview:myHud];
    
    textHud = [[MBProgressHUD alloc] initWithView:self.view];
    [textHud setMode:MBProgressHUDModeText];
    [self.view addSubview:textHud];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    positionOfNameField = userLoginNameField.frame.origin.y;
    positionOfPasswordField = userPasswordField.frame.origin.y;
}

- (void)dealloc
{
    serverRequest.delegate = nil;
    serverRequest = nil;
}

- (MyCustomTextField *)produceTextFieldWithLabelName:(NSString *)title withImage:(UIImage *)image
{
    MyCustomTextField *textField = [[MyCustomTextField alloc] initWithFrame:CGRectMake(0, 0, 290, 38)];
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    textField.background = image;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.font = [UIFont systemFontOfSize:15];
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 40, 38)];
    leftView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:leftView.frame];
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont boldSystemFontOfSize:17];
    [leftView addSubview:label];
    textField.leftView = leftView;
    return textField;
}

#pragma mark - IBAction
- (void)cancelLogin:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginIndirectly:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    OauthorType type;
    if (btn.tag == 0)
    {
        type = QQLogin_Oauthor;
    }
    else
    {
        type = SinaWeiBo_Oauthor;
    }

    OauthorController *controller = [[OauthorController alloc] initWithOauthorType:type];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    controller.delegate = self;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)loginByWooboo:(id)sender
{
    if (userLoginNameField.text.length <= 0 || userPasswordField.text.length <= 0)
    {
        textHud.labelText = @"账号和密码不能为空!";
        [textHud show:YES];
        [textHud hide:YES afterDelay:2];
        return;
    }
    [myHud show:YES];
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                         userLoginNameField.text,                @"UserName",
                         userPasswordField.text,                   @"UserPassword",
                         nil];
    [serverRequest requestServerWithType:login_wooboo withParamObject:dic];
}

- (void)quickRegister:(id)sender
{
    [userLoginNameField resignFirstResponder];
    [userPasswordField resignFirstResponder];
    RegisterController *controller = [[RegisterController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)handleSeverDataDictionary:(NSDictionary *)dic withRequestType:(RequsetType)type
{
    NSDictionary *dataDic = [dic objectForKey:@"DATA"];
    NSString *ftpUrl = [dic objectForKey:@"FTP"];
    
    NSString *userID = [dataDic objectForKey:@"id"];
    NSString *userLoginName = [dataDic objectForKey:@"userName"];
    NSString *userNickName = [dataDic objectForKey:@"realName"];
    NSString *userAvater = [dataDic objectForKey:@"icoPath"];
    NSString *userPhone = [dataDic objectForKey:@"mobile"];
    NSString *userSex = [dataDic objectForKey:@"sex"];
    
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"UserID"];
    [[NSUserDefaults standardUserDefaults] setObject:userLoginName forKey:@"UserLoginName"];
    [[NSUserDefaults standardUserDefaults] setObject:userNickName forKey:@"UserNickName"];
    if (userAvater != nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[ftpUrl stringByAppendingString:userAvater] forKey:@"UserAvaterPath"];
    }
    if (userPhone != nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:userPhone forKey:@"UserPhone"];
    }
    if (userSex != nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:userSex forKey:@"UserSex"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginStatusChanged" object:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ServerRequestParamDelegate
- (void)requsetSuccessWithType:(RequsetType)type withServerData:(NSDictionary *)severData withMoreMark:(BOOL)flag
{
    [self handleSeverDataDictionary:severData withRequestType:type];
}

- (void)requsetFailedWithType:(RequsetType)type
{
    [myHud hide:YES];
    textHud.labelText = @"密码或账号错误!";
    [textHud show:YES];
    [textHud hide:YES afterDelay:2];
}

#pragma mark - OauthorControllerDelegate
- (void)oauthorSuccessWithType:(OauthorType)type withUserDic:(NSMutableDictionary *)dic
{
    switch (type)
    {
        case QQLogin_Oauthor:
        {
            [myHud show:YES];
            OpenAPIOperation *operation = [[OpenAPIOperation alloc] init];
            [operation setOauthorMark:dic];
            operation.delegate = self;
            [operation getSpaceUserInfo];
            break;
        }
        case SinaWeiBo_Oauthor:
        {
            [myHud show:YES];
            OpenAPIOperation *operation = [[OpenAPIOperation alloc] init];
            [operation setOauthorMark:dic];
            operation.delegate = self;
            [operation getSinaUserInfo];
            break;
        }
        default:
            break;
    }
}

- (void)oauthorFailed
{
    [myHud hide:YES];
    [textHud setLabelText:@"第三方授权失败,请重试!"];
    [textHud show:YES];
    [textHud hide:YES afterDelay:2];
}

#pragma mark - OpenAPIOperationDelegate
- (void)operationSuccessWithType:(OperationType)type withObject:(NSDictionary *)dic    //向服务器注册
{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSString* loginType;
    if (type == QQSpace_Get_User_Info)
    {
        loginType = @"tecent";
    }
    else
    {
        loginType = @"sina";	
    }
    [dataDic setObject:loginType forKey:@"loginType"];
    [serverRequest requestServerWithType:login_indirect withParamObject:dataDic];
}

- (void)operationFailedWithType:(OperationType)type
{
    [myHud hide:YES];
    [textHud setLabelText:@"第三方授权失败,请重试!"];
    [textHud show:YES];
    [textHud hide:YES afterDelay:2];
}

#pragma mark - UITextFieldDelagate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    float postion;
    if (textField.tag == 0)
    {
        postion = -positionOfNameField + 20;
    }
    else
    {
        postion = -positionOfNameField + 10;
    }
    
    [UIView animateWithDuration:0.3f animations:^
     {
         CGRect frame = self.view.frame;
         frame.origin.y = postion;
         self.view.frame = frame;
     }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [UIView animateWithDuration:0.3f animations:^
     {
         CGRect frame = self.view.frame;
         frame.origin.y = 0;
         self.view.frame = frame;
     }];
    return YES;
}

@end
