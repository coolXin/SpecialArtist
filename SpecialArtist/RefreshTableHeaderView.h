//
//  RefreshTableHeaderView.h
//  refreshTest
//
//  Created by cuibaoyin on 13-1-28.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#define REFRESH_LOADING_STATUS @"加载中..."
#define REFRESH_PULL_DOWN_STATUS @"下拉可以刷新..."
#define REFRESH_RELEASED_STATUS @"松开即可刷新..."
#define REFRESH_UPDATE_TIME_PREFIX @"最后更新: "
#define REFRESH_HEADER_HEIGHT 60

@protocol RefreshTableHeaderViewDelegate <NSObject>

- (void)headerViewStartLoading;

@end

#import <UIKit/UIKit.h>
@interface RefreshTableHeaderView : UIView
{
    BOOL isLoading;
    BOOL isDragging;
    UIScrollView *owner;
    NSString *lastUpdateTimeMark;
}

@property (nonatomic, retain)  UIActivityIndicatorView *refreshIndicator;
@property (nonatomic, retain)  UILabel *refreshStatusLabel;
@property (nonatomic, retain)  UILabel *refreshLastUpdatedTimeLabel;
@property (nonatomic, retain)  UIImageView *refreshArrowImageView;
@property (nonatomic, assign) id<RefreshTableHeaderViewDelegate>delegate;

// 初始化
- (id)initWithOwner:(UIScrollView *)theOwner withDelegate:(id)theDelegate withLastUpdateTimeMark:(NSString *)mark;

// 开始加载和结束加载动画
- (void)startLoading;
- (void)stopLoading;

// UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end
