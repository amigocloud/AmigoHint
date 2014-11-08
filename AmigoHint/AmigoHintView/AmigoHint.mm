//
//  AmigoHint.m
//  AmigoHint
//
//  Created by Victor on 11/6/14.
//  Copyright (c) 2014 AmigoCloud. All rights reserved.
//

#import "AmigoHint.h"

@implementation AmigoHintObject
@synthesize header;
@synthesize text;
@synthesize buttonPosition;
@synthesize textPosition;
@synthesize rect;
@end


@implementation AmigoHint

@synthesize wndw;
@synthesize objArray;
@synthesize backgroundColor;
@synthesize button;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.4]

#define UIColorFromRGBAlpha(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

- (id)init:(NSString*)key
{
    active = false;
    NSNumber *showTutorialOnLaunch = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (showTutorialOnLaunch == nil)
    {
        active = true;
        showTutorialOnLaunch = @YES;
        [[NSUserDefaults standardUserDefaults] setObject:showTutorialOnLaunch forKey:key];
    } else
    {
        active = false;
        return self;
    }

    hintIndex = 0;
    backgroundColor = [UIColor clearColor];
    objArray = [[NSMutableArray alloc]init];
    
    wndw = [UIApplication sharedApplication].keyWindow;
    self = [super initWithFrame:wndw.frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:UIColorFromRGB(0x000000)];
        self.opaque = NO;
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(nextMethod)
         forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];

        [wndw addSubview:self];
    }
    return self;
}

-(void)nextMethod
{
    [self nextHint];
    [self setNeedsDisplay];
}

-(void)nextHint
{
    hintIndex++;
    if(hintIndex >= [objArray count])
    {
        [self removeFromSuperview];
    } else
    {
        [self update];
    }
}

-(void)update
{
    if(!active)
        return;
    
    AmigoHintObject *obj = [objArray objectAtIndex:hintIndex];

    if(hintIndex>0)
    {
        AmigoHintObject *objLast = [objArray objectAtIndex:hintIndex-1];
        
        UILabel *oldH = objLast.header;
        [oldH removeFromSuperview];

        UILabel *oldL = objLast.text;
        [oldL removeFromSuperview];
    }
    UILabel *h = obj.header;
    [self addSubview:h];

    UILabel *l = obj.text;
    [self addSubview:l];
    
    if(hintIndex < [objArray count]-1)
        [button setTitle:@"Next" forState:UIControlStateNormal];
    else
        [button setTitle:@"Close" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blueColor]];
    
    CGRect r = wndw.frame;
    float left = r.origin.x + r.size.width*0.1;
    float right = r.origin.x + r.size.width*0.8;
    float top = r.origin.y + r.size.height*0.1;
    float bottom = r.origin.y + r.size.height*0.85;
    switch (obj.buttonPosition)
    {
        case BottomLeft:
            button.frame = CGRectMake(left, bottom, 150.0, 40.0);
            break;
            
        case BottomRight:
            button.frame = CGRectMake(right, bottom, 150.0, 40.0);
            break;
            
        case TopLeft:
            button.frame = CGRectMake(left, top, 150.0, 40.0);
            break;
            
        case TopRight:
            button.frame = CGRectMake(right, top, 150.0, 40.0);
            break;
    }
}

-(UILabel *)createLabel:(NSString*)text position:(CGPoint)position size:(int)size color:(UIColor*)color
{
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc]
     initWithString:text
     attributes:@
     {
     NSFontAttributeName: [UIFont boldSystemFontOfSize:size],
     NSForegroundColorAttributeName: color
     }];
    
    CGRect r = wndw.frame;
    CGRect labelSize = [attributedText boundingRectWithSize:CGSizeMake(r.size.width/2.0, CGFLOAT_MAX)
                            options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(position.x, position.y, labelSize.size.width, labelSize.size.height)];
    [fromLabel setText:text];
    fromLabel.font = [UIFont systemFontOfSize:size];
    fromLabel.numberOfLines = 0;
    [fromLabel setTextColor:color];
    return fromLabel;
}

