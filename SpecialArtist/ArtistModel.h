//
//  ArtistModel.h
//  Artist
//
//  Created by cuibaoyin on 13-3-8.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArtistModel : NSObject

@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString *realName;
@property(nonatomic,strong) NSString *avatar;
@property(nonatomic,strong) NSString *textDesc;
@property(nonatomic,strong) NSString *email;
@property(nonatomic,strong) NSString *productCount;

- (id)initWithDictionary:(NSDictionary *)dic withFtpPath:(NSString *)ftpPath;

@end
