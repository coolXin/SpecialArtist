//
//  shareToController.m
//  Artist
//
//  Created by cuibaoyin on 13-4-1.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import "ShareToController.h"
#import "OauthorController.h"
#import "ArtWorksModel.h"
#import "CustomNaviagtionBar.h"

@interface ShareToController ()

@end

@implementation ShareToController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//    }
//    return self;
//}

- (id)initWithObject:(id)model withSharedImage:(UIImage *)image
{
    if (self = [super init])
    {
        operation = [[OpenAPIOperation alloc] init];
        operation.delegate = self;
        serverRequest = [[ServerRequestParam alloc] init];
        serverRequest.delegate = self;
        objectModel = model;
        sharedImage = image;
        
        selectedType = share_artwork;
        ArtWorksModel *workModel = (ArtWorksModel *)model;
        modelID = workModel.id;
    }
    return self;
}

- (void)loadView
{
    [self setTitle:@"分享"];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navigationPic.png"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:14] forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *leftBar = [[CustomNaviagtionBar getInstance] barButtonItemImage:[UIImage imageNamed:@"backOff.png"] withPressedImage:[UIImage imageNamed:@"backOn.png"] withSize:CGSizeMake(41, 30)];
    [(UIButton *)leftBar.customView addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:leftBar];

    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, Application_HEIGHT)];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 110)];
    inputView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:inputView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, inputView.frame.size.width, inputView.frame.size.height)];
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shareInputBackground" ofType:@"png"]];
    imageView.image = [image stretchableImageWithLeftCapWidth:29 topCapHeight:16];
    [inputView addSubview:imageView];
    
    UIImageView *sharedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 100, 100)];
    sharedImageView.image = sharedImage;
    [inputView addSubview:sharedImageView];
    
    messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(sharedImageView.frame.origin.x + sharedImageView.frame.size.width, 5, inputView.frame.size.width - sharedImageView.frame.size.width - 5, 100)];
    messageTextView.backgroundColor = [UIColor clearColor];
    messageTextView.delegate = self;
    messageTextView.returnKeyType = UIReturnKeyDone;
    messageTextView.font = [UIFont systemFontOfSize:15];
    messageTextView.textColor = [UIColor blackColor];
    messageTextView.textAlignment = NSTextAlignmentLeft;
    ArtWorksModel *workModel = (ArtWorksModel *)objectModel;
    messageTextView.text = [NSString stringWithFormat:@"在好艺术APP中发现一款好的作品:%@，地址:http://github.com",workModel.title];
    [inputView addSubview:messageTextView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, inputView.frame.origin.y + inputView.frame.size.height + 25, 300, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:20];
    label.text = @"分享作品到";
    label.textColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
    
    CGRect frame = label.frame;
    frame.origin.y = frame.origin.y + frame.size.height + 15;
    frame.origin.x = 10 + 32;
    frame.size = CGSizeMake(58, 58);
    UIButton *sinaShare = [UIButton buttonWithType:UIButtonTypeCustom];
    sinaShare.frame = frame;
    [sinaShare setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sina" ofType:@"png"]] forState:UIControlStateNormal];
    [sinaShare addTarget:self action:@selector(shareToSina:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sinaShare];
    
    frame.origin.y = frame.origin.y + frame.size.height + 5;
    frame.size = CGSizeMake(58, 20);
    label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"新浪微博";
//    label.textColor = [UIColor grayColor];
    [self.view addSubview:label];
    
    frame = sinaShare.frame;
    frame.origin.x = frame.origin.x + frame.size.width + 32;
    UIButton *tencentShare = [UIButton buttonWithType:UIButtonTypeCustom];
    tencentShare.frame = frame;
    [tencentShare setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tecent" ofType:@"png"]] forState:UIControlStateNormal];
    [tencentShare addTarget:self action:@selector(shareToTecentWeibo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tencentShare];
    
    frame.origin.y = frame.origin.y + frame.size.height + 5;
    frame.size = CGSizeMake(58, 20);
    label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"腾讯微博";
    //    label.textColor = [UIColor grayColor];
    [self.view addSubview:label];
    
    frame = tencentShare.frame;
    frame.origin.x = frame.origin.x + frame.size.width + 32;
    UIButton *wechatFriend = [UIButton buttonWithType:UIButtonTypeCustom];
    wechatFriend.frame = frame;
    [wechatFriend setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wechatFriend" ofType:@"png"]] forState:UIControlStateNormal];
    [wechatFriend addTarget:self action:@selector(shareToWechat:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wechatFriend];
    
    frame.origin.y = frame.origin.y + frame.size.height + 5;
    frame.size = CGSizeMake(58, 20);
    label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"微信好友";
    //    label.textColor = [UIColor grayColor];
    [self.view addSubview:label];
    
    frame = sinaShare.frame;
    frame.origin.y = frame.origin.y + frame.size.height + 25 + 10;
    UIButton *wechatFriends = [UIButton buttonWithType:UIButtonTypeCustom];
    wechatFriends.frame = frame;
    wechatFriends.tag = 1;
    [wechatFriends setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"wechatFriends" ofType:@"png"]] forState:UIControlStateNormal];
    [wechatFriends addTarget:self action:@selector(shareToWechat:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wechatFriends];
    
    frame.origin.y = frame.origin.y + frame.size.height + 5;
    frame.size = CGSizeMake(58, 20);
    label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"微信好友圈";
    //    label.textColor = [UIColor grayColor];
    [self.view addSubview:label];
    
    frame = wechatFriends.frame;
    frame.origin.x = frame.origin.x + frame.size.width + 32;
    UIButton *messageShare = [UIButton buttonWithType:UIButtonTypeCustom];
    messageShare.frame = frame;
    [messageShare setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"message" ofType:@"png"]] forState:UIControlStateNormal];
    [messageShare addTarget:self action:@selector(shareToMSG:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:messageShare];
    
    frame.origin.y = frame.origin.y + frame.size.height + 5;
    frame.size = CGSizeMake(58, 20);
    label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"短信";
    //    label.textColor = [UIColor grayColor];
    [self.view addSubview:label];
    
    frame = messageShare.frame;
    frame.origin.x = frame.origin.x + frame.size.width + 32;
    UIButton *emailShare = [UIButton buttonWithType:UIButtonTypeCustom];
    emailShare.frame = frame;
    [emailShare setBackgroundImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"email" ofType:@"png"]] forState:UIControlStateNormal];
    [emailShare addTarget:self action:@selector(shareToEmail:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:emailShare];
    
    frame.origin.y = frame.origin.y + frame.size.height + 5;
    frame.size = CGSizeMake(58, 20);
    label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"邮件";
    //    label.textColor = [UIColor grayColor];
    [self.view addSubview:label];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
       
    progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progressHud];
    [progressHud setLabelText:@"发送中..."];
    
    textHud = [[MBProgressHUD alloc] initWithView:self.view];
    [textHud setMode:MBProgressHUDModeText];
    [self.view addSubview:textHud];
}

- (void)dealloc
{
    [messageTextView removeFromSuperview];
    messageTextView = nil;
    [progressHud removeFromSuperview];
    progressHud = nil;
    [textHud removeFromSuperview];
    textHud = nil;
    sharedImage = nil;
    objectModel = nil;
    operation.delegate = nil;
    operation = nil;
    serverRequest.delegate = nil;
    serverRequest = nil;
}

#pragma mark - IBAction
- (void)goBack:(id)semder
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)shareToSina:(id)sender
{
    if ([self tellSinaOauthor])
    {
        [progressHud show:YES];
        NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"sina_access_token"];
        NSString *only_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"sina_only_id"];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:access_token,@"access_token",only_id,@"only_id", nil];
        [operation setOauthorMark:dic];
        [operation addMessageToSinaWithText:messageTextView.text withImage:sharedImage];
    }
}

