//
//  CommitViewController.m
//  Artist
//
//  Created by cuibaoyin on 13-3-21.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import "CommitViewController.h"
#import "CommitCell.h"
#import "CommentModel.h"
#import "ArtWorksModel.h"
#import "CustomNaviagtionBar.h"

@interface CommitViewController ()

@end

@implementation CommitViewController
@synthesize dataArray = myArray;
@synthesize myTable = myTabelView;

- (id)initWithModel:(ArtWorksModel *)model
{
    if (self = [super init])
    {
        myModel = model;
        myArray = [[NSMutableArray alloc] initWithCapacity:0];
        serverRequest = [[ServerRequestParam alloc] init];
        serverRequest.delegate = self;
    }
    return self;
}

- (void)loadView
{
    CGRect frame = Application_Frame;
    frame.origin.y = 0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view .backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    //tableview
    myTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, Application_Frame.size.height - 44 * 2)];
    myTabelView.backgroundColor = [UIColor clearColor];
//    myTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTabelView.dataSource = self;
    myTabelView.delegate = self;
    [self.view addSubview:myTabelView];
    
    myTableHeaderView = [[RefreshTableHeaderView alloc] initWithOwner:myTabelView withDelegate:self withLastUpdateTimeMark:@"评论"];
    
    WordOrVoiceComment *inputView = [[WordOrVoiceComment alloc] initWithFrame:CGRectMake(0, Application_Frame.size.height - 44 * 2, 320, 44)];
    inputView.delegate = self;
    [self.view addSubview:inputView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"评论"];

    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navigationPic.png"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:14] forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *leftBar = [[CustomNaviagtionBar getInstance] barButtonItemImage:[UIImage imageNamed:@"backOff.png"] withPressedImage:[UIImage imageNamed:@"backOn.png"] withSize:CGSizeMake(41, 30)];
    [(UIButton *)leftBar.customView addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:leftBar];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelText = @"发送中...";
    [self.view addSubview:hud];
    
    textHud = [[MBProgressHUD alloc] initWithView:self.view];
    [textHud setMode:MBProgressHUDModeText];
    [textHud setLabelText:@"上传失败,请重试"];
    [self.view addSubview:textHud];
    
    [myTableHeaderView startLoading];
}

- (void)dealloc
{
    serverRequest.delegate = nil;
    serverRequest = nil;
}

#pragma mark - methods
- (void)goBack:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleSeverDataDictionary:(NSDictionary *)dic withRequestType:(RequsetType)type isLoadMore:(BOOL)flag;
{
    if (type == get_comment_artWork)
    {
        if (!flag)//上拉刷新清空数组
        {
            [myArray removeAllObjects];
        }
        
        NSArray *dataArray = [dic objectForKey:@"DATA"];
        for (NSDictionary *dataDic in dataArray)
        {
            [myArray addObject:[[CommentModel alloc] initWithDictionary:dataDic withFtpPath:[dic objectForKey:@"FTP"] withObjectType:get_comment_artWork]];
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
    else
    {
        [hud hide:YES];
        [myTableHeaderView startLoading];
        myModel.commentCount = [NSString stringWithFormat:@"%d",[myModel.commentCount intValue] + 1 ];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CommentNumChanged" object:myModel.id];
    }
}

- (void)handleRequestFailedWithRequestType:(RequsetType)type
{
    if (type == get_comment_artWork)
    {
        [myTableHeaderView stopLoading];
        [myTableFooterView stopLoading];
    }
    else
    {
        [hud hide:YES];
        [textHud show:YES];
        [textHud hide:YES afterDelay:2];
    }
}

#pragma mark - WordOrVoiceCommentDelegate
- (void)commitVoiceComment:(NSString *)path withDuration:(int)duration
{
    [hud show:YES];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [paramDic setObject:[NSString stringWithFormat:@"%d",duration] forKey:@"duration"];
    [paramDic setObject:myModel.id forKey:@"objectID"];
    [paramDic setObject:path forKey:@"filePath"];
    [serverRequest requestServerWithType:upload_artwork_voice_comment withParamObject:paramDic];
}

- (void)commitTextComment:(NSString *)comentText
{
    [hud show:YES];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [paramDic setObject:myModel.id forKey:@"objectID"];
    [paramDic setObject:comentText forKey:@"contentText"];
    [serverRequest requestServerWithType:upload_artwork_text_comment withParamObject:paramDic];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myArray count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    CommitCell *cell = (CommitCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommitCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    float height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    [cell setFrame:CGRectMake(0, 0, 320, height)];
    [cell setupCellWithCommit:[myArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel *model = [myArray objectAtIndex:indexPath.row];
    NSString *str = [NSString stringWithFormat:@"%@:%@",model.user_name,model.content];
    UIFont *font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
    CGSize size = [str sizeWithFont:font constrainedToSize:CGSizeMake(260, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    if (size.height  > 40)
    {
        return size.height + 10;
    }
    else
    {
        return 50.0f;
    }
}

#pragma mark - ServerRequestParamDelegate
- (void)requsetSuccessWithType:(RequsetType)type withServerData:(NSDictionary *)severData withMoreMark:(BOOL)flag
{
    [self handleSeverDataDictionary:severData withRequestType:type isLoadMore:flag];
}

- (void)requsetFailedWithType:(RequsetType)type
{
    [self handleRequestFailedWithRequestType:type];
}

#pragma mark - RefreshTableHeaderViewDelegate && LoadMoreFooterView
- (void)headerViewStartLoading
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:myModel.id,@"objectID",[NSNumber numberWithInt:0],@"startNum", nil];
    [serverRequest requestServerWithType:get_comment_artWork withParamObject:dic];
}

- (void)footerViewStartLoading
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:myModel.id,@"objectID",[NSNumber numberWithInt:[myArray count]],@"startNum", nil];
    [serverRequest requestServerWithType:get_comment_artWork withParamObject:dic];
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
