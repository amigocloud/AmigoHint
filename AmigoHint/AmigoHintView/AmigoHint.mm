//
//  AmigoHint.m
//  AmigoHint
//
//  Created by Victor on 11/6/14.
//  Copyright (c) 2014 AmigoCloud. All rights reserved.
//

#import "AmigoHint.h"

@implementation AmigoHintObject
@synthesize headerStr;
@synthesize textStr;
@synthesize view;
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
@synthesize nextButton;
@synthesize prevButton;

#define BG_ALPHA 0.6

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:BG_ALPHA]

#define UIColorFromRGBAlpha(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define BLUE_COLOR UIColorFromRGBAlpha(0x74c9cd)

- (id)init:(NSString*)key complete:( void ( ^ )( void ) )complete;
{
    callback = complete;
    
    active = true;
#if 1
    NSNumber *showTutorialOnLaunch = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (showTutorialOnLaunch == nil)
    {
        active = true;
        showTutorialOnLaunch = @YES;
        [[NSUserDefaults standardUserDefaults] setObject:showTutorialOnLaunch forKey:key];
    } else
    {
        active = false;
        if(callback!=nil)
            callback();
        return self;
    }
#endif
    
    hintIndex = 0;
    backgroundColor = [UIColor clearColor];
    objArray = [[NSMutableArray alloc]init];
    
    wndw = [UIApplication sharedApplication].keyWindow;
    self = [super initWithFrame:wndw.frame];
        
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.contentMode = UIViewContentModeRedraw;
    
    if (self) {
        // Initialization code
        [self setBackgroundColor:UIColorFromRGB(0x000000)];
        self.opaque = NO;

        prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [prevButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [prevButton setBackgroundColor:BLUE_COLOR];
        [prevButton setTitle:@"Previous" forState:UIControlStateNormal];
        [prevButton addTarget:self action:@selector(prevMethod)
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:prevButton];
        
        nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [nextButton setBackgroundColor:BLUE_COLOR];
        [nextButton addTarget:self action:@selector(nextMethod)
         forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextButton];

        [wndw addSubview:self];
    }
    return self;
}

-(void)prevMethod
{
    [self prevHint];
}

-(void)nextMethod
{
    [self nextHint];
}

-(void)prevHint
{
    if([objArray count] > 0)
    {
        AmigoHintObject *obj = [objArray objectAtIndex:hintIndex];
        
        UILabel *oldH = obj.header;
        [oldH removeFromSuperview];
        
        UILabel *oldL = obj.text;
        [oldL removeFromSuperview];
    }
    
    if(hintIndex > 0)
        hintIndex--;
    
    [self update];
}

-(void)nextHint
{
    if([objArray count] > 0)
    {
        AmigoHintObject *obj = [objArray objectAtIndex:hintIndex];
        
        UILabel *oldH = obj.header;
        [oldH removeFromSuperview];
        
        UILabel *oldL = obj.text;
        [oldL removeFromSuperview];
    }
    
    hintIndex++;
    if(hintIndex >= [objArray count])
    {
        [self removeFromSuperview];
        if(callback!=nil)
            callback();
        
    } else
    {
        [self update];
    }
}

-(void)update
{
    if(!active || [objArray count] == 0)
        return;
    
    AmigoHintObject *obj = [objArray objectAtIndex:hintIndex];

    UILabel *oldH = obj.header;
    if(oldH!=nil)
        [oldH removeFromSuperview];
    
    UILabel *oldL = obj.text;
    if(oldL!=nil)
        [oldL removeFromSuperview];
    
    [self updateElements];

    UILabel *hl = obj.header;
    [self addSubview:hl];

    UILabel *tl = obj.text;
    [self addSubview:tl];
    
    if(hintIndex==0)
        prevButton.hidden=true;
    else
        prevButton.hidden=false;
    
    if(hintIndex < [objArray count]-1)
    {
        [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    }
    else
    {
        [nextButton setTitle:@"Close" forState:UIControlStateNormal];
    }
    
    CGRect r = wndw.frame;
    
    // Button positions for iPhone
    float left = r.origin.x + r.size.width*0.1;
    float right = r.origin.x + r.size.width*0.6;
    float top = r.origin.y + r.size.height*0.1;
    float bottom = r.origin.y + r.size.height*0.8;
    float centerY = r.origin.y + r.size.height*0.6;
    float buttonWidth = 100;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        // Button positions for iPad
        right = r.origin.x + r.size.width*0.8;
        centerY = r.origin.y + r.size.height*0.7;
        buttonWidth = 150;
    }
    
    float y;
    
    if(obj.buttonPosition&AmigoHintPosition_Top)
        y = top;
    
    if(obj.buttonPosition&AmigoHintPosition_Bottom)
        y = bottom;
    
    if(obj.buttonPosition&AmigoHintPosition_CenterY)
        y = centerY;

    prevButton.frame = CGRectMake(left, y, buttonWidth, 40.0);
    nextButton.frame = CGRectMake(right, y, buttonWidth, 40.0);

    [self setNeedsDisplay];
}

-(void)updateElements
{
    if(!active)
        return;
    
    AmigoHintObject *obj = [objArray objectAtIndex:hintIndex];
    
    CGRect r = wndw.frame;
    float left = r.origin.x + r.size.width*0.1;
    float right = r.origin.x + r.size.width*0.6;
    float top = r.origin.y + r.size.height*0.2;
    float bottom = r.origin.y + r.size.height*0.6;
    float centerX = r.origin.x + r.size.width*0.25;
    float centerY = r.origin.y + r.size.height*0.25;
    CGPoint textPosH;
    CGPoint textPosT;
    
    float x, y;
    
    if(obj.textPosition&AmigoHintPosition_Left)
        x = left;
    
    if(obj.textPosition&AmigoHintPosition_Right)
        x = right;
    
    if(obj.textPosition&AmigoHintPosition_CenterX)
        x = centerX;
    
    if(obj.textPosition&AmigoHintPosition_Top)
        y = top;
    
    if(obj.textPosition&AmigoHintPosition_Bottom)
        y = bottom;
    
    if(obj.textPosition&AmigoHintPosition_CenterY)
        y = centerY;

    textPosH = CGPointMake(x, y);
    textPosT = CGPointMake(x, y+60);

    // Font sizes for iPhone
    int fontSizeH = 24;
    int fontSizeT = 16;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        // Font sizes for iPad
        fontSizeH = 32;
        fontSizeT = 24;
    }
    
    UILabel *headerLabel = [self createLabel:obj.headerStr position:textPosH size:fontSizeH color:BLUE_COLOR bold:true];
    UILabel *textLabel = [self createLabel:obj.textStr position:textPosT size:fontSizeT color:[UIColor whiteColor] bold:false];
    
    CGRect vf = obj.view.frame;
    vf.size.width *= 2;
    vf.origin.x = obj.view.frame.origin.x - obj.view.frame.size.width/2.0;
    vf.size.height *= 2;
    vf.origin.y = obj.view.frame.origin.y - obj.view.frame.size.height/2.0;
    
    obj.header = headerLabel;
    obj.text = textLabel;
    obj.rect = vf;
}

