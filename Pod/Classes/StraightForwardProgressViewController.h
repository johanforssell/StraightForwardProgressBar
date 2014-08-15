//
//  StraightForwardProgressViewController.h
//  Pods
//
//  Created by Johan Forssell on 15/08/14.
//
//

#import <UIKit/UIKit.h>

@interface StraightForwardProgressViewController : UIViewController

@property (nonatomic, strong) NSProgress *progressObject;
@property (nonatomic, strong) UIColor    *progressColor;
@property (nonatomic, strong) UIColor    *backgroundColor;
@property (nonatomic, assign) CGFloat     progress;
@end
