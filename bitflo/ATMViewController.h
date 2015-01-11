//
//  ATMViewController.h
//  bitflo
//
//  Created by Boris  on 1/10/15.
//  Copyright (c) 2015 LLT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Parse/Parse.h>
#import "AudioJack.h"

#import <UIKit/UIKit.h>

#define FLOBLE_UUID @"6e400001-b5a3-f393-e0a9-e50e24dcca9e"

@interface ATMViewController : UIViewController <ACRAudioJackReaderDelegate, AVAudioPlayerDelegate>{
    
    CGPoint startPosition;
    
    //Application Delegate
    //AppDelegate *appDelegate;
    NSString  *filePath;
    NSString *previousResponse;
    
    int currentInput;
    
    UIVisualEffectView *blurEffectView;
    
    NSString *passcode;
    NSString *storedPasscode;
}

@property (nonatomic, strong) dispatch_source_t timerSource;
@property (getter = isObservingMessages) BOOL observingMessages;

@property (nonatomic, strong) IBOutlet UITextView *logView;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) IBOutlet UITextField *amountTextField;

@property (nonatomic, strong) IBOutlet UIButton *oneButton;
@property (nonatomic, strong) IBOutlet UIButton *twoButton;
@property (nonatomic, strong) IBOutlet UIButton *threeButton;
@property (nonatomic, strong) IBOutlet UIButton *fourButton;
@property (nonatomic, strong) IBOutlet UIButton *fiveButton;
@property (nonatomic, strong) IBOutlet UIButton *sixButton;
@property (nonatomic, strong) IBOutlet UIButton *sevenButton;
@property (nonatomic, strong) IBOutlet UIButton *eightButton;
@property (nonatomic, strong) IBOutlet UIButton *nineButton;
@property (nonatomic, strong) IBOutlet UIButton *zeroButton;

@property (nonatomic, strong) IBOutlet UIImageView *firstNumber;
@property (nonatomic, strong) IBOutlet UIImageView *secondNumber;
@property (nonatomic, strong) IBOutlet UIImageView *thirdNumber;
@property (nonatomic, strong) IBOutlet UIImageView *fourthNumber;

- (void)resetReader;
- (void)setSleep;
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)audioPlayer successfully:(BOOL)flag;

@end
