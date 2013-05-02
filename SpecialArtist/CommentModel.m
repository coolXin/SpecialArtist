//
//  CommentModel.m
//  Artist
//
//  Created by cuibaoyin on 13-3-21.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

- (id)initWithDictionary:(NSDictionary *)dic withFtpPath:(NSString *)ftpPath withObjectType:(RequsetType)type
{
    if (self = [super init])
    {
        if (![self stringIsNull:[dic objectForKey:@"id"]])
        {
            _id = [dic objectForKey:@"id"];
        }
        if (![self stringIsNull:[dic objectForKey:@"createDate"]])
        {
            _commitTime = [dic objectForKey:@"createDate"];
        }
        if (![self stringIsNull:[dic objectForKey:@"textDesc"]])
        {
            _content = [dic objectForKey:@"textDesc"];
        }
        if (![self stringIsNull:[dic objectForKey:@"type"]])
        {
            _type = [[dic objectForKey:@"type"] integerValue];
        }
        if (![self stringIsNull:[dic objectForKey:@"memberId"]])
        {
            _user_id = [dic objectForKey:@"memberId"];
        }
        if (![self stringIsNull:[dic objectForKey:@"icoImg"]])
        {
            _user_avater = [ftpPath stringByAppendingString:[dic objectForKey:@"icoImg"]];
        }
        if (![self stringIsNull:[dic objectForKey:@"nickName"]])
        {
            _user_name = [dic objectForKey:@"nickName"];
        }
        if (![self stringIsNull:[dic objectForKey:@"soundPath"]])
        {
            _voicePath = [ftpPath stringByAppendingString:[dic objectForKey:@"soundPath"]];
        }
        if (![self stringIsNull:[dic objectForKey:@"time"]])
        {
            _voiceDuration = [dic objectForKey:@"time"];
        }
        _objectType = type;
    }
    return self;
}

- (BOOL)stringIsNull:(id)str
{
    if (str == nil || (NSNull *)str == [NSNull null] )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
