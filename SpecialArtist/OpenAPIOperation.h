//
//  OpenAPIOperation.h
//  Artist
//
//  Created by cuibaoyin on 13-3-13.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageUI/MessageUI.h"

@protocol OpenAPIOperationDelegate;

typedef enum {
    QQSpace_Get_User_Info = 0, //获取QQ空间用户信息
    QQSpace_Add_Share,//添加QQ空间分享
    TecentWeiBo_Get_User_Info,//获取腾讯微博用户信息
    TecentWeiBo_Add_TextMessage,//添加腾讯文字微博
    TecentWeiBo_Add_PicMessage,//添加腾讯图文微博
    Sina_Get_User_Info,//获取新浪微博用户信息
    Sina_Add_TextMessage,//发表新浪文字微博
    Sina_Add_PicMessage,//发表新浪图文微博
    Email_Share,//通过邮件分享
    Msg_Share,//通过短信分享
    Wechat_Share,//微信分享
}OperationType;

@interface OpenAPIOperation : NSObject<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
{
    NSString *acess_token;
    NSString *only_id;
}

@property(assign ,nonatomic)  id<OpenAPIOperationDelegate>delegate;

- (void)setOauthorMark:(NSDictionary *)info;
//QQ登录接口
- (void)getSpaceUserInfo;
- (void)addSpaceShareWithTitle:(NSString *)title withPath:(NSString *)path  withMessage:(NSString *)textMessage imagePath:(NSString *)imagePath;
- (void)getTecentWeiBoUserInfo;
- (void)addMessageToTecentWeiBoWithText:(NSString *)txtMessage;
- (void)addMessageToTecentWeiBoWithText:(NSString *)textMessage withImage:(UIImage *)image;

//Sina登录接口
- (void)getSinaUserInfo;
- (void)addMessageToSinaWithText:(NSString *)txtMessage;
- (void)addMessageToSinaWithText:(NSString *)textMessage withImage:(UIImage *)image;

//wechat分享,0是好友，1是朋友圈
- (void)addMessageToWeChatWithType:(int)type withTitle:(NSString *)title withDescription:(NSString *)description withImage:(UIImage *)image withUrl:(NSString *)urlStr;

//短信分享
- (void)addMessageToMSGWithText:(NSString *)textMessage withViewController:(UIViewController *)controller;

//邮件分享
- (void)addMessageToMailWithTitle:(NSString *)title withText:(NSString *)textMessage withImage:(UIImage *)image withViewController:(UIViewController *)controller;
@end

@protocol OpenAPIOperationDelegate <NSObject>
@optional
- (void)operationSuccessWithType:(OperationType)type withObject:(NSDictionary *)dic; //返回成功的操作类型，如有信息在dic中返回
- (void)operationFailedWithType:(OperationType)type;

@end