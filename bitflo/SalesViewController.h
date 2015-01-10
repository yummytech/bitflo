//
//  SalesViewController.h
//  bitflo
//
//  Created by Boris  on 1/10/15.
//  Copyright (c) 2015 LLT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SalesDelegate

- (void)dismiss:(UIViewController *)viewController withSales:(NSMutableArray *)array;

@end

@interface SalesViewController : UIViewController {
    
    float tableHeight;
}

@property (nonatomic, strong) NSMutableArray *salesArray;
@property (nonatomic, strong) IBOutlet UITableView *theTable;
@property (nonatomic, strong) IBOutlet UILabel *totalLabel;

@property (weak,nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;

@property (weak, nonatomic) id<SalesDelegate> delegate;

@end
