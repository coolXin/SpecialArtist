//
//  OauthorController.m
//  Artist
//
//  Created by cuibaoyin on 13-3-13.
//  Copyright (c) 2013年 wooboo. All rights reserved.
// when oauthor success return a NSDictionary ()

#import "OauthorController.h"
#import "ShareData.h"
#import "JSONKit.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "CustomNaviagtionBar.h"

@interface OauthorController ()

@end

@implementation OauthorController

- (id)initWithOauthorType:(OauthorType)type 
{
    if (self = [super init])
    {
        selectedType = type;
        userDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

#pragma mark - viewLifeScyle
- (void)loadView
{
    switch (selectedType)
    {
        case QQLogin_Oauthor:
        {
            [self setTitle:@"QQ登录授权"];
            break;
        }
        case SinaWeiBo_Oauthor:
        {
            [self setTitle:@"新浪微博授权"];
            break;
        }
        default:
            break;
    }
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navigationPic.png"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:14] forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *leftBar = [[CustomNaviagtionBar getInstance] barButtonItemImage:[UIImage imageNamed:@"backOff.png"] withPressedImage:[UIImage imageNamed:@"backOn.png"] withSize:CGSizeMake(41, 30)];
    [(UIButton *)leftBar.customView addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:leftBar];
    
    CGRect frame = CGRectMake(0, 0, Application_Frame.size.width, Application_Frame.size.height);
    frame.size.height = frame.size.height - 44;
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    self.view = view;
    
    oauthorWebView = [[UIWebView alloc] initWithFrame:self.view.frame];
    oauthorWebView.backgroundColor = [UIColor grayColor];
    oauthorWebView.delegate = self;
    [self.view addSubview:oauthorWebView];
    
    NSURL *oauthorUrl = [self generateOauthCodeUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:oauthorUrl];
    [oauthorWebView loadRequest:request];
    
    hud = [[MBProgressHUD alloc] initWithView:oauthorWebView];
    [oauthorWebView addSubview:hud];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - methods
- (void)goBack:(id)sender//取消授权或者授权成功后返回
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    DISMISSCONTROLLER(self);
}

- (NSURL*)generateURL:(NSString*)baseURL params:(NSDictionary*)params
{
	if (params)
    {
		NSMutableArray* pairs = [NSMutableArray array];
		for (NSString* key in params.keyEnumerator)
        {
			NSString* value = [params objectForKey:key];
            value = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
		}
		NSString* query = [pairs componentsJoinedByString:@"&"];
		NSString* url = [NSString stringWithFormat:@"%@?%@", baseURL, query];
        
		return [NSURL URLWithString:url];
	}
    else
    {
		return [NSURL URLWithString:baseURL];
	}
}

- (NSString *) getStringFromUrl: (NSString*) url needle:(NSString *) needle
{
	NSString * str = nil;
	NSRange start = [url rangeOfString:needle];
	if (start.location != NSNotFound)
    {
		NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
		NSUInteger offset = start.location+start.length;
		str = end.location == NSNotFound
		? [url substringFromIndex:offset]
		: [url substringWithRange:NSMakeRange(offset, end.location)];
		str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	}
	return str;
}

#pragma mark - oauthor methods
-(NSURL*)generateOauthCodeUrl //生成授权url，传给webView加载
{
    switch (selectedType)
    {
        case SinaWeiBo_Oauthor:
        {
            NSMutableDictionary* SinaParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                               @"mobile",                             @"display",
                                               @"wooboo",                           @"state",
                                               SINA_APP_KEY,                       @"client_id",
                                               SINA_REDIRECT_URL,              @"redirect_uri",
                                               nil];
            
            return  [self generateURL:SINA_API_AUTHORIZE params:SinaParams];
        }
        case QQLogin_Oauthor:
        {
            NSString *scope = @"get_simple_userinfo,add_share,get_info,add_t,add_pic_t";
            NSMutableDictionary* QQParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             @"token",                              @"response_type",
                                             @"wooboo",                          @"state",
                                             scope,                                   @"scope",
                                             QQ_APP_ID,                           @"client_id",
                                             QQ_REDIRECT_URL,               @"redirect_uri",
                                             nil];
            
            return  [self generateURL:QQ_API_TOKEN params:QQParams];
        }
        default:
            return nil;
    }
}

