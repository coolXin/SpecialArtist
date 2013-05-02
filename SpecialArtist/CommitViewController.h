//
//  CommitViewController.h
//  Artist
//
//  Created by cuibaoyin on 13-3-21.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordOrVoiceComment.h"
#import "LoadMoreFooterView.h"
#import "RefreshTableHeaderView.h"
#import "ArtWorksModel.h"

@interface CommitViewController : UIViewController<WordOrVoiceCommentDelegate,UITableViewDelegate,UITableViewDataSource,RefreshTableHeaderViewDelegate,LoadMoreFooterViewDelegate,ServerRequestParamDelegate>
{
    MBProgressHUD *hud;
    MBProgressHUD *textHud;
    
    UITableView *myTabelView;
    NSMutableArray *myArray;
    
    RefreshTableHeaderView *myTableHeaderView;
    LoadMoreFooterView *myTableFooterView;
    ServerRequestParam *serverRequest;
    
    ArtWorksModel *myModel;
}

- (id)initWithModel:(ArtWorksModel *)model;

@property(strong, nonatomic) NSMutableArray *dataArray;
@property(strong, nonatomic) UITableView *myTable;

@end
