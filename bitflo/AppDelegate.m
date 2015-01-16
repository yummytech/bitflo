//
//  AppDelegate.h
//  bitflo
//
//  Created by Boris  on 1/10/15.
//  Copyright (c) 2015 LLT. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "AJDHex.h"  // TODO: this file shouldn't be needed as functions are duplicated here.
#import <CommonCrypto/CommonCrypto.h>

@interface AppDelegate ()

@end

@implementation AppDelegate {
    
    ACRAudioJackReader *_reader;
    ACRDukptReceiver *_dukptReceiver;
    int _swipeCount;
    
    NSCondition *_responseCondition;
    
    NSCondition * _picWaitResponseCondition;
    NSCondition * _picWaitAuthenticateResponseCondition;
    NSCondition * _picWaitReadResponseCondition;
    NSCondition * _picWaitWriteResponseCondition;
    
    BOOL _firmwareVersionReady;
    NSString *_firmwareVersion;
    
    BOOL _statusReady;
    ACRStatus *_status;
    
    BOOL _resultReady;
    ACRResult *_result;
    
    BOOL _customIdReady;
    NSData *_customId;
    
    BOOL _deviceIdReady;
    NSData *_deviceId;
    
    BOOL _dukptOptionReady;
    BOOL _dukptOption;
    
    BOOL _trackDataOptionReady;
    ACRTrackDataOption _trackDataOption;
    
    BOOL _piccAtrReady;
    NSData *_piccAtr;
    
    BOOL _piccResponseApduReady;
    NSData *_piccResponseApdu;
    
    NSUserDefaults *_defaults;
    NSData *_masterKey;
    NSData *_masterKey2;
    NSData *_aesKey;
    NSData *_iksn;
    NSData *_ipek;
    
    NSString *_piccTimeoutString;
    NSString *_piccCardTypeString;
    NSString *_piccCommandApduString;
    NSString *_piccRfConfigString;
    
    NSUInteger _piccTimeout;
    NSUInteger _piccCardType;
    NSData *_piccCommandApdu;
    NSData *_piccRfConfig;
    
    UIAlertView *_trackDataAlert;
    
    NSOperationQueue * picQueue;
    NSBlockOperation * picRead;
    NSBlockOperation * picResponse;
    NSBlockOperation * picAuthenticate;
    NSBlockOperation * picWrite;
    
    NSMutableData * tagData;
    BOOL tagDataFlag;
    
}

