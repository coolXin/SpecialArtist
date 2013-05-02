//
//  ArtistDetailsController.m
//  Artist
//
//  Created by cuibaoyin on 13-3-8.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#define litleTitleColor [UIColor colorWithRed:160.0/255 green:165.0/255 blue:164.0/255 alpha:1.0f]

#import "ArtistDetailsController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "CustomNaviagtionBar.h"
#import <QuartzCore/QuartzCore.h>

@interface ArtistDetailsController ()

@end

@implementation ArtistDetailsController
- (id)init
{
    if (self = [super init])
    {
        serverRequest = [[ServerRequestParam alloc] init];
        serverRequest.delegate = self;
        
        artShowArray = [[NSMutableArray alloc] initWithCapacity:0];
        videoArray = [[NSMutableArray alloc] initWithCapacity:0];
        videoImageArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)loadView
{
    //navigationBar
    [self setTitle:@"作家介绍"];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navigationPic.png"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:14] forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *leftBar = [[CustomNaviagtionBar getInstance] barButtonItemImage:[UIImage imageNamed:@"backOff.png"] withPressedImage:[UIImage imageNamed:@"backOn.png"] withSize:CGSizeMake(41, 30)];
    [(UIButton *)leftBar.customView addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:leftBar];
    
    //self.view
    CGRect frame = CGRectMake(0, 0, 320, Application_HEIGHT - 44);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view setBackgroundColor:[UIColor whiteColor]];
    self.view = view;
    
    myScrollView = [[UIScrollView alloc] initWithFrame:frame];
    [self.view addSubview:myScrollView];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    faildHud = [[MBProgressHUD alloc] initWithView:self.view];
    [faildHud setLabelText:@"请求失败,请重试!"];
    [faildHud setMode:MBProgressHUDModeText];
    [self.view addSubview:faildHud];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
}

- (void)dealloc
{
    serverRequest.delegate = nil;
    serverRequest = nil;
}

#pragma mark - methods
- (void)goBack:(id)sender
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)loadData
{
    [hud show:YES];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:ARTISTID,@"objectID",nil];
    [serverRequest requestServerWithType:get_artistDetails withParamObject:dic];
}

- (void)steupUI
{
    [self setTitle:[NSString stringWithFormat:@"%@简介",myModel.realName]];
    
    UIImageView *avaterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 300, 240)];
    [[avaterImageView layer] setMasksToBounds:YES];
    [[avaterImageView layer] setCornerRadius:5.0f];
    [[avaterImageView layer] setBorderWidth:0.1f];
    [[avaterImageView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    MBProgressHUD *myHud = [[MBProgressHUD alloc] initWithView:self.view];
    [avaterImageView addSubview:myHud];
    SDWebImageCompletedBlock imageCompletedBlock = ^(UIImage *image, NSError *error, SDImageCacheType cacheType)
    {
        [myHud hide:YES];
        [myHud removeFromSuperview];
    };
    SDWebImageDownloaderProgressBlock imageProgressBlock = ^(NSUInteger receivedSize, long long expectedSize)
    {
        [myHud show:YES];
    };
    [avaterImageView setImageWithURL:[NSURL URLWithString:myModel.avatar] placeholderImage:[UIImage imageNamed:@"image1.png"] options:SDWebImageLowPriority progress:imageProgressBlock completed:imageCompletedBlock];
    [myScrollView addSubview:avaterImageView];
    
    //分割线
    CGRect frame = avaterImageView.frame;
    float pointY = frame.origin.y + frame.size.height + 10;
    UIImageView *seperatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x, pointY, 300, 0.5)];
    seperatorImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"seperator" ofType:@"png"]];
    seperatorImageView.alpha = 0.6;
    [myScrollView addSubview:seperatorImageView];
    
    //文字简介label
    frame = seperatorImageView.frame;
    pointY = frame.origin.y + frame.size.height + 10;
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, pointY, 300, 30)];
    textLabel.font = [UIFont boldSystemFontOfSize:20];
    textLabel.backgroundColor = litleTitleColor;
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.text = @"简介:";
    [myScrollView addSubview:textLabel];
    
    //文字简介textview
    frame = textLabel.frame;
    pointY = frame.origin.y + frame.size.height;
    CGSize size = [myModel.textDesc sizeWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(300, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    if (size.height < 300)
    {
        frame = CGRectMake(10, pointY, 300, size.height);
    }
    else
    {
        frame = CGRectMake(10, pointY, 300, 300);
    }
    UITextView *contentTextView = [[UITextView alloc] initWithFrame:frame];
    contentTextView.font = [UIFont systemFontOfSize:15];
    contentTextView.backgroundColor = litleTitleColor;
    contentTextView.editable = NO;
    contentTextView.textAlignment = NSTextAlignmentLeft;
    [contentTextView setContentInset:UIEdgeInsetsMake(-8, -5, -5, -5)];
    contentTextView.textColor = [UIColor blackColor];
    contentTextView.text = myModel.textDesc;
    [myScrollView addSubview:contentTextView];

    //segmentButton
    frame = contentTextView.frame;
    frame.origin.y = frame.origin.y + frame.size.height + 10;
    frame.origin.x = 0;
    frame.size.height = 35;
    frame.size.width = 160;
    artShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    artShowBtn.frame = frame;
    [artShowBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"showOn" ofType:@"png"]] forState:UIControlStateNormal];
    [artShowBtn addTarget:self action:@selector(artShowBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:artShowBtn];
    
    frame.origin.x = 160;
    videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    videoButton.frame = frame;
    [videoButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"videoOff" ofType:@"png"]] forState:UIControlStateNormal];
    [videoButton addTarget:self action:@selector(videoBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
    [myScrollView addSubview:videoButton];
    
    //showtableview && videoscrollview
    frame.origin.y = frame.origin.y + frame.size.height;
    frame.origin.x = 0;
    frame.size.width = 320;
    frame.size.height = 200;
    showTableView = [[UITableView alloc] initWithFrame:frame];
    showTableView.delegate = self;
    showTableView.dataSource = self;
    showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myScrollView addSubview:showTableView];
    
    videoSrollview = [[UIScrollView alloc] initWithFrame:frame];
    videoSrollview.backgroundColor = [UIColor clearColor];
    videoSrollview.hidden = YES;
    videoSrollview.userInteractionEnabled = YES;
    [myScrollView addSubview:videoSrollview];

    frame = showTableView.frame;
    [myScrollView setContentSize:CGSizeMake(320, frame.origin.y + frame.size.height + 10)];
    
    [hud removeFromSuperview];
    hud.center = CGPointMake(showTableView.frame.size.width * 0.5, showTableView.frame.size.height * 0.5);
    [self artShowBtnSelected:nil];
}

