//
//  ArtistDetailsController.h
//  Artist
//
//  Created by cuibaoyin on 13-3-8.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtistModel.h"

@interface ArtistDetailsController : UIViewController<ServerRequestParamDelegate,UITableViewDataSource,UITableViewDelegate>
{
    ArtistModel *myModel;
    NSMutableArray *artShowArray;
    NSMutableArray *videoArray;
    NSMutableArray *videoImageArray;
    ServerRequestParam *serverRequest;

    UIScrollView *myScrollView;
    UITableView *showTableView;
    UIScrollView *videoSrollview;
    MBProgressHUD *hud;
    MBProgressHUD *faildHud;
    
    UIButton *artShowBtn;
    UIButton *videoButton;
    int selectedType;
}

@end
