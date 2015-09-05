//
//  ViewController.m
//  FlashCard
//
//  Created by Aditya Tannu on 10/5/14.
//  Copyright (c) 2014 Aditya Tannu. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()

@property (strong, nonatomic) NSArray *wordsArray;
@property (strong, nonatomic) NSArray *meaningsArray;
@property (strong, nonatomic) NSArray *sentenceArray;
@property (strong, nonatomic) NSArray *FavCountArray;
@property (strong, nonatomic) NSArray *FavsArray;
@property (strong, nonatomic) NSMutableArray *FavWordsArray;
@property (strong, nonatomic) NSMutableArray *FavMeaningssArray;
@property (strong, nonatomic) NSMutableArray *FavSentenceArray;

@end

@implementation ViewController

#define NO_OF_WORDS 1020
#define FLASH_CARD_RADIUS 20

int randomIndex = 0;
int randomFavIndex = 0;
BOOL gameOver = NO;
BOOL word_or_meaning = NO;

float autoPilotSpeed = 1.5;
BOOL speedChanged;

-(void)viewDidLoad{
    [super viewDidLoad];

    //    UIVisualEffect *blurEffect;
    //    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //    UIVisualEffectView *visualEffectView;
    //    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //    visualEffectView.frame = self.view.bounds;
    //    [backgroundImage addSubview:visualEffectView];
    
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"Property List Words" ofType:@"plist"];
    self.wordsArray = [[NSMutableArray alloc] initWithContentsOfFile:path1];
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"Property List Meanings" ofType:@"plist"];
    self.meaningsArray = [[NSMutableArray alloc] initWithContentsOfFile:path2];

    NSString *path3 = [[NSBundle mainBundle] pathForResource:@"Property List Sentence" ofType:@"plist"];
    self.sentenceArray = [[NSMutableArray alloc] initWithContentsOfFile:path3];
    
    self.FavWordsArray = [[NSMutableArray alloc] init];
    self.FavMeaningssArray = [[NSMutableArray alloc] init];
    self.FavSentenceArray = [[NSMutableArray alloc] init];
    
    [favButton setImage:[UIImage imageNamed:@"star-off-large.png"] forState:UIControlStateNormal];
    [favButton setImage:[UIImage imageNamed:@"star-on-large.png"] forState:UIControlStateSelected];
    [favButton setImage:[UIImage imageNamed:@"star-on-large.png"] forState:UIControlStateHighlighted];

    [PlayPauseButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [PlayPauseButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateSelected];
    [PlayPauseButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateHighlighted];

    [FavsOnlyButton setImage:[UIImage imageNamed:@"heart-off.png"] forState:UIControlStateNormal];
    [FavsOnlyButton setImage:[UIImage imageNamed:@"heart-on.png"] forState:UIControlStateSelected];
    [FavsOnlyButton setImage:[UIImage imageNamed:@"heart-on.png"] forState:UIControlStateHighlighted];

    
    [self checkAndCreateScores];
  
    [self checkAndCreateFavs];
    
    [NSTimer scheduledTimerWithTimeInterval:autoPilotSpeed target:self selector:@selector(myTimerTick:) userInfo:nil repeats:YES];
    
    favButton.selected = NO;
    
    [self nextword];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self getSettings];
    
    [self DoIKnowThisWord];
   
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)nextword{
    
    if(self.DoIKnowAllWords == YES)
    {
            [textView setText:[[NSString alloc] initWithFormat:@"Game Over" ] ];
            [meaningView setText:[[NSString alloc] initWithFormat:@""]];
            [sentenceView setText:[[NSString alloc] initWithFormat:@""]];
        gameOver = YES;
    }
    else
    {
        randomIndex = arc4random() % NO_OF_WORDS;
        
        randomFavIndex = arc4random() % [self.FavCountArray count];
        
        while (self.DoIKnowThisWord == YES) {
            randomIndex = arc4random() % NO_OF_WORDS;
            NSLog(@"Repeat: Sorry, reshuffling...");
        }
        
        if(self.DoILikeThisWord){
            favButton.selected = YES;
        }
        else{
            favButton.selected = NO;
        }
        
        // Lookup word and meaning
        NSString *myWord = [[NSString alloc] init];
        
        if (FavsOnlyButton.selected) {
            myWord = [self.FavWordsArray objectAtIndex:randomFavIndex];
            favButton.selected = YES;
        }
        else{
            myWord = [self.wordsArray objectAtIndex:randomIndex];
        }
        
        
        CATransition *animation = [CATransition animation];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionMoveIn;
        animation.duration = 0.25;
        [textView.layer addAnimation:animation forKey:@"kCATransitionMoveIn"];
        textView.text = [[NSString alloc] initWithFormat:@"%@", myWord ];
        
        [textView setText:[[NSString alloc] initWithFormat:@"%@", myWord ] ];
//        textView.layer.cornerRadius = FLASH_CARD_RADIUS;
//        textView.layer.masksToBounds = YES;
        [textView setFont:[UIFont systemFontOfSize:56]];
        [meaningView setText:[[NSString alloc] initWithFormat:@""]];
        [sentenceView setText:[[NSString alloc] initWithFormat:@""]];
        [self refreshFavs];

    }
}