-(void)addHint:(NSString*)header text:(NSString*)text buttonPosition:(AmigoHintPositionType)buttonPosition textPosition:(AmigoHintPositionType)textPosition view:(UIView*)view
{
    if(!active)
        return;

    AmigoHintObject *obj = [AmigoHintObject alloc];
    
    CGRect r = wndw.frame;
    float left = r.origin.x + r.size.width*0.1;
    float right = r.origin.x + r.size.width*0.6;
    float top = r.origin.y + r.size.height*0.1;
    float bottom = r.origin.y + r.size.height*0.6;
    float centerX = r.origin.x + r.size.width*0.25;
    float centerY = r.origin.y + r.size.height*0.25;
    CGPoint textPosH;
    CGPoint textPosT;
    switch (textPosition)
    {
        case BottomLeft:
            textPosH = CGPointMake(left, bottom);
            textPosT = CGPointMake(left, bottom+50);
            break;
            
        case BottomRight:
            textPosH = CGPointMake(right, bottom);
            textPosT = CGPointMake(right, bottom+50);
            break;
            
        case TopLeft:
            textPosH = CGPointMake(left, top);
            textPosT = CGPointMake(left, top+50);
            break;
            
        case TopRight:
            textPosH = CGPointMake(right, top);
            textPosT = CGPointMake(right, top+50);
            break;
            
        case Center:
            textPosH = CGPointMake(centerX, centerY);
            textPosT = CGPointMake(centerX, centerY+50);
            break;
            
    }

    UILabel *headerLabel = [self createLabel:header position:textPosH size:32 color:[UIColor blueColor]];
    UILabel *textLabel = [self createLabel:text position:textPosT size:24 color:[UIColor whiteColor]];
    
    CGRect vf = view.frame;
    vf.size.width *= 2;
    vf.origin.x = view.frame.origin.x - view.frame.size.width/2.0;
    vf.size.height *= 2;
    vf.origin.y = view.frame.origin.y - view.frame.size.height/2.0;
    
    obj.header = headerLabel;
    obj.text = textLabel;
    obj.rect = vf;
    obj.buttonPosition = buttonPosition;
    obj.textPosition = textPosition;
    [objArray addObject:obj];
    [self update];
}

- (void)drawRect:(CGRect)rect
{
    if(!active)
        return;

    [backgroundColor setFill];
    UIRectFill(rect);

    AmigoHintObject *obj = [objArray objectAtIndex:hintIndex];
    
    CGRect holeRect = obj.rect;
    
    // Draw Circles
    CGPoint center = CGPointMake(holeRect.origin.x + holeRect.size.width / 2.0, holeRect.origin.y + holeRect.size.height / 2.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    CGContextSetStrokeColorWithColor(ctx, [UIColorFromRGB(0x0050ff) CGColor]);

    float step=10;
    float size = holeRect.size.width * 0.9;
    float scale = size*0.6;
    for(int i=0; i<=3; i++)
    {
        CGContextSetLineWidth(ctx, i*2);
        CGContextAddArc(ctx, center.x, center.y, scale, 0, 2*M_PI, 0);
        CGContextStrokePath(ctx);
        scale += step;
    }

    // Draw hole
    float sizeHole = holeRect.size.width * 1.0;
    float alpha = 0.4;
    for(int i=0; i<50; i++)
    {
        CGRect holeRectRound = CGRectMake(center.x-sizeHole/2.0, center.y-sizeHole/2.0, sizeHole, sizeHole);
        CGRect holeRectIntersection = CGRectIntersection( holeRectRound, rect );
        [[UIBezierPath bezierPathWithRoundedRect:holeRectIntersection cornerRadius:holeRect.size.height] addClip];
        UIColor *color= [UIColor colorWithWhite:0 alpha:alpha];
        [color setFill];
        UIRectFill(holeRectIntersection);
        sizeHole -= 1;
        alpha -= 0.008;
    }
}


@end
