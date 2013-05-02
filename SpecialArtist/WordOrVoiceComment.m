//
//  WordOrVoiceComment.m
//  Artist
//
//  Created by cuibaoyin on 13-3-22.
//  Copyright (c) 2013年 wooboo. All rights reserved.
//

#define INPUTVIEWWIDTH 249.0f
#define INPUTVIEMIXWHEIGHT 30
#define INPUTVIEWMAXHEIGHT 200.0f

#import "WordOrVoiceComment.h"
#import "AmrRecordAndPlay.h"

@implementation WordOrVoiceComment

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        frame.origin.x = 0;
        frame.origin.y = 0;
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"commentBottomBackgroud" ofType:@"png"]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [image stretchableImageWithLeftCapWidth:1.5 topCapHeight:22];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:imageView];
        
        //更换评论方式的button
        frame.origin.x = 10;
        frame.origin.y = 7;
        frame.size.width = 33;
        frame.size.height = 30;
        changeStyleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        changeStyleBtn.frame = frame;
        changeStyleBtn.tag = 0;
        changeStyleBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [changeStyleBtn setImage:[UIImage imageNamed:@"text_comment.png"] forState:UIControlStateNormal];
        [changeStyleBtn addTarget:self action:@selector(changeStyleBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:changeStyleBtn];
        
        //录音button
        recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        recordBtn.frame = CGRectMake(53, 7, 249, 30);
        [recordBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pressToRecord" ofType:@"png"]] forState:UIControlStateNormal];
        [recordBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"releaseToCommit" ofType:@"png"]] forState:UIControlStateHighlighted];
        [recordBtn addTarget:self action:@selector(startRecord:) forControlEvents:UIControlEventTouchDown];
        [recordBtn addTarget:self action:@selector(stopRecord:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:recordBtn];
        
        //文字输入view
        inputTextView = [[HPGrowingTextView alloc] initWithFrame:recordBtn.frame];
        inputTextView.hidden = YES;
        inputTextView.backgroundColor = [UIColor clearColor];
        inputTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        inputTextView.minNumberOfLines = 1;
        inputTextView.maxNumberOfLines = 4;
        inputTextView.returnKeyType = UIReturnKeySend; //just as an example
        inputTextView.font = [UIFont systemFontOfSize:15.0f];
        inputTextView.delegate = self;
        inputTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        inputTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;

        
        frame = inputTextView.frame;
        inputBackground = [[UIImageView alloc] initWithFrame:frame];
        inputBackground.hidden = YES;
        image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"inputBackground" ofType:@"png"]];
        inputBackground.image = [image stretchableImageWithLeftCapWidth:15 topCapHeight:15];
        inputBackground.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:inputBackground];
        [self addSubview:inputTextView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeChanged:)
                                                     name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - methods
- (void)changeStyleBtnPressed:(id)sender
{
    if (changeStyleBtn.tag == 0)
    {
        [changeStyleBtn setImage:[UIImage imageNamed:@"voice_comment.png"] forState:UIControlStateNormal];
        recordBtn.hidden = YES;
        inputBackground.hidden = NO;
        inputTextView.hidden = NO;
        [inputTextView becomeFirstResponder];
        changeStyleBtn.tag = 1;
    }
    else
    {
        [changeStyleBtn setImage:[UIImage imageNamed:@"text_comment.png"] forState:UIControlStateNormal];
        recordBtn.hidden = NO;
        inputBackground.hidden = YES;
        inputTextView.hidden = YES;
        [inputTextView resignFirstResponder];
        changeStyleBtn.tag = 0;
    }
}

- (void)startRecord:(id)sender
{
    [AmrRecordAndPlay getInstance].delegate = self;
    [[AmrRecordAndPlay getInstance] startRecordAudio];
}

- (void)stopRecord:(id)sender
{
    [[AmrRecordAndPlay getInstance] stopRecordAudio];
}

#pragma mark - AmrRecordAndPlayDelegate
- (void)audioRecord:(AVAudioRecorder *)recorder finishedWithAmrFilePath:(NSString *)path withRecordDuration:(int)duration
{
    if ([_delegate respondsToSelector:@selector(commitVoiceComment:withDuration:)])
    {
        [_delegate commitVoiceComment:path withDuration:duration];
    }
}

- (void)audioRecord:(AVAudioRecorder *)recorder failedRecorderWithError:(NSString *)error
{
    
}

#pragma mark - UITextViewDelegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect frame = self.frame;
    frame.size.height -= diff;
    frame.origin.y += diff;
	self.frame = frame;
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        if ([_delegate respondsToSelector:@selector(commitTextComment:)])
        {
            [_delegate commitTextComment:growingTextView.text];
        }
        [growingTextView resignFirstResponder];
        growingTextView.text = nil;
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark - keyboardNotifacation
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    __block CGRect frame = self.frame;
    CGRect appFrame = [UIScreen mainScreen].applicationFrame;

    [UIView animateWithDuration:animationDuration animations:^
     {
         float pointY = appFrame.size.height  - frame.size.height - 44;
         frame.origin.y = pointY;
         self.frame = frame;
     }];
}

- (void)keyboardWillBeChanged:(NSNotification*)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    __block CGRect frame = self.frame;
    CGRect appFrame = [UIScreen mainScreen].applicationFrame;
    [UIView animateWithDuration:animationDuration animations:^
     {
         float pointY = appFrame.size.height - keyboardRect.size.height - frame.size.height - 44;
         frame.origin.y = pointY;
         self.frame = frame;
     }];
}

@end
