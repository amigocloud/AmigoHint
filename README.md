AmigoHint
=========

#### What is AmigoHint

AmigoHint is the Objective-C++ library that makes development of an on-screen help easy for iOS devices. 

#### Example
```obj-c
hintView = [[AmigoHint alloc] init:@"TestHint2" complete:^
{
    printf("Hint complete!\n");
}];

[hintView addHint:@"Hint for button 1"
            text:@"Button1 will do some actions"
            buttonPosition:AmigoHintPosition_Bottom
            textPosition:AmigoHintPosition_Top|AmigoHintPosition_Right
            view:button1];

[hintView addHint:@"Hint for button 2"
            text:@"Button2 will do another action"
            buttonPosition:AmigoHintPosition_Bottom
            textPosition:AmigoHintPosition_Top|AmigoHintPosition_Left
            view:button2];
```
