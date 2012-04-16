//
//  EAGLView.h
//  openglTestViews
//
//  Created by marko.hlebar on 5/8/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "ARViewController.h"
//#import "ccEAGLView.h"

@class OpenGLTexture3D;
@class ARPlane;
@class WMGamestate;
@class MRRootViewController;

@protocol EAGLTouchDelegate <NSObject>
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
@end
 
/*
This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
The view content is basically an EAGL surface you render your OpenGL scene into.
Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
*/
@interface EAGLView : UIView {
    
@private
    /* The pixel dimensions of the backbuffer */
    GLint backingWidth;
    GLint backingHeight;
    
    EAGLContext *context;
    
    /* OpenGL names for the renderbuffer and framebuffers used to render to this view */
    GLuint viewRenderbuffer, viewFramebuffer;
    
    /* OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist) */
    GLuint depthRenderbuffer;
    
    NSTimer *animationTimer;
    NSTimeInterval animationInterval;
	
	//OpenGLTexture3D *texture;
	
	ARViewController *arView;
	
	BOOL touch1;
	BOOL touch2;
	
	CGPoint touchPosition1;
	CGPoint touchPosition2;
	CGPoint startPoint;
	
	CGPoint lastPosition;
//	CGPoint endPoint;
	
	WMGamestate *gameState;
	
	id<EAGLTouchDelegate>   touchDelegate;
	
	MRRootViewController *rootController;

}

@property (assign) MRRootViewController *rootController;
@property (nonatomic,assign) ARViewController *arView;
@property NSTimeInterval animationInterval;
@property(nonatomic,readwrite,assign)	id<EAGLTouchDelegate>   touchDelegate;

- (void)startAnimation;
- (void)stopAnimation;
- (void)drawView;
- (void)update;
- (void)mainLoop;

-(void) initGL;
-(void) initUIViews;

-(void) swapBuffers;


@end
