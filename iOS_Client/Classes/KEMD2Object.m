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

#import "Types3D.h"
#import "CCTexture2D.h"
#import "KEGLRenderable.h"
#import "KEMD2Object.h"
#import <malloc/malloc.h>

#define NUMVERTEXNORMALS        162
#define SHADEDOT_QUANT          16

static KEMD2Vector anorms_table[ NUMVERTEXNORMALS ] = {
#include    "anorms.h"
};

KEMD2Animation const KEMD2AnimationStand = { 0,  39,  9 };
KEMD2Animation const KEMD2AnimationRun = {  40,  46, 10 };
KEMD2Animation const KEMD2AnimationAttack = {  47,  53, 10 };
KEMD2Animation const KEMD2AnimationPainA = {  54,  57,  7 };
KEMD2Animation const KEMD2AnimationPainB = {  58,  61,  7 };
KEMD2Animation const KEMD2AnimationPainC = {  62,  65,  7 };
KEMD2Animation const KEMD2AnimationJump = {  66,  71,  7 };
KEMD2Animation const KEMD2AnimationFlip = {  72,  83,  7 };
KEMD2Animation const KEMD2AnimationSalute = {  84,  94,  7 };
KEMD2Animation const KEMD2AnimationFallBack = {  95, 111, 10 };
KEMD2Animation const KEMD2AnimationWave = { 112, 122,  7 };
KEMD2Animation const KEMD2AnimationPoint = { 123, 134,  6 };
KEMD2Animation const KEMD2AnimationCrouchStand = { 135, 153, 10 };
KEMD2Animation const KEMD2AnimationCrouchWalk = { 154, 159,  7 };
KEMD2Animation const KEMD2AnimationCrouchAttack = { 160, 168, 10 };
KEMD2Animation const KEMD2AnimationCrouchPain = { 196, 172,  7 };
KEMD2Animation const KEMD2AnimationCrouchDeath = { 173, 177,  5 };
KEMD2Animation const KEMD2AnimationDeathFallBack = { 178, 183,  7 };
KEMD2Animation const KEMD2AnimationDeathFallForward = { 184, 189,  7 };
KEMD2Animation const KEMD2AnimationDeathFallBackSlow = { 190, 197,  7 };
KEMD2Animation const KEMD2AnimationBoom = { 198, 198,  5 };

@interface KEMD2Object ()

@property (nonatomic, readwrite, retain) CCTexture2D *texture;

@end


@implementation KEMD2Object

#pragma mark Properties

@synthesize texture=_texture, animation=_animation, fpsScale=_fpsScale;

/****************************************************************************************************
 *	setAnimation:
 ****************************************************************************************************/

- (void) setAnimation:(KEMD2Animation)animation
{
	_animation = animation;
	_nextFrame = _animation.firstFrame;
}

#pragma mark Public methods

/****************************************************************************************************
 *	md2WithContentsOfFile:
 ****************************************************************************************************/

+ (KEMD2Object *) md2WithContentsOfFile:(NSString *)path texture:(CCTexture2D *)texture
{
	return [[[KEMD2Object alloc] initWithContentsOfFile:path texture:texture] autorelease];
}

/****************************************************************************************************
 *	initWithContentsOfFile:
 ****************************************************************************************************/

- (id) initWithContentsOfFile:(NSString *)path texture:(CCTexture2D *)texture
{
	return [self initWithData:[NSData dataWithContentsOfFile:path] texture:texture];
}

/****************************************************************************************************
 *	initWithData:
 ****************************************************************************************************/

