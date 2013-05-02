//
//  CommitCell.m
//  Artist
//
//  Created by cuibaoyin on 13-3-21.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import "CommitCell.h"
#import "AFDownloadRequestOperation.h"
#import "CommitViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"

@implementation CommitCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setupCellWithCommit:(CommentModel *)model
{
    [self cleanUpTheCell];
    _myModel = model;
    
    [_avaterImageView setImageWithURL:[NSURL URLWithString:_myModel.user_avater] placeholderImage:[UIImage imageNamed:@"commentDefaultAvater.png"] options:SDWebImageProgressiveDownload progress:nil completed:nil];
    _avaterImageView.layer.cornerRadius = 2.0;
    _avaterImageView.layer.masksToBounds = YES;
    _avaterImageView.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.2].CGColor;
    _avaterImageView.layer.borderWidth = 1.0;
    
    NSString *str = [NSString stringWithFormat:@"%@: %@",model.user_name,model.content];
    UIFont *font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    CGSize size = [str sizeWithFont:font constrainedToSize:CGSizeMake(260, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    
    _textContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    _textContentLabel.numberOfLines = 0;
    _textContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _textContentLabel.text = str;
    _textContentLabel.font = font;
    _textContentLabel.textColor = [UIColor blackColor];
    _textContentLabel.backgroundColor = [UIColor clearColor];
    _textContentLabel.center = CGPointMake(size.width * 0.5 + 50, self.frame.size.height * 0.5);
    [self addSubview:_textContentLabel];

    if (model.type == 1)
    {
        _voiceView.hidden = NO;
        float center_X = _textContentLabel.frame.origin.x + _textContentLabel.frame.size.width + _voiceView.frame.size.width * 0.5 + 5;
        float center_y = _textContentLabel.center.y;
        _voiceView.center = CGPointMake(center_X, center_y);
        _durationLabel.text = [_myModel.voiceDuration stringByAppendingString:@"''"];
    }
}

- (void)cleanUpTheCell
{
    if (_textContentLabel != nil)
    {
        [_textContentLabel removeFromSuperview];
        _textContentLabel = nil;
    }

    _voiceView.hidden = YES;
//    _playBtn.tag = 0;
}

- (void)resetPlayingCell //重置正在播放的cell
{
    CommitViewController *controller = (CommitViewController *)self.superview.superview.nextResponder;
    for (int i = 0; i < [controller.dataArray count]; i ++)
    {
        CommentModel *model = [controller.dataArray objectAtIndex:i];
        if ([model.voiceFileDownloadPath isEqualToString:[AmrRecordAndPlay getInstance].playingFilePath])
        {
            NSIndexPath *index = [NSIndexPath indexPathForItem:i inSection:0];
            CommitCell *cell = (CommitCell *)[controller.myTable cellForRowAtIndexPath:index];
            cell.audioStatusImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"commentPausing" ofType:@"png"]];
            [[AmrRecordAndPlay getInstance] stopPlayAudio];
            [AmrRecordAndPlay getInstance].delegate = nil;
        }
    }
}

- (void)steupPlayer//初始化播放器
{
    NSString *voiceCommentFileName = [NSString stringWithFormat:@"%d-%@-%@-%@.amr",_myModel.objectType, _myModel.id,_myModel.user_id,_myModel.commitTime];
    NSString *dictonaryPath = [DocumentsDirectory stringByAppendingString:@"/voiceComment"];
    [[NSFileManager defaultManager] createDirectoryAtPath:dictonaryPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *filePath = [dictonaryPath stringByAppendingPathComponent:voiceCommentFileName];
    _myModel.voiceFileDownloadPath = filePath;

    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        _audioStatusImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"commentPlaying" ofType:@"png"]];
        [[AmrRecordAndPlay getInstance] steupPlayAudioWithPath:filePath];
        [AmrRecordAndPlay getInstance].delegate = self;
        [[AmrRecordAndPlay getInstance] startPlayAudio];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:_myModel.voicePath];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3600];
        AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:filePath shouldResume:YES];
        
        __block UIActivityIndicatorView *activeIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activeIndicator.frame = CGRectMake(0, 0, _audioStatusImageView.frame.size.width * 0.8, _audioStatusImageView.frame.size.height * 0.8);
        [activeIndicator startAnimating];
        _audioStatusImageView.image = nil;
        [_audioStatusImageView addSubview:activeIndicator];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             [activeIndicator stopAnimating];
             [activeIndicator removeFromSuperview];
             _audioStatusImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"commentPlaying" ofType:@"png"]];
             [[AmrRecordAndPlay getInstance] steupPlayAudioWithPath:filePath];
             [AmrRecordAndPlay getInstance].delegate = self;
             [[AmrRecordAndPlay getInstance] startPlayAudio];
         }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
             [activeIndicator stopAnimating];
             [activeIndicator removeFromSuperview];
             _audioStatusImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"commentPausing" ofType:@"png"]];
         }];
        [operation start];
    }
}

- (IBAction)playBtnPressed:(id)sender
{
    NSString *playerPath = [AmrRecordAndPlay getInstance].playingFilePath;
    if (playerPath == nil)
    {
//        NSLog(@"播放器没有初始化");
        [self steupPlayer];
    }
    else if(![playerPath isEqualToString:_myModel.voiceFileDownloadPath])
    {
//        NSLog(@"播放器不等于点击的CELL");
        [self resetPlayingCell];
        [self steupPlayer];
    }
    else
    {
        switch ([[AmrRecordAndPlay getInstance] getStausOfPlayer])
        {
            case isPlaying:
            {
                [[AmrRecordAndPlay getInstance] pausePlayAudio];
                _audioStatusImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"commentPausing" ofType:@"png"]];
                return;
            }
            case isPausing:
            {
                [[AmrRecordAndPlay getInstance] startPlayAudio];
                _audioStatusImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"commentPlaying" ofType:@"png"]];                return;
            }
            case isStopping:
            {
                [self steupPlayer];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - AmrRecordAndPlayDelegate
- (void)audioPlayer:(AVAudioPlayer *)player finishedPlayingWithSuccessfully:(BOOL)flag
{
    if (flag)
    {
        _audioStatusImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"commentPausing" ofType:@"png"]];
    }
}

- (void)audioPlayer:(AVAudioPlayer *)player failedPlayingWithError:(NSError *)error
{
    
}
@end
