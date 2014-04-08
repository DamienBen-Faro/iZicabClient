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
            if ([dict objectForKey:@"data"]  > 0 && ![[dict objectForKey:@"data"] isEqualToString:@"empty"])
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
    UIImage *backBtnImage = [UIImage imageNamed:@"backButton@2x.png"];
    UIImage *backBtnImagePressed = [UIImage imageNamed:@"backButton@2x.png"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn setBackgroundImage:backBtnImagePressed forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 50, 70);
    UIView *backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 70)];
    [backButtonView setFrame:CGRectMake(0, 30, 50, 70)];//25, 75
    [backButtonView addSubview:backBtn];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *homeBtnImage = [UIImage imageNamed:@"menuButton@2X.png"];
    UIImage *homeBtnImagePressed = [UIImage imageNamed:@"menuButton@2X.png"];
    [homeBtn setBackgroundImage:homeBtnImage forState:UIControlStateNormal];
    [homeBtn setBackgroundImage:homeBtnImagePressed forState:UIControlStateHighlighted];
    [homeBtn addTarget:self action:@selector(goToDash) forControlEvents:UIControlEventTouchUpInside];
    homeBtn.frame = CGRectMake(0, 0, 50, 70);
    UIView *homeButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 70)];
    [homeButtonView setFrame:CGRectMake(270, 30, 50, 70)];//25, 75
    [homeButtonView addSubview:homeBtn];
    
    
    
    
    CustomNavBar *navigationBar = [[CustomNavBar alloc] initWithFrame:CGRectZero];
    [navigationBar addSubview:backButtonView];
    [navigationBar addSubview:homeButtonView];
	[self.navigationController setValue:navigationBar forKey:@"navigationBar"];
    
    
    [(CustomNavBar *)self.navigationController.navigationBar setTitleNavBar:@"MES RESERVATIONS"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    
}




- (void)goBack
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
