//
//  EAGLView.m
//  openglTestViews
//
//  Created by marko.hlebar on 5/8/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//



#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import "OpenGLTexture3D.h"
#import "EAGLView.h"

#import "OpenGLCommon.h"

#import "ARViewController.h"
#import "ARToGLCoordinates.h"

#import "WMGamestate.h"

#import "CocosWMBridge.h"
#import "MRRootViewController.h"
#import "MRInfoView.h"

#import "MRObjectGroupManager.h"

//#import "banana.h"
//#import "p47.h"
//#import "pirpir.h"

#define USE_DEPTH_BUFFER 0
#define kMinimumGestureLength	25
#define kMaximumVariance		5

// A class extension to declare private methods
@interface EAGLView ()

@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) NSTimer *animationTimer;

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;

@end


@implementation EAGLView

@synthesize arView;
@synthesize rootController;
@synthesize context;
@synthesize animationTimer;
@synthesize animationInterval;
@synthesize touchDelegate;

// You must implement this method
+ (Class)layerClass {
    return [CAEAGLLayer class];
}


//The GL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithCoder:(NSCoder*)coder {
    
    if ((self = [super initWithCoder:coder])) {
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = NO;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context]) {
            [self release];
            return nil;
        }
        
        animationInterval = 1.0 / 60.0;
    }
	
	
	CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2); 
	self.transform = transform; 
	// Repositions and resizes the view. 
	[self setCenter:CGPointMake(160.0, 240.0)]; 
	CGRect contentRect = CGRectMake(0, 0, 480, 320); 
	self.bounds = contentRect;
	//self.frame = contentRect;

	[self initGL];
	[self initUIViews];
	
	//[self initCocos2d];
	//[self layoutSubviews];
	
	/*
	MRInfoView *info = [[MRInfoView alloc] initWithFrame:CGRectMake(0, 0, 240, 320)];
	[self addSubview:info];
	*/
	gameState = [WMGamestate new];
	gameState.arView = arView;
	gameState.eaglView = self;
	[gameState loadGameState];
	
	[[CocosWMBridge inst] setGamestate:gameState];
	[[CocosWMBridge inst] startGame];
	
    return self;

}

-(void) initGL
{
	
	glEnable(GL_CULL_FACE);
	glCullFace(GL_BACK);

	glEnable(GL_TEXTURE_2D);
	glEnable(GL_BLEND);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR); 
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR); 
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	//glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);

	glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_NORMAL_ARRAY);
    //glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	//glEnable(GL_DEPTH_TEST);
	//glDepthFunc(GL_LESS);
	
	/*
    // Enable lighting
    glEnable(GL_LIGHTING);
    
    // Turn the first light on
    glEnable(GL_LIGHT0);
    
    // Define the ambient component of the first light
    static const Color3D light0Ambient[] = {{0.4, 0.4, 0.4, 1.0}};
	glLightfv(GL_LIGHT0, GL_AMBIENT, (const GLfloat *)light0Ambient);
    
    // Define the diffuse component of the first light
    static const Color3D light0Diffuse[] = {{0.7, 0.7, 0.7, 1.0}};
	glLightfv(GL_LIGHT0, GL_DIFFUSE, (const GLfloat *)light0Diffuse);
    
    // Define the specular component and shininess of the first light
    static const Color3D light0Specular[] = {{0.7, 0.7, 0.7, 1.0}};
    glLightfv(GL_LIGHT0, GL_SPECULAR, (const GLfloat *)light0Specular);
    
    // Define the position of the first light
    // const GLfloat light0Position[] = {10.0, 10.0, 10.0}; 
    static const Vertex3D light0Position[] = {{5.0, 5.0, 5.0}};
	glLightfv(GL_LIGHT0, GL_POSITION, (const GLfloat *)light0Position); 
	
    // Calculate light vector so it points at the object
    static const Vertex3D objectPoint[] = {{0.0, 0.0, -5.0}};
    const Vertex3D lightVector = Vector3DMakeWithStartAndEndPoints(light0Position[0], objectPoint[0]);
    glLightfv(GL_LIGHT0, GL_SPOT_DIRECTION, (GLfloat *)&lightVector);
	*/
}

