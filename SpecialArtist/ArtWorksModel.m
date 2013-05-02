//
//  ArtWorksModel.m
//  Artist
//
//  Created by cuibaoyin on 13-3-6.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import "ArtWorksModel.h"

@implementation ArtWorksModel

- (id)initWithDictionary:(NSDictionary *)dic withFtp:(NSString *)ftpPath
{
    if (self = [super init])
    {
        [self setModelWithDictionary:dic withFtp:ftpPath];
    }
    return self;
}

- (void)setModelWithDictionary:(NSDictionary *)dic withFtp:(NSString *)ftpPath
{
    if (![self stringIsNull:[dic objectForKey:@"id"]])
    {
        _id = [dic objectForKey:@"id"];
    }
    if (![self stringIsNull:[dic objectForKey:@"artId"]])
    {
        _artistId = [dic objectForKey:@"artId"];
    }
    if (![self stringIsNull:[dic objectForKey:@"realName"]])
    {
        _artistName = [dic objectForKey:@"realName"];
    }
    if (![self stringIsNull:[dic objectForKey:@"birthday"]])
    {
        _birthday = [dic objectForKey:@"birthday"];
    }
    if (![self stringIsNull:[dic objectForKey:@"productName"]])
    {
        _title = [dic objectForKey:@"productName"];
    }
    if (![self stringIsNull:[dic objectForKey:@"icoPath"]])
    {
        _image_small = [ftpPath stringByAppendingString:[dic objectForKey:@"icoPath"]];
    }
    if (![self stringIsNull:[dic objectForKey:@"imgPath"]])
    {
        _image_original = [ftpPath stringByAppendingString:[dic objectForKey:@"imgPath"]];
    }
    if (![self stringIsNull:[dic objectForKey:@"textDesc"]])
    {
        _textDesc = [dic objectForKey:@"textDesc"];
    }
    if (![self stringIsNull:[dic objectForKey:@"soundDesc"]])
    {
        _voiceDesc = [ftpPath stringByAppendingString:[dic objectForKey:@"soundDesc"]];
    }
    if (![self stringIsNull:[dic objectForKey:@"likeCount"]])
    {
        _likeCount = [dic objectForKey:@"likeCount"];
    }
    if (![self stringIsNull:[dic objectForKey:@"commentCount"]])
    {
        _commentCount = [dic objectForKey:@"commentCount"];
    }
    if (![self stringIsNull:[dic objectForKey:@"focusCount"]])
    {
        _observeCount = [dic objectForKey:@"focusCount"];
    }
}

- (BOOL)stringIsNull:(NSString *)str
{
    if (str == nil || (NSNull *)str == [NSNull null] || str.length <= 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
