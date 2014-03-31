//
//  ActuCell.h
//  iZicab
//
//  Created by Damien  on 3/28/14.
//  Copyright (c) 2014 Damien . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActuCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *infoType;
@property (nonatomic, weak) IBOutlet UILabel *date;
@property (nonatomic, weak) IBOutlet UILabel *hour;
@property (nonatomic, weak) IBOutlet UIImageView *img;
@property (nonatomic, weak) IBOutlet UITextView *desc;


@end
