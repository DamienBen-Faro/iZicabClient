//
//  ViewController.m
//  iZicab
//
//  Created by Damien  on 3/26/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "SignController.h"
#import "DashboardViewController.h"


@implementation SignController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://199.16.131.147/~izicat/102/Website/index.php/ws/reservation/readAll"]] queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *_response, NSData *_data, NSError *_error) {
                              
                               NSError *error;
                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:&error];
                               NSLog(@"diction:%@", dict);
                           
                        }];
    
    [self checkAccount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) sendInscription:(id) sender
{
    NSLog(@"wat");
}

-(void)checkAccount
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    DashboardViewController* ctrl = (DashboardViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
    
    
    [self.navigationController pushViewController:ctrl animated:YES];
}

@end