@synthesize currentAmount, currentNumberOfItems, salesArray, isNewPayment;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self initACR35];
    
    //[Stripe setDefaultPublishableKey:@"pk_test_5A6sQZLDRHpkjtqs90yCjWoG"];
    
    [Parse setApplicationId:@"yAlCwfOGqCttOdLeme3rP1ah98B3pF34G6XOgDnL"
                  clientKey:@"7wOyTy9ZDWbTfsA32GSNKUcn5cnwqim1S1zX1Wsm"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    salesArray = [[NSMutableArray alloc] init];
    
    isNewPayment = [NSNumber numberWithBool:YES];
    
    currentNumberOfItems = 0;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "bp.bitflo" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"bitflo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"bitflo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - ACR35 driver support

- (void)initACR35 {    
    // Register an observer for the Audio Session Route change notification.
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(handleRouteChange:)
                                                 name: AVAudioSessionRouteChangeNotification
                                               object: [AVAudioSession sharedInstance]];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    // Initialize ACRAudioJackReader object.
    _reader = [[ACRAudioJackReader alloc] init];
    [_reader setDelegate:self];
    
    _swipeCount = 0;
    
    _responseCondition = [[NSCondition alloc] init];
    
    _picWaitResponseCondition = [[NSCondition alloc] init];
    _picWaitAuthenticateResponseCondition = [[NSCondition alloc] init];
    _picWaitReadResponseCondition = [[NSCondition alloc] init];
    _picWaitWriteResponseCondition = [[NSCondition alloc] init];
    
    _firmwareVersionReady = NO;
    _firmwareVersion = nil;
    
    _statusReady = NO;
    _status = nil;
    
    _resultReady = NO;
    _result = nil;
    
    _customIdReady = NO;
    _customId = nil;
    
    _deviceIdReady = NO;
    _deviceId = nil;
    
    _dukptOptionReady = NO;
    _dukptOption = NO;
    
    _trackDataOptionReady = NO;
    _trackDataOption = NO;
    
    _piccAtrReady = NO;
    _piccAtr = nil;
    
    _piccResponseApduReady = NO;
    _piccResponseApdu = nil;
    
    // Load the settings.
    _defaults = [NSUserDefaults standardUserDefaults];
    
    _masterKey = [_defaults dataForKey:@"MasterKey"];
    if (_masterKey == nil) {
        _masterKey = [AJDHex byteArrayFromHexString:@"00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"]; // TODO: Need to swap AJDHex class for local function call as Utilities are continaed herein
    }
    
    _masterKey2 = [_defaults dataForKey:@"MasterKey2"];
    if (_masterKey2 == nil) {
        _masterKey2 = [AJDHex byteArrayFromHexString:@"00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"];
    }
    
    _aesKey = [_defaults dataForKey:@"AesKey"];
    if (_aesKey == nil) {
        _aesKey = [AJDHex byteArrayFromHexString:@"4E 61 74 68 61 6E 2E 4C 69 20 54 65 64 64 79 20"];
    }
    
    _iksn = [_defaults dataForKey:@"IKSN"];
    if (_iksn == nil) {
        _iksn = [AJDHex byteArrayFromHexString:@"FF FF 98 76 54 32 10 E0 00 00"];
    }
    
    _ipek = [_defaults dataForKey:@"IPEK"];
    if (_ipek == nil) {
        _ipek = [AJDHex byteArrayFromHexString:@"6A C2 92 FA A1 31 5B 4D 85 8A B3 A3 D7 D5 93 3A"];
    }
    
    _piccTimeoutString = [_defaults stringForKey:@"PiccTimeout"];
    _piccCardTypeString = [_defaults stringForKey:@"PiccCardType"];
    _piccCommandApduString = [_defaults stringForKey:@"PiccCommandApdu"];
    _piccRfConfigString = [_defaults stringForKey:@"PiccRfConfig"];
    
    if (_piccTimeoutString == nil) {
        _piccTimeoutString = @"1";
    }
    
    if (_piccCardTypeString == nil) {
        _piccCardTypeString = @"8F";
    }
    
    if (_piccCommandApduString == nil) {
        _piccCommandApduString = @"00 84 00 00 08";
    }
    
    if (_piccRfConfigString == nil) {
        _piccRfConfigString = @"07 85 85 85 85 85 85 85 85 69 69 69 69 69 69 69 69 3F 3F";
    }
    
    _piccTimeout = [_piccTimeoutString integerValue];
    uint8_t cardType[] = { 0 };
    [self toByteArray:_piccCardTypeString buffer:cardType bufferSize:sizeof(cardType)];
    _piccCardType = cardType[0];
    _piccCommandApdu = [self toByteArray:_piccCommandApduString];
    _piccRfConfig = [self toByteArray:_piccRfConfigString];
    
    // Initialize the DUKPT receiver object.
    _dukptReceiver = [[ACRDukptReceiver alloc] init];
    
    // Set the key serial number.
    [_dukptReceiver setKeySerialNumber:_iksn];
    
    // Load the initial key.
    [_dukptReceiver loadInitialKey:_ipek];
    
    
    picQueue = [[NSOperationQueue alloc]init];
    tagData = [[NSMutableData alloc]initWithCapacity:32];
    tagDataFlag = NO; // this flag will be set when the tagData is updated, it is up to the user to clear it after accessing.
    
}

#pragma mark - Utility functions