- (void)shareToTecentWeibo:(id)sender
{
    if ([self tellTecentOauthor])
    {
        [progressHud show:YES];
        NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"tecent_access_token"];
        NSString *only_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"tecent_only_id"];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:access_token,@"access_token",only_id,@"only_id", nil];
        [operation setOauthorMark:dic];
        [operation addMessageToTecentWeiBoWithText:messageTextView.text withImage:sharedImage];
    }
}

- (void)shareToQQSpace:(id)sender
{
    if ([self tellTecentOauthor])
    {
        [progressHud show:YES];
        NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"tecent_access_token"];
        NSString *only_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"tecent_only_id"];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:access_token,@"access_token",only_id,@"only_id", nil];
        [operation setOauthorMark:dic];
        
        ArtWorksModel *workModel = (ArtWorksModel *)objectModel;
        [operation addSpaceShareWithTitle:[NSString stringWithFormat:@"作品:%@",workModel.title] withPath:workModel.image_original withMessage:messageTextView.text imagePath:workModel.image_original];
    }
}

- (void)shareToWechat:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    ArtWorksModel *workModel = (ArtWorksModel *)objectModel;
    [operation addMessageToWeChatWithType:btn.tag withTitle:workModel.title withDescription:@"我在好艺术app中发现了一款不错的作品" withImage:sharedImage withUrl:@"www.wooboo.com.cn"];
}

