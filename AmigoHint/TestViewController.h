//
//  ViewController.h
//  AmigoHint
//
//  Created by Victor on 11/6/14.
//  Copyright (c) 2014 AmigoCloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AmigoHint.h"

@interface TestViewController : UIViewController
{
    AmigoHint *hintView;
    UIButton *button1;
    UIButton *button2;
}

@property (retain, nonatomic) AmigoHint *hintView;
@property (retain, nonatomic) IBOutlet UIButton *button1;
@property (retain, nonatomic) IBOutlet UIButton *button2;

@end