- (NSString *)toHexString:(const uint8_t *)buffer length:(size_t)length {
    
    NSString *hexString = @"";
    size_t i = 0;
    
    for (i = 0; i < length; i++) {
        if (i == 0) {
            hexString = [hexString stringByAppendingFormat:@"%02X", buffer[i]];
        } else {
            hexString = [hexString stringByAppendingFormat:@" %02X", buffer[i]];
        }
    }
    
    return hexString;
}

- (NSUInteger)toByteArray:(NSString *)hexString buffer:(uint8_t *)buffer bufferSize:(NSUInteger)bufferSize {
    
    NSUInteger length = 0;
    BOOL first = YES;
    int num = 0;
    unichar c = 0;
    NSUInteger i = 0;
    
    for (i = 0; i < [hexString length]; i++) {
        
        c = [hexString characterAtIndex:i];
        if ((c >= '0') && (c <= '9')) {
            num = c - '0';
        } else if ((c >= 'A') && (c <= 'F')) {
            num = c - 'A' + 10;
        } else if ((c >= 'a') && (c <= 'f')) {
            num = c - 'a' + 10;
        } else {
            num = -1;
        }
        
        if (num >= 0) {
            
            if (first) {
                
                buffer[length] = num << 4;
                
            } else {
                
                buffer[length] |= num;
                length++;
            }
            
            first = !first;
        }
        
        if (length >= bufferSize) {
            break;
        }
    }
    
    return length;
}

- (NSData *)toByteArray:(NSString *)hexString {
    
    NSData *byteArray = nil;
    uint8_t *buffer = NULL;
    NSUInteger i = 0;
    unichar c = 0;
    NSUInteger count = 0;
    int num = 0;
    BOOL first = YES;
    NSUInteger length = 0;
    
    // Count the number of HEX characters.
    for (i = 0; i < [hexString length]; i++) {
        
        c = [hexString characterAtIndex:i];
        if (((c >= '0') && (c <= '9')) ||
            ((c >= 'A') && (c <= 'F')) ||
            ((c >= 'a') && (c <= 'f'))) {
            count++;
        }
    }
    
    // Allocate the buffer.
    buffer = (uint8_t *) malloc((count + 1) / 2);
    
    if (buffer != NULL) {
        
        for (i = 0; i < [hexString length]; i++) {
            
            c = [hexString characterAtIndex:i];
            if ((c >= '0') && (c <= '9')) {
                num = c - '0';
            } else if ((c >= 'A') && (c <= 'F')) {
                num = c - 'A' + 10;
            } else if ((c >= 'a') && (c <= 'f')) {
                num = c - 'a' + 10;
            } else {
                num = -1;
            }
            
            if (num >= 0) {
                
                if (first) {
                    
                    buffer[length] = num << 4;
                    
                } else {
                    
                    buffer[length] |= num;
                    length++;
                }
                
                first = !first;
            }
        }
        
        // Create the byte array.
        byteArray = [[NSData alloc] initWithBytes:buffer length:length];
        
        // Free the buffer.
        free(buffer);
        buffer = NULL;
    }
    
    return byteArray;
}

- (BOOL)decryptData:(const void *)dataIn dataInLength:(size_t)dataInLength key:(const void *)key keyLength:(size_t)keyLength dataOut:(void *)dataOut dataOutLength:(size_t)dataOutLength pBytesReturned:(size_t *)pBytesReturned {
    
    BOOL ret = NO;
    
    // Decrypt the data.
    if (CCCrypt(kCCDecrypt, kCCAlgorithmAES128, 0, key, keyLength, NULL, dataIn, dataInLength, dataOut, dataOutLength, pBytesReturned) == kCCSuccess) {
        ret = YES;
    }
    
    return ret;
}

- (void)resetReader {
    
    // Show the progress.
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Resetting the reader..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    //[alert show];
    
    // Reset the reader.
    [_reader resetWithCompletion:^{
        
        NSLog(@"reset");
        
        // Hide the progress.
        if (!self.timerSource) {
            self.observingMessages = YES;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            self.timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(self.timerSource, dispatch_walltime(NULL, 0), 0.5 * NSEC_PER_SEC, 1ull * NSEC_PER_SEC);
            dispatch_source_set_event_handler(self.timerSource, ^{
                if (self.isObservingMessages) {
                    [self powerOn];
                }
            });
        }
        dispatch_resume(self.timerSource);
        
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            [alert dismissWithClickedButtonIndex:0 animated:YES];
        //        });
        
    }];
}

