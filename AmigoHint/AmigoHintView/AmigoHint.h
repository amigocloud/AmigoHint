//
//  AmigoHint.h
//  AmigoHint
//
//  Created by Victor on 11/6/14.
//  Copyright (c) 2014 AmigoCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AmigoHintObject : NSObject
{
    CGRect  rect;
    UILabel *header;
    UILabel *text;
    int     buttonPosition;
    int     textPosition;
}

@property (nonatomic) CGRect rect;
@property (retain, nonatomic) UILabel *header;
@property (retain, nonatomic) UILabel *text;
@property (nonatomic) int buttonPosition;
@property (nonatomic) int textPosition;

@end

@interface AmigoHint : UIView
{
    UIWindow* wndw;
    UIButton *nextButton;
    
    NSMutableArray *objArray;
    UIColor *backgroundColor;
    UIButton *button;
    
    int hintIndex;
    bool active;
}

typedef NS_ENUM(NSInteger, AmigoHintPositionType) {
    BottomLeft = 0,
    BottomRight = 1,
    TopLeft = 2,
    TopRight = 3,
    Center = 4
};

-(id)init:(NSString*)key;
-(void)addHint:(NSString*)header text:(NSString*)text buttonPosition:(AmigoHintPositionType)buttonPosition textPosition:(AmigoHintPositionType)textPosition view:(UIView*)view;

@property (retain, nonatomic) UIWindow* wndw;
@property (retain, nonatomic) NSMutableArray *objArray;
@property (retain, nonatomic) UIColor *backgroundColor;
@property (retain, nonatomic) UIButton *button;

@end
