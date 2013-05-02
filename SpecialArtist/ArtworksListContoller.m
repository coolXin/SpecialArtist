//
//  ArtworksListContoller.m
//  SpecialArtist
//
//  Created by Cby on 13-4-18.
//  Copyright (c) 2013年 Cby. All rights reserved.
//

#define menuColor [UIColor colorWithRed:100.0/255 green:182.0/255 blue:250.0/255 alpha:1.0f]

#import "ArtworksListContoller.h"
#import "ArtWorksModel.h"
#import "ArtWorkCell.h"
#import "LoginController.h"
#import "UserCenterController.h"
#import "ArtistDetailsController.h"

@interface ArtworksListContoller ()

@end

@implementation ArtworksListContoller
@synthesize myTable = myTabelView;
@synthesize dataArray= myArray;

- (void)loadView
{
    CGRect frame = Application_Frame;
    frame.origin.y = 0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view .backgroundColor = [UIColor whiteColor];
    self.view = view;
    //tableview
    frame.size.height = frame.size.height - 50;
    frame.origin.y = 44;
    myTabelView = [[UITableView alloc] initWithFrame:frame];
    myTabelView.backgroundColor = [UIColor clearColor];
    myTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTabelView.dataSource = self;
    myTabelView.delegate = self;
    [self.view addSubview:myTabelView];
    
    myTableHeaderView = [[RefreshTableHeaderView alloc] initWithOwner:myTabelView withDelegate:self withLastUpdateTimeMark:@"主页"];
    
    //仿导航栏
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerView];
    
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:headerView.frame];
    UIImage *image = [UIImage imageNamed:@"navigationPic.png"];
    headerImageView.image = [image stretchableImageWithLeftCapWidth:0.5 topCapHeight:14];
    [headerView addSubview:headerImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:headerView.frame];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"主页";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    [headerView addSubview:titleLabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(10, 7, 41, 30);
    btn.tag = 0;
    UIImage *menuOff = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menuOff" ofType:@"png"]];
    UIImage *menuOn = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menuOn" ofType:@"png"]];
    [btn setImage:menuOff forState:UIControlStateNormal];
    [btn setImage:menuOn forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btn];
    
    //菜单view
    frame = CGRectMake(10, 44, 143, 107);
    frame.origin.y = frame.origin.y - frame.size.height;
    menuView = [[UIView alloc] initWithFrame:frame];
    menuView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:menuView belowSubview:headerView];
    
    frame.origin.x = 0;
    frame.origin.y = 0;
    UIImageView *menuImage = [[UIImageView alloc] initWithFrame:frame];
    menuImage.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menuBackImage" ofType:@"png"]];
    [menuView addSubview:menuImage];
    
    loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 137, 44)];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.font = [UIFont boldSystemFontOfSize:20];
    loginLabel.textAlignment = NSTextAlignmentCenter;
    loginLabel.textColor = [UIColor whiteColor];
    [menuView addSubview:loginLabel];
    
    artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, 137, 44)];
    artistLabel.backgroundColor = [UIColor clearColor];
    artistLabel.font = [UIFont boldSystemFontOfSize:20];
    artistLabel.textAlignment = NSTextAlignmentCenter;
    artistLabel.textColor = [UIColor whiteColor];
    artistLabel.text = @"作家介绍";
    [menuView addSubview:artistLabel];
    
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setFrame:loginLabel.frame];
    [loginBtn addTarget:self action:@selector(loginBtnDown:) forControlEvents:UIControlEventTouchDown];
    [loginBtn addTarget:self action:@selector(loginBtnUp:) forControlEvents:UIControlEventTouchUpOutside];
    [loginBtn addTarget:self action:@selector(loginBtnUp:) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:loginBtn];
    [self setLoginBtnTitle];

    UIButton *artistDetailsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [artistDetailsBtn setFrame:artistLabel.frame];
    [artistDetailsBtn addTarget:self action:@selector(artistBtnDown:) forControlEvents:UIControlEventTouchDown];
    [artistDetailsBtn addTarget:self action:@selector(artistBtnUp:) forControlEvents:UIControlEventTouchUpInside];
    [artistDetailsBtn addTarget:self action:@selector(artistBtnUp:) forControlEvents:UIControlEventTouchUpOutside];
    [menuView addSubview:artistDetailsBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    serverRequest = [[ServerRequestParam alloc] init];
    serverRequest.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCommentNotification:) name:@"CommentNumChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLoginSuccessNotifaction:) name:@"LoginStatusChanged" object:nil];
    myArray = [[NSMutableArray alloc] initWithCapacity:0];
    [myTableHeaderView startLoading];
}