- (void)shareToMSG:(id)sender
{
    [operation addMessageToMSGWithText:@"我在好艺术app中发现了一款不错的作品" withViewController:self];
}

- (void)shareToEmail:(id)sender
{
    [operation addMessageToMailWithTitle:messageTextView.text withText:@"我要分享" withImage:sharedImage withViewController:self];
}

#pragma mark - methods
- (BOOL)tellTecentOauthor//判断腾讯是否授权，授权是否过期
{
    NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"tecent_access_token"];
    NSString *only_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"tecent_only_id"];
    
    if (access_token != nil && only_id != nil)
    {
        return YES;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"你尚未使用腾讯帐号对好艺术授权,是否授权进行分享？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"授权", nil];
        alert.tag = QQLogin_Oauthor;
        [alert show];
        return NO;
    }
}

- (BOOL)tellSinaOauthor//判断新浪是否授权，授权是否过期
{
    NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"sina_access_token"];
    NSString *only_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"sina_only_id"];
    //    NSString *expires_in = [[NSUserDefaults standardUserDefaults] objectForKey:@"sina_expires_in"];
    if (access_token != nil && only_id != nil)
    {
        return YES;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"你尚未使用新浪微博对好艺术授权,是否授权进行分享？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"授权", nil];
        alert.tag = SinaWeiBo_Oauthor;
        [alert show];
        return NO;
    }
}

- (void)showOauthorViewWith:(OauthorType)type//展示授权页面
{
    OauthorController *oauthor = [[OauthorController alloc] initWithOauthorType:type];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:oauthor];
    [self.navigationController presentModalViewController:nav animated:YES];
}

- (void)sendMessageToSeverWithType:(OperationType)type
{
    NSString *shareType;
    switch (type)
    {
        case QQSpace_Add_Share:
            shareType = @"QQ空间";
            break;
        case TecentWeiBo_Add_TextMessage:
            shareType = @"腾讯微博";
            break;
        case Sina_Add_TextMessage:
            shareType = @"新浪微博";
            break;
        case Email_Share:
            shareType = @"邮件";
            break;
        case Wechat_Share:
            shareType = @"微信";
            break;
        default:
            break;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:modelID,@"objectID",shareType,@"shareType",nil];
    [serverRequest requestServerWithType:selectedType withParamObject:dic];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    else
        return YES;
}

#pragma mark - ServerRequestParamDelegate
- (void)requsetSuccessWithType:(RequsetType)type withServerData:(NSDictionary *)severData withMoreMark:(BOOL)flag
{
    NSLog(@"请求成功");
}

- (void)requsetFailedWithType:(RequsetType)type
{
    NSLog(@"请求失败");
}

#pragma mark - OpenAPIOperationDelegate
- (void)operationSuccessWithType:(OperationType)type withObject:(NSMutableDictionary *)dic
{
    [self sendMessageToSeverWithType:type];
    if (type == Sina_Add_PicMessage || type == QQSpace_Add_Share || type == TecentWeiBo_Add_PicMessage)
    {
        [progressHud hide:YES];
        [textHud setLabelText:@"消息发送成功"];
        [textHud show:YES];
        [textHud hide:YES afterDelay:2];
    }
}

- (void)operationFailedWithType:(OperationType)type
{
    if (type == Sina_Add_PicMessage || type == QQSpace_Add_Share || type == TecentWeiBo_Add_PicMessage)
    {
        [progressHud hide:YES];
        [textHud setLabelText:@"消息发送失败,请重试!"];
        [textHud show:YES];
        [textHud hide:YES afterDelay:2];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 1:
        {
            if (alertView.tag == QQLogin_Oauthor)
            {
                [self showOauthorViewWith:QQLogin_Oauthor];
            }
            else
            {
                [self showOauthorViewWith:SinaWeiBo_Oauthor];
            }
            break;
        }
        default:
            break;
    }
}

@end
