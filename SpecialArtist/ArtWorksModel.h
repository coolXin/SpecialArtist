//
//  ArtWorksModel.h
//  Artist
//
//  Created by cuibaoyin on 13-3-6.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArtWorksModel : NSObject

@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString *artistId;
@property(nonatomic,strong) NSString *artistName;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *birthday;
@property(nonatomic,strong) NSString *image_small;
@property(nonatomic,strong) NSString *image_original;
@property(nonatomic,strong) NSString *textDesc;
@property(nonatomic,strong) NSString *voiceDesc;
@property(nonatomic,strong) NSString *likeCount;
@property(nonatomic,strong) NSString *commentCount;
@property(nonatomic,strong) NSString *observeCount;

- (id)initWithDictionary:(NSDictionary *)dic withFtp:(NSString *)ftpPath;
- (void)setModelWithDictionary:(NSDictionary *)dic withFtp:(NSString *)ftpPath;

@end
