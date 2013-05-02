//
//  HaoKanCell.m
//  Artist
//
//  Created by cuibaoyin on 13-3-5.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#define backColor [UIColor colorWithRed:231.0/255 green:231.0/255 blue:231.0/255 alpha:1.0f]
#define titleColor [UIColor colorWithRed:55.0/255 green:62.0/255 blue:82.0/255 alpha:1.0f]
#define litleTitleColor [UIColor colorWithRed:160.0/255 green:165.0/255 blue:164.0/255 alpha:1.0f]
#define numColor [UIColor colorWithRed:100.0/255 green:182.0/255 blue:250.0/255 alpha:1.0f]

#import "ArtWorkCell.h"
#import "ArtWorksModel.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "WorksBrowserController.h"
#import "CommitViewController.h"
#import "LoginController.h"

@implementation ArtWorkCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
    }
    return self;
}

- (void)cleanDataAndUI
{
    dataArray = nil;
    indexPath = nil;
    if (serverRequest)
    {
        serverRequest.delegate = nil;
        serverRequest = nil;
    }
    if (hud)
    {
        [hud hide:YES];
        [hud removeFromSuperview];
        hud = nil;
    }
    if (failedHud)
    {
        [failedHud hide:YES];
        [failedHud removeFromSuperview];
        failedHud = nil;
    }
}

- (void)loadDataWithArray:(NSMutableArray *)array withIndexPath:(NSIndexPath *)index
{
    dataArray = array;
    indexPath = index;
    ArtWorksModel *myModel = [dataArray objectAtIndex:indexPath.row];
    
    _frameView.backgroundColor = backColor;
    [[_frameView layer] setMasksToBounds:YES];
    [[_frameView layer] setCornerRadius:5.0];
    [[_frameView layer] setBorderWidth:0.1f];
    [[_frameView layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    
    _workNameLabel.text = myModel.title;
    _workNameLabel.textColor = titleColor;
    _litleTitleLabel.text = [NSString stringWithFormat:@"%@%@作品",myModel.birthday,myModel.artistName];
    _litleTitleLabel.textColor = litleTitleColor;
    
    MBProgressHUD *myHud = [[MBProgressHUD alloc] initWithView:self];
    [_myImageView addSubview:myHud];
    [_myImageView setImageWithURL:[NSURL URLWithString:myModel.image_small] placeholderImage:[UIImage imageNamed:@"image1.png"] options:SDWebImageProgressiveDownload progress:^(NSUInteger receivedSize, long long expectedSize)
     {
         [myHud show:YES];
     }
     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
     {
         [myHud hide:YES];
         [myHud removeFromSuperview];
     }];
    [self addGestureToImageView:_myImageView];
    [self setLabelNum];
}

- (void)setLabelNum
{
    ArtWorksModel *myModel = [dataArray objectAtIndex:indexPath.row];
    NSString *fancyStr = [NSString stringWithFormat:@"%@",myModel.likeCount];
    NSString *commentStr = [NSString stringWithFormat:@"%@",myModel.commentCount];
    _fancyLabel.text = fancyStr;
    _fancyLabel.textColor = numColor;
    _commentLabel.text = commentStr;
    _commentLabel.textColor = numColor;
}

- (void)addGestureToImageView:(UIImageView *)imageView
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewPressed:)];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:tapGesture];
}

- (BOOL)checkLoginStatuseWith:(NSString *)str
{
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    if (userID == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        [alert show];
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark - UITouch
- (void)imageViewPressed:(UITapGestureRecognizer *)recognizer
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.type = @"rippleEffect";
    animation.delegate = self;
    [animation setValue:recognizer.view forKey:@"targetView"];
    [recognizer.view.layer addAnimation:animation forKey:nil];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        LoginController *controller = [[LoginController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [(UIViewController *)self.superview.superview.nextResponder presentModalViewController:nav animated:YES];
    }
}

#pragma mark - AnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag)
    {
        WorksBrowserController *controller = [[WorksBrowserController alloc] initWithArray:dataArray withCurrentPage:indexPath.row];
        UIViewController *selfController = (UIViewController *)self.superview.superview.nextResponder;
        [selfController presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark - IBAction
- (IBAction)fancyWork:(id)sender
{
    ArtWorksModel *myModel = [dataArray objectAtIndex:indexPath.row];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:myModel.id,@"objectID",nil];
    
    if (serverRequest == nil)
    {
        serverRequest = [[ServerRequestParam alloc] init];
        serverRequest.delegate = self;
        
        hud = [[MBProgressHUD alloc] initWithView:self.superview.superview];
        [self.superview.superview addSubview:hud];
        
        failedHud = [[MBProgressHUD alloc] initWithView:self.superview.superview];
        [failedHud setMode:MBProgressHUDModeText];
        [failedHud setLabelText:@"请求失败，请重试!"];
        [self.superview.superview addSubview:failedHud];
    }
    [hud show:YES];
    [serverRequest requestServerWithType:fancy_artwork withParamObject:dic];
}

- (IBAction)commentWork:(id)sender
{
    if ([self checkLoginStatuseWith:@"登录后就可以评论此作品,是否登录?"])
    {
        UIViewController *supController = (UIViewController *)self.superview.superview.nextResponder;
        ArtWorksModel *myModel = [dataArray objectAtIndex:indexPath.row];
        CommitViewController *controller = [[CommitViewController alloc] initWithModel:myModel];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [supController presentModalViewController:nav animated:YES];
    }
}

#pragma mark - ServerRequestParamDelegate
- (void)requsetSuccessWithType:(RequsetType)type withServerData:(NSDictionary *)severData withMoreMark:(BOOL)flag
{
    if (type == fancy_artwork)
    {
        [hud hide:YES];
        
        ArtWorksModel *model = [dataArray objectAtIndex:indexPath.row];
        model.likeCount = [NSString stringWithFormat:@"%d",[model.likeCount intValue] + 1];
        
        UITableView *table = (UITableView *)self.superview;
        [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationNone];
    }
}

- (void)requsetFailedWithType:(RequsetType)type
{
    [hud hide:YES];
    
    [failedHud show:YES];
    [failedHud hide:YES afterDelay:2];
}

@end
