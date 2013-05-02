//
//  ArtWorkIntroduce.m
//  Artist
//
//  Created by cuibaoyin on 13-3-27.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import "ArtWorkIntroduce.h"
#import <QuartzCore/QuartzCore.h>
#import "AudioPlayer.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface ArtWorkIntroduce ()

@end

@implementation ArtWorkIntroduce

- (id)initWithModel:(ArtWorksModel *)model
{
    if (self = [super init])
    {
        myModel = model;
        serverRequest = [[ServerRequestParam alloc] init];
        serverRequest.delegate = self;
    }
    return self;
}

- (void)loadView
{
    CGRect frame = CGRectMake(0, 0, Application_Frame.size.width, Application_Frame.size.height);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    self.view = view;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerView];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:headerView.frame];
    UIImage *image = [UIImage imageNamed:@"navigationPic.png"];
    headerImageView.image = [image stretchableImageWithLeftCapWidth:0.5 topCapHeight:14];
    [headerView addSubview:headerImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = myModel.title;
    [headerView addSubview:titleLabel];

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(5, 7, 41, 30);
    [backBtn setImage:[UIImage imageNamed:@"backOff.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"backOn.png"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:backBtn];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, frame.size.width, frame.size.height)];
    myScrollView.backgroundColor = [UIColor whiteColor];
    myScrollView.showsVerticalScrollIndicator = YES;
    [view addSubview:myScrollView];
    
    [self requestServer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)dealloc
{
    serverRequest.delegate = nil;
    serverRequest = nil;
}

#pragma mark - methods
- (void)requestServer
{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [hud setLabelText:@"加载中..."];
    [myScrollView addSubview:hud];
    [hud show:YES];
    
    faildHud = [[MBProgressHUD alloc] initWithView:self.view];
    [faildHud setMode:MBProgressHUDModeText];
    [faildHud setLabelText:@"加载失败，请重试！"];
    [myScrollView addSubview:faildHud];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:myModel.id,@"objectID",nil];
    [serverRequest requestServerWithType:get_artWorkDetails withParamObject:dic];
}

- (void)steupUI
{
    //作品图片
    UIImageView  *workImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
    __block MBProgressHUD *workHud = [[MBProgressHUD alloc] initWithView:self.view];
    [workImageView addSubview:workHud];
    [workImageView setImageWithURL:[NSURL URLWithString:myModel.image_original] placeholderImage:[UIImage imageNamed:@"image1.png"] options:SDWebImageLowPriority progress:^(NSUInteger receivedSize, long long expectedSize)
     {
         [workHud show:YES];
     }
     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
     {
         [workHud hide:YES];
         [workHud removeFromSuperview];
     }];
    
    workImageView.backgroundColor = [UIColor whiteColor];
    [[workImageView layer] setMasksToBounds:YES];
    [[workImageView layer] setCornerRadius:10.0];
    [[workImageView layer] setBorderWidth:0.2f];
    [[workImageView layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [myScrollView addSubview:workImageView];
    
    //语音介绍按钮
    CGRect frame = workImageView.frame;
    if (myModel.voiceDesc != nil)
    {
        UIButton *playAudioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        frame.origin.y = frame.origin.y + frame.size.height + 10;
        frame.size.width = 248;
        frame.size.height = 34;
        frame.origin.x = (320 - frame.size.width) * 0.5;
        playAudioBtn.frame = frame;
        [playAudioBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"audioPlayBackgroundOff" ofType:@"png"]] forState:UIControlStateNormal];
        [playAudioBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"audioPlayBackgroundOn" ofType:@"png"]] forState:UIControlStateHighlighted];
        [playAudioBtn addTarget:self action:@selector(playAudioDesc:) forControlEvents:UIControlEventTouchUpInside];
        [myScrollView addSubview:playAudioBtn];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 72, 14)];
        imageview.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"audioTitle" ofType:@"png"]];
        imageview.center = CGPointMake(playAudioBtn.frame.size.width * 0.5, playAudioBtn.frame.size.height * 0.5);
        [playAudioBtn addSubview:imageview];
        
        audioStatusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageview.frame.origin.x + imageview.frame.size.width +10, imageview.frame.origin.y, 10, 14)];
        audioStatusImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"audioPausing" ofType:@"png"]];
        [playAudioBtn addSubview:audioStatusImageView];
    }

    //分割线
    frame.origin.x = 10;
    frame.origin.y = frame.origin.y + frame.size.height + 10;
    frame.size.width = 300;
    frame.size.height = 0.5;
    UIImageView *seperatorImageView = [[UIImageView alloc] initWithFrame:frame];
    seperatorImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"seperator" ofType:@"png"]];
    [myScrollView addSubview:seperatorImageView];
    
    //作品文字介绍
    UIFont *font = [UIFont boldSystemFontOfSize:15];
    frame = seperatorImageView.frame;
    float pointY = frame.origin.y + frame.size.height + 10;
    UILabel *textDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, pointY, 300, 20)];
    textDescLabel.font = [UIFont boldSystemFontOfSize:20];
    textDescLabel.backgroundColor = [UIColor clearColor];
    textDescLabel.textAlignment = NSTextAlignmentLeft;
    textDescLabel.text = @"创作背景:";
    textDescLabel.textColor = [UIColor grayColor];
    [myScrollView addSubview:textDescLabel];
    
    frame = textDescLabel.frame;
    pointY = frame.origin.y + frame.size.height + 5;
    CGSize size = [myModel.textDesc sizeWithFont:font constrainedToSize:CGSizeMake(300, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x, pointY, 300, size.height)];
    contentLabel.font = [UIFont systemFontOfSize:15];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.text = myModel.textDesc;
    contentLabel.textColor = [UIColor blackColor];
    [myScrollView addSubview:contentLabel];
    
    frame = contentLabel.frame;
    [myScrollView setContentSize:CGSizeMake(320, frame.origin.y + frame.size.height + 50)];
}

- (void)goBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)playAudioDesc:(id)sender
{
    NSString *urlStr = [[AudioPlayer sharePlayer].url absoluteString];
    if ([urlStr isEqualToString:myModel.voiceDesc])
    {
        if ([[AudioPlayer sharePlayer] isPyaerPlaying])
        {
            [[AudioPlayer sharePlayer] pausePlay];
            audioStatusImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"audioPausing" ofType:@"png"]];
        }
        else
        {
            [[AudioPlayer sharePlayer] startPlayWithType:PlayerTypeNetwork];
            audioStatusImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"audioPlaying" ofType:@"png"]];
        }
    }
    else
    {
        [[AudioPlayer sharePlayer] playWithDataSourceType:DataSourceTypeNetwork withURLString:myModel.voiceDesc];
        audioStatusImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"audioPlaying" ofType:@"png"]];
    }
}

#pragma mark - ServerRequestParamDelegate
- (void)requsetSuccessWithType:(RequsetType)type withServerData:(NSDictionary *)severData withMoreMark:(BOOL)flag
{
    NSString *ftpPath = [severData objectForKey:@"FTP"];
    NSDictionary *dataDic = [severData objectForKey:@"DATA"];
    [myModel setModelWithDictionary:dataDic withFtp:ftpPath];
    [self steupUI];
    [hud hide:YES];
    [hud removeFromSuperview];
}

- (void)requsetFailedWithType:(RequsetType)type
{
    [hud hide:YES];
    [hud removeFromSuperview];
    [faildHud show:YES];
    [faildHud hide:YES afterDelay:2];
}
@end
