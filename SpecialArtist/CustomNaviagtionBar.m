//
//  CustomNaviagtionBar.m
//  Artist
//
//  Created by cuibaoyin on 13-3-8.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import "CustomNaviagtionBar.h"

static CustomNaviagtionBar *sharedInstance;

@implementation CustomNaviagtionBar

+ (id)getInstance
{
    if (sharedInstance == nil)
    {
        sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

- (UIBarButtonItem*)barButtonItemWithText:(NSString*)buttonText
{
    return [[UIBarButtonItem alloc] initWithCustomView:[self buttonWithText:buttonText stretch:CapLeftAndRight]];
}

- (UIBarButtonItem*)barButtonItemImage:(UIImage*)image withPressedImage:(UIImage *)pressedImage withSize:(CGSize)size
{
    return [[UIBarButtonItem alloc] initWithCustomView:[self buttonWithImage:image withPressedImage:pressedImage withSize:size stretch:CapLeftAndRight]];
}

-(UIButton*)buttonWithImage:(UIImage*)image withPressedImage:(UIImage *)pressedImage withSize:(CGSize)size stretch:(CapLocation)location
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, 0, size.width, size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:pressedImage forState:UIControlStateHighlighted];
    button.tag = location;
    button.adjustsImageWhenHighlighted = NO;
    
    return button;
}

-(UIButton*)buttonWithText:(NSString*)buttonText stretch:(CapLocation)location
{
    UIImage* buttonImage = nil;
    UIImage* buttonPressedImage = nil;
    NSUInteger buttonWidth = 0;
    if (location == CapLeftAndRight)
    {
        buttonWidth = BUTTON_WIDTH;
        buttonImage = [[UIImage imageNamed:@"nav-button.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0];
        buttonPressedImage = [[UIImage imageNamed:@"nav-button-press.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0];
    }
    else
    {
//        buttonWidth = BUTTON_SEGMENT_WIDTH;
//        
//        buttonImage = [self image:[[UIImage imageNamed:@"nav-button.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0] withCap:location capWidth:CAP_WIDTH buttonWidth:buttonWidth];
//        buttonPressedImage = [self image:[[UIImage imageNamed:@"nav-button-press.png"] stretchableImageWithLeftCapWidth:CAP_WIDTH topCapHeight:0.0] withCap:location capWidth:CAP_WIDTH buttonWidth:buttonWidth];
    }
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, buttonWidth, buttonImage.size.height);
    button.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.shadowOffset = CGSizeMake(0,-1);
    button.titleLabel.shadowColor = [UIColor darkGrayColor];
    button.tag = location;
    
    [button setTitle:buttonText forState:UIControlStateNormal];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:buttonPressedImage forState:UIControlStateSelected];
    button.adjustsImageWhenHighlighted = NO;
    
    return button;
}

@end
