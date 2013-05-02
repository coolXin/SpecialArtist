//
//  AudioRecordAndPlay.h
//  ArmTest
//
//  Created by cuibaoyin on 13-3-20.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
@protocol AmrRecordAndPlayDelegate;

typedef enum{
    isPlaying = 0,
    isPausing,
    isStopping,
}PlayerStatus;

@interface AmrRecordAndPlay : NSObject<AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    AVAudioRecorder *myRecorder;
    AVAudioPlayer * avPlayer;

	NSString *recordedWavFilePath;
    NSString *recordedAmrFilePath;
    int recordDuration;
    
    UIView *micView;
    UIImageView *micImageView;
    NSTimer *timer;
    PlayerStatus nowStatus;
}

@property(assign, nonatomic) id<AmrRecordAndPlayDelegate>delegate;
@property(retain, nonatomic) NSString *playingFilePath;

+ (AmrRecordAndPlay *)getInstance;

- (void)startRecordAudio;
- (void)stopRecordAudio;

- (void)steupPlayAudioWithPath:(NSString *)path;
- (void)startPlayAudio;
- (void)stopPlayAudio;
- (void)pausePlayAudio;
- (PlayerStatus)getStausOfPlayer;

@end

@protocol AmrRecordAndPlayDelegate <NSObject>

@optional
- (void)audioRecord:(AVAudioRecorder *)recorder finishedWithAmrFilePath:(NSString *)path withRecordDuration:(int)duration;
- (void)audioRecord:(AVAudioRecorder *)recorder failedRecorderWithError:(NSString *)error;

- (void)audioPlayer:(AVAudioPlayer *)player finishedPlayingWithSuccessfully:(BOOL)flag;
- (void)audioPlayer:(AVAudioPlayer *)player failedPlayingWithError:(NSError *)error;

@end