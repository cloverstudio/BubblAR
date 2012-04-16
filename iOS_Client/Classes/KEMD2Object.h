/*
 Copyright (c) 2009 Ben Hopkins
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
*/

#import <Foundation/Foundation.h>
#import "KEGLRenderable.h"
#import "Types3D.h"
#import "OpenGLCommon.h"


#define MD2_MAGIC_NUMBER	844121161
#define MD2_VERSION		8

// ---- MD2 Types ------------------------------//

typedef struct
{
	int identifier;
	int version;
	int skinWidth;
	int skinHeight;
	int frameSize;
	int skinCount;
	int vertexCount;
	int textureCoordinateCount;
	int triangleCount;
	int glCommandCount;
	int frameCount;
	int skinsOffset;
	int textureCoordinatesOffset;
	int trianglesOffset;
	int framesOffset;
	int glCommandsOffset;
	int eofOffset;
} KEMD2Header;

typedef float KEMD2Vector[3];

typedef char KEMD2TexturePath[64];

typedef struct
{
	unsigned char xyz[3];
	unsigned char lightnormalindex;
} KEMD2Vertex;

typedef struct
{
	short s;
	short t;
} KEMD2TextureCoordinate;

typedef struct
{
	short vertexIndices[3];
	short textureCoordinateIndices[3];
} KEMD2Triangle;

typedef char KEMD2FrameName[16];

typedef struct
{
	KEMD2FrameName name;
	GLVertex *vertices;
} KEMD2Frame;

typedef struct
{
	int firstFrame;
	int lastFrame;
	float fps;
} KEMD2Animation;

// ---- Standard Quake animations ---------------//

extern KEMD2Animation const KEMD2AnimationStand;
extern KEMD2Animation const KEMD2AnimationRun;
extern KEMD2Animation const KEMD2AnimationAttack;
extern KEMD2Animation const KEMD2AnimationPainA;
extern KEMD2Animation const KEMD2AnimationPainB;
extern KEMD2Animation const KEMD2AnimationPainC;
extern KEMD2Animation const KEMD2AnimationJump;
extern KEMD2Animation const KEMD2AnimationFlip;
extern KEMD2Animation const KEMD2AnimationSalute;
extern KEMD2Animation const KEMD2AnimationFallBack;
extern KEMD2Animation const KEMD2AnimationWave;
extern KEMD2Animation const KEMD2AnimationPoint;
extern KEMD2Animation const KEMD2AnimationCrouchStand;
extern KEMD2Animation const KEMD2AnimationCrouchWalk;
extern KEMD2Animation const KEMD2AnimationCrouchAttack;
extern KEMD2Animation const KEMD2AnimationCrouchPain;
extern KEMD2Animation const KEMD2AnimationCrouchDeath;
extern KEMD2Animation const KEMD2AnimationDeathFallBack;
extern KEMD2Animation const KEMD2AnimationDeathFallForward;
extern KEMD2Animation const KEMD2AnimationDeathFallBackSlow;
extern KEMD2Animation const KEMD2AnimationBoom;

// ---- Class Interface --------------------------//

@protocol KEGLRenderable;
@class CCTexture2D;

@interface KEMD2Object : NSObject <KEGLRenderable>
{
	KEMD2Header _header;
	KEMD2TexturePath *_skins;
	KEMD2TextureCoordinate *_textureCoordinates;
	KEMD2Triangle *_triangles;
	KEMD2Frame *_frames;
	KEMD2Animation _animation;
	float _oldTime;
	float _fpsScale;
	NSInteger _currentFrame;
	NSInteger _nextFrame;
	
	GLVertex *_vertices;
	CCTexture2D *_texture;
}

@property (nonatomic, readonly, retain) CCTexture2D *texture;
@property (nonatomic, readwrite, assign) KEMD2Animation animation;
@property (nonatomic, readwrite, assign) float fpsScale;

+ (KEMD2Object *) md2WithContentsOfFile:(NSString *)path texture:(CCTexture2D *)texture;

- (id) initWithContentsOfFile:(NSString *)path texture:(CCTexture2D *)texture;
- (id) initWithData:(NSData *)data texture:(CCTexture2D *)texture;

- (void) doTick:(float)time;
- (float) getVertexMaxOffsets;


@end
