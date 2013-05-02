//
//  ServerRequestParam.m
//  Artist
//
//  Created by cuibaoyin on 13-4-3.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import "ServerRequestParam.h"
#import "JSONKit.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
static ServerRequestParam *sharedInstance;
@implementation ServerRequestParam

+ (id)sharedRequest
{
    if (sharedInstance == nil)
    {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

#pragma mark - methods
- (NSString *)getParamByType:(RequsetType)type withObject:(NSMutableDictionary *)dataDic
{
    NSString *params;
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSString *objectID = [dataDic objectForKey:@"objectID"];
    NSString *startNum = [dataDic objectForKey:@"startNum"];

    if ([startNum intValue] > 0)
    {
        flag = YES;
    }
    else
    {
        flag = NO;
    }
    
    switch (type)
    {
        case get_hotPushList: //获取热推列表
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                       @"hotPushList",                              @"action",
                       startNum,                                        @"start",
                       [NSString stringWithFormat:@"%d",10],                                   @"psize",
                       nil] JSONString];
            break;
        }
        case get_artShowList://展览列表
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"showList",                     @"action",
                                 startNum,                         @"start",
                                 [NSString stringWithFormat:@"%d",10],                                   @"psize",
                                 nil] JSONString];
            break;
        }
        case get_videoList_artist:
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                       @"artView",                     @"action",
                       objectID,                        @"artId",
                       startNum,                         @"start",
                       [NSString stringWithFormat:@"%d",10],                                   @"psize",
                       nil] JSONString];
            break;
        }
        case get_artShowList_artist://艺术家相关展览列表
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                       @"searchShowByArtId",                     @"action",
                       objectID,    @"artId",
                       startNum,                         @"start",
                       [NSString stringWithFormat:@"%d",10],                                   @"psize",
                       nil] JSONString];
            break;
        }
        case get_artWorkList_all://好看作品列表
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                       @"listpicture",                                                              @"action",
                       startNum,              @"start",
                       [NSString stringWithFormat:@"%d",10],                         @"psize",
                       nil] JSONString];
            break;
        }
        case get_artWorkList_artist://某个艺术家的作品列表
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                       @"listpicture",                     @"action",
                       objectID,                            @"artId",
                       startNum,                  @"start",
                       [NSString stringWithFormat:@"%d",10],                            @"psize",
                       nil] JSONString];
            break;
        }
        case get_artWorkList_show://某个展览的作品列表
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                       @"listpicture",                     @"action",
                       objectID,                             @"showId",
                       startNum,                  @"start",
                       [NSString stringWithFormat:@"%d",10],                            @"psize",
                       nil] JSONString];
            break;
        }
        case get_hotwords_search://搜索热词
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"hotWordList",                                                        @"action",
                                 startNum,                @"start",
                                 [NSString stringWithFormat:@"%d",10],                          @"psize",
                                 nil] JSONString];
            break;
        }
        case get_artistDetails://获取艺术家详细
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"artInfoDetail",                         @"action",
                                 objectID,                                      @"id",
                                 nil] JSONString];
            break;
        }
        case get_artShowDetails://获取展览详细
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                       @"showDetail",                         @"action",
                       objectID,                                      @"id",
                       nil] JSONString];
            break;
        }
        case get_artStadiumDetails://获取场馆详细
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                       @"addressInfoDetail",                         @"action",
                       objectID,                                      @"id",
                       nil] JSONString];
            break;
        }
        case get_artWorkDetails://获取作品详细
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                       @"artProductDetail",                         @"action",
                       objectID,                                      @"id",
                       nil] JSONString];
            break;
        }
        case get_comment_artWork://获取作品评论
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"productCommentList",                         @"action",
                                 objectID,                                                  @"id",
                                 startNum,                  @"start",
                                 [NSNumber numberWithInt:10],                @"psize",
                                 nil] JSONString];
            break;
        }
        case get_comment_artShow://获取展览评论
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                       @"showCommentList",                         @"action",
                       objectID,                                                  @"id",
                       startNum,                                            @"start",
                       [NSNumber numberWithInt:10],                @"psize",
                       nil] JSONString];
            break;
        }
        case get_searchData://获取展览评论
        {
            params =  [[NSDictionary dictionaryWithObjectsAndKeys:
                        @"searchKeyWord",                     @"action",
                        [dataDic objectForKey:@"word"],                     @"word",
                        [dataDic objectForKey:@"startNum"],                                     @"start",
                        [NSString stringWithFormat:@"%d",10],                                   @"psize",
                        nil] JSONString];
            break;
        }
        case get_weeklyList:
        {
            params =  [[NSDictionary dictionaryWithObjectsAndKeys:
              @"weekReportList",                     @"action",
              startNum,                                     @"start",
              [NSString stringWithFormat:@"%d",10],                                   @"psize",
              nil] JSONString];
            break;
        }
        case upload_artwork_voice_comment:
        {
            params =  [[NSDictionary dictionaryWithObjectsAndKeys:
                        @"saveProductComment",                     @"action",
                        userID,                                     @"memberId",
                        objectID,                   @"id",
                        [dataDic objectForKey:@"duration"],                   @"time",
                        [NSNumber numberWithInt:1],                                   @"type",
                        nil] JSONString];
            break;
        }
        case upload_artwork_text_comment:
        {
            params =  [[NSDictionary dictionaryWithObjectsAndKeys:
                        @"saveProductComment",                     @"action",
                        userID,                                     @"memberId",
                        objectID,                   @"id",
                        [dataDic objectForKey:@"contentText"],                            @"text",
                        [NSNumber numberWithInt:0],                                   @"type",
                        nil] JSONString];
            break;
        }
        case upload_artshow_voice_comment:
        {
            params =  [[NSDictionary dictionaryWithObjectsAndKeys:
                        @"saveShowComment",                     @"action",
                        userID,                                     @"memberId",
                        objectID,                   @"id",
                        [dataDic objectForKey:@"duration"],                   @"time",
                        [NSNumber numberWithInt:1],                                   @"type",
                        nil] JSONString];
            break;
        }
        case upload_artshow_text_comment:
        {
            params =  [[NSDictionary dictionaryWithObjectsAndKeys:
                        @"saveShowComment",                     @"action",
                        userID,                                     @"memberId",
                        objectID,                   @"id",
                        [dataDic objectForKey:@"contentText"],                            @"text",
                        [NSNumber numberWithInt:0],                                   @"type",
                        nil] JSONString];
            break;
        }
        case upload_useravater:
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"uploadMemberIco",                             @"action",
                                 userID,                                                    @"id",
                                 nil] JSONString];
            break;
        }
        case fancy_artshow:
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"showlike",                     @"action",
                                 objectID,                              @"id",
                                 nil] JSONString];
            break;
        }
        case fancy_artwork:
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                       @"productlike",                     @"action",
                       objectID,                              @"id",
                       nil] JSONString];
            break;
        }
        case share_artshow:
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                       @"saveShowShare",                             @"action",
                       objectID ,                                   @"id",
                       userID,                                                @"memberId",
                       [dataDic objectForKey:@"shareType"],                                          @"type",
                       nil] JSONString];
            break;
        }
        case share_artwork:
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                       @"saveProductShare",                             @"action",
                       objectID ,                                   @"id",
                       userID,                                                @"memberId",
                       [dataDic objectForKey:@"shareType"],                                          @"type",
                       nil] JSONString];
            break;
        }
        case observe_artshow:
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"saveShowFocus",                     @"action",
                                 objectID,                              @"id",
                                 userID,                              @"memberId",
                                 nil] JSONString];            break;
            break;
        }
        case login_wooboo:
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"memberLogin",                             @"action",
                                 [dataDic objectForKey:@"UserName"],                @"email",
                                 [dataDic objectForKey:@"UserPassword"],                   @"password",
                                 nil] JSONString];
            break;
        }
        case login_indirect:
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                       @"uuidLogin",                             @"action",
                       [dataDic objectForKey:@"nickName"],                @"nickName",
                       [dataDic objectForKey:@"only_id"],                   @"uuid",
                       [dataDic objectForKey:@"loginType"],                   @"type",
                       nil] JSONString];
            break;
        }
        case register_wooboo:
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"saveMemberInfo",                   @"action",
                                 [dataDic objectForKey:@"UserName"],                 @"email",
                                 [dataDic objectForKey:@"UserNickName"],                  @"nickName",
                                 [dataDic objectForKey:@"UserPassword"],                   @"password",
                                 nil] JSONString];
            break;
        }
        case modyUserInfo:
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"updateMemberInfo",                   @"action",
                                 userID,                                            @"id",
                                 [dataDic objectForKey:@"UserNickName"],                  @"nickName",
                                 [dataDic objectForKey:@"UserPhoneNum"],                   @"mobile",
                                 [dataDic objectForKey:@"UserGender"],                            @"gender",
                                 nil] JSONString];
            break;
        }
        case modyUserPassword:
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                       @"updatePwd",                   @"action",
                       userID,                                            @"memberId",
                       [dataDic objectForKey:@"oldPassword"],                  @"oldPassword",
                       [dataDic objectForKey:@"newPassword"],                   @"password",
                       nil] JSONString];
            break;
        }            
        case works_user_comment:
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                       @"myProductCommentList",                             @"action",
                       userID,                                             @"memberId",
                       ARTISTID  ,@"artId",
                       startNum,                                     @"start",
                       [NSString stringWithFormat:@"%d",10],                                   @"psize",
                       nil] JSONString];
            break;
        }
        case shows_user_comment:
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                       @"myShowCommentList",                             @"action",
                       userID,                                                              @"memberId",
                       startNum,                                     @"start",
                       [NSString stringWithFormat:@"%d",10],                                   @"psize",
                       nil] JSONString];
            break;
        }
        case shows_user_observe:
        {
            params = [[NSDictionary dictionaryWithObjectsAndKeys:
                       @"myShowFocus",                              @"action",
                       userID,                                                @"memberId",
                       startNum,                                            @"start",
                       [NSString stringWithFormat:@"%d",10],                                   @"psize",
                       nil] JSONString];
            break;
        }
        default:
            break;
    }
    return params;
}

