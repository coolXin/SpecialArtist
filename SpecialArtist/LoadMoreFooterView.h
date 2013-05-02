//
//  RefreshTableHeaderView.h
//  refreshTest
//
//  Created by cuibaoyin on 13-1-28.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#define REFRESH_LOADING_STATUS @"加载中..."
#define REFRESH_NORMAL_STATUS @"点击加载更多"
#define REFRESH_FOOTER_HEIGHT 50

@protocol LoadMoreFooterViewDelegate <NSObject>

- (void)footerViewStartLoading;

@end

#import <UIKit/UIKit.h>
@interface LoadMoreFooterView : UIView
{
    BOOL isLoading;
    BOOL isDragging;
    UIScrollView *owner;
}

@property (nonatomic, retain)  UIActivityIndicatorView *refreshIndicator;
@property (nonatomic, retain)  UIButton *getMoreBtn;
@property (nonatomic, retain)  UILabel *refreshStatusLabel;
@property (nonatomic, assign) id<LoadMoreFooterViewDelegate>delegate;

// 初始化
- (id)initWithOwner:(UITableView *)theOwner withDelegate:(id)theDelegate;

// 开始加载和结束加载动画
- (void)startLoading;
- (void)stopLoading;

@end
