//
//  ArtistModel.m
//  Artist
//
//  Created by cuibaoyin on 13-3-8.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import "ArtistModel.h"

@implementation ArtistModel

- (id)initWithDictionary:(NSDictionary *)dic withFtpPath:(NSString *)ftpPath
{
    if (self = [super init])
    {
        if (![self stringIsNull:[dic objectForKey:@"id"]])
        {
            _id = [dic objectForKey:@"id"];
        }
        if (![self stringIsNull:[dic objectForKey:@"icoPath"]])
        {
            _avatar = [ftpPath stringByAppendingString:[dic objectForKey:@"icoPath"]];
        }
        if (![self stringIsNull:[dic objectForKey:@"realName"]])
        {
            _realName = [dic objectForKey:@"realName"];
        }
        if (![self stringIsNull:[dic objectForKey:@"artDesc"]])
        {
            _textDesc = [dic objectForKey:@"artDesc"];
        }
        if (![self stringIsNull:[dic objectForKey:@"email"]])
        {
            _email = [dic objectForKey:@"email"];
        }
        if (![self stringIsNull:[dic objectForKey:@"productCount"]])
        {
            _productCount = [dic objectForKey:@"productCount"];
        }
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
