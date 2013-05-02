//
//  CustomNaviagtionBar.h
//  Artist
//
//  Created by cuibaoyin on 13-3-8.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BUTTON_WIDTH 54.0
#define BUTTON_SEGMENT_WIDTH 51.0
#define CAP_WIDTH 5.0

typedef enum
{
    CapLeft  = 0,
    CapMiddle,
    CapRight,
    CapLeftAndRight,
} CapLocation;

@interface CustomNaviagtionBar : NSObject

+ (id)getInstance;

- (UIBarButtonItem*)barButtonItemWithText:(NSString*)buttonText;
- (UIButton*)buttonWithText:(NSString*)buttonText stretch:(CapLocation)location;
- (UIBarButtonItem*)barButtonItemImage:(UIImage*)image withPressedImage:(UIImage *)pressedImage withSize:(CGSize)size;

@end
