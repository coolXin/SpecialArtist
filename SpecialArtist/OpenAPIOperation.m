//
//  OpenAPIOperation.m
//  Artist
//
//  Created by cuibaoyin on 13-3-13.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import "OpenAPIOperation.h"
#import "ShareData.h"
#import "WXApi.h"
#import "JSONKit.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@implementation OpenAPIOperation
- (void)setOauthorMark:(NSDictionary *)info
{
    acess_token = [info objectForKey:@"access_token"];
    only_id = [info objectForKey:@"only_id"];
}

#pragma mark - methods
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

- (void)requestWithType:(OperationType)type withUrl:(NSString *)requestUrl withRequestParams:(NSMutableDictionary *)params withImage:(UIImage *)image
{
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:requestUrl]];
    NSURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:requestUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         if (image != nil)
         {
             [formData appendPartWithFileData:UIImagePNGRepresentation(image)  name:@"pic" fileName:@"image" mimeType:@"png"];
         }
     }];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
         NSMutableDictionary *dic = [[JSONDecoder decoder] mutableObjectWithData:responseObject];
         NSLog(@"%@",dic);
         if ([_delegate respondsToSelector:@selector(operationSuccessWithType:withObject:)])
         {
             [_delegate operationSuccessWithType:type withObject:dic];
         }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@",error);
         [_delegate operationFailedWithType:type];
     }];
    [operation start];
}

#pragma mark - QQLogin_API_Operation
//获取空间用户信息
- (void)getSpaceUserInfo
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   acess_token,                       @"access_token",
                                   only_id,                              @"openid",
                                   QQ_APP_ID,                                         @"oauth_consumer_key",
                                   nil];
    NSURL *url = [self generateURL:QQ_SPACE_USER_INFO params:params];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *request = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSMutableDictionary *dic = [[JSONDecoder decoder] mutableObjectWithData:responseObject];
         
         NSString *nickName = [dic objectForKey:@"nickname"];
         NSString *avater = [dic objectForKey:@"figureurl_2"];
         NSDictionary *userDic = [[NSDictionary alloc] initWithObjectsAndKeys:nickName,@"nickName",avater,@"avaterUrl",only_id,@"only_id",nil];
         if ([_delegate respondsToSelector:@selector(operationSuccessWithType:withObject:)])
         {
             [_delegate operationSuccessWithType:QQSpace_Get_User_Info withObject:userDic];
         }
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if ([_delegate respondsToSelector:@selector(operationFailedWithType:)])
         {
             [_delegate operationFailedWithType:QQSpace_Get_User_Info];
         }
     }];
    [request start];
}

//添加空间分享
- (void)addSpaceShareWithTitle:(NSString *)title withPath:(NSString *)path  withMessage:(NSString *)textMessage imagePath:(NSString *)imagePath
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   acess_token,                       @"access_token",
                                   only_id,                              @"openid",
                                   QQ_APP_ID,                                         @"oauth_consumer_key",
                                   title,                                          @"title",
                                   path,                                    @"url",
                                   @"艺术家app",                                                    @"site",
                                   @"http://www.wooboo.com.cn",                  @"fromurl",
                                   @"json",                                              @"format",
                                   textMessage,                                       @"summary",
                                   imagePath,            @"images",
                                   nil];
    [self requestWithType:QQSpace_Add_Share withUrl:QQ_SPACE_ADD_SHARE withRequestParams:params withImage:nil];
}

//获取腾讯微博用户信息
- (void)getTecentWeiBoUserInfo
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   acess_token,                       @"access_token",
                                   only_id,                              @"openid",
                                   QQ_APP_ID,                                         @"oauth_consumer_key",
                                   @"json",                                              @"format",
                                   nil];
    [self requestWithType:TecentWeiBo_Get_User_Info withUrl:TECENTWEIBO_USER_INFO withRequestParams:params withImage:nil];
}

//向腾讯微博发送文字消息
- (void)addMessageToTecentWeiBoWithText:(NSString *)txtMessage
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   acess_token,                       @"access_token",
                                   only_id,                              @"openid",
                                   QQ_APP_ID,                                         @"oauth_consumer_key",
                                   txtMessage,                                         @"content",
                                   @"json",                                               @"format",
                                   [NSString stringWithFormat:@"%d",0],   @"compatibleflag",
                                   nil];
    [self requestWithType:TecentWeiBo_Add_TextMessage withUrl:TECENTWEIBO_ADD_TEXTMESSAGE withRequestParams:params withImage:nil];
}

