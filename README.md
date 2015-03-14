AmigoHint
=========

AmigoHint is the Objective-C++ library that makes development of the on screen help easy. 

Here is a little example of hint for two buttons:

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

