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
#import "DashboardViewController.h"
#import "ConnectionData.h"

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
    self.tableView.dataSource = self;
    
   self.spin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [self.spin setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2)];
    [self.spin setColor:[UIColor colorWithRed:89.0/255.0 green:200.0/255.0 blue:220.0/255.0 alpha:1]];
    self.spin.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);

 
    [[ConnectionData sharedConnectionData] beginService: @"info/infos":[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"s", @"lat",nil]  :@selector(callBackController:):self];
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

- (void) viewWillDisappear:(BOOL)animated
{
      [[UIApplication sharedApplication] setStatusBarHidden:YES];
     [super viewWillDisappear:animated];
}





- (void)viewWillAppear:(BOOL)animated
{
    [self setCustomTitle:@"ACTUALITÉ"];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 153;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    //cell.infoType.text = @"infoType";//[tableData objectAtIndex:indexPath.row];

    cell.infoType.font = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
    cell.infoType.textColor = [UIColor darkGrayColor];
        cell.infoType.text = self.arr[[indexPath row]][@"type"];
    
    cell.date.font = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
    cell.date.textColor = [UIColor darkGrayColor];
    cell.date.text = self.arr[[indexPath row]][@"date"];

    cell.hour.font = [UIFont fontWithName:@"Roboto-Thin" size:20.0];
    cell.hour.textColor = [UIColor darkGrayColor];
        cell.hour.text = self.arr[[indexPath row]][@"hour"];
    
    cell.desc.font = [UIFont fontWithName:@"Roboto-Thin" size:15.0];
    cell.desc.textColor = [UIColor darkGrayColor];
    cell.desc.text = self.arr[[indexPath row]][@"value"];


    NSURL * imageURL = [NSURL URLWithString: self.arr[[indexPath row]][@"imgSmall"]];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    cell.img.image = image;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    ActuDetailViewController* ctrl = (ActuDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ActuDetailViewController"];
    ctrl.arr = self.arr[[indexPath row]];
    [self.spin startAnimating];
    [self.view addSubview:self.spin];

    
    [self.navigationController pushViewController:ctrl animated:YES];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [self.spin stopAnimating];
    [self.spin removeFromSuperview];
}

@end