-(UILabel *)createLabel:(NSString*)text position:(CGPoint)position size:(int)size color:(UIColor*)color bold:(bool)bold
{
    NSMutableAttributedString *attributedText;
    if(bold)
    {
        attributedText = [[NSMutableAttributedString alloc]
                          initWithString:text
                          attributes:@
                          {
                          NSFontAttributeName: [UIFont boldSystemFontOfSize:size],
                          NSForegroundColorAttributeName: color
                          }];
    } else
    {
        attributedText = [[NSMutableAttributedString alloc]
                          initWithString:text
                          attributes:@
                          {
                          NSFontAttributeName: [UIFont systemFontOfSize:size],
                          NSForegroundColorAttributeName: color
                          }];
    }
    
    CGRect r = wndw.frame;
    CGRect labelSize = [attributedText boundingRectWithSize:CGSizeMake(r.size.width*0.9, CGFLOAT_MAX)
                            options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(position.x, position.y, labelSize.size.width, labelSize.size.height)];
    [fromLabel setText:text];
    fromLabel.font = [UIFont systemFontOfSize:size];
    fromLabel.numberOfLines = 0;
    [fromLabel setTextColor:color];
    return fromLabel;
}

-(void)addHint:(NSString*)header text:(NSString*)text buttonPosition:(int)buttonPosition textPosition:(int)textPosition view:(UIView*)view
{
    if(!active)
        return;

    AmigoHintObject *obj = [AmigoHintObject alloc];
    obj.headerStr = header;
    obj.textStr = text;
    obj.buttonPosition = buttonPosition;
    obj.textPosition = textPosition;
    obj.view = view;
    [objArray addObject:obj];
    
    [self update];
}



- (void)drawRect:(CGRect)rect
{
    if(!active)
        return;

    [self update];
    
    [backgroundColor setFill];
    UIRectFill(rect);

    AmigoHintObject *obj = [objArray objectAtIndex:hintIndex];
    
    CGRect holeRect = obj.rect;
    
    // Draw Circles
    CGPoint center = CGPointMake(holeRect.origin.x + holeRect.size.width / 2.0, holeRect.origin.y + holeRect.size.height / 2.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    CGContextSetStrokeColorWithColor(ctx, [UIColorFromRGB(0x74c9cd) CGColor]);

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
    float alpha = BG_ALPHA;
    for(int i=0; i<50; i++)
    {
        CGRect holeRectRound = CGRectMake(center.x-sizeHole/2.0, center.y-sizeHole/2.0, sizeHole, sizeHole);
        CGRect holeRectIntersection = CGRectIntersection( holeRectRound, rect );
        [[UIBezierPath bezierPathWithRoundedRect:holeRectIntersection cornerRadius:holeRect.size.height] addClip];
        UIColor *color= [UIColor colorWithWhite:0 alpha:alpha];
        [color setFill];
        UIRectFill(holeRectIntersection);
        sizeHole -= 1;
        alpha -= 0.015;
    }
}


@end
