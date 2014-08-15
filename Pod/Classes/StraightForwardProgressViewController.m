//
//  StraightForwardProgressViewController.m
//  Pods
//
//  Created by Johan Forssell on 15/08/14.
//
//

#import "StraightForwardProgressViewController.h"

static void *ProgressObserverContext = &ProgressObserverContext;


@interface StraightForwardProgressViewController ()
@property (strong) CAShapeLayer *progressLayer;
@property (strong) CAShapeLayer *progressShape;
@end

@implementation StraightForwardProgressViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _commonInit];
    }
    return self;
}

- (void)_commonInit
{
    self.progressColor   = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    self.progressLayer   = [CAShapeLayer layer]; // just a dummy
}

- (void)dealloc
{
    if (_progressObject) {
        // TODO: Do we need to check if there's something to actually remove first?
        [_progressObject removeObserver:self forKeyPath:NSStringFromSelector(@selector(fractionCompleted)) context:ProgressObserverContext];
        _progressObject = nil;
    }
}

#pragma mark - UI life cycle

- (void)viewDidLoad
{
    [self.view.layer addSublayer:self.progressLayer];
    self.view.backgroundColor = self.backgroundColor;
}


- (void)viewWillAppear:(BOOL)animated
{
    [self setupProgressBar];
    [self.progressLayer addAnimation:[self progressAnimation] forKey:@"upload progress"];
    [self fakeUpdateProgressContinously];
}

- (void)fakeUpdateProgressContinously
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.progress += 0.008;
        if (self.progress > 0.1) {
            self.progress += 0.1;
        }
        if (self.progress > 0.3) {
            self.progress += 0.1;
        }

        if (self.progress < 1) {
            [self fakeUpdateProgressContinously];
        }
    });
}

- (void)viewWillLayoutSubviews
{
    [self updateVisualProgress];
}

- (void)updateVisualProgress
{
    self.progressLayer.path = [self progressPath:self.view.bounds.size];
}

- (void)setupProgressBar
{
    CAShapeLayer *progressShape = [CAShapeLayer layer];
    NSLog(@"size %@", NSStringFromCGSize(self.view.bounds.size));
    progressShape.path = [self progressPath:self.view.bounds.size];
    
    progressShape.strokeColor = self.progressColor.CGColor;
    progressShape.fillColor   = self.progressColor.CGColor;
    progressShape.lineWidth   = self.view.bounds.size.height;
    progressShape.frame       = self.view.frame;
    progressShape.speed       = 0;
    [self.view.layer addSublayer:progressShape];
    self.progressLayer = progressShape;
}

- (CGPathRef)progressPath:(CGSize)sized
{
    CGFloat halfway_up = floorf(sized.height/2);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, halfway_up);
    CGPathAddLineToPoint(path, NULL, sized.width, halfway_up);

    return path;
}

- (CAAnimation *)progressAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0;
    animation.toValue   = @1;
    animation.fillMode = kCAFillModeBoth;
    animation.removedOnCompletion = NO;
    animation.duration = 0.4;

    return animation;
}

#pragma mark - accessors

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    self.progressLayer.timeOffset = MIN(1.0, progress);
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
    self.progressLayer.strokeColor = progressColor.CGColor;
    self.progressLayer.fillColor   = progressColor.CGColor;
}

- (void)setProgressObject:(NSProgress *)progressObject
{
    if (_progressObject) {
        [_progressObject removeObserver:self forKeyPath:NSStringFromSelector(@selector(fractionCompleted)) context:ProgressObserverContext];
        _progressObject = nil;
    }

    _progressObject = progressObject;
    [_progressObject addObserver:self forKeyPath:NSStringFromSelector(@selector(fractionCompleted))  options:NSKeyValueObservingOptionInitial context:ProgressObserverContext];
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == ProgressObserverContext)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSProgress *progress = object;
            self.progress = progress.fractionCompleted;
        }];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


@end