- (void)dealloc
{
    serverRequest.delegate = nil;
    serverRequest = nil;
}

- (void)showMenu:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 0)
    {
        [UIView animateWithDuration:0.5f animations:^
        {
            btn.tag = 1;
            CGRect frame = menuView.frame;
            frame.origin.y = frame.origin.y + frame.size.height;
            [menuView setFrame:frame];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5f animations:^
         {
             btn.tag = 0;
             CGRect frame = menuView.frame;
             frame.origin.y = frame.origin.y - frame.size.height;
             [menuView setFrame:frame];
         }];
    }
}

- (void)getLoginSuccessNotifaction:(id)notifaction
{
    [self setLoginBtnTitle];
}

- (void)getCommentNotification:(NSNotification *)notifaction
{
    for (int i = 0; i < [myArray count]; i ++)
    {
        ArtWorksModel *model = [myArray objectAtIndex:i];
        if ([model.id isEqualToString:notifaction.object])
        {
            [myTabelView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:NO];
            return;
        }
    }
}

- (void)setLoginBtnTitle
{
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    if (userID == nil)
    {
        loginBtn.tag = 0;
        loginLabel.text = @"登陆/注册";
    }
    else
    {
        loginBtn.tag = 1;
        loginLabel.text = @"个人中心";
    }
}

- (void)artistBtnDown:(id)sender
{
    artistLabel.textColor = menuColor;
}

- (void)artistBtnUp:(id)sender
{
    artistLabel.textColor = [UIColor whiteColor];
    ArtistDetailsController *controller = [[ArtistDetailsController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentModalViewController:nav animated:YES];
}

- (void)loginBtnDown:(id)sender
{
    loginLabel.textColor = menuColor;
}

- (void)loginBtnUp:(id)sender
{
    loginLabel.textColor = [UIColor whiteColor];

    if (loginBtn.tag == 0)
    {
        LoginController *controller = [[LoginController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        UserCenterController *controller = [[UserCenterController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:nav animated:YES completion:nil];
        
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myArray count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    ArtWorkCell *cell = (ArtWorkCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ArtWorkCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell cleanDataAndUI];
    [cell loadDataWithArray:myArray withIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300.0;
}

#pragma mark - ServerRequestParamDelegate
- (void)requsetSuccessWithType:(RequsetType)type withServerData:(NSDictionary *)severData withMoreMark:(BOOL)flag
{
    if (!flag)//上拉刷新清空数组
    {
        [myArray removeAllObjects];
    }
    
    NSArray *dataArray = [severData objectForKey:@"DATA"];
    for (NSDictionary *dataDic in dataArray)
    {
        [myArray addObject:[[ArtWorksModel alloc] initWithDictionary:dataDic  withFtp:[severData objectForKey:@"FTP"]]];
    }
    [myTabelView reloadData];
    
    if (!flag)//停止加载动画
    {
        [myTableHeaderView stopLoading];
    }
    else
    {
        [myTableFooterView stopLoading];
    }
    
    //判断是否需要footerview
    if ([dataArray count] == 10 && myTableFooterView == nil)
    {
        myTableFooterView = [[LoadMoreFooterView alloc] initWithOwner:myTabelView withDelegate:self];
        myTabelView.tableFooterView = myTableFooterView;
    }
    if([dataArray count] < 10 && myTableFooterView != nil)       //去除加载更多view
    {
        [myTableFooterView removeFromSuperview];
        myTableFooterView = nil;
        [myTabelView setTableFooterView:nil];
    }
}

- (void)requsetFailedWithType:(RequsetType)type
{
    [myTableHeaderView stopLoading];
    [myTableFooterView stopLoading];
}

#pragma mark - RefreshTableHeaderViewDelegate && LoadMoreFooterView
- (void)headerViewStartLoading
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:ARTISTID,@"objectID",[NSNumber numberWithInt:0],@"startNum", nil];
    [serverRequest requestServerWithType:get_artWorkList_artist withParamObject:dic];
}

- (void)footerViewStartLoading
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:ARTISTID,@"objectID",[NSNumber numberWithInt:[myArray count]],@"startNum", nil];
    [serverRequest requestServerWithType:get_artWorkList_artist withParamObject:dic];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [myTableHeaderView scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [myTableHeaderView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [myTableHeaderView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

@end
