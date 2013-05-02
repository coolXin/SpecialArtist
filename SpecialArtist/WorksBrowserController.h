//
//  WorksBrowserController.h
//  Artist
//
//  Created by cuibaoyin on 13-3-5.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagesBrowser.h"

@interface WorksBrowserController : UIViewController<ImageBrowserDelegate,UIAlertViewDelegate,ServerRequestParamDelegate>
{
    ImagesBrowser *imageBrowser;
    
    ServerRequestParam *serverRequest;
    MBProgressHUD *hud;
    MBProgressHUD *failedHud;
}

@property (strong, nonatomic) IBOutlet UIView *headview;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *footerImageView;
@property (strong, nonatomic) IBOutlet UIButton *fancyBtn;
@property (strong, nonatomic) IBOutlet UIButton *commentBtn;

@property (strong , nonatomic) NSMutableArray *myArray;

@property (readwrite , nonatomic) int currentPage;

- (id)initWithArray:(NSMutableArray *)array withCurrentPage:(int)currentPage;
- (IBAction)goBack:(id)sender;
- (IBAction)shareToInternet:(id)sender;
- (IBAction)fancyWork:(id)sender;
- (IBAction)commentWork:(id)sender;
- (IBAction)showArtWorkIntroduce:(id)sender;

@end
