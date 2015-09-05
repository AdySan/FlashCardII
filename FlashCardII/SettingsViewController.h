//
//  SettingsViewController.h
//  FlashCards
//
//  Created by Aditya Tannu on 10/11/14.
//  Copyright (c) 2014 Aditya Tannu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>
{
    
    IBOutlet UISlider *autoPilotSlider;
    IBOutlet UILabel *autoPilotSpeedValue;
    
}


- (IBAction)initList:(id)sender;
- (IBAction)autoPilotSliderMoved:(id)sender;

- (IBAction)setSettings;
- (IBAction)getMySettings;
@end
