//
//  BinderCardDetailViewController.m
//  Binder Buddy
//
//  Created by James Rodriguez on 10/21/13.
//  Copyright (c) 2013 BinderInc. All rights reserved.
//

#import "BinderCardDetailViewController.h"
#import "BinderCurrentTradeHandler.h"

NSString *counter = @"";
NSMutableArray *valueArray;
@interface BinderCardDetailViewController ()
-(void)configureView;
@end

@implementation BinderCardDetailViewController

#pragma mark - Managing the card item

//checks if card detail is the same item if not repopulate with new data
-(void)setCardDetail:(id)newCardDetail{
    if(_cardDetail != newCardDetail)
    {
        _cardDetail = newCardDetail;
        [self performSearchForCard];
    }
}
-(void) loadImage
{
    
    self.cardImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.cardDetail.cardImageURL]];
}

//takes the card information stored in cardDetail and sets the labels
//todo function to calculate the differing prices, and using trollandtoad api
//for card text
-(void)configureView{
    //update the card detail interface with the card item
    
    if(self.cardDetail){
        
        self.cardName.text = self.cardDetail.cardName;
        self.cardRarity.text = self.cardDetail.cardRarity;
        self.cardSet.text = self.cardDetail.cardSet;
        self.cardImage.image = self.cardDetail.cardImage;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//load initial view upon loading view
- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self performSearchForCard];
	// Do any additional setup after loading the view.
    //[self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)AddToTrade:(id)sender{
    BinderCardModel *item = self.cardDetail;
    item.cardPrice = [NSString stringWithFormat:@"%g", self.cardPrice];
    item.cardQuantity = self.cardQuantityToAdd.text;
    BinderCurrentTradeHandler *trade = [BinderCurrentTradeHandler sharedTrade];
    [trade.currentTrade addObject:item];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Added"
                                                   message: @"Card has been added to Trade"
                                                  delegate: self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"OK",nil];
    
    [alert show];
    
}

-(void) performSearchForCard
{
    //[results removeAllObjects];
    //[self.tableView reloadData];
    
    //configure the spinner
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    
    //go to a background thread so we don't block
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *query = [NSString stringWithFormat:@"http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=JamesRod-e299-4b0d-aa2c-cbc6feed4d6a&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&keywords=-lot -x2 -x3 -grabbab -collection -binder -playset %@ %@", self.cardDetail.cardName, self.cardDetail.cardSet];
        
        query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *url = [NSURL URLWithString:query];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        [self processData:data];
                
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^(void) {
                    [self loadImage];
                });
            [spinner stopAnimating];
            [self configureView];
        });
    });
    
}

- (IBAction)alertFeatures
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Buy it now"
                                                    message:@"This feature is coming soon"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    //[alert release];
}
-(void) processData:(NSData *)searchData
{
    double sum = 0.0;
    double max = 0.0;
    double min = DBL_MAX;
    double recent = 0.0;
    //parse and process the server reply
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:searchData options:kNilOptions error:nil];
    
    //ignore some of the basic results
    NSDictionary *topLevelResults = json[@"findItemsByKeywordsResponse"];
    
    for(NSDictionary *searchResults in topLevelResults)
    {
        NSLog(@"%@", searchResults[@"searchResult"]);
        for(NSDictionary *items in searchResults[@"searchResult"])
        {
            counter = items[@"@count"];
            valueArray = [[NSMutableArray alloc] initWithCapacity:counter.integerValue];
            for(NSDictionary *autoPayArray in items[@"item"])
            {
                if(self.cardDetail.cardImageURL == nil)
                {
                   
                    NSArray *tempGalleryArray = [autoPayArray objectForKey:@"galleryURL"];
                    NSString *tempImage = [tempGalleryArray objectAtIndex:0];
                    //newCard.cardPrice = [currentPriceLayer objectForKey:@"_value_"];
                    NSURL *tempImageUrl = [NSURL URLWithString:tempImage];
                    self.cardDetail.cardImageURL = tempImageUrl;
                }
                for(NSDictionary *autoPay in autoPayArray[@"sellingStatus"])
                {
                    for(NSDictionary *values in autoPay[@"convertedCurrentPrice"])
                    {
                        NSString *value = values[@"__value__"];
                        [valueArray addObject:[NSNumber numberWithDouble:value.doubleValue]];
                        if(recent == 0.0)
                        {
                            recent = [value doubleValue];
                            self.cardPrice = [value doubleValue];
                        }
                    }
                    
                }
            }
            
        }
        
    }
  

    for(NSNumber* num in valueArray)
    {
        double value = [num doubleValue];
        if(value > max)
            max = value;
        if(value < min)
            min = value;
        
        sum += value;
    }
    double average = sum/counter.doubleValue;
    self.maxPrice.text =[NSString stringWithFormat:@"%.02f", max];
    self.minPrice.text =[NSString stringWithFormat:@"%.02f", min];
    self.averagePrice.text =[NSString stringWithFormat:@"%.02f", average];
    self.recentPrice.text = [NSString stringWithFormat:@"%.02f", recent];
 
    NSLog(@"");

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showWeb"]) {
        
        BinderBuyCardViewController *bbcvc = [segue destinationViewController];
        bbcvc.cardName = self.cardDetail.cardName;
        bbcvc.cardSet = self.cardDetail.cardSet; 
    }
}

@end
