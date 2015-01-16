//
//  SalesViewController.m
//  bitflo
//
//  Created by Boris  on 1/10/15.
//  Copyright (c) 2015 LLT. All rights reserved.
//

#import "SalesViewController.h"
#import "SalesTableViewCell.h"
#import "SalesTallTableViewCell.h"

@interface SalesViewController ()

@end

@implementation SalesViewController

@synthesize salesArray, theTable, totalLabel;

- (IBAction)clear:(id)sender {
    
    salesArray = [[NSMutableArray alloc] init];
    totalLabel.text = @"Total $0.00";
    [theTable reloadData];
    [self.delegate dismiss:self withSales:salesArray];
}

- (IBAction)done:(id)sender {
    
    [self.delegate dismiss:self withSales:salesArray];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    tableHeight = 0;
    [theTable reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    tableHeight = 0;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [salesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if ([[salesArray objectAtIndex:indexPath.row] objectForKey:@"note"]) {
        
        tableView.rowHeight = 88;
        tableHeight += tableView.rowHeight;
        
        SalesTallTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_tall" forIndexPath:indexPath];
        cell.noteLabel.text = [[salesArray objectAtIndex:indexPath.row] objectForKey:@"note"];
        cell.amountDescriptionLabel.text = [[salesArray objectAtIndex:indexPath.row] objectForKey:@"description"];
        cell.amountLabel.text = [NSString stringWithFormat:@"$%.2f",[[[salesArray objectAtIndex:indexPath.row] objectForKey:@"amount"] floatValue]/100];
        
        if (indexPath.row == [salesArray count] - 1) {
            self.tableHeightConstraint.constant = tableHeight;
            [self.theTable needsUpdateConstraints];
        }
        
        return cell;
        
    } else {
        
        tableView.rowHeight = 44;
        tableHeight += tableView.rowHeight;
        
        SalesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.amountDescriptionLabel.text = [[salesArray objectAtIndex:indexPath.row] objectForKey:@"description"];
        cell.amountLabel.text = [NSString stringWithFormat:@"$%.2f",[[[salesArray objectAtIndex:indexPath.row] objectForKey:@"amount"] floatValue]/100];
        // Configure the cell...
        
        if (indexPath.row == [salesArray count] - 1) {
            self.tableHeightConstraint.constant = tableHeight;
            [self.theTable needsUpdateConstraints];
        }
        
        return cell;
    }
    
}

@end
