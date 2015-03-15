AmigoHint
=========

#### What is AmigoHint?

AmigoHint is the Objective-C++ library that makes development of an on-screen help easy for iOS devices. 

#### Example
```obj-c
    hintView = [[AmigoHint alloc] init:@"GlobeViewHint_1" complete:^ void ( void )
                {
                    [globeVC showDatasetsIfNeeded];
                }];

    [hintView addHint:@"List of datasets"
                text:@"- Shows list of available datasets and tracks.\n- Togle visibility on the globe.\n- Selecting dataset will zoom in to it."
                buttonPosition:AmigoHintPosition_Bottom
                textPosition:AmigoHintPosition_Top|AmigoHintPosition_Left
                view:navbarVC.datasetsBtn];

```

#### Screenshot
The AmigoCloud application screenshot
![Screenshot](http://i.imgur.com/LBNQEtj.png)
