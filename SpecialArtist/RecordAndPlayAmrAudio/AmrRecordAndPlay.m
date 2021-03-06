//
//  AudioRecordAndPlay.m
//  ArmTest
//
//  Created by cuibaoyin on 13-3-20.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import "AmrRecordAndPlay.h"
#import <AudioToolbox/AudioToolbox.h>
#import "amrFileCodec.h"
#import "SCListener.h"

@implementation AmrRecordAndPlay
static AmrRecordAndPlay *sharedInstance;

#pragma mark Singleton Pattern
+ (AmrRecordAndPlay *)getInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
        {
            sharedInstance = [[AmrRecordAndPlay alloc] init];
        }
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self)
    {
		if (sharedInstance == nil)
        {
			sharedInstance = [super allocWithZone:zone];
			return sharedInstance;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

- (id)init
{
    if (self = [super init])
    {
        //Instanciate an instance of the AVAudioSession object.
        //Setup the audioSession for playback and record.
        //We could just use record and then switch it to playback leter, but
        //since we are going to do both lets set it up once.
        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        NSError *error;
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
								 sizeof (audioRouteOverride),
								 &audioRouteOverride);
        //Activate the session
        [audioSession setActive:YES error:&error];
        
        [self steupRecorder];
    }
    return self;
}

#pragma mark - recorderMethods
- (void)steupRecorder
{
    //Begin the recording session.
    //Error handling removed.  Please add to your own code.
    //Setup the dictionary object with all the recording settings that this
    //Recording sessoin will use
    //Its not clear to me which of these are required and which are the bare minimum.
    //This is a good resource: http://www.totodotnet.net/tag/avaudiorecorder/
    
    NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                   [NSNumber numberWithFloat:8000.00], AVSampleRateKey,
                                   [NSNumber numberWithInt:2], AVNumberOfChannelsKey,
                                   [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                   nil];
    
    //Now that we have our settings we are going to instanciate an instance of our recorder instance.
    //Generate a temp file for use by the recording.
    //This sample was one I found online and seems to be a good choice for making a tmp file that
    //will not overwrite an existing one.
    //I know this is a mess of collapsed things into 1 call.  I can break it out if need be.
    
    NSError *error;
    recordedWavFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"wavRecord.caf"];
    recordedAmrFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"amrRecord.amr"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:recordedWavFilePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:recordedWavFilePath error:&error];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:recordedAmrFilePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:recordedAmrFilePath error:&error];
    }
    
    //Setup the recorder to use this file and record to it.
    //Use the recorder to start the recording.
    //Im not sure why we set the delegate to self yet.
    //Found this in antother example, but Im fuzzy on this still.
    //We call this to start the recording process and initialize
    //the subsstems so that when we actually say "record" it starts right away.
    //Start the actual Recording
    //There is an optional method for doing the recording for a limited time see
    //[recorder recordForDuration:(NSTimeInterval) 10]
    myRecorder = [[ AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:recordedWavFilePath] settings:recordSetting error:&error];
    [myRecorder setDelegate:self];
}

- (void)startRecordAudio
{
    [self steupMicView];
    [self startMicListion];
    [myRecorder prepareToRecord];
    [myRecorder record];
    NSLog(@"录音开始");
}

- (void)stopRecordAudio
{
    [self stopMicListion];
    [myRecorder stop];
    NSLog(@"录音结束");
}

- (void)getTheRecordDuration
{
    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:recordedWavFilePath] options:nil];
    CMTime audioDuration = audioAsset.duration;
    recordDuration = ceil(CMTimeGetSeconds(audioDuration));
}

- (void)encodeWavToAmr
{
    NSData *wavData = [NSData dataWithContentsOfFile:recordedWavFilePath];
    if (wavData != nil)
    {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        hud.labelText = @"转换中...";
        [[UIApplication sharedApplication].keyWindow addSubview:hud];
        [hud show:YES];
        
//        NSLog(@"转换开始");
        NSData *amrData = EncodeWAVEToAMR(wavData, 2, 16);
//        NSLog(@"转换结束，写入文件开始");
        [amrData writeToFile:recordedAmrFilePath atomically:YES];
//        NSLog(@"写入完成");
        
        [hud hide:YES];
        [hud removeFromSuperview];
        
        if ([_delegate respondsToSelector:@selector(audioRecord:finishedWithAmrFilePath:withRecordDuration:)])
        {
            [_delegate audioRecord:myRecorder finishedWithAmrFilePath:recordedAmrFilePath withRecordDuration:recordDuration];
        }
    }
    else
    {
//        NSLog(@"录音失败");
        if ([_delegate respondsToSelector:@selector(audioRecord:failedRecorderWithError:)])
        {
            [_delegate audioRecord:myRecorder failedRecorderWithError:nil];
        }
    }
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
//    NSLog(@"录音成功");
    if (flag)
    {
        [self getTheRecordDuration];
//        NSLog(@"%d",recordDuration);
        [self performSelectorInBackground:@selector(encodeWavToAmr) withObject:nil];
//        NSThread *thread = [NSThread detachNewThreadSelector:@selector(encodeWavToAmr) toTarget:self withObject:nil];
//        [self encodeWavToAmr];
    }
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
//    NSLog(@"录音失败");
    if ([_delegate respondsToSelector:@selector(audioRecord:failedRecorderWithError:)])
    {
        [_delegate audioRecord:recorder failedRecorderWithError:nil];
    }
}

