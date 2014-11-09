//
//  AmigoHint.h
//  AmigoHint
//
//  Created by Victor on 11/6/14.
//  Copyright (c) 2014 AmigoCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

enum AmigoHintPositionType
{
    AmigoHintPosition_Bottom = 0x01,
    AmigoHintPosition_Top = 0x02,
    AmigoHintPosition_Right = 0x04,
    AmigoHintPosition_Left = 0x08,
    AmigoHintPosition_CenterX = 0x10,
    AmigoHintPosition_CenterY = 0x20
};

@interface AmigoHintObject : NSObject
{
    NSString *headerStr;
    NSString *textStr;
    int buttonPosition;
    int textPosition;
    UIView *view;
    
    CGRect  rect;
    UILabel *header;
    UILabel *text;
}

@property (retain, nonatomic) NSString *headerStr;
@property (retain, nonatomic) NSString *textStr;
@property (retain, nonatomic) UIView *view;

@property (nonatomic) CGRect rect;
@property (retain, nonatomic) UILabel *header;
@property (retain, nonatomic) UILabel *text;
@property (nonatomic) int buttonPosition;
@property (nonatomic) int textPosition;

@end

typedef void (^completeCallback)(void);

@interface AmigoHint : UIView
{
    UIWindow* wndw;
    
    NSMutableArray *objArray;
    UIColor *backgroundColor;
    UIButton *prevButton;
    UIButton *nextButton;
    
    int hintIndex;
    bool active;

    completeCallback callback;
    
}

-(id)init:(NSString*)key complete:( void ( ^ )( void ) )complete;
                                   
-(void)addHint:(NSString*)header text:(NSString*)text buttonPosition:(int)buttonPosition textPosition:(int)textPosition view:(UIView*)view;

@property (retain, nonatomic) UIWindow* wndw;
@property (retain, nonatomic) NSMutableArray *objArray;
@property (retain, nonatomic) UIColor *backgroundColor;
@property (retain, nonatomic) UIButton *prevButton;
@property (retain, nonatomic) UIButton *nextButton;

@end