- (void)loadVideoBtn
{
    for (int i = 1; i <= [videoArray count]; i ++)
    {
        int line = (int)ceilf((float)i / 3);
        int row = i % 3;
        float pointX = 5 * row + 100 * (row - 1);
        float pointY = 10 * line + 80 * (line - 1);
        CGRect frame = CGRectMake(pointX, pointY, 100, 80);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage imageNamed:@"image1.png"];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i - 1;
        
        CALayer *layer = [imageView layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:5.0];
        [layer setBorderWidth:0.3f];
        [layer setBorderColor:[[UIColor clearColor] CGColor]];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo:)];
        [imageView addGestureRecognizer:tapGesture];
    
        [videoSrollview addSubview:imageView];
    }
}

- (void)playVideo:(UITapGestureRecognizer *)recognizer
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.type = @"rippleEffect";
    animation.delegate = self;
    [animation setValue:recognizer.view forKey:@"targetView"];
    [recognizer.view.layer addAnimation:animation forKey:nil];
}

- (void)artShowBtnSelected:(id)sender
{
    [artShowBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"showOn" ofType:@"png"]] forState:UIControlStateNormal];
    [videoButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"videoOff" ofType:@"png"]] forState:UIControlStateNormal];
    showTableView.hidden = NO;
    videoSrollview.hidden = YES;
    
    if ([artShowArray count] == 0)
    {
        [showTableView addSubview:hud];
        //加载展览
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:ARTISTID,@"objectID",nil];
        [serverRequest requestServerWithType:get_artShowList_artist withParamObject:dic];
    }
}

- (void)videoBtnSelected:(id)sender
{
    [artShowBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"showOff" ofType:@"png"]] forState:UIControlStateNormal];
    [videoButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"videoOn" ofType:@"png"]] forState:UIControlStateNormal];
    showTableView.hidden = YES;
    videoSrollview.hidden = NO;
    
    if ([videoArray count] == 0)
    {
        [videoSrollview addSubview:hud];
        //加载视频
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:ARTISTID,@"objectID",nil];
        [serverRequest requestServerWithType:get_videoList_artist withParamObject:dic];
    }
}