- (id) initWithData:(NSData *)data texture:(CCTexture2D *)texture
{
	if( self = [super init])
	{
		self.texture = texture;
		_oldTime = 0;
		_currentFrame = 0;
		_nextFrame = 1;
		_fpsScale = 1;
		
		[data getBytes:&_header length:sizeof(KEMD2Header)];
		
		if( _header.identifier != MD2_MAGIC_NUMBER || _header.version != MD2_VERSION)
			return nil;
		
		//NSLog(@"num frames = %d", _header.frameCount);
		
		size_t skinsSize = _header.skinCount * sizeof(KEMD2TexturePath);
		size_t textureCoordinatesSize = _header.textureCoordinateCount * sizeof(KEMD2TextureCoordinate);
		size_t trianglesSize = _header.triangleCount * sizeof(KEMD2Triangle);
		size_t framesSize = _header.frameCount * sizeof(KEMD2Frame);
		
		_skins = malloc( skinsSize);
		_textureCoordinates = malloc( textureCoordinatesSize);
		_triangles = malloc( trianglesSize);
		_frames = malloc( framesSize);
		KEMD2Vertex *vertexBuffer = malloc( _header.vertexCount * sizeof(KEMD2Vertex));
		
		if( !_skins || !_textureCoordinates || !_triangles || !_frames || !vertexBuffer)
		{
			if( _skins) free( _skins);
			if( _textureCoordinates) free( _textureCoordinates);
			if( _triangles) free( _triangles);
			if( _frames) free( _frames);
			if( vertexBuffer) free( vertexBuffer);
			NSLog(@"Couldn't allocate memory");
			return nil;
		}
		
		[data getBytes:_skins range:(NSRange){ _header.skinsOffset, skinsSize}];
		[data getBytes:_textureCoordinates range:(NSRange){ _header.textureCoordinatesOffset, textureCoordinatesSize}];
		[data getBytes:_triangles range:(NSRange){ _header.trianglesOffset, trianglesSize}];
		
		size_t verticesSize = _header.triangleCount * sizeof(GLVertex) * 3;
		NSRange range = { _header.framesOffset, sizeof(KEMD2Vector)};
		BOOL couldntAllocateFrame = NO;
		KEMD2Vector frameScale;
		KEMD2Vector frameTranslate;
		KEMD2Vertex *md2Vertex;
		GLVertex *glVertex;
		KEMD2TextureCoordinate *textureCoordinate;
		NSInteger i, j, k;
		for( i=0; i<_header.frameCount; i++)
		{
			_frames[i].vertices = malloc( verticesSize);
			if( !_frames[i].vertices)
			{
				couldntAllocateFrame = YES;
				break;
			}
			
			range.length = sizeof(KEMD2Vector);
			[data getBytes:&frameScale range:range];
			range.location += range.length;
			
			[data getBytes:&frameTranslate range:range];
			range.location += range.length;
			
			range.length = sizeof(KEMD2FrameName);
			[data getBytes:_frames[ i].name range:range];
			range.location += range.length;
			
			range.length = _header.vertexCount * sizeof(KEMD2Vertex);
			[data getBytes:vertexBuffer range:range];
			range.location += range.length;

			for( j=0; j<_header.triangleCount; j++)
			{
				for( k=0; k<3; k++)
				{
					md2Vertex = &vertexBuffer[ _triangles[j].vertexIndices[k]];
					textureCoordinate = &_textureCoordinates[ _triangles[j].textureCoordinateIndices[k]];
					
					glVertex = &_frames[i].vertices[j*3+k];
					glVertex->position.x = (frameScale[0] * md2Vertex->xyz[0]) + frameTranslate[0];
					glVertex->position.y = (frameScale[1] * md2Vertex->xyz[1]) + frameTranslate[1];
					glVertex->position.z = (frameScale[2] * md2Vertex->xyz[2]) + frameTranslate[2];
					glVertex->textureCoords.x = (GLfloat) textureCoordinate->s / _header.skinWidth;
					glVertex->textureCoords.y = (GLfloat) textureCoordinate->t / _header.skinHeight;
					glVertex->normal.x = anorms_table[ md2Vertex->lightnormalindex][0];
					glVertex->normal.y = anorms_table[ md2Vertex->lightnormalindex][1];
					glVertex->normal.z = anorms_table[ md2Vertex->lightnormalindex][2];
				}
			}
		}
		free( vertexBuffer);
		
		_vertices = malloc( verticesSize);
		
		if( couldntAllocateFrame || !_vertices)
		{
			for( i=0; i<_header.frameCount; i++)
			{
				if( _frames[i].vertices)
					free( _frames[i].vertices);
			}
			free( _skins);
			free( _textureCoordinates);
			free( _triangles);
			free( _frames);
			NSLog(@"Couldn't allocate memory");
			return nil;
		}
		
		memcpy( _vertices, _frames[0].vertices, verticesSize);
		/*
		NSLog(@"size of _vertices: %d", malloc_size(_vertices));
		NSLog(@"size of _skins: %d", malloc_size(_skins));
		NSLog(@"size of _textureCoordinates: %d", malloc_size(_textureCoordinates));
		NSLog(@"size of _vertices: %d", malloc_size(_triangles));
		NSLog(@"size of _frames: %d", malloc_size(_frames));

		NSLog(@"############\n");
		 */

		self.animation = KEMD2AnimationCrouchWalk;
	}
	return self;
}

/****************************************************************************************************
 *	doTick:
 ****************************************************************************************************/

- (void) doTick:(float)time
{
	KEMD2Animation anim = self.animation;
	float fps = anim.fps * self.fpsScale;
	
	if( time - _oldTime > 1.0 / fps)
	{
		_currentFrame = _nextFrame;
		_nextFrame++;
		_oldTime = time;
	}
	
	if( _currentFrame >= anim.lastFrame)
		_currentFrame = anim.firstFrame;
	
	if( _nextFrame >= anim.lastFrame)
		_nextFrame = anim.firstFrame;
	
	if (_currentFrame <= _header.frameCount) 
	{
	
		float alpha = fps * (time - _oldTime);
		GLVertex *currentVertices = _frames[_currentFrame].vertices;
		GLVertex *nextVertices = _frames[_nextFrame].vertices;
		
		NSInteger vertexCount = _header.triangleCount * 3;
		for( NSInteger i=0; i<vertexCount; i++)
		{
			_vertices[i].position.x = currentVertices[i].position.x + alpha * (nextVertices[i].position.x - currentVertices[i].position.x);
			_vertices[i].position.y = currentVertices[i].position.y + alpha * (nextVertices[i].position.y - currentVertices[i].position.y);
			_vertices[i].position.z = currentVertices[i].position.z + alpha * (nextVertices[i].position.z - currentVertices[i].position.z);
			_vertices[i].normal.x = currentVertices[i].normal.x + alpha * (nextVertices[i].normal.x - currentVertices[i].normal.x);
			_vertices[i].normal.y = currentVertices[i].normal.y + alpha * (nextVertices[i].normal.y - currentVertices[i].normal.y);
			_vertices[i].normal.z = currentVertices[i].normal.z + alpha * (nextVertices[i].normal.z - currentVertices[i].normal.z);
		}
	}
}

