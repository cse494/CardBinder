//
//  BinderViewController.m
//  Binder Buddy
//
//  Created by James Rodriguez on 10/21/13.
//  Copyright (c) 2013 BinderInc. All rights reserved.
//

#import "BinderViewController.h"
#import "BinderCurrentTradeHandler.h"

@interface BinderViewController ()

@end

@implementation BinderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    BinderCurrentTradeHandler *trade = [BinderCurrentTradeHandler sharedTrade];
    trade.currentTrade = [[NSMutableArray alloc] init];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ViewBinder:(UIButton *)sender
{
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [CardGamesController getCardGames].cardGames.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[CardGamesController getCardGames].cardGames objectAtIndex:row];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"BinderSegue"])
    {
        CardGamesController *gameController = [CardGamesController getCardGames];
        
        int index = [self.picker selectedRowInComponent:0];
        MYGlobalBinderIndex = index;
        gameController.currentGame = [gameController.cardGames objectAtIndex:index];
    }
    
}

//delete this function and instead add prepare for segue
-(IBAction)readPressed
{
    CardGamesController *gameController = [CardGamesController getCardGames];
    
    int index = [self.picker selectedRowInComponent:0];
    MYGlobalBinderIndex = index;
    gameController.currentGame = [gameController.cardGames objectAtIndex:index];
    
    /*BinderCardsListViewController *nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"binderCardsListVC"];
    
    [self.navigationController pushViewController:nextView animated:YES];*/
}

@end
