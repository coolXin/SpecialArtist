//
//  RefreshTableHeaderView.m
//  refreshTest
//
//  Created by cuibaoyin on 13-1-28.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import "RefreshTableHeaderView.h"

@implementation RefreshTableHeaderView

- (id)initWithOwner:(UIScrollView *)theOwner withDelegate:(id)theDelegate withLastUpdateTimeMark:(NSString *)mark
{
    if (self = [super init])
    {
        self.frame = CGRectMake(0, - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT);
        lastUpdateTimeMark = mark;
        [self setupUI];
        owner = theOwner;
        _delegate = theDelegate;
        [owner insertSubview:self atIndex:0];
    }
    return self;
}

#pragma mark - methods
- (void)setupUI
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
    
    _refreshLastUpdatedTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, REFRESH_HEADER_HEIGHT - 30.0f, self.frame.size.width, 20.0f)];
    _refreshLastUpdatedTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _refreshLastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12.0f];
    _refreshLastUpdatedTimeLabel.textColor = [UIColor darkGrayColor];
    _refreshLastUpdatedTimeLabel.backgroundColor = [UIColor clearColor];
    _refreshLastUpdatedTimeLabel.textAlignment = NSTextAlignmentCenter;
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:lastUpdateTimeMark];
    if (str != nil)
    {
        _refreshLastUpdatedTimeLabel.text = str;
    }
    else
    {
        _refreshLastUpdatedTimeLabel.text = @"从未更新";
    }
    
    _refreshStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, REFRESH_HEADER_HEIGHT - 48.0f, self.frame.size.width, 20.0f)];
    _refreshStatusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _refreshStatusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    _refreshStatusLabel.textColor = [UIColor darkGrayColor];
    _refreshStatusLabel.backgroundColor = [UIColor clearColor];
    _refreshStatusLabel.textAlignment = NSTextAlignmentCenter;
    
    _refreshArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueArrow.png"]];
    _refreshArrowImageView.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 30) / 2),(floorf(REFRESH_HEADER_HEIGHT - 55) / 2),25, 45);
    
    _refreshIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _refreshIndicator.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    _refreshIndicator.hidesWhenStopped = YES;
    [_refreshIndicator stopAnimating];
    
    [self addSubview:_refreshLastUpdatedTimeLabel];
    [self addSubview:_refreshStatusLabel];
    [self addSubview:_refreshArrowImageView];
    [self addSubview:_refreshIndicator];
}

- (void)startLoading
{
    isLoading = YES;
    [UIView animateWithDuration:0.3 animations:^
     {
         owner.contentOffset = CGPointMake(0, - REFRESH_HEADER_HEIGHT);
         owner.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
     } completion:^(BOOL finished)
     {
         _refreshStatusLabel.text = REFRESH_LOADING_STATUS;
         _refreshArrowImageView.hidden = YES;
         [_refreshIndicator startAnimating];
         
         if ([_delegate respondsToSelector:@selector(headerViewStartLoading)])
         {
             [_delegate headerViewStartLoading];
         }
     }];
}

- (void)stopLoading
{
    isLoading = NO;
    [UIView animateWithDuration:0.3 animations:^
     {
         owner.contentOffset = CGPointZero;
         owner.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
     } completion:^(BOOL finished)
     {
         _refreshArrowImageView.transform = CGAffineTransformMakeRotation(0);
         _refreshStatusLabel.text = REFRESH_PULL_DOWN_STATUS;
         _refreshArrowImageView.hidden = NO;
         [_refreshIndicator stopAnimating];
         
         NSDate *nowDate = [NSDate date];
         NSDateFormatter *outFormat = [[NSDateFormatter alloc] init];
         [outFormat setDateFormat:@"MM'-'dd HH':'mm':'ss"];
         NSString *timeStr = [outFormat stringFromDate:nowDate];
         NSString *lastStr = [NSString stringWithFormat:@"%@%@", REFRESH_UPDATE_TIME_PREFIX, timeStr];
         [[NSUserDefaults standardUserDefaults] setObject:lastStr forKey:lastUpdateTimeMark];
         [[NSUserDefaults standardUserDefaults] synchronize];
         _refreshLastUpdatedTimeLabel.text = lastStr;
     }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (isLoading)
    {
        return;
    }
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isLoading)
    {
        if (scrollView.contentOffset.y > 0)
        {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
        {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
    }
    else if (isDragging && scrollView.contentOffset.y < 0)
    {
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT)
        {
            _refreshStatusLabel.text = REFRESH_RELEASED_STATUS;
            _refreshArrowImageView.transform = CGAffineTransformMakeRotation(3.14);
        }
        else
        { 
            _refreshStatusLabel.text = REFRESH_PULL_DOWN_STATUS;
            _refreshArrowImageView.transform = CGAffineTransformMakeRotation(0);
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (isLoading)
    {
        return;
    }
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT)
    {
        [self startLoading];
    }
}

@end
