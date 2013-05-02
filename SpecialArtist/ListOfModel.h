//
//  ListOfModel.h
//  Artist
//
//  Created by cuibaoyin on 13-4-2.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadMoreFooterView.h"

@interface ListOfModel : UIViewController<UITableViewDataSource,UITableViewDelegate,ServerRequestParamDelegate>
{
    MBProgressHUD *hud;
    MBProgressHUD *textHud;
    ServerRequestParam *serverRequest;
    
    UITableView *myTabelView;
    NSMutableArray *myArray;
    LoadMoreFooterView *myTableFooterView;
}
@end
