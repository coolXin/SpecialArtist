//
//  shareToController.h
//  Artist
//
//  Created by cuibaoyin on 13-4-1.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenAPIOperation.h"

@interface ShareToController : UIViewController<OpenAPIOperationDelegate,ServerRequestParamDelegate,UITextViewDelegate>
{
    OpenAPIOperation *operation;
    RequsetType selectedType;
    ServerRequestParam *serverRequest;
    MBProgressHUD *progressHud;
    MBProgressHUD *textHud;
    
    id objectModel;
    NSString *modelID;
    UIImage *sharedImage;
    UITextView *messageTextView;
}
                                            
- (id)initWithObject:(id)model withSharedImage:(UIImage *)image;

@end
