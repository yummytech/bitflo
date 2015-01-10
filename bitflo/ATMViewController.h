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
}

@property (nonatomic, strong) dispatch_source_t timerSource;
@property (getter = isObservingMessages) BOOL observingMessages;

@property (nonatomic, strong) IBOutlet UITextView *logView;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

- (void)resetReader;
- (void)setSleep;
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)audioPlayer successfully:(BOOL)flag;

@end
