//
//  ContactlessViewController.h
//  bitflo
//
//  Created by Boris  on 1/10/15.
//  Copyright (c) 2015 LLT. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Parse/Parse.h>
#import "AudioJack.h"


@interface ContactlessViewController : UIViewController <ACRAudioJackReaderDelegate, AVAudioPlayerDelegate>{
    
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
- (BOOL)getNfcData;
- (BOOL)putNfcData:(NSData *) data;
- (void)readCommand;
@end
