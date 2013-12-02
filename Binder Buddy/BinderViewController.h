//
//  BinderViewController.h
//  Binder Buddy
//
//  Created by James Rodriguez on 10/21/13.
//  Copyright (c) 2013 BinderInc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardGamesController.h"
#import "BinderCardsListViewController.h"

extern NSInteger MYGlobalBinderIndex;

@interface BinderViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

- (IBAction)ViewBinder:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property(nonatomic, assign) int *binderIndex;

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

@end

NSInteger MYGlobalBinderIndex;