-(IBAction)showMeaning{
    
    if(gameOver == NO){
        NSString *myMeaning = [[NSString alloc] init];
        NSString *mySentence = [[NSString alloc] init];
        
        if (FavsOnlyButton.selected) {
            myMeaning = [self.FavMeaningssArray objectAtIndex:randomFavIndex];
            mySentence = [self.FavSentenceArray objectAtIndex:randomFavIndex];
        }
        else{
            myMeaning = [self.meaningsArray objectAtIndex:randomIndex];
            mySentence = [self.sentenceArray objectAtIndex:randomIndex];
        }
        
//        CATransition *animation = [CATransition animation];
//        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        animation.type = kCATransitionFade;
//        animation.duration = 0.5;
//        [meaningView.layer addAnimation:animation forKey:@"kCATransitionFade"];
//        [meaningView setText:[[NSString alloc] initWithFormat:@"%@", myMeaning ] ];
        
        
        [UILabel transitionWithView:meaningView
                           duration:0.5
                            options:(UIViewAnimationOptionTransitionCrossDissolve)
                         animations:^{
//                             textView.layer.masksToBounds = YES;
//                             textView.layer.cornerRadius = FLASH_CARD_RADIUS;
                             meaningView.text = [[NSString alloc] initWithFormat:@"%@", myMeaning ];
                             [meaningView setFont:[UIFont systemFontOfSize:18]];
                         }
                         completion:^(BOOL finished) {
                             //  Do whatever when the animation is finished
                         }];

        [UILabel transitionWithView:sentenceView
                           duration:0.5
                            options:(UIViewAnimationOptionTransitionCrossDissolve)
                         animations:^{
                             //                             textView.layer.masksToBounds = YES;
                             //                             textView.layer.cornerRadius = FLASH_CARD_RADIUS;
                             sentenceView.text = [[NSString alloc] initWithFormat:@"%@", mySentence ];
                             [sentenceView setFont:[UIFont systemFontOfSize:14]];
                         }
                         completion:^(BOOL finished) {
                             //  Do whatever when the animation is finished
                         }];
        
        //        autoPilotSwitch.on = NO;
        PlayPauseButton.selected = NO;
    }
}


# pragma AutoForward methods

//-(IBAction)flipAutoPilotSwitch:(id)sender{
//    if(autoPilotSwitch.on){
//        autoPilotLabel.text = @"▶︎▶︎: ON";
//        NSLog(@"AutoPilot ON autoPilotSpeed = %1.1f", autoPilotSpeed);
//    }
//    else
//    {
//        autoPilotLabel.text = @"▶︎▶︎: OFF";
//    }
//}

-(void) getSettings{
    
    float newautoPilotSpeed;
    NSUserDefaults *UserSettings = [NSUserDefaults standardUserDefaults];
    newautoPilotSpeed = [[UserSettings objectForKey:@"slider_preference"] floatValue];
    
    if(newautoPilotSpeed != autoPilotSpeed){
        NSLog(@"Speed changed");
        speedChanged = YES;
        autoPilotSpeed = newautoPilotSpeed;
    }
    else{
        speedChanged = NO;
    }
    
}