- (IBAction)transmit:(id)sender {
    
    // Transmit the command APDU.
    _piccResponseApduReady = NO;
    _resultReady = NO;
    
    // Show the PICC response APDU.
    //[self showPiccResponseApdu:piccViewController];
    
    NSData *commandApdu = nil;
    
    
    commandApdu = [AJDHex byteArrayFromHexString:@"FF CA 00 00 00"];
    
    if (![_reader piccTransmitWithTimeout:9.0 commandApdu:[commandApdu bytes] length:[commandApdu length]]) {
        
        // Show the request queue error.
        [self showRequestQueueError];
        
    } else {
        
        [self powerOn];
        
    }
    
    
    //    [self getNfcData];
    //      NSData * myData = [AJDHex byteArrayFromHexString:@"55 44 33 22 11"];
    //      [self putNfcData:myData];
#if 0
    
    commandApdu = [AJDHex byteArrayFromHexString:@"FF CA 00 00 00"];
    
    
    if (![_reader piccTransmitWithTimeout:9.0 commandApdu:[commandApdu bytes] length:[commandApdu length]]) {
        
        // Show the request queue error.
        [self showRequestQueueError];
        
    } else {
        
        [self powerOn];
        
    }
#endif
}

-(void)powerOn {
    
    /*
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Powering on the PICC..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
     [alert show];
     */
    
    // Clear the ATR.
    
    // Power on the PICC.
    _piccAtrReady = NO;
    _resultReady = NO;
    if (![_reader piccPowerOnWithTimeout:_piccTimeout cardType:_piccCardType]) {
        
        // Show the request queue error.
        [self showRequestQueueError];
        
    } else {
        
        // Show the PICC ATR.
        //[self showPiccAtr:piccViewController];
    }
    
}

- (void)showRequestQueueError {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // Show the result.
        UIAlertView *resultAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The request cannot be queued." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [resultAlert show];
    });
}

- (void)setSleep {
    
    // Show the progress.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Setting the reader to sleep..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Set the reader to sleep.
        _resultReady = NO;
        if (![_reader sleep]) {
            
            // TODO: Show the sleep request queue error (this should only happen when App goes to background so perhaps a Nitification?).
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reader Error"
                                                            message:@"The reader couldn't be set to sleep"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        } else {
            
            // This is simply a place holder for the Successful Sleep state. Not needed for this app.
        }
        
        // Hide the progress.
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
    });
}

- (void)stopScan {
    //_reader.mute = YES; // Mute ACR35 library
    if (self.timerSource) dispatch_suspend(self.timerSource);
    NSLog(@"Stopped scan timer %p",self.timerSource);
}

