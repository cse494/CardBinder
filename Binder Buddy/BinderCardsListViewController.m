//
//  BinderCardsListViewController.m
//  Binder Buddy
//
//  Created by James Rodriguez on 10/21/13.
//  Copyright (c) 2013 BinderInc. All rights reserved.
//

#import "BinderCardsListViewController.h"
#import "BinderCardDetailViewController.h"
#import "CardListItem.h"

@interface BinderCardsListViewController ()
{
    //array for ebay card search,
    //ebaydata to hold json data,
    //array for loaded binder
    NSMutableData *EbayData;
    NSURLConnection *connection;
    NSMutableArray *arrayBinder;
    NSMutableArray *arrayEbay;
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
    CardListItem *item = [[CardListItem alloc]init];
    item.text = @"New Card";
    [arrayBinder addObject:item];
    
    [self.tableView reloadData];
    [self saveCardListItems];
    
}

//location to store binder data
-(NSString *)documentsDirectory{
    return [@"~/Documents" stringByExpandingTildeInPath];
}

//file path for binder data to be toggled based which binder was selected from beginning of
//picker view default is YuGiOh for now
-(NSString *)dataFilePath{
    return [[self documentsDirectory] stringByAppendingPathComponent:@"YugiohBinder.plist"];
}

//stores binder data into arrayBinder 
-(void)saveCardListItems{
    NSMutableData *data =[[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:arrayBinder forKey:@"CardListItems"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}

//loads binder data from file path otherwise defaults binder with a sinle card
-(void)loadCardListItems{
    NSString *path = [self dataFilePath];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        
        arrayBinder = [unarchiver decodeObjectForKey:@"CardListItems"];
        [unarchiver finishDecoding];
    }
    else{
        CardListItem *item;
        arrayBinder = [[NSMutableArray alloc] initWithCapacity:1];
        
        for(int i=0; i<1; i++){
            
            item = [[CardListItem alloc] init];
            item.text = @"New card";
            
            [arrayBinder addObject:item];
        }
    }
    
}

//after adding an item, the recently added item is appended to the end of the table
-(void)BinderAddCardViewController:(BinderAddCardViewController *)controller didFinishAddingItem:(CardListItem *)item{
    int newRowIndex = [arrayBinder count];
    [arrayBinder addObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//return to last view if canceled
-(void)BinderAddCardViewControllerDidCancel:(BinderAddCardViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //holds each card detail from ebay
    arrayEbay =[[NSMutableArray alloc]init];
    [self loadCardListItems];
    NSLog(@"%@",[self dataFilePath]);
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
        //NSDictionary *imageURL = [diction objectForKey:@"im:image"];
        //NSDictionary *imageSize = [imageURL objectForKey:@"2"];
        //newAlbum.imageURL = [imageSize objectForKey:@"label"];
        NSArray *sellingStatus = [diction objectForKey:@"sellingStatus"];
        NSDictionary *sellingLayer = [sellingStatus objectAtIndex:0];
        NSArray *currentPrice = [sellingLayer objectForKey:@"currentPrice"];
        NSDictionary *currentPriceLayer = [currentPrice objectAtIndex:0];
        newCard.cardPrice = [currentPriceLayer objectForKey:@"_value_"];
       
        //stores ablum instance into array
        [arrayEbay addObject:newCard];
    }
    //reloads table with loaded data
    [[self myTableView]reloadData];
}

//prepares card detail for bindercarddetialviewcontroller
//prepares add card for binderaddcarddetailviewcontroller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.myTableView indexPathForSelectedRow];
        BinderCardModel *object = arrayEbay[indexPath.row];
        
        [arrayEbay removeAllObjects];
        
        NSString *ebayurl = [NSString stringWithFormat:@"http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=JamesRod-e299-4b0d-aa2c-cbc6feed4d6a&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&keywords=%@ %@", object.cardName, object.cardSet];
        NSURL *url = [NSURL URLWithString:ebayurl];
        /* NSURL *url = [NSURL URLWithString:@"http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=JamesRod-e299-4b0d-aa2c-cbc6feed4d6a&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&keywords=" & object.cardName & " " & object.cardSet]];*/
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        connection = [NSURLConnection connectionWithRequest:request delegate:self];
        
        if(connection){
            EbayData=[[NSMutableData alloc]init];
        }
        
        [[segue destinationViewController] setCardDetail:object];
    }
    else if([segue.identifier isEqualToString:@"AddCard"]){
        
        UINavigationController *navigationController = segue.destinationViewController;
        BinderAddCardViewController *controller = (BinderAddCardViewController *)navigationController.topViewController;
        controller.delegate = self;
    }
    else{
        //do nothing
    }
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
    return arrayBinder.count;
}

//populates the table view with each row data
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
   
    /****************************/
    //this model needs to be changed since the data loaded is from the plist and not from the ebay
    //populated data not sure where to go from here yet tho but might need to delimit the text
    //of each row and store those object.card_____ of each component this is important for the card detail
    BinderCardModel *object = arrayBinder[indexPath.row];
    
    //NSString *celltext=[NSString stringWithFormat:@"%@/n%@/n%@/n%@",object.cardName,object.cardSet, object.cardRarity, object.cardQuantity];
    
    cell.textLabel.text = @"Hello world";
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
