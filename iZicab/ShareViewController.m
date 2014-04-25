//
//  ShareViewController.m
//  iZicab
//
//  Created by Damien  on 3/28/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "ShareViewController.h"
#import "CustomNavBar.h"
#import "DashboardViewController.h"

@implementation ShareViewController

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
    
}


- (void)viewWillAppear:(BOOL)animated
{
    

        [self setCustomTitle:@"ACTUALITÉ DÉTAILS"];
    
}


- (IBAction)datShare:(id)sender
{
    switch ([sender tag])
    {
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.facebook.com/izicabcontact"]];
            break;
        case 2:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://twitter.com/izicab"]];
            break;
        case 3:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://plus.google.com/b/114507113861003937099/114507113861003937099/about?hl=fr"]];
            break;
        case 4:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms:"]];
            break;
        case 5:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.linkedin.com/company/5027134?trk=tyah&trkInfo=tarId%3A1397845878305%2Ctas%3Aizica%2Cidx%3A1-1-1"]];
            break;
        case 6:
        {
            NSString *subject = [NSString stringWithFormat:@"iZicab"];
            
            NSString *mail = [NSString stringWithFormat:@"info@izicab.com"];
            
            NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:?to=%@&subject=%@",
                                                        [mail stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                                                        [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
            
            [[UIApplication sharedApplication] openURL:url];
            break;
        }
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
