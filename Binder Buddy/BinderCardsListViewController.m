//
//  BinderCardsListViewController.m
//  Binder Buddy
//
//  Created by James Rodriguez on 10/21/13.
//  Copyright (c) 2013 BinderInc. All rights reserved.
//

#import "BinderCardsListViewController.h"


@interface BinderCardsListViewController ()
{
    //array for ebay card search,
    //ebaydata to hold json data,
    //array for loaded binder
    NSMutableData *EbayData;
    NSURLConnection *connection;
}
@end

@implementation BinderCardsListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

//
- (IBAction)addCard:(id)sender {
    BinderCardModel *item = [[BinderCardModel alloc]init];
    item.cardName = @"New Card";
    [self.arrayBinder addObject:item];
    
    [self.tableView reloadData];
    [self saveCardListItems];
    
    BinderCardsListViewController *nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"addCardVC"];
    
    [self.navigationController pushViewController:nextView animated:YES];
}

//location to store binder data
-(NSString *)documentsDirectory{
    return [@"~/Documents" stringByExpandingTildeInPath];
}

//file path for binder data to be toggled based which binder was selected from beginning of
//picker view default is YuGiOh for now
-(NSString *)dataFilePath{
    
     if(MYGlobalBinderIndex ==0)
     {
     return [[self documentsDirectory] stringByAppendingPathComponent:@"PokemonBinder.plist"];
     }
     else if(MYGlobalBinderIndex==1)
     {
      return [[self documentsDirectory] stringByAppendingPathComponent:@"YugiohBinder.plist"];
     }
     else
     {
     return [[self documentsDirectory] stringByAppendingPathComponent:@"MTGBinder.plist"];
     }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BinderCardModel *object = [self.arrayBinder objectAtIndex:indexPath.row];
    [self loadCardListItems];
    for(int i=0; i<self.arrayBinder.count;i++)
    {
        BinderCardModel *tempDeleteCompare = [self.arrayBinder objectAtIndex:i];
        if([object.cardName  isEqualToString: tempDeleteCompare.cardName])
        {
            [self.arrayBinder removeObjectAtIndex:i];
            [tableView reloadData];
            self.searchBar.text=@"";
            [self saveCardListItems];
            return;
        }
            
    }
    
    /*[self.arrayBinder removeObjectAtIndex:indexPath];
    [tableView reloadData];
    [self saveCardListItems];*/
    
}

//stores binder data into arrayBinder
-(void)saveCardListItems{
    NSMutableData *data =[[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self.arrayBinder forKey:@"BinderCardModel"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

//loads binder data from file path otherwise defaults binder with a single card
-(void)loadCardListItems{
    NSString *path = [self dataFilePath];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        
        self.arrayBinder = [unarchiver decodeObjectForKey:@"BinderCardModel"];
        [unarchiver finishDecoding];
    }
    else{
        BinderCardModel *item;
        self.arrayBinder = [[NSMutableArray alloc] initWithCapacity:1];
        
        for(int i=0; i<1; i++){
            
            item = [[BinderCardModel alloc] init];
            item.cardName = @"Dark Magician";
            item.cardSet = @"sye-001";
            
            [self.arrayBinder addObject:item];
        }
    }
}

//after adding an item, the recently added item is appended to the end of the table
-(void)BinderAddCardViewController:(BinderAddCardViewController *)controller didFinishAddingItem:(BinderCardModel *)item{
    int newRowIndex = [self.arrayBinder count];
    [self.arrayBinder addObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self saveCardListItems];
}

//return to last view if canceled
-(void)BinderAddCardViewControllerDidCancel:(BinderAddCardViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; //seconds
    //lpgr.delegate = self;
    [self.myTableView addGestureRecognizer:lpgr];
    //[lpgr release];
    
    //holds each card detail from ebay
    self.arrayEbay =[[NSMutableArray alloc]init];
    [self loadCardListItems];
    NSLog(@"%@",[self dataFilePath]);
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.myTableView];
    
    NSIndexPath *indexPath = [self.myTableView indexPathForRowAtPoint:p];
    
    UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:0.31 green: 0.6 blue:.1 alpha:.2];
    if (indexPath == nil)
        NSLog(@"long press on table view but not on a row");
    else
        NSLog(@"long press on table view at row %d", indexPath.row);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//if ebay response received
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [EbayData setLength:0];
}

