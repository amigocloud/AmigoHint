//
//  ViewController.m
//  AmigoHint
//
//  Created by Victor on 11/6/14.
//  Copyright (c) 2014 AmigoCloud. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

@synthesize hintView;
@synthesize button1;
@synthesize button2;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) viewDidAppear:(BOOL)animated
{
    hintView = [[AmigoHint alloc] init:@"TestHint1"];
    [hintView addHint:@"Hint for button 1"
                 text:@"Some text\nSecond line of text"
                buttonPosition:AmigoHintPosition_Bottom|AmigoHintPosition_Right
                textPosition:AmigoHintPosition_Top|AmigoHintPosition_Right
                 view:button1];
    
    [hintView addHint:@"Hint for button 2"
                 text:@"Another text\n - second line of text\n - third Line"
       buttonPosition:AmigoHintPosition_Bottom|AmigoHintPosition_Left
         textPosition:AmigoHintPosition_Top|AmigoHintPosition_Left
                 view:button2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
