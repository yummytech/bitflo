//
//  AddNoteViewController.h
//  bitflo
//
//  Created by Boris  on 1/10/15.
//  Copyright (c) 2015 LLT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddNoteDelegate

- (void)dismiss:(UIViewController *)viewController withNote:(NSString *)string;

@end

@interface AddNoteViewController : UIViewController

@property (weak, nonatomic) id<AddNoteDelegate> delegate;
@property (nonatomic, strong) IBOutlet UITextView *textView;

@end
