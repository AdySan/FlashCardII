//
//  FavsTableViewController.m
//  FlashCards
//
//  Created by Aditya Tannu on 10/25/14.
//  Copyright (c) 2014 Aditya Tannu. All rights reserved.
//

#import "FavsTableViewController.h"

@interface FavsTableViewController ()

@property (strong, nonatomic) NSArray *wordsArray;
@property (strong, nonatomic) NSArray *meaningsArray;
@property (strong, nonatomic) NSArray *FavCountArray;
@property (strong, nonatomic) NSArray *FavsArray;
@property (strong, nonatomic) NSMutableArray *FavWordsArray;
@property (strong, nonatomic) NSMutableArray *FavMeaningssArray;

@end

@implementation FavsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"Property List Words" ofType:@"plist"];
    self.wordsArray = [[NSMutableArray alloc] initWithContentsOfFile:path1];
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"Property List Meanings" ofType:@"plist"];
    self.meaningsArray = [[NSMutableArray alloc] initWithContentsOfFile:path2];
   
    [self getFavs];
    
    [self filterFavs:[NSString stringWithFormat:@"%d", 1]];
    
    self.FavWordsArray = [[NSMutableArray alloc] init];
    self.FavMeaningssArray = [[NSMutableArray alloc] init];
    [self populateFavs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getFavs{
    // Check if it's already learnt
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath= [documentsDirectory stringByAppendingPathComponent:@"Property List Favs.plist"];
    self.FavsArray = [[NSMutableArray alloc] initWithContentsOfFile:writableDBPath];

}

-(void) populateFavs{

    int count = 0;
    for (int i=0; i<[self.FavsArray count]; i++) {
        if ([[self.FavsArray objectAtIndex:i] intValue] == 1) {
            [self.FavWordsArray insertObject:[self.wordsArray objectAtIndex:i] atIndex:count];
            [self.FavMeaningssArray insertObject:[self.meaningsArray objectAtIndex:i] atIndex:count];
            count++;
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    
    return [self.FavWordsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [self.FavWordsArray objectAtIndex: indexPath.row];
    cell.detailTextLabel.text = [self.FavMeaningssArray objectAtIndex:indexPath.row];

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma Filter Favs

-(void)filterFavs:(NSString *)searchText
{
    NSPredicate *predicate = [NSPredicate  predicateWithFormat:@"SELF == %d", [searchText intValue]];
    self.FavCountArray = [self.FavsArray filteredArrayUsingPredicate:predicate];
    NSLog(@"Favs size = %d",[self.FavCountArray count]);

}

@end
