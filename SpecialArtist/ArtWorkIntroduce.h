//
//  ArtWorkIntroduce.h
//  Artist
//
//  Created by cuibaoyin on 13-3-27.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArtWorksModel.h"

@interface ArtWorkIntroduce : UIViewController<ServerRequestParamDelegate>
{
    ArtWorksModel *myModel;
    UIScrollView *myScrollView;
    UIImageView *audioStatusImageView;
    
    ServerRequestParam *serverRequest;
    MBProgressHUD *hud;
    MBProgressHUD *faildHud;
}

- (id)initWithModel:(ArtWorksModel *)model;

@end
