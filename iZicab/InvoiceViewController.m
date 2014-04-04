//
//  InvoiceViewController.m
//  iZicab
//
//  Created by Damien  on 3/28/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import "InvoiceViewController.h"
#import "CustomNavBar.h"
#import "ConnectionData.h"
#import "DashboardViewController.h"

@implementation InvoiceViewController

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
    self.date.text = self.resaCtrl.startDate.titleLabel.text;
    self.start.text = self.resaCtrl.startAddress.text;
    self.end.text = self.resaCtrl.endAddress.text;
    self.passenger.text = self.resaCtrl.passBtn.titleLabel.text;
    self.luggage.text = self.resaCtrl.luggBtn.titleLabel.text;
    
    self.baby.text = [NSString stringWithFormat:@"%i", self.resaCtrl.babySeat.selected];
    self.wifi.text = [NSString stringWithFormat:@"%i", self.resaCtrl.wifi.selected];
    self.paper.text = [NSString stringWithFormat:@"%i", self.resaCtrl.paper.selected];
    
    self.premium.selected = YES;
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
    [(CustomNavBar *)self.navigationController.navigationBar setTitleNavBar:@"INVOICE"];

}


- (IBAction)standard:(id)sender
{
        self.price.text = @"55€";
        self.premium.selected = NO;
        self.standard.selected = YES;
}

- (IBAction)premium:(id)sender
{
     self.price.text = @"75€";
        self.premium.selected = YES;
        self.standard.selected = NO;
}

- (void(^)(NSURLResponse *_response, NSData *_data, NSError *_error))sendResa
{
    return ^(NSURLResponse *_response, NSData *_data, NSError *_error) {
        
       NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"%@", dict);
        if (error == nil && [[dict objectForKey:@"error"] length] == 0)
        {

            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
                                                            message:@"Reservation Effectuée"
                                                           delegate:self
                                                  cancelButtonTitle:@"ok"
                                                  otherButtonTitles:nil];
            [alert show];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            DashboardViewController* ctrl = (DashboardViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
            [self.navigationController pushViewController:ctrl animated:YES];
            
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


- (IBAction)send:(id)sender
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    
    NSString *isPremium = @"standard";
    
    if ( self.premium.selected)
        isPremium = @"premium";
    
   
    NSLog(@"hahahh:%f / %@", self.resaCtrl.startLat, self.resaCtrl.phone.text);
    [ConnectionData sendReq: @"reservation/create": [self sendResa]: self: [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                                            @"userId",  [defaults objectForKey:@"userId"],
                                                                            @"latStart", [NSString stringWithFormat:@"%f", self.resaCtrl.startLat ],
                                                                            @"lngStart", [NSString stringWithFormat:@"%f", self.resaCtrl.startLng],
                                                                            @"startAddress", self.start.text,
                                                                            @"latEnd", [NSString stringWithFormat:@"%f", self.resaCtrl.endLat],
                                                                            @"lngEnd", [NSString stringWithFormat:@"%f", self.resaCtrl.endLng ],
                                                                            @"endAddress", self.end.text,
                                                                            @"tripType", isPremium,
                                                                            @"tripDateTime", self.date.text,
                                                                            @"paymentMode", @"cash",
                                                                            @"seat", self.passenger.text,
                                                                            @"luggage", self.luggage.text,
                                                                            @"convention", @"no covention",
                                                                            @"status", @"waiting",
                                                                            @"contactName", self.resaCtrl.name.text,
                                                                            @"contactEmail", @"empty",
                                                                            @"contactPhone", self.resaCtrl.phone.text,
                                                                            @"convention", @"" ,
                                                                            @"wifi", self.wifi.text,
                                                                            @"magazine", self.paper.text,
                                                                            @"babysit" , self.baby.text
                                                                            ,nil]];
    
}

- (void)goback
{
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