-(void) initUIViews
{
	/*
	CGAffineTransform transform = CGAffineTransformMakeRotation(0); 
	self.transform = transform; 
	// Repositions and resizes the view. 
	[self setCenter:CGPointMake(240, 160.0)]; 
	CGRect contentRect = CGRectMake(0, 0, 480, 320); 
	self.bounds = contentRect;
	 */
	
	rootController = [[MRRootViewController alloc] initWithNibName:nil bundle:nil];
	rootController.glView = self;
	[self insertSubview: rootController.view atIndex:1];
	
	/*
	CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI / 2.0); 
	self.transform = transform; 
	//[rootController release];
	 */
}


/*

-(void) initCocos2d
{
	// Cocos2D initialization
	
	if( ! [CCDirector setDirectorType:CCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:CCDirectorTypeDefault];
	
	[[CCDirector sharedDirector] setPixelFormat:kRGBA8];
	
	[[CCDirector sharedDirector] setAnimationInterval:1.0f/30];
	[[CCDirector sharedDirector] setAlphaBlending:YES];
	[[CCDirector sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
	[[CCDirector sharedDirector] setDisplayFPS:YES];
	[[CCDirector sharedDirector] attachInView:self];
	[[CCDirector sharedDirector] stopAnimation];

	//add texture map
	[[GameManager inst] addTextureAtlas:textureAtlasUI:@"textureAtlasUI.png"];
	
	[[GameManager inst] addScene:@"LoadingScene"];
	[[GameManager inst] addScene:@"ViewerScene"];
	
	[[GameManager inst] startScene];
}

 */

- (void)mainLoop
{
	[self update];
	[self drawView];
	[gameState collisionDetection];
	//[gameState think];
	[gameState cleanup];
}

- (void)update
{
	Vector3D cameraDirection = getGLVectorForARCoordinate(arView.centerCoordinate);
	cameraDirection.y = -cameraDirection.y;
	[gameState setSphericalOrientationWithAzimuth:arView.centerCoordinate.azimuth andInclination:arView.centerCoordinate.inclination];
	[gameState setCameraDirection:cameraDirection];
	[gameState update];
}


- (void)drawView 
{

   	glViewport(0, 0, backingWidth, backingHeight);
	
	glPushMatrix();
	// glLoadIdentity();
	
	glMatrixMode(GL_PROJECTION);
	
	gluPerspective(60.0, 480 / 320.0f, 1.0, 1000.0);
	
	glMatrixMode(GL_MODELVIEW);
	
	
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
	[gameState draw];	

	//gluLookAt(50, 50, 50, 50, 50, 0, 0, 1, 0);
	//[tex drawInRect:CGRectMake(0,0,100,100)];
	
	glPopMatrix();
	
	[self swapBuffers];
	
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSArray *allTouches = [touches allObjects];
	int count = [allTouches count];
	
	if(count > 0)
	{
		////NSLog(@"Touch 1 = YES");
		touchPosition1 = [[allTouches objectAtIndex:0] locationInView:self];
		
		////NSLog(@"Touch position x = %f, y = %f", touchPosition1.x, touchPosition1.y);
		touch1 = YES;
		
		lastPosition = touchPosition1;
		
		[gameState setTouch:touch1 :touch2 :touchPosition1 :touchPosition2];
	}
	if(count > 1)
	{
		touchPosition2 = [[allTouches objectAtIndex:0] locationInView:self];
		touch2 = YES;
	}	
	
	//NSLog(@"touch : (%f, %f)", touchPosition1.x, touchPosition1.y);
	/*
	if(touchDelegate)
	{
		[touchDelegate touchesBegan:touches withEvent:event];
	}
	 */
}

