//
//  BinderViewController.m
//  Binder Buddy
//
//  Created by James Rodriguez on 10/21/13.
//  Copyright (c) 2013 BinderInc. All rights reserved.
//

#import "BinderViewController.h"

@interface BinderViewController ()

@end

@implementation BinderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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

-(IBAction)readPressed
{
    CardGamesController *gameController = [CardGamesController getCardGames];
    
    int index = [self.picker selectedRowInComponent:0];
    gameController.currentGame = [gameController.cardGames objectAtIndex:index];
    
    /*BinderCardsListViewController *nextView = [self.storyboard instantiateViewControllerWithIdentifier:@"binderCardsListVC"];
    
    [self.navigationController pushViewController:nextView animated:YES];*/
}

@end