#pragma mark - Mifare 4K read/write 32 bytes starting at block 4
- (BOOL)getNfcData //:(NSData *) data
{
    //BOOL result = YES;
    
    picAuthenticate = [NSBlockOperation blockOperationWithBlock: ^{ NSData * commandApdu = [AJDHex byteArrayFromHexString:@"FF 86 00 00 05 01 00 04 60 00"]; // authenticate block
        [_picWaitAuthenticateResponseCondition lock];
        [_picWaitAuthenticateResponseCondition wait];
        
        if (![_reader piccTransmitWithTimeout:9.0 commandApdu:[commandApdu bytes] length:[commandApdu length]]) {
            // Show the request queue error.
            [self showRequestQueueError];
            //        result = NO;
        } else
        {
            [self powerOn];
        }
        NSLog(@"::commandApdu = %@",commandApdu);
        [_picWaitAuthenticateResponseCondition unlock];
    }];
    
    //    BOOL predicate = NO;
    
    //    NSTimeInterval QLCTimeoutInterval = 2.0;
    
    //    NSDate *startDate = [NSDate date];
    //    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:QLCTimeoutInterval];
    //    uint32_t sleepTimeInterval = QLCTimeoutInterval; //arc4random_uniform(2 * QLCTimeoutInterval) + 1;
    //    NSLog(@"Sleeping for %u seconds.", sleepTimeInterval);
    //    sleep(sleepTimeInterval);
    //    [_picWaitResponseCondition lock];
    //    while(predicate = [_picWaitResponseCondition waitUntilDate:timeoutDate]){};
    //    [_picWaitResponseCondition unlock];
#if 0
    commandApdu = [AJDHex byteArrayFromHexString:@"FF B0 00 04 20"];
    if (![_reader piccTransmitWithTimeout:9.0 commandApdu:[commandApdu bytes] length:[commandApdu length]]) {
        
        // Show the request queue error.
        [self showRequestQueueError];
        NSLog(@"::Error commandApdu = %@",commandApdu);
        
        //        result = NO;
        
    } else
    {
        [self powerOn];
    }
    NSLog(@"::commandApdu = %@",commandApdu);
#endif
    
    //picQueue
    picRead = [NSBlockOperation blockOperationWithBlock: ^{ NSData * commandApdu = [AJDHex byteArrayFromHexString:@"FF B0 00 04 20"];
        //BOOL predicate = NO;
        [_picWaitReadResponseCondition lock];
        [_picWaitReadResponseCondition wait];
        if (![_reader piccTransmitWithTimeout:9.0 commandApdu:[commandApdu bytes] length:[commandApdu length]]) {
            
            // Show the request queue error.
            [self showRequestQueueError];
            NSLog(@"::Error commandApdu = %@",commandApdu);
            
            //        result = NO;
            
        } else
        {
            [self powerOn];
        }
        [_picWaitReadResponseCondition unlock];
        NSLog(@"::commandApdu = %@",commandApdu);
    }];
    
#if 0
    //picQueue
    picRead = [NSBlockOperation blockOperationWithBlock: ^{
        [_picWaitResponseCondition lock];
        [_picWaitResponseCondition wait];
        NSLog(@"::commandApdu = %@",commandApdu);
        [self performSelectorOnMainThread:@selector(readCommand) withObject:nil waitUntilDone:NO];
        [_picWaitResponseCondition unlock];
    }];
#endif
    
    [picQueue cancelAllOperations];
    [picQueue addOperation:picAuthenticate];
    [picQueue addOperation:picRead];
    return YES;
    
    
}

- (void)readCommand
{
    NSData *commandApdu = [AJDHex byteArrayFromHexString:@"FF B0 00 04 20"];
    
    if (![_reader piccTransmitWithTimeout:9.0 commandApdu:[commandApdu bytes] length:[commandApdu length]]) {
        
        // Show the request queue error.
        [self showRequestQueueError];
        NSLog(@"::Error commandApdu = %@",commandApdu);
        
        //        result = NO;
        
    } else
    {
        [self powerOn];
    }
    NSLog(@"::commandApdu = %@",commandApdu);
    
}