//FLICKING
/*
- (FlickEvent)wasFlicked:(UITouch *)touch {
	
	FlickEvent flick;
	
    double diffX = endPoint.x - startPoint.x;

	if (abs(diffX) > 20.0) 
	{
		flick.flicked = YES;
		flick.position = startPoint;
		
		if (diffX > 0) {
			flick.move = MOVE_LEFT;
			flick.distance = diffX;
		}
		else {
			flick.move = MOVE_RIGHT;
			
			if (magicMode) {
				flick.distance = -MAGICFLICKSPEED;
			}
			else
				flick.distance = -FLICKSPEED;
		}
	}
	else {
		flick.flicked = NO;
		flick.distance = 0.0;
		flick.move = MOVE_NO;
	}
	
	flick.handled = NO;
	
    return flick;
}
*/



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	UITouch *touch = [touches anyObject];
	CGPoint currentPosition = [touch locationInView:self];
	
	CGFloat deltaX = (lastPosition.x - currentPosition.x);
//	CGFloat deltaY = fabsf(startPoint.y - currentPosition.y);
	
	//if (fabsf(deltaX) >= kMinimumGestureLength ){//&& deltaY <= kMaximumVariance) {
		
	[[MRObjectGroupManager sharedInstance] moveItems:deltaX];
	[[MRObjectGroupManager sharedInstance] setSwipe:YES];
		//NSLog(@"swipe");
	//}	
	
	lastPosition = currentPosition;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	[[MRObjectGroupManager sharedInstance] setSwipe:NO];

	lastPosition = CGPointMake(0, 0);
	
	touch1 = NO;
	touch2 = NO;
	
	NSArray *allTouches = [touches allObjects];
	
	touchPosition1 = [[allTouches objectAtIndex:0] locationInView:self];
	
	[gameState setTouch:touch1 :touch2 :touchPosition1 :touchPosition2];
	
	/*
	if(touchDelegate)
	{
		[touchDelegate touchesEnded:touches withEvent:event];
	}
	 */
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	/*
	if(touchDelegate)
	{
		[touchDelegate touchesCancelled:touches withEvent:event];
	}
	 */
}

- (void) swapBuffers
{
	EAGLContext *oldContext = [EAGLContext currentContext];
	GLuint oldRenderbuffer;
	
	if(oldContext != context)
		[EAGLContext setCurrentContext:context];
	
	glGetIntegerv(GL_RENDERBUFFER_BINDING_OES, (GLint *) &oldRenderbuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	
	if(![context presentRenderbuffer:GL_RENDERBUFFER_OES])
		printf("Failed to swap renderbuffer in %s\n", __FUNCTION__);
	
	
	if(oldContext != context)
		[EAGLContext setCurrentContext:oldContext];
}


- (void)layoutSubviews {
    [EAGLContext setCurrentContext:context];
    [self destroyFramebuffer];
    [self createFramebuffer];
    [self drawView];
}


- (BOOL)createFramebuffer {
    
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
	glGenRenderbuffersOES(1, &depthRenderbuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
	glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
        
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        //NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }

	
    return YES;
}


- (void)destroyFramebuffer {
    
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}


- (void)startAnimation {
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(mainLoop) userInfo:nil repeats:YES];
}


- (void)stopAnimation {
    self.animationTimer = nil;
}


- (void)setAnimationTimer:(NSTimer *)newTimer {
    [animationTimer invalidate];
    animationTimer = newTimer;
}


- (void)setAnimationInterval:(NSTimeInterval)interval {
    
    animationInterval = interval;
    if (animationTimer) {
        [self stopAnimation];
        [self startAnimation];
    }
}

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	return NO;
	
}
*/

- (void)dealloc {
    
	[gameState release];
    [self stopAnimation];
    
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [context release];  
    [super dealloc];
}

@end
