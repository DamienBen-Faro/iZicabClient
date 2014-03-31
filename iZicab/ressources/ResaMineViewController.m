//
//  ResaMineViewController.m
//  iZicab
//
//  Created by Damien  on 3/28/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "ResaMineViewController.h"
#import "CustomNavBar.h"
#import "ResaMineCell.h"
#import "ReservationViewController.h"
#import "InvoiceViewController.h"

@implementation ResaMineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}


- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"buttonBack"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 97, 15);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    
    [self.navigationItem setLeftBarButtonItem:backButton];
    CustomNavBar *navigationBar = [[CustomNavBar alloc] initWithFrame:CGRectZero];
	[self.navigationController setValue:navigationBar forKey:@"navigationBar"];
    [(CustomNavBar *)self.navigationController.navigationBar setTitleNavBar:@"MES RESERVATIONS"];
    
    self.tableView.delegate = self;
    self.arr = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", nil];
    self.tableView.dataSource = self;
}


- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 137;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ResaMineCell";
    
    ResaMineCell *cell = (ResaMineCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ResaMineCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    cell.date.font = [UIFont fontWithName:@"Roboto-Light" size:20.0];
    cell.date.textColor = [UIColor darkGrayColor];
    
    cell.hour.font = [UIFont fontWithName:@"Roboto-Light" size:20.0];
    cell.hour.textColor = [UIColor darkGrayColor];
    
    cell.startAddress.font = [UIFont fontWithName:@"Roboto-Thin" size:15.0];
    cell.startAddress.textColor = [UIColor darkGrayColor];
    
    cell.startEndress.font = [UIFont fontWithName:@"Roboto-Thin" size:15.0];
    cell.startEndress.textColor = [UIColor darkGrayColor];
    
    
   //[tableData objectAtIndex:indexPath.row];
    
    cell.date.text = @"12/12/2012";
    cell.hour.text = @"12h14";
    cell.startAddress.text = @"14-16 RUE SOLEILLET PARIS 75020";
    cell.startEndress.text = @"AEROPORT CHARLES DE GAULLE Roissy-en-France 95700";
    
    
    [cell.see addTarget:self action:@selector(seeResa) forControlEvents:UIControlEventTouchDown];
    [cell.modif addTarget:self action:@selector(modifResa) forControlEvents:UIControlEventTouchDown];
    [cell.deleteResa addTarget:self action:@selector(deleteResa) forControlEvents:UIControlEventTouchDown];
  
    
    
    return cell;
}

-(void) seeResa
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    InvoiceViewController* ctrl = (InvoiceViewController *)[storyboard instantiateViewControllerWithIdentifier:@"InvoiceViewController"];
    [self.navigationController pushViewController:ctrl animated:YES];

}

- (void)deleteResa
{
    
}

- (void)modifResa
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    ReservationViewController* ctrl = (ReservationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ReservationViewController"];
                                                                    [self.navigationController pushViewController:ctrl animated:YES];

}


@end
