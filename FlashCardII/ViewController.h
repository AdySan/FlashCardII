//
//  ViewController.h
//  FlashCard
//
//  Created by Aditya Tannu on 10/5/14.
//  Copyright (c) 2014 Aditya Tannu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"


@interface ViewController : UIViewController {

    IBOutlet UILabel *textView;
    IBOutlet UILabel *meaningView;
    IBOutlet UILabel *sentenceView;
//    IBOutlet UISwitch *autoPilotSwitch;
//    IBOutlet UISwitch *FavsOnlySwitch;
//    IBOutlet UILabel *autoPilotLabel;
    IBOutlet UILabel *RemainingWords;
    IBOutlet UIButton *favButton;

    IBOutlet UIButton *FavsOnlyButton;
    IBOutlet UIButton *PlayPauseButton;
    IBOutlet UILabel *NoOfFavs;
}

- (IBAction)flipAutoPilotSwitch:(id)sender;
-(IBAction) nextword;
-(IBAction) iKnowThisONe;
-(BOOL) DoIKnowThisWord;
-(BOOL) DoIKnowAllWords;
- (IBAction)getSettings:(id)sender;


@end