- (BOOL)putNfcData:(NSData *) data  // will always write 32 bytes
{
    Byte writeCommand[] = {0xFF, 0xD6, 0x00, 0x04, 0x20,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
    NSMutableData * commandApdu = [NSMutableData dataWithCapacity:37];
    NSRange range = {.location = 0, .length = 37};
    [commandApdu replaceBytesInRange:range withBytes:writeCommand];
    range.location = 5; range.length = [data length];
    [commandApdu replaceBytesInRange:range withBytes:(Byte*)data.bytes];
    
    //    NSMutableData * commandApdu = [AJDHex byteArrayFromHexString:@"FF D6 00 04 10 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F 10"];
    
    
    //BOOL result = YES;
    
    picAuthenticate = [NSBlockOperation blockOperationWithBlock: ^{ NSData * commandApdu = [AJDHex byteArrayFromHexString:@"FF 86 00 00 05 01 00 04 60 00"]; // authenticate block
        [_picWaitAuthenticateResponseCondition lock];
        [_picWaitAuthenticateResponseCondition wait];
        
        if (![_reader piccTransmitWithTimeout:9.0 commandApdu:[commandApdu bytes] length:[commandApdu length]]) {
            // Show the request queue error.
            [self showRequestQueueError];
            //        result = NO;
        } else
        {
            [self powerOn];
        }
        NSLog(@"::commandApdu = %@",commandApdu);
        [_picWaitAuthenticateResponseCondition unlock];
    }];
    
    
    //picQueue
    picWrite = [NSBlockOperation blockOperationWithBlock: ^{ /*NSData * commandApdu = [AJDHex byteArrayFromHexString:@"FF B0 00 04 20"];*/
        [_picWaitWriteResponseCondition lock];
        [_picWaitWriteResponseCondition wait];
        if (![_reader piccTransmitWithTimeout:9.0 commandApdu:[commandApdu bytes] length:[commandApdu length]]) {
            
            // Show the request queue error.
            [self showRequestQueueError];
            NSLog(@"::Error commandApdu = %@",commandApdu);
            
            //        result = NO;
            
        } else
        {
            [self powerOn];
        }
        [_picWaitWriteResponseCondition unlock];
        NSLog(@"::commandApdu = %@",commandApdu);
    }];
    
    [picQueue cancelAllOperations];
    [picQueue addOperation:picAuthenticate];
    [picQueue addOperation:picWrite];
    return YES;
    
}

/**
 * Detect when the audio route has changed manage when Headphone jack is plugged/unplugged so as to never hear the AudioJack tone
 * @param notification the notification registered
 */
-(void)handleRouteChange:(NSNotification*)notification{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    AVAudioSessionPortDescription *input = [[session.currentRoute.inputs count]?session.currentRoute.inputs:nil objectAtIndex:0];
    
    if ([input.portType isEqual: @"MicrophoneBuiltIn"]) {
        // TODO: need to mute AudioJack library
    } else if ([input.portType isEqual: @"MicrophoneWired"]) {
        // TODO: need to unmute AudioJack library
    }
}


#pragma mark - Audio Jack Reader Delegate

- (void)reader:(ACRAudioJackReader *)reader didSendRawData:(const uint8_t *)rawData length:(NSUInteger)length {
    
    NSString *hexString = [self toHexString:rawData length:length];
    
    hexString = [hexString stringByAppendingString:[_reader verifyData:rawData length:length] ? @" (Checksum OK)" : @" (Checksum Error)"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //Set hex value to Global Variable
        AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.cardData setObject:hexString forKey:@"hex"];
        
        // NSLog(@"LOG_HEX%@",hexString);
        // TODO: This is where I need to display the hexString into the Card Details/Log Console views.
        // self.dataReceivedLabel.text = hexString;
        // [self.tableView reloadData];
    });
    
    
    //   picResponse = [NSBlockOperation blockOperationWithBlock: ^{ NSLog(@"::picResponse");
    //   }];
    
    //    [picRead addDependency: picResponse];
    //    [picQueue addOperation:picResponse];
    //    [picQueue addOperation:picRead];
    //    ::didSendRawData 23 00 05 A1 90 00 3A 7D
#if 0
    if((rawData[4] == 0x90 && rawData[5] == 0x00) || (rawData[4] == 0x63 && rawData[5] == 0x00))
    {
        NSLog(@"_picWaitResponseCondition signal");
        [_picWaitResponseCondition signal];
    }
    else
    {
        //        NSLog(@"_picWaitResponseCondition signal no cigar %2.2x %2.2x", rawData[4],rawData[5]);
        
    }