-(void)myTimerTick:(NSTimer *)timer{
    
    if (speedChanged == YES) {
        [timer invalidate];
        NSLog(@"Reset Time to OFF");
        // set timer with updated speed
        [NSTimer scheduledTimerWithTimeInterval:autoPilotSpeed target:self selector:@selector(myTimerTick:) userInfo:nil repeats:YES];
        speedChanged = NO;
    }
    
    NSLog(@"Ding: Speed = %1.1f",autoPilotSpeed);
    
//    if(autoPilotSwitch.on)
    if (PlayPauseButton.selected)
    {
        //        [timer invalidate]; //to stop and invalidate the timer.
        //        [NSTimer scheduledTimerWithTimeInterval:autoPilotSpeed target:self selector:@selector(myTimerTick:) userInfo:nil repeats:YES];

        [self nextword];
        [self markAsIKnowThisOne];
        
//        if(word_or_meaning == NO){
//            [self showMeaning];
//            [self markAsIKnowThisOne];
//            word_or_meaning = YES;
//        }
//        else{
//            [self nextword];
//            word_or_meaning = NO;
//        }
        
    }
    else
    {
        //        [timer invalidate]; //to stop and invalidate the timer.
    }
}

- (IBAction)PlayPauseToggle:(id)sender {
    if (!PlayPauseButton.selected) {
        NSLog(@"Play");
        PlayPauseButton.selected = !PlayPauseButton.selected;
//        [self markAsFaved];
//        autoPilotLabel.text = @"▶︎▶︎: ON";
    }
    else{
        NSLog(@"Paused");
        PlayPauseButton.selected = !PlayPauseButton.selected;
//        [self markAsUnFaved];
//        autoPilotLabel.text = @"▶︎▶︎: OFF";
    }
}

# pragma Score methods