//if ebay data received append 
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [EbayData appendData:data];
}

//if there was an error log the error
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //error message in case connection failed
    NSLog(@"Fail with error");
}

//after loading all data form ebay step through the json data
//and store the card price into newCard data type and reload table
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    //main dictionary  for json layer
    NSDictionary *allDataDictionary = [NSJSONSerialization JSONObjectWithData:EbayData options:0 error:nil];
    
    //second layer array
    NSArray *arrayfindItemsByKeywords = [allDataDictionary objectForKey:@"findItemsByKeywordsResponse"];
    
    //third layer dictionary
    NSDictionary *thirdLayer = [arrayfindItemsByKeywords objectAtIndex:0];
    NSArray *searchResult = [thirdLayer objectForKey:@"searchResult"];
    NSDictionary *fourthLayer = [searchResult objectAtIndex:0];
    NSArray *item = [fourthLayer objectForKey:@"item"];
    
    //for loop stores each cards price
    for (NSDictionary *diction in item) {
        BinderCardModel *newCard = [[BinderCardModel alloc]init];
        NSArray *sellingStatus = [diction objectForKey:@"sellingStatus"];
        NSDictionary *sellingLayer = [sellingStatus objectAtIndex:0];
        NSArray *currentPrice = [sellingLayer objectForKey:@"currentPrice"];
        NSDictionary *currentPriceLayer = [currentPrice objectAtIndex:0];
        newCard.cardPrice = [currentPriceLayer objectForKey:@"_value_"];
       
        //stores ablum instance into array
        [self.arrayEbay addObject:newCard];
    }
    //reloads table with loaded data
    [[self myTableView]reloadData];
}

//prepares card detail for bindercarddetialviewcontroller
//prepares add card for binderaddcarddetailviewcontroller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    self.searchBar.text = @"";
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.myTableView indexPathForSelectedRow];
        BinderCardModel *object = self.arrayBinder[indexPath.row];
        [self loadCardListItems ];
        [self.myTableView reloadData];
        [[segue destinationViewController] setCardDetail:object];
    }
    else if([segue.identifier isEqualToString:@"AddCard"]){
        [self loadCardListItems ];
        [self.myTableView reloadData];
        UINavigationController *navigationController = segue.destinationViewController;
        BinderAddCardViewController *controller = (BinderAddCardViewController *)navigationController.topViewController;
        controller.delegate = self;
    }
    else{
        //do nothing
    }
}

#pragma mark - Search Bar Delegation
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self loadCardListItems];
    
    NSMutableArray *searchedCards = [NSMutableArray array];
    
    
        for(BinderCardModel *object in self.arrayBinder)
        {
            
            if([searchBar.text isEqualToString:object.cardName])
            {
                [searchedCards addObject: object];
            }
        }
    
    [self.arrayBinder removeAllObjects];
    
    for(BinderCardModel *object in searchedCards){
            [self.arrayBinder addObject: object];
    }

    [self.tableView reloadData];
    
    //int newRowIndex = [searchedCards.count];
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    //NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text = @"";
    [self loadCardListItems ];
    [self.tableView endEditing:YES];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

//only 1 selection
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

//determine the number of rows that need to be made to create the tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.arrayBinder count];
}

//populates the table view with each row data
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    BinderCardModel *binder = [self.arrayBinder objectAtIndex:indexPath.row];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1081];
    UILabel *setLabel = (UILabel *)[cell viewWithTag:1082];
    UILabel *rarityLabel = (UILabel *)[cell viewWithTag:1083];
    UILabel *quantityLabel = (UILabel *)[cell viewWithTag:1084];
    //UIImage *image = (UIImage *)[cell viewWithTag:1085];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    nameLabel.text = binder.cardName;
    setLabel.text = binder.cardSet;
    rarityLabel.text = binder.cardRarity;
    quantityLabel.text = binder.cardQuantity;
   // image = binder.cardSet;

    /****************************/
    //this model needs to be changed since the data loaded is from the plist and not from the ebay
    //populated data not sure where to go from here yet tho but might need to delimit the text
    //of each row and store those object.card_____ of each component this is important for the card detail
    
    //celltext;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
