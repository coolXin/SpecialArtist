//
//  ImagesBrowser.m
//  Artist
//
//  Created by cuibaoyin on 13-3-5.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import "ImagesBrowser.h"
#import "ArtWorksModel.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "MBProgressHUD.h"

@implementation ImagesBrowser

- (id)initWithFrame:(CGRect)frame withItemArray:(NSMutableArray *)array withCurrentPage:(int)page
{
    self = [super initWithFrame:frame];
    if (self)
    {
        myItemArray = [[NSMutableArray alloc] initWithArray:array];
        currentPage = page;
        priviousPage = page;
        self.backgroundColor = [UIColor clearColor];
        
        [self steupScrollView];
        [self steupImageView];
        [self downloadImageViewPage:page - 1];
        [self downloadImageViewPage:page];
        [self downloadImageViewPage:page + 1];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [myItemArray release];
}

#pragma mark methods
- (void)steupScrollView
{
    CGRect frame = self.frame;
    frame.origin = CGPointMake(0, 0);
    myScrollView = [[UIScrollView alloc] initWithFrame:frame];
    CGSize size = frame.size;
    size.width = size.width * [myItemArray count];
    myScrollView.contentSize = size;
    myScrollView.contentOffset = CGPointMake(currentPage * frame.size.width, 0);
    [myScrollView setDelegate:self];
    [myScrollView setBackgroundColor:[UIColor blackColor]];
    [myScrollView setPagingEnabled:YES];
    [myScrollView setShowsVerticalScrollIndicator:NO];
    [myScrollView setShowsHorizontalScrollIndicator:NO];
    [self addSubview:myScrollView];
    [myScrollView release];
}

- (void)steupImageView
{
    for (int i = 0; i < [myItemArray count]; i++)
    {
        CGRect frame = self.frame;
        frame.origin.x = i * frame.size.width;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.contentSize = CGSizeMake(320, 460);
        scrollView.delegate = self;
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        scrollView.minimumZoomScale = 1.0;
        scrollView.maximumZoomScale = 3.0;
        [scrollView setZoomScale:1.0];
        [scrollView setTag:i];
        [myScrollView addSubview:scrollView];
        [scrollView release];
    }
}

- (void)downloadImageViewPage:(int)page
{
    if (page < 0 || page >= [myItemArray count])
    {
        return;
    }
    
    UIScrollView *scrollView;
    for (UIView *view in myScrollView.subviews)
    {
        if ([view isKindOfClass:[UIScrollView class]] && view.tag == page)
        {
            scrollView = (UIScrollView *)view;
        }
    }

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
    imageView.tag = page;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [imageView addGestureRecognizer:gesture];
    [imageView setUserInteractionEnabled:YES];
    [scrollView addSubview:imageView];
    [imageView release];
    
    ArtWorksModel *model = [myItemArray objectAtIndex:page];
    NSURL *url = [NSURL URLWithString:model.image_original];
    __block MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    hud.mode = MBProgressHUDModeDeterminate;
    hud.labelText = @"加载中...";
    [imageView addSubview:hud];
    [hud show:YES];
    [hud release];
    
    [imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"image1.png"] options:SDWebImageLowPriority progress:^(NSUInteger receivedSize, long long expectedSize)
     {
         if (hud != nil)
         {
             float progress = (float)receivedSize/expectedSize;
             [hud setProgress:progress];
         }
     }
    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
     {
         if (hud != nil)
         {
             [hud hide:YES];
             [hud removeFromSuperview];
         }
     }];
}

- (void)removeOutsideImageView
{
    for (int i = 0; i < [myItemArray count] ; i ++ )
    {
        if (i < currentPage - 1 || i > currentPage + 1 )
        {
            UIImageView *imageView = [self getImageViewByTag:i];
            for (UIView *view in imageView.subviews)
            {
                [view removeFromSuperview];
            }
            [imageView removeFromSuperview];
        }
    }
}

- (UIImageView *)getImageViewByTag:(int)tag
{
    UIScrollView *scrollView;
    for (UIView *view in myScrollView.subviews)
    {
        if ([view isKindOfClass:[UIScrollView class]] && view.tag == tag)
        {
            scrollView = (UIScrollView *)view;
        }
    }
    
    for (UIView *view in scrollView.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]] && view.tag == tag)
        {
            return (UIImageView *)view;
        }
    }
    return nil;
}

- (void)imageTapped:(UITapGestureRecognizer *)recognizer
{
    [_delegate pageTapped];
}

#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    for (UIView *view in scrollView.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]])
        {
            return view;
        }
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = myScrollView.frame.size.width;
    int page = floor((myScrollView.contentOffset.x - pageWidth * 0.5) / pageWidth) + 1;
    if (page != currentPage)
    {
        pageChanged = YES;
        [_delegate pageChanged:page];
        priviousPage = currentPage;
    }
    currentPage = page;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == myScrollView && pageChanged)
    {
        //去除不用的imageview，并加载应该显示的图片
        [self removeOutsideImageView];
        if (currentPage > priviousPage)
        {
            [self downloadImageViewPage:currentPage + 1];
        }
        else if(currentPage < priviousPage)
        {
            [self downloadImageViewPage:currentPage - 1];
        }
        
        pageChanged = NO;
        for (UIScrollView *s in scrollView.subviews)
        {
            if ([s isKindOfClass:[UIScrollView class]])
            {
                [s setZoomScale:1.0];
            }
        }
    }
}

@end