-(void) checkAndCreateScores{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath= [documentsDirectory stringByAppendingPathComponent:@"Property List Done.plist"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success){
        NSLog(@"Score plist exists");
        return;
    }
    
    NSLog(@"Scores plist does not exist, so making one");
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Property List Done.plist"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

-(IBAction)markAsIKnowThisOne{
    // Save state
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath= [documentsDirectory stringByAppendingPathComponent:@"Property List Done.plist"];
    NSMutableArray *DoneArray = [[NSMutableArray alloc] initWithContentsOfFile:writableDBPath];
    [DoneArray replaceObjectAtIndex:randomIndex withObject:[NSNumber numberWithInteger:1]];
    [DoneArray writeToFile:writableDBPath atomically:YES];}

-(IBAction)iKnowThisONe{
    
    // Save state
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath= [documentsDirectory stringByAppendingPathComponent:@"Property List Done.plist"];
    NSMutableArray *DoneArray = [[NSMutableArray alloc] initWithContentsOfFile:writableDBPath];
    [DoneArray replaceObjectAtIndex:randomIndex withObject:[NSNumber numberWithInteger:1]];
    [DoneArray writeToFile:writableDBPath atomically:YES];
    
    [self nextword];
    
}

-(BOOL) DoIKnowAllWords{
    // Check if it's already learnt
    NSFileManager *fileManager2 = [NSFileManager defaultManager];
    NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory2 = [paths2 objectAtIndex:0];
    NSString *writableDBPath2= [documentsDirectory2 stringByAppendingPathComponent:@"Property List Done.plist"];
    NSMutableArray *DoneArray2 = [[NSMutableArray alloc] initWithContentsOfFile:writableDBPath2];
    
    for (int i=0; i<NO_OF_WORDS; i++)
    {
        if ([DoneArray2 objectAtIndexedSubscript:i ] == [NSNumber numberWithInteger:2])
        {
            return NO;
        }
    }
    return YES;
}

-(BOOL) DoIKnowThisWord{
    // Check if it's already learnt
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath= [documentsDirectory stringByAppendingPathComponent:@"Property List Done.plist"];
    NSMutableArray *DoneArray = [[NSMutableArray alloc] initWithContentsOfFile:writableDBPath];
    
    int occurrences = 0;
    for(NSNumber *whatcha in DoneArray){
        occurrences += ([whatcha isEqualToNumber:[NSNumber numberWithInt:2]]?1:0);
    }
    NSLog(@"Remainging Words = %d",occurrences);
    RemainingWords.text = [NSString stringWithFormat:@"剩余:%d",occurrences];
    
    if ([DoneArray objectAtIndexedSubscript:randomIndex] == [NSNumber numberWithInteger:1]) {
        NSLog(@"Stumbled on word I knowe already, reshuffle");
        return YES;
    }
    else{
        NSLog(@"Found new word!");
        return NO;
    }
}


# pragma Fav methods

//-(IBAction)flipFavsOnlySwitch:(id)sender {
//    if(FavsOnlySwitch.on){
//        NSLog(@"Favs Only!");
//    }
//    else
//    {
//        NSLog(@"All words!");
//    }
//}

-(void)checkAndCreateFavs{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath= [documentsDirectory stringByAppendingPathComponent:@"Property List Favs.plist"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success){
        NSLog(@"Favs plist exists");
        return;
    }
    
    NSLog(@"Favs plist does not exist, so making one");
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Property List Favs.plist"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

-(void)filterFavs:(NSString *)searchText{
    NSPredicate *predicate = [NSPredicate  predicateWithFormat:@"SELF == %d", [searchText intValue]];
    self.FavCountArray = [self.FavsArray filteredArrayUsingPredicate:predicate];
//    NSLog(@"Favs size = %d",[self.FavCountArray count]);
    
}

-(void)getFavs{
    // Check if it's already learnt
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath= [documentsDirectory stringByAppendingPathComponent:@"Property List Favs.plist"];
    self.FavsArray = [[NSMutableArray alloc] initWithContentsOfFile:writableDBPath];
    
}

-(void)populateFavs{
    
    int count = 0;
    for (int i=0; i<[self.FavsArray count]; i++) {
        if ([[self.FavsArray objectAtIndex:i] intValue] == 1) {
            [self.FavWordsArray insertObject:[self.wordsArray objectAtIndex:i] atIndex:count];
            [self.FavMeaningssArray insertObject:[self.meaningsArray objectAtIndex:i] atIndex:count];
            [self.FavSentenceArray insertObject:[self.sentenceArray objectAtIndex:i] atIndex:count];
            count++;
        }
    }
}

-(IBAction)favWordToggle:(id)sender{
    if (!favButton.selected) {
        NSLog(@"Faved!");
        favButton.selected = !favButton.selected;
        [self markAsFaved];
    }
    else{
        NSLog(@"Unfaved :(");
        favButton.selected = !favButton.selected;
        [self markAsUnFaved];
    }
}

-(IBAction)FavsOnlyToggle:(id)sender {
    
    if (!FavsOnlyButton.selected) {
        NSLog(@"Favs Only");
        FavsOnlyButton.selected = !FavsOnlyButton.selected;
        //        [self markAsFaved];
        //        autoPilotLabel.text = @"▶︎▶︎: ON";
    }
    else{
        NSLog(@"Everything");
        FavsOnlyButton.selected = !FavsOnlyButton.selected;
        //        [self markAsUnFaved];
        //        autoPilotLabel.text = @"▶︎▶︎: OFF";
    }
    
}

-(IBAction)markAsFaved{
    
    // Save state
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath= [documentsDirectory stringByAppendingPathComponent:@"Property List Favs.plist"];
    NSMutableArray *DoneArray = [[NSMutableArray alloc] initWithContentsOfFile:writableDBPath];
    [DoneArray replaceObjectAtIndex:randomIndex withObject:[NSNumber numberWithInteger:1]];
    [DoneArray writeToFile:writableDBPath atomically:YES];
    
    [self refreshFavs];
    
}

-(IBAction)markAsUnFaved{
    
    // Save state
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath= [documentsDirectory stringByAppendingPathComponent:@"Property List Favs.plist"];
    NSMutableArray *DoneArray = [[NSMutableArray alloc] initWithContentsOfFile:writableDBPath];
    [DoneArray replaceObjectAtIndex:randomIndex withObject:[NSNumber numberWithInteger:2]];
    [DoneArray writeToFile:writableDBPath atomically:YES];
    
    [self refreshFavs];
}

-(BOOL)DoILikeThisWord{
    // Check if it's already learnt
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath= [documentsDirectory stringByAppendingPathComponent:@"Property List Favs.plist"];
    NSMutableArray *DoneArray = [[NSMutableArray alloc] initWithContentsOfFile:writableDBPath];
//    
//    int occurrences = 0;
//    for(NSNumber *whatcha in DoneArray){
//        occurrences += ([whatcha isEqualToNumber:[NSNumber numberWithInt:1]]?1:0);
//    }
//    NSLog(@"Faved Words = %d",occurrences);
    
    NoOfFavs.text = [NSString stringWithFormat:@"★:%d",[self.FavCountArray count]];
    
    
    if ([DoneArray objectAtIndexedSubscript:randomIndex] == [NSNumber numberWithInteger:1]) {
        NSLog(@"Stumbled on word I like ★");
        return YES;
    }
    else{
        NSLog(@"Sorry, not a fav ☆");
        return NO;
    }
}

-(void)refreshFavs{
    [self getFavs];
    
    [self filterFavs:[NSString stringWithFormat:@"%d", 1]];
    
    [self populateFavs];
}

@end
