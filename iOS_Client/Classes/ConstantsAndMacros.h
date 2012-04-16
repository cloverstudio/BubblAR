//
//  ConstantsAndMacros.h
//  Particles
//

// How many times a second to refresh the screen
#if TARGET_OS_IPHONE && !TARGET_IPHONE_SIMULATOR
#define kRenderingFrequency             15.0
#define kInactiveRenderingFrequency     5.0
#else
#define kRenderingFrequency             30.0
#define kInactiveRenderingFrequency     3.0
#endif
// For setting up perspective, define near, far, and angle of view
#define kZNear                          0.01
#define kZFar                           1000.0
#define kFieldOfView                    45.0
// Defines whether to setup and use a depth buffer
#define USE_DEPTH_BUFFER                1
// Set to 1 if you want it to attempt to create a 2.0 context
#define kAttemptToUseOpenGLES2          0
// Macros
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 180.0 / M_PI)
#define IPHONE_FOV_WIDTH 0.925024504	//RAD
#define IPHONE_FOV_HEIGHT 0.674335		//RAD
#define IPHONE_SCREEN_LANDSCAPE_WIDTH	0.076 * 100//cm
#define IPHONE_SCREEN_LANDSCAPE_HEIGHT	0.051 * 100//cm
#define IPHONE_FOCUS 0.0286350539 * 100			//cm
#define IPHONE_PIXEL_SIZE 0.000158333333	*100	//cm
#define IPHONE_CENTERCOORDINATE_LANDSCAPE CGPointMake(240,160)
#define IPHONE_SCREEN_LANDSCAPE_RECT CGRectMake(0,0,480,320)

#pragma mark -
#pragma mark MRCOLORS
#define UICOLOR_DARKBLUE [UIColor colorWithRed:22./255. green:72./255. blue:118./255. alpha:1.0];
