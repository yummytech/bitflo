//
//  AppDelegate.h
//  bitflo
//
//  Created by Boris  on 1/10/15.
//  Copyright (c) 2015 LLT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioJack.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {

}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSString *currentAmount;
@property (nonatomic, strong) NSString *currentNumberOfItems;
@property (nonatomic, strong) NSMutableArray *salesArray;

@property (nonatomic, strong) NSNumber *isNewPayment;
@property (nonatomic, strong) NSMutableDictionary *cardData;
@property (nonatomic, strong) dispatch_source_t timerSource;
@property (getter = isObservingMessages) BOOL observingMessages;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)audioPlayer successfully:(BOOL)flag;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)resetReader:(id)viewController;
- (void)setSleep;
- (void)initACR35;
- (void)stopScan;

@end

