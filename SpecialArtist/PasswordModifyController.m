//
//  PasswordModifyController.m
//  Artist
//
//  Created by cuibaoyin on 13-4-2.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import "PasswordModifyController.h"
#import "CustomNaviagtionBar.h"
#import "MyCustomTextField.h"

@interface PasswordModifyController ()

@end

@implementation PasswordModifyController

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
    //navigationBar
    [self setTitle:@"修改密码"];
    UIBarButtonItem *leftBar = [[CustomNaviagtionBar getInstance] barButtonItemImage:[UIImage imageNamed:@"backOff.png"] withPressedImage:[UIImage imageNamed:@"backOn.png"] withSize:CGSizeMake(41, 30)];
    [(UIButton *)leftBar.customView addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:leftBar];
    
    CGRect frame = CGRectMake(0, 0, 320, Application_HEIGHT - 44);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    self.view = view;
    
    password_old = [self produceTextField];
    frame = password_old.frame;
    frame.origin.x = 25;
    frame.origin.y = 15;
    password_old.frame = frame;
    password_old.placeholder = @"旧密码";
    password_old.secureTextEntry = YES;
    [self.view addSubview:password_old];
    
    frame.origin.y = frame.origin.y + frame.size.height + 10;
    password_new = [self produceTextField];
    password_new.frame = frame;
    password_new.placeholder = @"新密码";
    password_new.secureTextEntry = YES;
    [self.view addSubview:password_new];
    
    frame.origin.y = frame.origin.y + frame.size.height + 10;
    affirm_new = [self produceTextField];
    affirm_new.frame = frame;
    affirm_new.placeholder = @"重复密码";
    affirm_new.secureTextEntry = YES;
    [self.view addSubview:affirm_new];
    
    frame = affirm_new.frame;
    frame.origin.y = frame.origin.y + frame.size.height + 30;
    frame.size.width = 98;
    frame.size.height = 33;
    frame.origin.x = (320 - frame.size.width) * 0.5;
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = frame;
    [submitBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"modyOff" ofType:@"png"]] forState:UIControlStateNormal];
    [submitBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"modyOn" ofType:@"png"]] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(modify:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
    progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    [progressHud setLabelText:@"提交中..."];
    [self.view addSubview:progressHud];
    
    textHud = [[MBProgressHUD alloc] initWithView:self.view];
    [textHud setMode:MBProgressHUDModeText];
    [self.view addSubview:textHud];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)dealloc
{
    [password_old removeFromSuperview];
    password_old = nil;
    [affirm_new removeFromSuperview];
    affirm_new = nil;
    [password_new removeFromSuperview];
    password_new = nil;
    [progressHud removeFromSuperview];
    progressHud = nil;
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

- (void)modify:(id)sender
{
    [password_old resignFirstResponder];
    [password_new resignFirstResponder];
    [affirm_new resignFirstResponder];
    if (![affirm_new.text isEqualToString:password_new.text])
    {
        [textHud setLabelText:@"两次密码不一致"];
        [textHud show:YES];
        [textHud hide:YES afterDelay:2];
        return;
    }

    [progressHud show:YES];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:password_old.text,@"oldPassword",password_new.text,@"newPassword", nil];
    [serverRequest requestServerWithType:modyUserPassword withParamObject:dic];
}

#pragma mark - ServerRequestParamDelegate
- (void)requsetSuccessWithType:(RequsetType)type withServerData:(NSDictionary *)severData withMoreMark:(BOOL)flag
{
    [progressHud hide:YES];
    [textHud setLabelText:@"修改成功"];
    [textHud show:YES];
    [textHud hide:YES afterDelay:2];
}

- (void)requsetFailedWithType:(RequsetType)type
{
    [progressHud hide:YES];
    [textHud setLabelText:@"原密码不正确,请重试"];
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
