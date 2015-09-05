//
//  SettingsViewController.m
//  FlashCards
//
//  Created by Aditya Tannu on 10/11/14.
//  Copyright (c) 2014 Aditya Tannu. All rights reserved.
//

#import "SettingsViewController.h"
#import "ViewController.h"

@interface SettingsViewController ()

@property (strong, nonatomic) NSArray *wordsArray;
@property (strong, nonatomic) NSArray *meaningsArray;
@property (strong, nonatomic) NSArray *searchResultsArray;
@property (strong, nonatomic) NSArray *searchResultsMeaningsArray;

@end

@implementation SettingsViewController

- (IBAction)getMySettings {
    
    float newautoPilotSpeed;
    NSUserDefaults *UserSettings = [NSUserDefaults standardUserDefaults];
    newautoPilotSpeed = [[UserSettings objectForKey:@"slider_preference"] floatValue];

    autoPilotSlider.value = newautoPilotSpeed;
    autoPilotSpeedValue.text = [NSString stringWithFormat:@"%1.1f秒",autoPilotSlider.value];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//        UIVisualEffect *blurEffect;
//        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        UIVisualEffectView *visualEffectView;
//        visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        visualEffectView.frame = self.view.bounds;
//        [backgroundImage addSubview:visualEffectView];
    
    self.getMySettings;
    
    
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"Property List Words" ofType:@"plist"];
    self.wordsArray = [[NSMutableArray alloc] initWithContentsOfFile:path1];

    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"Property List Meanings" ofType:@"plist"];
    self.meaningsArray = [[NSMutableArray alloc] initWithContentsOfFile:path2];
    
    
    self.searchResultsArray = [[NSArray alloc] init];
    self.searchResultsMeaningsArray = [[NSArray alloc] init];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    self.getMySettings;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//-(IBAction)saveAutoPilotSpeed{
//    
//    // Save state
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *writableDBPath= [documentsDirectory stringByAppendingPathComponent:@"Settings.plist"];
//    NSMutableArray *DoneArray = [[NSMutableArray alloc] initWithContentsOfFile:writableDBPath];
//    [DoneArray replaceObjectAtIndex:0 withObject:[NSNumber numberWithInteger:1]];
//    [DoneArray writeToFile:writableDBPath atomically:YES];
//}


- (IBAction)setSettings{

    NSUserDefaults *UserSettings = [NSUserDefaults standardUserDefaults];
    [UserSettings setObject:[NSNumber numberWithFloat:autoPilotSlider.value] forKey:@"slider_preference" ];
    
}

- (IBAction)initList:(id)sender {

        BOOL success;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath= [documentsDirectory stringByAppendingPathComponent:@"Property List Done.plist"];
        success = [fileManager fileExistsAtPath:writableDBPath];
        if (success){
            NSLog(@"plist exists");
            NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Property List Done.plist"];
            [fileManager removeItemAtPath:writableDBPath error:&error];
            if (!success) {
                NSAssert1(0, @"Failed to delete writable database file with message '%@'.", [error localizedDescription]);
            }
            success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
            if (!success) {
                NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
            }
            
            return;
        }
        
        NSLog(@"plist does not exist, so making a blank one");
        // The writable database does not exist, so copy the default to the appropriate location.
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Property List Done.plist"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
   
}

- (IBAction)initScores:(id)sender {
    
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath= [documentsDirectory stringByAppendingPathComponent:@"Property List Favs.plist"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success){
        NSLog(@"Favs.plist exists");
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Property List Favs.plist"];
        [fileManager removeItemAtPath:writableDBPath error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to delete writable database file with message '%@'.", [error localizedDescription]);
        }
        success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
        
        return;
    }
    
    NSLog(@"plist does not exist, so making a blank one");
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Property List Favs.plist"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    
}

- (IBAction)autoPilotSliderMoved:(id)sender {
    autoPilotSpeedValue.text = [NSString stringWithFormat:@"%1.1f秒",autoPilotSlider.value];
 
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath= [documentsDirectory stringByAppendingPathComponent:@"Settings.plist"];
    NSMutableArray *SettingsArray = [[NSMutableArray alloc] initWithContentsOfFile:writableDBPath];
    [SettingsArray replaceObjectAtIndex:0 withObject:[NSNumber numberWithFloat:autoPilotSlider.value]];
    [SettingsArray writeToFile:writableDBPath atomically:YES];
    self.setSettings;
    NSLog(@"Chaging Speed to %1.1f",autoPilotSlider.value);
    
}


#pragma TableView methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResultsArray count];
    }
    else {
        return [self.wordsArray count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }  
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [self.searchResultsArray objectAtIndex:indexPath.row];
       
        NSUInteger originalIndex = [self.wordsArray indexOfObject:cell.textLabel.text];
        cell.detailTextLabel.text = [self.meaningsArray objectAtIndex:originalIndex];

        
    }
    else{
    cell.textLabel.text = [self.wordsArray objectAtIndex: indexPath.row];
        cell.detailTextLabel.text = [self.meaningsArray objectAtIndex:indexPath.row];
    }
    return cell;
}

//-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    if (indexPath.row == 0) {
////        return nil;
////    }
////    else{
//        return indexPath;
////    }
//}
//
//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *rowWord = self.wordsArray [indexPath.row];
//    
//    //    NSString *rowMeaning = self.meaningsArray [indexPath.row];
//    
////    NSUInteger originalIndex = [self.wordsArray indexOfObject:rowWord];
////    NSLog(@"Index = %d",originalIndex);
//    
////    NSString *rowMeaning = [self.meaningsArray objectAtIndex:originalIndex];
//    
//    
////    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:rowWord message:rowMeaning delegate:nil cancelButtonTitle:@"Got it" otherButtonTitles:nil, nil];
//    
////    [alert show];
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//}

#pragma Search Methods

-(void)filterContentforSearchText:(NSString *)searchText scope:(NSString *)scope
{
    NSPredicate *predicate = [NSPredicate  predicateWithFormat:@"SELF beginswith[c] %@", searchText];
    self.searchResultsArray = [self.wordsArray filteredArrayUsingPredicate:predicate];
//    self.searchResultsMeaningsArray = [self.meaningsArray filteredArrayUsingPredicate:predicate];
    
  
}

-(bool)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentforSearchText:searchString  scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES; 
}

@end