- (void)generateVideoHtmlWithString:(NSMutableString *)string
{
    UIView *backView = [[UIView alloc] initWithFrame:self.view.frame];
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:backView.frame];
    imageView.backgroundColor = [UIColor grayColor];
    imageView.alpha = 0.7f;
    [backView addSubview:imageView];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 100, 310, 200)];
    //    webView.delegate = self;
    webView.backgroundColor = [UIColor clearColor];
    CALayer *layer = [webView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:5.0];
    [layer setBorderWidth:0.3f];
    [layer setBorderColor:[[UIColor clearColor] CGColor]];
    [backView addSubview:webView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, 25, 25);
    button.center =  CGPointMake(webView.frame.origin.x + 8, webView.frame.origin.y);
    button.backgroundColor = [UIColor clearColor];
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    //    [button setImage:[UIImage imageNamed:@"delBtn.png"] forState:UIControlStateNormal];
    //    [button setImage:[UIImage imageNamed:@"delBtnOn.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(closeVideoView:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:button];
    
    NSMutableString *srcString = [self replaceString:string withNewString:@"width=310 frameborder=0 src" withBegainString:@"height" withEndString:@"src"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSMutableString *htmlStr = [NSMutableString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    htmlStr = [self replaceString:htmlStr withNewString:srcString withBegainString:@"<iframe" withEndString:@"</iframe>"];
    [webView loadHTMLString:htmlStr baseURL:nil];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f;
    animation.type = kCATransitionReveal;
    animation.subtype = kCAMediaTimingFunctionEaseInEaseOut;
    [backView.layer addAnimation:animation forKey:nil];
}

- (NSMutableString *)replaceString:(NSMutableString *)oriString withNewString:(NSString *)newString withBegainString:(NSString *)begainString withEndString:(NSString *)endString
{
    NSRange range;
    NSRange begainRange = [oriString rangeOfString:begainString];
    NSRange endRange = [oriString rangeOfString:endString];
    range.location = begainRange.location;
    range.length = endRange.location - begainRange.location + endRange.length;
    
    NSMutableString *oriStrCopy = [NSMutableString stringWithString:oriString];
    [oriStrCopy deleteCharactersInRange:range];
    [oriStrCopy insertString:newString atIndex:range.location];
    return oriStrCopy;
}

- (void)closeVideoView:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [btn.superview removeFromSuperview];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [artShowArray count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCenterCell"];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserCenterCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.textLabel.textColor = [UIColor blackColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, 320,1)];
        imageView.image = [UIImage imageNamed:@"seperator.png"];
        [cell addSubview:imageView];
    }
    cell.textLabel.text = [artShowArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

#pragma mark - AnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    UIView *view = [anim valueForKey:@"tagetView"];
    [self generateVideoHtmlWithString:[videoArray objectAtIndex:view.tag]];
}

#pragma mark - ServerRequestParamDelegate
- (void)requsetSuccessWithType:(RequsetType)type withServerData:(NSDictionary *)severData withMoreMark:(BOOL)flag
{
    switch (type)
    {
        case get_artistDetails:
        {
            myModel = [[ArtistModel alloc] initWithDictionary:[severData objectForKey:@"DATA"] withFtpPath:[severData objectForKey:@"FTP"]];
            [self steupUI];
            break;
        }
        case get_videoList_artist:
        {
            [hud hide:YES];
            for (NSDictionary *dic in [severData objectForKey:@"DATA"])
            {
                NSString *imagePath = [[severData objectForKey:@"FTP"] stringByAppendingString:[dic objectForKey:@"imgPath"]];
                [videoArray addObject:[dic objectForKey:@"iosPath"]];
                [videoImageArray addObject:imagePath];
            }
            [self loadVideoBtn];
            break;
        }
        case get_artShowList_artist:
        {
            [hud hide:YES];
            for (NSDictionary *dic in [severData objectForKey:@"DATA"])
            {
                NSLog(@"%@",[dic objectForKey:@"campaignName"]);
                [artShowArray addObject:[dic objectForKey:@"campaignName"]];
            }
            [showTableView reloadData];
            break;
        }
        default:
            break;
    }
}

- (void)requsetFailedWithType:(RequsetType)type
{
    switch (type)
    {
        case get_artistDetails:
        {
            [hud hide:YES];
            [faildHud show:YES];
            [faildHud hide:YES afterDelay:2];
            break;
        }
        case get_videoList_artist:
        {
            break;
        }
        case get_artShowList_artist:
        {
            break;
        }
        default:
            break;
    }

}

@end
