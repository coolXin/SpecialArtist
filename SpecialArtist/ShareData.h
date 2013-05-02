//
//  ShareData.h
//  Artist
//
//  Created by cuibaoyin on 13-3-27.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#ifndef Artist_ShareData_h
#define Artist_ShareData_h

//QQ登录授权和API接口操作
#define QQ_APP_ID                     @"100390833"
#define QQ_APP_KEY                   @"927ea2818190142806b6e5c3cde7865a"
#define QQ_REDIRECT_URL          @"http://connect.qq.com"
#define QQ_API_TOKEN               @"https://openmobile.qq.com/oauth2.0/m_authorize"
#define QQ_API_OPENID              @"https://graph.z.qq.com/moc2/me"

#define QQ_SPACE_USER_INFO                              @"https://graph.qq.com/user/get_simple_userinfo"
#define QQ_SPACE_ADD_SHARE                            @"https://graph.qq.com/share/add_share"
#define TECENTWEIBO_USER_INFO                        @"https://graph.qq.com/user/get_other_info"
#define TECENTWEIBO_ADD_TEXTMESSAGE           @"https://graph.qq.com/t/add_t"
#define TECENTWEIBO_ADD_PICMESSAGE              @"https://graph.qq.com/t/add_pic_t "

//新浪微博登录授权和API接口操作
#define SINA_APP_SECRET                     @"2fd9dea7afcf8da732e13db8931230cd"
#define SINA_APP_KEY                          @"1490586423"
#define SINA_REDIRECT_URL                 @"http://www.wooboo.com.cn"
#define SINA_API_AUTHORIZE               @"https://api.weibo.com/oauth2/authorize"
#define SINA_API_TOKEN                      @"https://api.weibo.com/oauth2/access_token"

#define SINA_USER_INFO                        @"https://api.weibo.com/2/users/show.json"
#define SINA_ADD_TEXTMESSAGE           @"https://api.weibo.com/2/statuses/update.json"
#define SINA_ADD_PICMESSAGE           @"https://upload.api.weibo.com/2/statuses/upload.json"
//#define SINA_ADD_PICMESSAGE           @"https://api.weibo.com/2/statuses/upload_url_text.json"

#endif
