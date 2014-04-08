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
#import "ConnectionData.h"

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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    
    [ConnectionData sendReq: @"reservation/readAllMinePrivateUser": [self readMine]: self: [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                                                             [defaults objectForKey:@"userId"], @"userId"
                                                                                             ,nil]];
}



- (void(^)(NSURLResponse *_response, NSData *_data, NSError *_error))readMine
{
 
     return ^(NSURLResponse *_response, NSData *_data, NSError *_error)
    {
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"%@", dict);
        
        if (error == nil && [[dict objectForKey:@"error"] length] == 0)
        {
            [self.arr removeAllObjects];
            if ([dict objectForKey:@"data"]  > 0)
            {
             self.arr = [[NSMutableArray alloc] init];
             for (NSMutableArray * it in ((NSMutableArray*)dict[@"data"]))
                [self.arr addObject:it];
            }
            [self.tableView reloadData];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[dict objectForKey:@"error"] ? [dict objectForKey:@"error"] : @"internal server error"
                                                           delegate:self
                                                  cancelButtonTitle:@"ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }

    };
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
   // NSLog(@"%@", self.arr[[indexPath row]]);
    NSString *date =  self.arr[[indexPath row]][@"tripdatetime"];
    NSArray *listItems = [date componentsSeparatedByString:@" "];

    cell.date.text = [listItems objectAtIndex:0];
    cell.hour.text = [listItems objectAtIndex:1];
    cell.startAddress.text =  self.arr[[indexPath row]][@"startposition"];
    cell.startEndress.text =  self.arr[[indexPath row]][@"endposition"];
    
    
    cell.deleteResa.tag = [indexPath row];
    
    [cell.see addTarget:self action:@selector(seeResa) forControlEvents:UIControlEventTouchDown];
    [cell.modif addTarget:self action:@selector(modifResa:) forControlEvents:UIControlEventTouchDown];
    [cell.deleteResa addTarget:self action:@selector(deleteResa:) forControlEvents:UIControlEventTouchDown];
  
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    InvoiceViewController* ctrl = (InvoiceViewController *)[storyboard instantiateViewControllerWithIdentifier:@"InvoiceViewController"];
    ctrl.isSeeing = YES;
    NSLog(@"%@", self.arr[[indexPath row]]);
    ctrl.resa = self.arr[[indexPath row]];
    [self.navigationController pushViewController:ctrl animated:YES];
}

-(void) seeResa
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    InvoiceViewController* ctrl = (InvoiceViewController *)[storyboard instantiateViewControllerWithIdentifier:@"InvoiceViewController"];
    [self.navigationController pushViewController:ctrl animated:YES];

}


- (void(^)(NSURLResponse *_response, NSData *_data, NSError *_error))delResa
{
    
    return ^(NSURLResponse *_response, NSData *_data, NSError *_error)
    {
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"%@", dict);
        
        if (error == nil && [[dict objectForKey:@"error"] length] == 0)
        {
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [ConnectionData sendReq: @"reservation/readAllMinePrivateUser": [self readMine]: self: [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                                                                    [defaults objectForKey:@"userId"],  @"userId"
                                                                                                    ,nil]];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[dict objectForKey:@"error"] ? [dict objectForKey:@"error"] : @"internal server error"
                                                           delegate:self
                                                  cancelButtonTitle:@"ok"
                                                  otherButtonTitles:nil];
            [alert show];

        }
        
    };
}


- (IBAction)deleteResa:(id)sender
{
    NSLog(@"%@", self.arr[[sender tag]][@"id"]);
    [ConnectionData sendReq: @"reservation/delete": [self delResa]: self: [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                                                              self.arr[[sender tag]][@"id"],@"resaId"
                                                                                            ,nil]];
   
    
}

- (IBAction)modifResa:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    ReservationViewController* ctrl = (ReservationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ReservationViewController"];
    ctrl.resaUpdate =  self.arr[[sender tag]];
    ctrl.isResa = YES;
                                                                    [self.navigationController pushViewController:ctrl animated:YES];

}


@end
