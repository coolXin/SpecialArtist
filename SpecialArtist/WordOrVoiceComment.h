//
//  WordOrVoiceComment.h
//  Artist
//
//  Created by cuibaoyin on 13-3-22.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AmrRecordAndPlay.h"
#import "HPGrowingTextView.h"

@protocol WordOrVoiceCommentDelegate;

@interface WordOrVoiceComment : UIView<AmrRecordAndPlayDelegate,HPGrowingTextViewDelegate>
{
    UIButton *changeStyleBtn;
    UIButton *recordBtn;
    UIImageView *inputBackground;
    HPGrowingTextView *inputTextView;
}

@property(assign, nonatomic)  id<WordOrVoiceCommentDelegate>delegate;

@end

@protocol WordOrVoiceCommentDelegate <NSObject>
- (void)commitVoiceComment:(NSString *)path withDuration:(int)duration;
- (void)commitTextComment:(NSString *)comentText;
@end