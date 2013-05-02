//
//  ServerRequestParam.h
//  Artist
//
//  Created by cuibaoyin on 13-4-3.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

//********
//********
//This class has packaged all the internet request to the server in the application
//********
//********

#import <Foundation/Foundation.h>
@protocol ServerRequestParamDelegate;

typedef enum
{
    get_artShowList = 0,
    get_artShowList_artist,
    get_videoList_artist,
    get_artWorkList_all,
    get_artWorkList_artist,
    get_artWorkList_show,
    get_hotPushList,
    get_hotwords_search,
    get_artistDetails,
    get_artShowDetails,
    get_artStadiumDetails,
    get_artWorkDetails,
    get_comment_artWork, 
    get_comment_artShow,
    get_searchData,
    get_weeklyList,
    upload_artwork_text_comment,
    upload_artwork_voice_comment,
    upload_artshow_text_comment,
    upload_artshow_voice_comment,
    upload_useravater,
    fancy_artwork,
    fancy_artshow,
    share_artwork,
    share_artshow,
    observe_artshow,
    login_wooboo,
    login_indirect,
    register_wooboo,
    modyUserInfo,
    modyUserPassword,
    works_user_comment,
    shows_user_comment,
    shows_user_observe,
}RequsetType;

@interface ServerRequestParam : NSObject
{
    BOOL flag;
}

@property (assign, nonatomic) id<ServerRequestParamDelegate>delegate;

+ (id)sharedRequest;
- (void)requestServerWithType:(RequsetType)type withParamObject:(NSMutableDictionary *)objectDic;

@end

@protocol ServerRequestParamDelegate <NSObject>
@optional
- (void)requsetSuccessWithType:(RequsetType)type withServerData:(NSDictionary *)severData withMoreMark:(BOOL)flag;
- (void)requsetFailedWithType:(RequsetType)type;
@end