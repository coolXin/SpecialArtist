//
//  WorksBrowserController.m
//  Artist
//
//  Created by cuibaoyin on 13-3-5.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import "WorksBrowserController.h"
#import "ArtWorksModel.h"
#import "ArtworksListContoller.h"
#import "ArtWorkIntroduce.h"
#import "CommitViewController.h"
#import "ShareToController.h"
#import "LoginController.h"

@interface WorksBrowserController ()

@end

@implementation WorksBrowserController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithArray:(NSMutableArray *)array withCurrentPage:(int)currentPage
{
    if (self = [super init])
    {
        _myArray = [[NSMutableArray alloc] initWithArray:array];
        _currentPage = currentPage;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _headerImageView.image = [[UIImage imageNamed:@"navigationPic.png"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:14];
    _footerImageView.image = [[UIImage imageNamed:@"buttomImage.png"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:14];

    [self setChangedTitle];

    //加入图片浏览View
    CGRect frame = CGRectMake(0, 0, 320, 460);
    imageBrowser = [[ImagesBrowser alloc] initWithFrame:frame withItemArray:_myArray withCurrentPage:_currentPage];
    imageBrowser.delegate = self;
    [self.view insertSubview:imageBrowser atIndex:0];
}

- (void)dealloc
{
    if (serverRequest != nil)
    {
        serverRequest.delegate = nil;
        serverRequest = nil;
    }
}

- (void)setChangedTitle
{
    ArtWorksModel *model = [_myArray objectAtIndex:_currentPage];
    self.titleLabel.text = model.title;
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
#pragma mark IBAction
- (IBAction)goBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareToInternet:(id)sender
{
    if ([self checkLoginStatuseWith:@"登录后就可以分享给好友,是否登录?"])
    {
        UIImageView *imageView = [imageBrowser getImageViewByTag:_currentPage];
        ShareToController *controller = [[ShareToController alloc] initWithObject:[_myArray objectAtIndex:_currentPage] withSharedImage:imageView.image];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentModalViewController:nav animated:YES];
    }
}

- (IBAction)fancyWork:(id)sender
{
    ArtWorksModel *model = [_myArray objectAtIndex:_currentPage];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:model.id,@"objectID",nil];
    if (serverRequest == nil)
    {
        serverRequest = [[ServerRequestParam alloc] init];
        serverRequest.delegate = self;
        
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        
        failedHud = [[MBProgressHUD alloc] initWithView:self.view];
        [failedHud setMode:MBProgressHUDModeText];
        [failedHud setLabelText:@"请求失败，请重试!"];
        [self.view addSubview:failedHud];
    }
    [hud show:YES];
    [serverRequest requestServerWithType:fancy_artwork withParamObject:dic];
}

- (IBAction)commentWork:(id)sender
{
    if ([self checkLoginStatuseWith:@"登录后就可以评论此作品,是否登录?"])
    {
        ArtWorksModel *myModel = [_myArray objectAtIndex:_currentPage];
        CommitViewController *controller = [[CommitViewController alloc] initWithModel:myModel];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentModalViewController:nav animated:YES];
    }
}

- (IBAction)showArtWorkIntroduce:(id)sender
{
    ArtWorkIntroduce *controller = [[ArtWorkIntroduce alloc] initWithModel:[_myArray objectAtIndex:_currentPage]];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - ServerRequestParamDelegate
- (void)requsetSuccessWithType:(RequsetType)type withServerData:(NSDictionary *)severData withMoreMark:(BOOL)flag
{
    if (type == fancy_artwork)
    {
        [hud hide:YES];
        
        ArtWorksModel *model = [_myArray objectAtIndex:_currentPage];
        model.likeCount = [NSString stringWithFormat:@"%d",[model.likeCount intValue] + 1];
        
        ArtworksListContoller *controller = (ArtworksListContoller *)self.presentingViewController;
            NSIndexPath *index = [NSIndexPath indexPathForRow:_currentPage inSection:0];
        [controller.myTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)requsetFailedWithType:(RequsetType)type
{
    [hud hide:YES];
    [failedHud show:YES];
    [failedHud hide:YES afterDelay:2];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        LoginController *controller = [[LoginController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentModalViewController:nav animated:YES];
    }
}

#pragma mark ImageBrowserDelegate
- (void)pageChanged:(int)currentPage
{
    //滚动列表让当前Item显示在中间
    ArtworksListContoller *listController = (ArtworksListContoller *)self.presentingViewController;
    if ([listController isKindOfClass:[ArtworksListContoller class]])
    {
        NSIndexPath *index = [NSIndexPath indexPathForRow:currentPage inSection:0];
        [listController.myTable scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
    _currentPage = currentPage;
    [self setChangedTitle];
}

- (void)pageTapped
{
    if (_headview.hidden)
    {
        _headview.hidden = NO;
        _footerView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^
        {
            _headview.frame = CGRectMake(0, 0, 320, 40);
            _footerView.frame = CGRectMake(0, 420, 320, 40);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^
         {
             _headview.frame = CGRectMake(0, -40, 320, 40);
             _footerView.frame = CGRectMake(0, 500, 320, 40);
         }
        completion:^(BOOL finished)
         {
             _headview.hidden = YES;
             _footerView.hidden = YES;
         }];
    }
}
- (void)viewDidUnload {
    [self setHeaderImageView:nil];
    [self setFooterImageView:nil];
    [super viewDidUnload];
}
@end
