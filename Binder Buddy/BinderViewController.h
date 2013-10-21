//
//  BinderViewController.h
//  Binder Buddy
//
//  Created by James Rodriguez on 10/21/13.
//  Copyright (c) 2013 BinderInc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BinderViewController : UIViewController
- (IBAction)ViewBinder:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickCardGame;

@end
