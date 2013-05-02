//
//  ListOfModel.m
//  Artist
//
//  Created by cuibaoyin on 13-4-2.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import "ListOfModel.h"
#import "ArtWorksModel.h"
#import "CustomNaviagtionBar.h"
#import "WorksBrowserController.h"
#import "ListOfModelCell.h"

@interface ListOfModel ()

@end

@implementation ListOfModel

- (id)init
{
    if (self = [super init])
    {
        serverRequest = [[ServerRequestParam alloc] init];
        serverRequest.delegate = self;
        myArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)loadView
{
    [self setTitle:@"评论的作品"];
    
    UIBarButtonItem *leftBar = [[CustomNaviagtionBar getInstance] barButtonItemImage:[UIImage imageNamed:@"backOff.png"] withPressedImage:[UIImage imageNamed:@"backOn.png"] withSize:CGSizeMake(41, 30)];
    [(UIButton *)leftBar.customView addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:leftBar];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, Application_HEIGHT - 44)];
    view .backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    //tableview
    CGRect frame = self.view.frame;
    myTabelView = [[UITableView alloc] initWithFrame:frame];
    myTabelView.backgroundColor = [UIColor clearColor];
    myTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTabelView.dataSource = self;
    myTabelView.delegate = self;
    [self.view addSubview:myTabelView];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [hud setLabelText:@"加载中..."];
    [self.view addSubview:hud];
    
    textHud = [[MBProgressHUD alloc] initWithView:self.view];
    [textHud setMode:MBProgressHUDModeText];
    [self.view addSubview:textHud];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [hud show:YES];
    [serverRequest requestServerWithType:works_user_comment withParamObject:nil];
}

- (void)dealloc
{
    serverRequest.delegate = nil;
    serverRequest = nil;
}

- (void)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ServerRequestParamDelegate
- (void)requsetSuccessWithType:(RequsetType)type withServerData:(NSDictionary *)severData withMoreMark:(BOOL)flag
{
    [hud hide:YES];
    [myTableFooterView stopLoading];

    NSArray *dataArray = [severData objectForKey:@"DATA"];
    for (NSDictionary *dataDic in dataArray)
    {
        [myArray addObject:[[ArtWorksModel alloc] initWithDictionary:dataDic  withFtp:[severData objectForKey:@"FTP"]]];
    }
    [myTabelView reloadData];
    
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
    [hud hide:YES];
    [myTableFooterView stopLoading];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myArray count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    ListOfModelCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ListOfModelCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    [cell steupUIWith:[myArray objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorksBrowserController *controller = [[WorksBrowserController alloc] initWithArray:myArray withCurrentPage:indexPath.row];
    [self.navigationController presentViewController:controller animated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