//向腾讯微博发送图片消息
- (void)addMessageToTecentWeiBoWithText:(NSString *)textMessage withImage:(UIImage *)image
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   acess_token,                       @"access_token",
                                   only_id,                              @"openid",
                                   QQ_APP_ID,                                         @"oauth_consumer_key",
                                   textMessage,                                       @"content",
                                   @"json",                                               @"format",
                                   [NSString stringWithFormat:@"%d",0],   @"compatibleflag",
                                   nil];
    [self requestWithType:TecentWeiBo_Add_PicMessage withUrl:TECENTWEIBO_ADD_PICMESSAGE withRequestParams:params withImage:image];
}

#pragma mark - Sina_API_Operation
//获取Sina微博用户信息
- (void)getSinaUserInfo
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   acess_token,                              @"access_token",
                                   only_id,                                           @"uid",
                                   nil];
    NSURL *url = [self generateURL:SINA_USER_INFO params:params];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *request = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSMutableDictionary *dic = [[JSONDecoder decoder] mutableObjectWithData:responseObject];
         NSString *nickName = [dic objectForKey:@"name"];
         NSString *avater = [dic objectForKey:@"avatar_large"];
         NSDictionary *userDic = [[NSDictionary alloc] initWithObjectsAndKeys:nickName,@"nickName",avater,@"avaterUrl",only_id,@"only_id",nil];
        if ([_delegate respondsToSelector:@selector(operationSuccessWithType:withObject:)])
         {
             [_delegate operationSuccessWithType:Sina_Get_User_Info withObject:userDic];
         }
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if ([_delegate respondsToSelector:@selector(operationFailedWithType:)])
         {
             [_delegate operationFailedWithType:Sina_Get_User_Info];
         }
     }];
    [request start];
}

//向Sina微博发送文字信息
- (void)addMessageToSinaWithText:(NSString *)txtMessage
{   
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   SINA_APP_KEY,                                       @"source",
                                   acess_token,                                  @"access_token",
                                   txtMessage,                                           @"status",
                                   nil];
    [self requestWithType:Sina_Add_TextMessage withUrl:SINA_ADD_TEXTMESSAGE withRequestParams:params withImage:nil];
}

//向Sina微博发送图片信息
- (void)addMessageToSinaWithText:(NSString *)textMessage withImage:(UIImage *)image
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   SINA_APP_KEY,                                       @"source",
                                   acess_token,                                 @"access_token",
                                   textMessage,                                          @"status",
                                   nil];
    [self requestWithType:Sina_Add_PicMessage withUrl:SINA_ADD_PICMESSAGE withRequestParams:params withImage:image];
}

#pragma mark - WeChat
- (void)addMessageToWeChatWithType:(int)type withTitle:(NSString *)title withDescription:(NSString *)description withImage:(UIImage *)image withUrl:(NSString *)urlStr
{
    //图片过大 缩小图片
    float tmp = image.size.height / image.size.width;
    CGSize newSize;
    if (image.size.height > 100)
    {
        newSize.height = 100;
        newSize.width = 100 / tmp;
    }
    if (image.size.width > 100)
    {
        newSize.width = 100;
        newSize.height = 100 * tmp;
    }
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();  
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:scaledImage];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlStr;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq *wxMessage = [[SendMessageToWXReq alloc] init];
    wxMessage.bText = NO;
    wxMessage.message = message;
    wxMessage.scene = type;
    [WXApi sendReq:wxMessage];
    
    if ([_delegate respondsToSelector:@selector(operationSuccessWithType:withObject:)])
    {
        [_delegate operationSuccessWithType:Wechat_Share withObject:nil];
    }
}

#pragma mark - MSG
- (void)addMessageToMSGWithText:(NSString *)textMessage withViewController:(UIViewController *)controller
{
    if ([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.messageComposeDelegate = self;
        picker.body = textMessage;
        [controller presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"设备没有短信功能" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"取消短信发送");
            break;
        case MessageComposeResultSent:
            if ([_delegate respondsToSelector:@selector(operationSuccessWithType:withObject:)])
            {
                [_delegate operationSuccessWithType:Msg_Share withObject:nil];
            }
            break;
        case MessageComposeResultFailed:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"短信发送失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            break;
        }
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
//    DISMISSCONTROLLER(controller);
}

#pragma mark - Mail
- (void)addMessageToMailWithTitle:(NSString *)title withText:(NSString *)textMessage withImage:(UIImage *)image withViewController:(UIViewController *)controller
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        [picker setSubject:textMessage];
        [picker setMessageBody:title isHTML:YES];
        [picker addAttachmentData:UIImagePNGRepresentation(image) mimeType:@"image/png" fileName:@"artwork"];
        [controller presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"设备没有邮件功能" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"取消邮件发送");
            break;
        case MFMailComposeResultSent:
            if ([_delegate respondsToSelector:@selector(operationSuccessWithType:withObject:)])
            {
                [_delegate operationSuccessWithType:Email_Share withObject:nil];
            }
            break;
        case MFMailComposeResultFailed:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"邮件发送失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            break;
        }
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];

//    DISMISSCONTROLLER(controller);
}
@end