#endif
    //  State machine to read tag data.
    //    accessState = BlockAuthenticationCommand;
    //    accessState = BlockReadCommand;
    //    accessState = BlockWriteCommand;
    //    accessState = BlockReadWriteData
    if((rawData[4] == 0x3B && rawData[5] == 0x8F) || (rawData[4] == 0x00 && rawData[5] == 0xE4)) //periodic atq or status
    {  // trigger block authentication
        NSLog(@"_picWaitAuthenticateResponseCondition signal");
        //       [_picWaitResponseCondition signal];
        [_picWaitAuthenticateResponseCondition signal];
    }
    else if((rawData[4] == 0x90 && rawData[5] == 0x00) || (rawData[4] == 0x63 && rawData[5] == 0x00))  // Authentication ok, send read command
    {  // trigger block read/write
        NSLog(@"_picWaitReadResponseCondition signal");
        [_picWaitReadResponseCondition signal];
        [_picWaitWriteResponseCondition signal];
    }
    else if((rawData[length - 4] == 0x90 && rawData[length - 3] == 0x00) && (rawData[2] == 0x25))  // Appears to be read data.
    {  // capture data
        //       NSData * readData = [NSData dataWithBytes:rawData length:length];
        NSRange range = {.location = 0, .length = 32};
        [tagData replaceBytesInRange:range withBytes:rawData];
        NSLog(@"capture data %@", tagData);
        tagDataFlag = YES;
        
        //        [_picWaitReadResponseCondition signal];
    }
}

- (void)reader:(ACRAudioJackReader *)reader didSendPiccAtr:(const uint8_t *)atr length:(NSUInteger)length {
    
    [_responseCondition lock];
    _piccAtr = [NSData dataWithBytes:atr length:length];
    _piccAtrReady = YES;
    
    [self transmit:nil];
    
    [_responseCondition signal];
    [_responseCondition unlock];
}

- (void)reader:(ACRAudioJackReader *)reader didSendPiccResponseApdu:(const uint8_t *)responseApdu length:(NSUInteger)length {
    
    [_responseCondition lock];
    _piccResponseApdu = [NSData dataWithBytes:responseApdu length:length];
    
    NSLog(@"piccResponse %@, %lu",_piccResponseApdu , length);
    
    // Mute AudioJack library
    _reader.mute = YES;
    // Route audio to speakers
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    
    // Construct URL to a scan sound file
    NSString *path = [[NSBundle mainBundle] pathForResource:@"scan_sound" ofType:@"mp3"]; // Android scan sound
    // NSString *path = [[NSBundle mainBundle] pathForResource:@"notification" ofType:@"mp3"];  // Bird chirp sound
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    NSError *error;
    // Create audio player object and initialize with URL to sound a scan
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
    self.audioPlayer.numberOfLoops = 1; // only play sound once
    
    if (self.audioPlayer == nil)
        NSLog(@"%@",[error description]);
    else
        self.audioPlayer.delegate = self; // assign this player delegate to this class so audioPlayerDidFinishPlaying will be called here
    [self.audioPlayer play]; // play the scan sound
    
    NSString *UUID = [self toHexString:[_piccResponseApdu bytes] length:[_piccResponseApdu length]];
    
    NSLog(@"UUID:%@",UUID);
    
    if ([UUID length] > 0) {
        NSLog(@"UUID");
        
        //[self performSelectorOnMainThread:@selector(completeTransaction:) withObject:UUID waitUntilDone:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary* userInfo = @{@"UUID": UUID};
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"UUIDNotification"
             object:self userInfo:userInfo];
        });
    }
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        logView.text = [NSString stringWithFormat:@"%@ \n %@", logView.text,[self toHexString:[_piccResponseApdu bytes] length:[_piccResponseApdu length]-2]]; // log the scan UUID without SW1 and SW2
//    });
    
    _piccResponseApduReady = YES;
    [_responseCondition signal];
    [_responseCondition unlock];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)audioPlayer successfully:(BOOL)flag
{
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil]; // Route audio back to Headphones
    _reader.mute = NO; // Unmute the AudioJack library
}

- (void)readerDidReset:(ACRAudioJackReader *)reader {
    
}

@end
