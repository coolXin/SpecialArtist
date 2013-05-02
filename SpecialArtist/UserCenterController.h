//
//  UserCenterController.h
//  Artist
//
//  Created by cuibaoyin on 13-3-25.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCenterController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,ServerRequestParamDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIImagePickerController *imagePiker;
    UIImage *avaterImage;
    UIImageView *avaterImageView;
    ServerRequestParam *serverRequest;
    MBProgressHUD *hud;
    MBProgressHUD *textHud;
}

@end
