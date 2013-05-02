//
//  RefreshTableHeaderView.m
//  refreshTest
//
//  Created by cuibaoyin on 13-1-28.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import "LoadMoreFooterView.h"

@implementation LoadMoreFooterView

- (id)initWithOwner:(UITableView *)theOwner withDelegate:(id)theDelegate
{
    if (self = [super init])
    {
        self.frame = CGRectMake(0, 0, 320, REFRESH_FOOTER_HEIGHT);
        [self setupUI];
        owner = theOwner;
        _delegate = theDelegate;
        theOwner.tableFooterView = self;
    }
    return self;
}

#pragma mark - methods
- (void)setupUI
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
    
    _refreshStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0, self.frame.size.width, self.frame.size.height)];
    _refreshStatusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _refreshStatusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    _refreshStatusLabel.textColor = [UIColor darkGrayColor];
    _refreshStatusLabel.backgroundColor = [UIColor clearColor];
    _refreshStatusLabel.textAlignment = NSTextAlignmentCenter;
    _refreshStatusLabel.text = REFRESH_NORMAL_STATUS;
    
    _getMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_getMoreBtn setFrame:self.frame];
    [_getMoreBtn addTarget:self action:@selector(startLoading) forControlEvents:UIControlEventTouchUpInside];
    
    _refreshIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _refreshIndicator.frame = CGRectMake(self.frame.size.width / 3, self.frame.size.height / 2 - 10, 20, 20);
    _refreshIndicator.hidesWhenStopped = YES;
    [_refreshIndicator stopAnimating];
    
    [self addSubview:_refreshStatusLabel];
    [self addSubview:_getMoreBtn];
    [self addSubview:_refreshIndicator];
}

- (void)startLoading
{
    [_refreshIndicator startAnimating];
    [_getMoreBtn setEnabled:NO];
    [_refreshStatusLabel setText:REFRESH_LOADING_STATUS];

     if ([_delegate respondsToSelector:@selector(headerViewStartLoading)])
     {
         [_delegate footerViewStartLoading];
     }
}

- (void)stopLoading
{
    [_refreshIndicator stopAnimating];
    [_getMoreBtn setEnabled:YES];
    [_refreshStatusLabel setText:REFRESH_NORMAL_STATUS];
}

@end
