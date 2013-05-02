//
//  ImagesBrowser.h
//  Artist
//
//  Created by cuibaoyin on 13-3-5.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ImageBrowserDelegate;

@interface ImagesBrowser : UIView<UIScrollViewDelegate>
{
    BOOL pageChanged;
    int priviousPage;
    int currentPage;
    UIScrollView *myScrollView;
    NSMutableArray *myItemArray;
}

@property (assign, nonatomic) id<ImageBrowserDelegate> delegate;
- (id)initWithFrame:(CGRect)frame withItemArray:(NSMutableArray *)array withCurrentPage:(int)page;
- (UIImageView *)getImageViewByTag:(int)tag;

@end

@protocol ImageBrowserDelegate <NSObject>

- (void)pageChanged:(int)currentPage;
- (void)pageTapped;

@end
