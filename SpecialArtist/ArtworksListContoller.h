//
//  ArtworksListContoller.h
//  SpecialArtist
//
//  Created by Cby on 13-4-18.
//  Copyright (c) 2013年 Cby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadMoreFooterView.h"
#import "RefreshTableHeaderView.h"

@interface ArtworksListContoller : UIViewController<UITableViewDelegate,UITableViewDataSource,RefreshTableHeaderViewDelegate,LoadMoreFooterViewDelegate,ServerRequestParamDelegate>
{
    UITableView *myTabelView;
    NSMutableArray *myArray;
    
    RefreshTableHeaderView *myTableHeaderView;
    LoadMoreFooterView *myTableFooterView;
    ServerRequestParam *serverRequest;
    UIView *menuView;
    UIButton *loginBtn;
    UILabel *loginLabel;
    UILabel *artistLabel;
}

@property(strong, nonatomic) UITableView *myTable;
@property(strong, nonatomic) NSMutableArray *dataArray;

@end
