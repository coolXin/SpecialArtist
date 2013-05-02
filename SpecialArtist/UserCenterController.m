//
//  UserCenterController.m
//  Artist
//
//  Created by cuibaoyin on 13-3-25.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import "UserCenterController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "CustomNaviagtionBar.h"
#import "PasswordModifyController.h"
#import "UserInfoModyController.h"
#import <QuartzCore/QuartzCore.h>
#import "ListOfModel.h"

@interface UserCenterController ()

@end

@implementation UserCenterController

- (id)init
{
    if (self = [super init])
    {
        serverRequest = [[ServerRequestParam alloc] init];
        serverRequest.delegate = self;
    }
    return self;
}

- (void)loadView
{
    //navigationBar
    [self setTitle:@"个人中心"];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navigationPic.png"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:14] forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *leftBar = [[CustomNaviagtionBar getInstance] barButtonItemImage:[UIImage imageNamed:@"backOff.png"] withPressedImage:[UIImage imageNamed:@"backOn.png"] withSize:CGSizeMake(41, 30)];
    [(UIButton *)leftBar.customView addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:leftBar];
    
    UIImage *offImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loginOutOff" ofType:@"png"]];
    UIImage *onImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"loginOutOn" ofType:@"png"]];
    UIBarButtonItem *rightBar = [[CustomNaviagtionBar getInstance] barButtonItemImage:offImage withPressedImage:onImage withSize:CGSizeMake(41, 30)];
    [(UIButton *)rightBar.customView addTarget:self action:@selector(logOut:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:rightBar];
    
    //self.view
    CGRect frame = CGRectMake(0, 0, 320, Application_HEIGHT - 44);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view setBackgroundColor:[UIColor whiteColor]];
    self.view = view;
    
    //头像ImageView
    avaterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 20, 150, 150)];
    [[avaterImageView layer] setMasksToBounds:YES];
    [[avaterImageView layer] setCornerRadius:5.0f];
    [[avaterImageView layer] setBorderWidth:0.1f];
    [[avaterImageView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    
    NSString *avaterUrlStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserAvaterPath"];
    NSString *avaterPath = [DocumentsDirectory stringByAppendingPathComponent:@"avater.png"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:avaterPath])
    {
        avaterImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:avaterPath]];
    }
    else
    {
        avaterImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"defaultAvater" ofType:@"png"]];
    }
    [avaterImageView setImageWithURL:[NSURL URLWithString:avaterUrlStr] placeholderImage:avaterImage options:SDWebImageLowPriority completed:nil];
    [self.view addSubview:avaterImageView];
    
    //调用系统相册button
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = avaterImageView.frame;
    [btn addTarget:self action:@selector(changeAvater:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    frame = avaterImageView.frame;
    frame.origin.y = frame.size.height + frame.origin.y + 5;
    frame.origin.x = 10;
    frame.size.width = 300;
    frame.size.height = 30;
    UILabel *avaterLabel = [[UILabel alloc] initWithFrame:frame];
    avaterLabel.font = [UIFont boldSystemFontOfSize:15];
    avaterLabel.textColor = [UIColor darkGrayColor];
    avaterLabel.textAlignment = NSTextAlignmentCenter;
    avaterLabel.text = @"设置头像";
    [self.view addSubview:avaterLabel];
    
    //tableview
    frame = avaterLabel.frame;
    frame.origin.x = 10;
    frame.origin.y = frame.size.height + frame.origin.y + 30;
    frame.size.height = 150;
    frame.size.width = 300;
    UITableView *myTableView = [[UITableView alloc] initWithFrame:frame];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.backgroundColor = [UIColor whiteColor];
    myTableView.bounces = NO;
    
    [[myTableView layer] setMasksToBounds:YES];
    [[myTableView layer] setCornerRadius:10.0f];
    [[myTableView layer] setBorderWidth:0.7f];
    [[myTableView layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [self.view addSubview:myTableView];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    textHud = [[MBProgressHUD alloc] initWithView:self.view];
    [textHud setMode:MBProgressHUDModeText];
    [self.view addSubview:textHud];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)dealloc
{
    serverRequest.delegate = nil;
    serverRequest = nil;
}

#pragma mark - methods
- (void)goBack:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)logOut:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UserID"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UserLoginName"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UserNickName"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UserAvaterPath"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UserPhone"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UserSex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginStatusChanged" object:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeAvater:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"设置头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [actionSheet showInView:self.view];
}

- (void)changeUserInfo
{
    UserInfoModyController *controller = [[UserInfoModyController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)changePassword
{
    PasswordModifyController *controller = [[PasswordModifyController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)showMyCommentWorks
{
    ListOfModel *controller = [[ListOfModel alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)pickImageWithType:(UIImagePickerControllerSourceType)type
{
    if (imagePiker == nil)
    {
        imagePiker = [[UIImagePickerController alloc] init];
    }
    imagePiker.delegate = self;
    imagePiker.sourceType = type;
    imagePiker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePiker.allowsEditing = YES;
    [self presentViewController:imagePiker animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCenterCell"];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserCenterCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
        cell.textLabel.textColor = [UIColor blackColor];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(270, 18, 10, 17)];
        imageview.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"usercenterTagOff" ofType:@"png"]];
        [cell addSubview:imageview];
    }

    switch (indexPath.row)
    {
        case 0:
        {
            cell.textLabel.text = @"资料设置";
            break;
        }
        case 1:
        {
            cell.textLabel.text = @"密码修改";
            break;
        }
        case 2:
        {
            cell.textLabel.text = @"我的评论";
            break;
        }
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row)
    {
        case 0:
        {
            [self changeUserInfo];
            break;
        }
        case 1:
        {
            [self changePassword];
            break;
        }
        case 2:
        {
            [self showMyCommentWorks];
            break;
        } 
        default:
            break;
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self pickImageWithType:UIImagePickerControllerSourceTypeCamera];
            break;
        case 1:
            [self pickImageWithType:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        case 2:
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    avaterImage = image;
    avaterImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];

    NSString *avaterPath = [DocumentsDirectory stringByAppendingPathComponent:@"avater.png"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:avaterPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:avaterPath error:nil];
    }

    NSData *data;
    if ((data = UIImagePNGRepresentation(image)) == nil)
    {
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    if ([data writeToFile:avaterPath atomically:NO])
    {
        [hud setLabelText:@"上传中..."];
        [hud show:YES];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:avaterPath,@"filePath",nil];
        [serverRequest requestServerWithType:upload_useravater withParamObject:dic];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ServerRequestParamDelegate
- (void)requsetSuccessWithType:(RequsetType)type withServerData:(NSDictionary *)severData withMoreMark:(BOOL)flag
{
    [hud hide:YES];
    if (type == upload_useravater)
    {
        NSDictionary *dataDic = [severData objectForKey:@"DATA"];
        NSString *ftpPath = [severData objectForKey:@"FTP"];
        NSString *avaterUrl = [ftpPath stringByAppendingString:[dataDic objectForKey:@"icoPath"]];
        [[NSUserDefaults standardUserDefaults] setObject:avaterUrl forKey:@"UserAvaterPath"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)requsetFailedWithType:(RequsetType)type
{
    [hud hide:YES];
    [textHud setLabelText:@"上传失败"];
    [textHud show:YES];
    [textHud hide:YES afterDelay:2];
}

@end