- (void)requestServerWithType:(RequsetType)type withParamObject:(NSMutableDictionary *)objectDic
{
    NSString *params = [self getParamByType:type withObject:objectDic];
    NSString *filePath = [objectDic objectForKey:@"filePath"];
    NSLog(@"Params:%@",params);
    NSLog(@"filePath:%@",filePath);
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:SERVERADRESS]];
    NSURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:SERVERADRESS parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         [formData appendPartWithFormData:[params dataUsingEncoding:NSUTF8StringEncoding] name:@"p"];
         if (filePath != nil)
         {
             [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"upload" error:nil];
         }
     }];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dic = [[JSONDecoder decoder] mutableObjectWithData:responseObject];
         NSLog(@"%@",dic);
         NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
         if ([[dic objectForKey:@"STATE"] intValue] == 200)
         {
//             [self postSuccessNotificationWithType:type withObject:dic];
             
             if ([_delegate respondsToSelector:@selector(requsetSuccessWithType:withServerData:withMoreMark:)])
             {
                 [_delegate requsetSuccessWithType:type withServerData:dic withMoreMark:flag];
             }
         }
         else
         {
//             [self postFailedNotificationWithType:type];
             if ([_delegate respondsToSelector:@selector(requsetFailedWithType:)])
             {
                 [_delegate requsetFailedWithType:type];
             }
         }
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@",error);
         if ([_delegate respondsToSelector:@selector(requsetFailedWithType:)])
         {
             [_delegate requsetFailedWithType:type];
         }
     }];
    [operation start];
}

- (void)postSuccessNotificationWithType:(RequsetType)type withObject:(NSDictionary *)dic
{
    switch (type)
    {
        case modyUserPassword:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ModyPasswordSuccess" object:dic];
            break;
        }
        default:
            break;
    }
}

- (void)postFailedNotificationWithType:(RequsetType)type
{
    switch (type)
    {
        case modyUserPassword:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ModyPasswordFailed" object:nil];
            break;
        }
        default:
            break;
    }

}
@end
