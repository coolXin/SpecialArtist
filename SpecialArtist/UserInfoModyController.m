//
//  UserInfoModyController.m
//  Artist
//
//  Created by cuibaoyin on 13-4-2.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import "UserInfoModyController.h"
#import "CustomNaviagtionBar.h"
#import "MyCustomTextField.h"

@interface UserInfoModyController ()

@end

@implementation UserInfoModyController

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
    [self setTitle:@"信息修改"];
    UIBarButtonItem *leftBar = [[CustomNaviagtionBar getInstance] barButtonItemImage:[UIImage imageNamed:@"backOff.png"] withPressedImage:[UIImage imageNamed:@"backOn.png"] withSize:CGSizeMake(41, 30)];
    [(UIButton *)leftBar.customView addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:leftBar];
    
    CGRect frame = CGRectMake(0, 0, 320, Application_HEIGHT - 44);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    self.view = view;
    
    nickNameLabel = [self produceTextField];
    frame = nickNameLabel.frame;
    frame.origin.x = 25;
    frame.origin.y = 15;
    nickNameLabel.frame = frame;
    nickNameLabel.placeholder = @"昵称";
    [self.view addSubview:nickNameLabel];
    
    frame.origin.y = frame.origin.y + frame.size.height + 10;
    phoneNameLabel = [self produceTextField];
    phoneNameLabel.frame = frame;
    phoneNameLabel.placeholder = @"手机号码";
    [self.view addSubview:phoneNameLabel];
    
    frame.origin.y = frame.origin.y + frame.size.height + 10;
    frame.origin.x = frame.origin.x + 5;
    frame.size.width = 65;
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"性别:";
    [self.view addSubview:label];
    
    frame.origin.x = frame.origin.x + frame.size.width + 10;
    frame.size = CGSizeMake(20, 30);
    UIImageView *sexBackground = [[UIImageView alloc] initWithFrame:frame];
    sexBackground.image = [UIImage imageNamed:@"sexBackground.png"];
    sexBackground.contentMode = UIViewContentModeCenter;
    [self.view addSubview:sexBackground];
    
    manBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    manBtn.frame = frame;
    manBtn.tag = 0;
    [manBtn addTarget:self action:@selector(sexChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:manBtn];
    
    frame.origin.x = frame.origin.x + frame.size.width + 5;
    frame.size = CGSizeMake(20, 30);
    UILabel *manLabel = [[UILabel alloc] initWithFrame:frame];
    manLabel.backgroundColor = [UIColor clearColor];
    manLabel.text = @"男";
    manLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:manLabel];
    
    frame.origin.x = frame.origin.x + frame.size.width + 30;
    frame.size = CGSizeMake(20, 30);
    sexBackground = [[UIImageView alloc] initWithFrame:frame];
    sexBackground.image = [UIImage imageNamed:@"sexBackground.png"];
    sexBackground.contentMode = UIViewContentModeCenter;
    [self.view addSubview:sexBackground];
    
    womenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    womenBtn.frame = frame;
    womenBtn.tag = 1;
    [womenBtn addTarget:self action:@selector(sexChanged:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:womenBtn];
    
    frame.origin.x = frame.origin.x + frame.size.width + 5;
    frame.size = CGSizeMake(20, 30);
    UILabel *womenLabel = [[UILabel alloc] initWithFrame:frame];
    womenLabel.backgroundColor = [UIColor clearColor];
    womenLabel.text = @"女";
    womenLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:womenLabel];
    
    frame.origin.y = frame.origin.y + frame.size.height + 30;
    frame.size.width = 98;
    frame.size.height = 33;
    frame.origin.x = (320 - frame.size.width) * 0.5;
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = frame;
    [submitBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"modyOff" ofType:@"png"]] forState:UIControlStateNormal];
    [submitBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"modyOn" ofType:@"png"]] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(modifyInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self getUserInfo];
    progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    [progressHud setLabelText:@"提交中..."];
    [self.view addSubview:progressHud];
    
    textHud = [[MBProgressHUD alloc] initWithView:self.view];
    [textHud setMode:MBProgressHUDModeText];
    [self.view addSubview:textHud];
}

- (void)dealloc
{
    serverRequest.delegate = nil;
    serverRequest = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -methods
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

- (void)getUserInfo
{
    NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserNickName"];
    NSString *sex = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserSex"];
    NSString *phoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserPhone"];
    nickNameLabel.text = nickName;
    phoneNameLabel.text = phoneNum;
    sexMark = [sex intValue];
    if (sexMark == 0)
    {
        [manBtn setImage:[UIImage imageNamed:@"sexSelected.png"] forState:UIControlStateNormal];
    }
    else
    {
        [womenBtn setImage:[UIImage imageNamed:@"sexSelected.png"] forState:UIControlStateNormal];
    }
}

- (void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)modifyInfo:(id)sender
{
    [nickNameLabel resignFirstResponder];
    [phoneNameLabel resignFirstResponder];
    [progressHud show:YES];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nickNameLabel.text,@"UserNickName",phoneNameLabel.text,@"UserPhoneNum",[NSNumber numberWithInt:sexMark],@"UserGender", nil];
    [serverRequest requestServerWithType:modyUserInfo withParamObject:dic];
}

- (void)sexChanged:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    sexMark = btn.tag;
    [manBtn setImage:nil forState:UIControlStateNormal];
    [womenBtn setImage:nil forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"sexSelected.png"] forState:UIControlStateNormal];
}

#pragma mark - ServerRequestParamDelegate
- (void)requsetSuccessWithType:(RequsetType)type withServerData:(NSDictionary *)severData withMoreMark:(BOOL)flag
{
    [progressHud hide:YES];
    [textHud setLabelText:@"个人信息更新成功"];
    [textHud show:YES];
    [textHud hide:YES afterDelay:2];
    
    NSDictionary *dataDic = [severData objectForKey:@"DATA"];
    [[NSUserDefaults standardUserDefaults] setObject:[dataDic objectForKey:@"realName"] forKey:@"UserNickName"];
    [[NSUserDefaults standardUserDefaults] setObject:[dataDic objectForKey:@"mobile"] forKey:@"UserPhone"];
    [[NSUserDefaults standardUserDefaults] setObject:[dataDic objectForKey:@"sex"] forKey:@"UserSex"];
}

- (void)requsetFailedWithType:(RequsetType)type
{
    [progressHud hide:YES];
    [textHud setLabelText:@"个人信息更新失败,请重试"];
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
