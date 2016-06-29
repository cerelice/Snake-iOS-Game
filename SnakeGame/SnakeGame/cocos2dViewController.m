#import "HelloWorldScene.h"
#import "cocos2dViewController.h"
#import "AbstactFactoryDesign.h"


@implementation cocos2dViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = [FactoryDesign sharedInstance].headColor;
    } else {
        // iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = [FactoryDesign sharedInstance].headColor;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        //self.navigationController.navigationBar.translucent = NO;
    }
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonClicked)];
    self.navigationItem.leftBarButtonItem = backButton;
    UIBarButtonItem *pauseButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pause.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(pauseGame)];
    self.navigationItem.rightBarButtonItem = pauseButton;
    CCDirector *director = [CCDirector sharedDirector];
    //[[[self navigationController] navigationBar] setHidden:YES];
    
    
    if([director isViewLoaded] == NO)
    {
        // Create the OpenGL view that Cocos2D will render to.
        CCGLView *glView = [CCGLView viewWithFrame:self.view.bounds
                                       pixelFormat:kEAGLColorFormatRGB565
                                       depthFormat:0
                                preserveBackbuffer:NO
                                        sharegroup:nil
                                     multiSampling:NO
                                   numberOfSamples:0];
        
        // Assign the view to the director.
        director.view = glView;
        
        
        // Initialize other director settings.
        [director setAnimationInterval:1.0f/60.0f];
        //[director enableRetinaDisplay:YES];
    }
    
    // Set the view controller as the director's delegate, so we can respond to certain events.
    director.delegate = self;
    
    // Add the director as a child view controller of this view controller.
    [self addChildViewController:director];
    
    // Add the director's OpenGL view as a subview so we can see it.
    [self.view addSubview:director.view];
    [self.view sendSubviewToBack:director.view];
    
    // Finish up our view controller containment responsibilities.
    [director didMoveToParentViewController:self];
    
    // Run whatever scene we'd like to run here.
    if(director.runningScene)
        [director replaceScene:[HelloWorldScene scene]];
    else
        [director pushScene:[HelloWorldScene scene]];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)backButtonClicked {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quit" message:@"Do you want to quit from this game?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
    CCScene *runningScene = [CCDirector sharedDirector].runningScene;
    if(runningScene) {
        runningScene.paused = YES;
    }
    //[FactoryDesign setSharedInstanceWithDesign:[ForrestFactoryDesign new]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)pauseGame
{
    CCScene *runningScene = [CCDirector sharedDirector].runningScene;
    if(runningScene) {
        runningScene.paused = !runningScene.paused;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end