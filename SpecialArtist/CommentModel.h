//
//  CommentModel.h
//  Artist
//
//  Created by cuibaoyin on 13-3-21.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CommentModel : NSObject

@property(nonatomic,strong) NSString *id;
@property(nonatomic,readwrite) RequsetType objectType;
@property(nonatomic,strong) NSString *commitTime;
@property(nonatomic,readwrite) int type; //0为文字，1为语音
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *voicePath;
@property(nonatomic,strong) NSString *voiceDuration;
@property(nonatomic,strong) NSString *user_id;
@property(nonatomic,strong) NSString *user_avater;
@property(nonatomic,strong) NSString *user_name;
@property(nonatomic,strong) NSString *voiceFileDownloadPath;

- (id)initWithDictionary:(NSDictionary *)dic withFtpPath:(NSString *)ftpPath withObjectType:(RequsetType)type;

@end