/****************************************************************************************************
 *	dealloc
 ****************************************************************************************************/

- (void) dealloc
{
	for( NSInteger i=0; i<_header.frameCount; i++)
		free( _frames[i].vertices);
	free( _skins);
	free( _textureCoordinates);
	free( _triangles);
	free( _frames);
	free( _vertices);
	self.texture = nil;
	
	[super dealloc];
}

/****************************************************************************************************
 *	description
 ****************************************************************************************************/

- (NSString *) description
{
	NSLog(@"desc called");
	NSString *s = @"\nMD2:\n\tskin width: %d\n\tskin height: %d\n\tframes: %d\n\tskins: %d\n\tvertices: %d\n\ttex coords: %d\n\ttris: %d\n\tgl commands: %d";
	return [NSString stringWithFormat:s, _header.skinWidth,
										_header.skinHeight,
										_header.frameCount,
										_header.skinCount,
										_header.vertexCount,
										_header.textureCoordinateCount,
										_header.triangleCount,
										_header.glCommandCount];
}
#pragma mark GLRenderable methods

/****************************************************************************************************
 *	setupForRenderGL
 ****************************************************************************************************/

- (void) setupForRenderGL
{	
	glEnable( GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable( GL_TEXTURE_2D);
	glBindTexture( GL_TEXTURE_2D, self.texture.name);
	glEnableClientState( GL_VERTEX_ARRAY);
	glEnableClientState( GL_TEXTURE_COORD_ARRAY);
	glEnableClientState( GL_NORMAL_ARRAY);
	//glEnableClientState( GL_COLOR_ARRAY);
}

/****************************************************************************************************
 *	renderGL
 ****************************************************************************************************/

- (void) renderGL
{
	glVertexPointer( 3, GL_FLOAT, sizeof( GLVertex), &_vertices[0].position);
	glTexCoordPointer( 2, GL_FLOAT, sizeof( GLVertex), &_vertices[0].textureCoords);
	glNormalPointer( GL_FLOAT, sizeof( GLVertex), &_vertices[0].normal);
	//glColorPointer( 4, GL_FLOAT, sizeof( GLVertex), &_vertices[0].color);
	glDrawArrays( GL_TRIANGLES, 0, _header.triangleCount * 3);
}

-(void) renderGLnotex
{
	glVertexPointer( 3, GL_FLOAT, sizeof( GLVertex), &_vertices[0].position);
	glNormalPointer( GL_FLOAT, sizeof( GLVertex), &_vertices[0].normal);
	//glColorPointer( 4, GL_FLOAT, sizeof( GLVertex), &_vertices[0].color);
	glDrawArrays( GL_TRIANGLES, 0, _header.triangleCount * 3);
}

/****************************************************************************************************
 *	cleanupAfterRenderGL
 ****************************************************************************************************/

- (void) cleanupAfterRenderGL
{
	glDisableClientState( GL_VERTEX_ARRAY);
	glDisableClientState( GL_TEXTURE_COORD_ARRAY);
	glDisableClientState( GL_NORMAL_ARRAY);
	//glDisableClientState( GL_COLOR_ARRAY);
	glDisable( GL_TEXTURE_2D);
}

#pragma mark Private methods

/****************************************************************************************************
 *	defaultValue
 ****************************************************************************************************/

-(float) getVertexMaxOffsets
{
	float reallyBigNum = 100000000;
	
	float minX = reallyBigNum;
	float maxX = -reallyBigNum;
	
	float minY = reallyBigNum;
	float maxY = -reallyBigNum;
	
	float minZ = reallyBigNum;
	float maxZ = -reallyBigNum;
	
	for (int i = 0; i < _header.triangleCount * 3; i++) 
	{
		float x = _vertices[i].position.x;
		float y = _vertices[i].position.y;
		float z = _vertices[i].position.z;
		
		if (x < minX) minX = x;
		if (x > maxX) maxX = x;
		if (y < minY) minY = y;
		if (y > maxY) maxY = y;
		if (z < minZ) minZ = z;
		if (z > maxZ) maxZ = z;
		
	}
	
	float maxOffset = 0;
	
	if ((maxX - minX) > maxOffset) maxOffset = (maxX - minX);
	if ((maxY - minY) > maxOffset) maxOffset = (maxY - minY);
	if ((maxZ - minZ) > maxOffset) maxOffset = (maxZ - minZ);
	
	return maxOffset;
}

@end
