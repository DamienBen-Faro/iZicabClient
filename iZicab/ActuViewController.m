//
//  ActuViewController.m
//  iZicab
//
//  Created by Damien  on 3/28/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "ActuViewController.h"
#import "CustomNavBar.h"
#import "ActuCell.h"
#import "ActuDetailViewController.h"

@implementation ActuViewController

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
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    self.tableView.delegate = self;
    self.arr = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", nil];
    self.tableView.dataSource = self;
    
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"buttonBack"]  ;
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 97, 15);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    
    [self.navigationItem setLeftBarButtonItem:backButton];
    CustomNavBar *navigationBar = [[CustomNavBar alloc] initWithFrame:CGRectZero];
	[self.navigationController setValue:navigationBar forKey:@"navigationBar"];
    [(CustomNavBar *)self.navigationController.navigationBar setTitleNavBar:@"ACTU"];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ActuCell";
    
    ActuCell *cell = (ActuCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActuCellView" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    /*cell.infoType.text = @"infoType";//[tableData objectAtIndex:indexPath.row];
    cell.img.image = [UIImage imageNamed:@"datB"];//[UIImage imageNamed:[thumbnails objectAtIndex:indexPath.row]];
    cell.date.text = @"12/12/2012";//[prepTime objectAtIndex:indexPath.row];
    cell.hour.text = @"12h14";//[prepTime objectAtIndex:indexPath.row];
    cell.desc.text = @"description de dingue";//[prepTime objectAtIndex:indexPath.row];*/
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    ActuDetailViewController* ctrl = (ActuDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ActuDetailViewController"];
    [self.navigationController pushViewController:ctrl animated:YES];

}

@end
