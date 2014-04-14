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
#import "DashboardViewController.h"


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

    [[ConnectionData sharedConnectionData] beginService: @"reservation/readAllMinePrivateUser":[[NSMutableDictionary alloc] initWithObjectsAndKeys:                                                                                                                 [defaults objectForKey:@"userId"], @"userId", nil] :@selector(callBackController:):self];

    
    self.segment = [[UISegmentedControl alloc] initWithItems:@[@"Réservation",@"Map"]];
    self.segment.segmentedControlStyle = UISegmentedControlStyleBordered;

    
    UIFont *font =  [UIFont fontWithName:@"Roboto-Thin" size:20.0];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.segment setTitleTextAttributes:attributes forState:UIControlStateNormal];
    self.segment.backgroundColor = [UIColor whiteColor];
    
}

- (void)callBackController:(NSDictionary *)dict
{
 
        NSError *error;
    
        if (error == nil && [[dict objectForKey:@"error"] length] == 0)
        {
            [self.arr removeAllObjects];
            if ([dict objectForKey:@"data"]  > 0 && [[dict objectForKey:@"data"] isKindOfClass:[NSArray class]])
            {
             self.arr = [[NSMutableArray alloc] init];
             for (NSMutableArray * it in ((NSMutableArray*)dict[@"data"]))
                [self.arr addObject:it];
            }
            [self.tableView reloadData];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
                                                            message:[dict objectForKey:@"error"] ? [dict objectForKey:@"error"] : @"internal server error"
                                                           delegate:self
                                                  cancelButtonTitle:@"ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }
}

- (void)callBackControllerDelete:(NSDictionary *)dict
{
    
    NSError *error;
    
    if (error == nil && [[dict objectForKey:@"error"] length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Réservation supprimée"
                                                       delegate:self
                                              cancelButtonTitle:@"ok"
                                              otherButtonTitles:nil];
        [alert show];
           NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [[ConnectionData sharedConnectionData] beginService: @"reservation/readAllMinePrivateUser":[[NSMutableDictionary alloc] initWithObjectsAndKeys:                                                                                                                 [defaults objectForKey:@"userId"], @"userId", nil] :@selector(callBackController:):self];

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
    [backButtonView setFrame:CGRectMake(0, 20, 50, 70)];//25, 75
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
    [homeButtonView setFrame:CGRectMake(270, 20, 50, 70)];//25, 75
    [homeButtonView addSubview:homeBtn];
    
    
    
    
    CustomNavBar *navigationBar = [[CustomNavBar alloc] initWithFrame:CGRectZero];
        navigationBar.isDash = YES;
    [navigationBar addSubview:backButtonView];
    [navigationBar addSubview:homeButtonView];
	[self.navigationController setValue:navigationBar forKey:@"navigationBar"];
    
    
    [(CustomNavBar *)self.navigationController.navigationBar setTitleNavBar:@"MES RESERVATIONS"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    
}


- (void) goToDash
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    DashboardViewController* ctrl = (DashboardViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    [UIView  beginAnimations:@"ShowDetails" context: nil];
    [UIView setAnimationDuration:0.5];
    [self.navigationController pushViewController:ctrl animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
}
- (void)goBack
{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    CATransition *transition = [CATransition animation];
    [transition setType:kCAAnimationCubicPaced];
    [self.navigationController.view.layer addAnimation:transition forKey:@"someAnimation"];
    
    [self.navigationController popViewControllerAnimated:YES];
    [CATransaction commit];
    
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
  
    if (self.segment.selectedSegmentIndex == 1)
    {
        cell.modif.hidden = YES;
        cell.deleteResa.hidden = YES;
    }
    else
    {
        cell.modif.hidden = NO;
        cell.deleteResa.hidden = NO;
    }
    
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


- (void)delResa:(NSDictionary *)dict
{
    

        NSError *error;
        
        
        NSLog(@"%@", dict);
        
        if (error == nil && [[dict objectForKey:@"error"] length] == 0)
        {
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [[ConnectionData sharedConnectionData] beginService: @"reservation/readAllMinePrivateUser":[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                                                                        [defaults objectForKey:@"userId"],  @"userId"
                                                                                                        ,nil] :@selector(callBackController:):self];

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
        

}


- (IBAction)deleteResa:(id)sender
{
 
    self.idToDelete = [sender tag];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
                                                             message:@"Voulez vous vraiment supprimer la reservation ?"
                                                            delegate:self
                                                   cancelButtonTitle:@"Non"
                                                   otherButtonTitles:@"Oui", nil];

    [alert show];

    
    
   
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1)
    {
        [[ConnectionData sharedConnectionData] beginService: @"reservation/delete":[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                                                    self.arr[self.idToDelete][@"id"],@"resaId"
                                                                                    ,nil] :@selector(callBackControllerDelete:):self];
    }
}

- (IBAction)changeRes:(id)sender
{
    

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    
    if (((UISegmentedControl *)sender).selectedSegmentIndex == 1)
        [[ConnectionData sharedConnectionData] beginService: @"ride/getClientHistoricalReservation":[[NSMutableDictionary alloc] initWithObjectsAndKeys:                                                                                                                 [defaults objectForKey:@"userId"], @"userId", nil] :@selector(callBackController:):self];
    else
            [[ConnectionData sharedConnectionData] beginService: @"reservation/readAllMinePrivateUser":[[NSMutableDictionary alloc] initWithObjectsAndKeys:                                                                                                                 [defaults objectForKey:@"userId"], @"userId", nil] :@selector(callBackController:):self];
    
        [self.tableView reloadData];
    
    
    
    
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
