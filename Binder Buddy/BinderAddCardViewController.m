//
//  BinderAddCardViewController.m
//  Binder Buddy
//
//  Created by James Rodriguez on 10/21/13.
//  Copyright (c) 2013 BinderInc. All rights reserved.
//

#import "BinderAddCardViewController.h"

@interface BinderAddCardViewController ()

@end

@implementation BinderAddCardViewController

@synthesize addCardNameText;
@synthesize addCardRarityText;
@synthesize addCardSetText;
@synthesize addCardQuantityText;
/*
//Default style for tableview
- (id)initWithStyle:(UIView)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/
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
	// Do any additional setup after loading the view.
}

//set input default to card name text input box
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.addCardNameText becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//cancel button returns to last screen
-(IBAction)Cancel:(id)sender{
    [self.delegate BinderAddCardViewControllerDidCancel:self];
}

//add card button saves the data from each of the input text fields
-(IBAction)Save:(id)sender{
    //stores card item
    BinderCardModel *item = [[BinderCardModel alloc]init];
    
    item.cardName = self.addCardNameText.text;
    item.cardSet = self.addCardSetText.text;
    item.cardRarity = self.addCardRarityText.text;
    item.cardQuantity = self.addCardQuantityText.text;
    
    //calls didFinishAddingItem function passing item name
    [self.delegate BinderAddCardViewController:self didFinishAddingItem:item];
}

/*
 
-(IBAction)DidTypeInSearchBar{
 
    array  
    for(i=0;i<arrayCardDatabase.count;i++)
    {
        if(strcompare(arraybinder.name, searchedParameter) >= searchedPrameter.strlegnth)
        {
            display possible names as drop down
        }
    }
 
    display names
    reload view
 
 }
*/


-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
@end