#pragma mark - playerMethods
- (void)steupPlayAudioWithPath:(NSString *)path
{
    if (avPlayer != nil)
    {
        [self stopPlayAudio];
    }
//    NSLog(@"start decode");
    NSData *amrData = [NSData dataWithContentsOfFile:path];
    NSData *linerData = [self decodeAmr:amrData];
//    NSLog(@"end decode");
    
    NSError *error;
    avPlayer = [[AVAudioPlayer alloc] initWithData:linerData error:&error];
    avPlayer.delegate = self;
    _playingFilePath = path;
    [avPlayer setVolume:1.0];
}

- (void)startPlayAudio
{
    [avPlayer prepareToPlay];
    [avPlayer play];
    nowStatus = isPlaying;
}

- (void)stopPlayAudio
{
    if (avPlayer != nil)
    {
        [avPlayer stop];
        avPlayer = nil;
        _playingFilePath = nil;
        nowStatus = isStopping;
    }
}

- (void)pausePlayAudio
{
    [avPlayer pause];
    nowStatus = isPausing;
}

- (PlayerStatus)getStausOfPlayer
{
    return nowStatus;
}

-(NSData *)decodeAmr:(NSData *)data
{
    if (!data)
    {
        return data;
    }
    return DecodeAMRToWAVE(data);
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag)
    {
        _playingFilePath = nil;
        nowStatus = isStopping;
        if ([_delegate respondsToSelector:@selector(audioPlayer:finishedPlayingWithSuccessfully:)])
        {
            [_delegate audioPlayer:player finishedPlayingWithSuccessfully:YES];
        }
    }
    else
    {
        if ([_delegate respondsToSelector:@selector(audioPlayer:finishedPlayingWithSuccessfully:)])
        {
            [_delegate audioPlayer:player finishedPlayingWithSuccessfully:NO];
        }
    }
//    NSLog(@"播放完成");
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    if ([_delegate respondsToSelector:@selector(audioPlayer:failedPlayingWithError:)])
    {
        [_delegate audioPlayer:player failedPlayingWithError:error];
    }
//    NSLog(@"播放失败");
}

#pragma mark - MicListioner
- (void)steupMicView
{
    CGRect frame = CGRectMake(0, 0, 90, 90);
    micView = [[UIView alloc] initWithFrame:frame];
    micView.backgroundColor = [UIColor clearColor];
    micView.center = CGPointMake(Application_Frame.size.width * 0.5, Application_Frame.size.height * 0.5);
    [[UIApplication sharedApplication].keyWindow addSubview:micView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"mic_background" ofType:@"png"]];
    [micView addSubview:imageView];
    
    micImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 57)];
    micImageView.center = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5);
    micImageView.image = [UIImage imageNamed:@"micSize_1.png"];
    [micView addSubview:micImageView];
}

- (void)startMicListion
{
    //開始偵測
    [[SCListener sharedListener] listen];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(getMicPower) userInfo:nil repeats:YES];
}

-(void)stopMicListion
{
    [timer invalidate];
    timer = nil;
    [[SCListener sharedListener] stop];
    
    [micView removeFromSuperview];
    micImageView = nil;
    micView = nil;
}

-(void)getMicPower
{
	AudioQueueLevelMeterState *levels = [[SCListener sharedListener] levels];
	Float32 peak = levels[0].mPeakPower;
	
	if ([[SCListener sharedListener] isListening])
    {
        [self setVoiceImageByPower:(int)(peak * 10000)];
    }
}

- (void)setVoiceImageByPower:(int)power
{
//    NSLog(@"%d",power);
    if (power <= 1428)
    {
        micImageView.image = [UIImage imageNamed:@"micSize_1.png"];
    }
    else if(power <= 2856)
    {
        micImageView.image = [UIImage imageNamed:@"micSize_2.png"];
    }
    else if(power <= 4284)
    {
        micImageView.image = [UIImage imageNamed:@"micSize_3.png"];
    }
    else if(power <= 5712)
    {
        micImageView.image = [UIImage imageNamed:@"micSize_4.png"];
    }
    else if(power <= 7142)
    {
        micImageView.image = [UIImage imageNamed:@"micSize_5.png"];
    }
    else if(power <= 10000)
    {
        micImageView.image = [UIImage imageNamed:@"micSize_6.png"];
    }
}

@end
