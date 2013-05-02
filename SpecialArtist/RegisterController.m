//
//  RegisterController.m
//  Artist
//
//  Created by cuibaoyin on 13-3-18.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import "RegisterController.h"
#import "CustomNaviagtionBar.h"
#import "MyCustomTextField.h"
@interface RegisterController ()

@end

@implementation RegisterController

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
    [self setTitle:@"用户注册"];
    UIBarButtonItem *leftBar = [[CustomNaviagtionBar getInstance] barButtonItemImage:[UIImage imageNamed:@"backOff.png"] withPressedImage:[UIImage imageNamed:@"backOn.png"] withSize:CGSizeMake(41, 30)];
    [(UIButton *)leftBar.customView addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:leftBar];

    CGRect frame = CGRectMake(0, 0, 320, Application_HEIGHT - 44);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    self.view = view;
        
    loginNameField = [self produceTextField];
    frame = loginNameField.frame;
    frame.origin.x = 25;
    frame.origin.y = 15;
    loginNameField.frame = frame;
    loginNameField.placeholder = @"账号,请使用常用邮箱";
    [self.view addSubview:loginNameField];

    frame.origin.y = frame.origin.y + frame.size.height + 10;
    nickNameField = [self produceTextField];
    nickNameField.frame = frame;
    nickNameField.placeholder = @"昵称";
    [self.view addSubview:nickNameField];
    
    frame.origin.y = frame.origin.y + frame.size.height + 10;
    passwordField = [self produceTextField];
    passwordField.frame = frame;
    passwordField.placeholder = @"登录密码";
    [self.view addSubview:passwordField];
    
    frame.origin.y = frame.origin.y + frame.size.height + 10;
    passwordAgainField = [self produceTextField];
    passwordAgainField.frame = frame;
    passwordAgainField.placeholder = @"重复密码";
    [self.view addSubview:passwordAgainField];
    
    frame.origin.y = frame.origin.y + frame.size.height + 25;
    frame.origin.x = (320 - 99) * 0.5;
    frame.size.height = 33;
    frame.size.width = 99;
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = frame;
    [registerBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"registerOff" ofType:@"png"]] forState:UIControlStateNormal];
    [registerBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"registerOn" ofType:@"png"]] forState:UIControlStateHighlighted];
    [registerBtn addTarget:self action:@selector(submitToServer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
       
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [hud setLabelText:@"提交中..."];
    [self.view addSubview:hud];
    textHud = [[MBProgressHUD alloc] initWithView:self.view];
    [textHud setMode:MBProgressHUDModeText];
    [self.view addSubview:textHud];
}

- (void)dealloc
{
    [loginNameField removeFromSuperview];
    loginNameField = nil;
    [nickNameField removeFromSuperview];
    nickNameField = nil;
    [passwordField removeFromSuperview];
    passwordField = nil;
    [passwordAgainField removeFromSuperview];
    passwordAgainField = nil;
    [hud removeFromSuperview];
    hud = nil;
    [textHud removeFromSuperview];
    textHud = nil;
    serverRequest.delegate = nil;
    serverRequest = nil;
}

#pragma mark - methods
- (UITextField *)produceTextField
{
    MyCustomTextField * textField = [[MyCustomTextField alloc] initWithFrame:CGRectMake(0, 0, 270, 38)];
    textField.borderStyle = UITextBorderStyleNone;
    textField.background = [[UIImage imageNamed:@"inputBackImage.png"] stretchableImageWithLeftCapWidth:19 topCapHeight:15];
    textField.font = [UIFont boldSystemFontOfSize:15];
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    return textField;
}

- (void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitToServer:(id)sender
{
    [loginNameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [passwordAgainField resignFirstResponder];
    [nickNameField resignFirstResponder];
    
    if ([self judgeFormRight])
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    loginNameField.text,   @"UserName",
                                    passwordField.text,     @"UserPassword",
                                    nickNameField.text,    @"UserNickName",nil];
        [serverRequest requestServerWithType:register_wooboo withParamObject:dic];
    }
}

- (BOOL)judgeFormRight
{
    if (loginNameField.text.length <= 0)
    {
        [textHud setLabelText:@"用户名不能为空!"];
        [textHud show:YES];
        [textHud hide:YES afterDelay:2];
        return NO;
    }
    else if (![self isValidateEmail:loginNameField.text])
    {
        [textHud setLabelText:@"请使用邮箱来注册!"];
        [textHud show:YES];
        [textHud hide:YES afterDelay:2];
        return NO;
    }
    else if (nickNameField.text.length <= 0)
    {
        [textHud setLabelText:@"昵称不能为空!"];
        [textHud show:YES];
        [textHud hide:YES afterDelay:2];
        return NO;
    }
    else if (passwordField.text.length <= 0)
    {
        [textHud setLabelText:@"密码不能为空!"];
        [textHud show:YES];
        [textHud hide:YES afterDelay:2];
        return NO;
    }
    else if (passwordField.text.length < 6)
    {
        [textHud setLabelText:@"密码长度必须大于6位!"];
        [textHud show:YES];
        [textHud hide:YES afterDelay:2];
        return NO;
    }
    else if (![passwordField.text isEqualToString:passwordAgainField.text])
    {
        [textHud setLabelText:@"两次密码不一致!"];
        [textHud show:YES];
        [textHud hide:YES afterDelay:2];
        return NO;
    }
    //    else if (!self.protocolBtn.tag)
    //    {
    //        [[ATMHud getInstance] showAlert:@"请同意使用协议" withActivity:NO withHiden:YES withView:self.view];
    //        return NO;
    //    }
    else
    {
        return YES;
    }
}

-(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - ServerRequestParamDelegate
- (void)requsetSuccessWithType:(RequsetType)type withServerData:(NSDictionary *)severData withMoreMark:(BOOL)flag
{
    [hud setLabelText:@"注册成功,登录中..."];
    NSDictionary *dataDic = [severData objectForKey:@"DATA"];
    NSString *userID = [dataDic objectForKey:@"id"];
    NSString *userLoginName = [dataDic objectForKey:@"userName"];
    NSString *userNickName = [dataDic objectForKey:@"realName"];
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"UserID"];
    [[NSUserDefaults standardUserDefaults] setObject:userLoginName forKey:@"UserLoginName"];
    [[NSUserDefaults standardUserDefaults] setObject:userNickName forKey:@"UserNickName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginStatusChanged" object:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)requsetFailedWithType:(RequsetType)type
{
    [hud hide:YES];
    [textHud setLabelText:@"注册失败,请重试!"];
    [textHud show:YES];
    [textHud hide:YES afterDelay:2];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

@end