- (void)getQQAccessTokenWith:(NSString *)urlString //取出AccessToken
{
    NSString *token = [self getStringFromUrl:urlString needle:@"access_token="];
    NSString *expires_in = [self getStringFromUrl:urlString needle:@"expires_in="];
    NSString *state = [self getStringFromUrl:urlString needle:@"state="];
    if ([state isEqualToString:@"wooboo"])
    {
        [userDic setObject:token forKey:@"access_token"];
        [userDic setObject:expires_in forKey:@"expires_in"];
        [self getQQLoginOpenIdWith:token]; //开始获取openID
    }
}

- (void)getQQLoginOpenIdWith:(NSString *)tokenID   //获取OpenID相当于QQ号
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   tokenID,                              @"access_token",
                                   nil];
    NSURL *url = [self generateURL:QQ_API_OPENID params:params];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *request = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSString *openId = [[str componentsSeparatedByString:@"="] lastObject];
         [userDic setObject:openId forKey:@"only_id"];
         [self oauthorSuccess];
         NSLog(@"QQ授权完成");
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self oauthorFailed];
     }];
    [request start];
}

- (void)getSinaAccessTokenWithCode:(NSString *)code
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"authorization_code",                             @"grant_type",
                                       code,                                    @"code",
                                       SINA_APP_KEY,                      @"client_id",
                                       SINA_APP_SECRET,                @"client_secret",
                                       SINA_REDIRECT_URL,             @"redirect_uri",
                                       nil];
    
    AFHTTPClient *request = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:SINA_API_TOKEN]];
    [request postPath:SINA_API_TOKEN parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSMutableDictionary *dic = [[JSONDecoder decoder] mutableObjectWithData:responseObject];
         if ([dic objectForKey:@"access_token"] != nil)
         {
             [userDic setObject:[dic objectForKey:@"access_token"] forKey:@"access_token"];
             [userDic setObject:[dic objectForKey:@"expires_in"] forKey:@"expires_in"];
             [userDic setObject:[dic objectForKey:@"uid"] forKey:@"only_id"];
             [self oauthorSuccess];
             NSLog(@"Sina授权完成");
        }
         else
         {
             [self oauthorFailed];
         }
    }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self oauthorFailed];
    }];
}

- (void)oauthorSuccess //授权成功，返回一个NSdictionary ,包含access_token,expires_in,only_id(qq登录或者新浪微博的用户唯一凭证)
{
    if (selectedType == QQLogin_Oauthor)//将授权获取的凭证存入本地
    {
        [[NSUserDefaults standardUserDefaults] setObject:[userDic objectForKey:@"access_token"] forKey:@"tecent_access_token"];
        [[NSUserDefaults standardUserDefaults] setObject:[userDic objectForKey:@"expires_in"] forKey:@"tecent_expires_in"];
        [[NSUserDefaults standardUserDefaults] setObject:[userDic objectForKey:@"only_id"] forKey:@"tecent_only_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:[userDic objectForKey:@"access_token"] forKey:@"sina_access_token"];
        [[NSUserDefaults standardUserDefaults] setObject:[userDic objectForKey:@"expires_in"] forKey:@"sina_expires_in"];
        [[NSUserDefaults standardUserDefaults] setObject:[userDic objectForKey:@"only_id"] forKey:@"sina_only_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self dismissViewControllerAnimated:YES completion:^
    {
        if ([_delegate respondsToSelector:@selector(oauthorSuccessWithType:withUserDic:)])
        {
            [_delegate oauthorSuccessWithType:selectedType withUserDic:userDic];
        }
    }];
}

- (void)oauthorFailed //授权失败
{
    if ([_delegate respondsToSelector:@selector(oauthorFailed)])
    {
        [_delegate oauthorFailed];
    }
    [self goBack:nil];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
//    NSLog(@"%@",url);
    if ([[url absoluteString ] hasPrefix:QQ_REDIRECT_URL])
    {
        [self getQQAccessTokenWith:[url absoluteString]]; //取出AccessToken,应该加载菊花
    }
    if ([[url absoluteString] hasPrefix:SINA_REDIRECT_URL])
    {
        NSString *code = [self getStringFromUrl:[url absoluteString] needle:@"code="];//取出AccessToken,应该加载菊花
        [self getSinaAccessTokenWithCode:code];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [hud show:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [hud hide:YES];
    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
}

@end
