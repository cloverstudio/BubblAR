#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR || TARGET_OS_EMBEDDED
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#else
#import <OpenGL/OpenGL.h>
#endif
@class OpenGLWaveFrontMaterial;
#pragma mark -
#pragma mark Color3D
#pragma mark -
typedef struct {
	GLfloat	red;
	GLfloat	green;
	GLfloat	blue;
	GLfloat alpha;
} Color3D;
static inline Color3D Color3DMake(CGFloat inRed, CGFloat inGreen, CGFloat inBlue, CGFloat inAlpha)
{
    Color3D ret;
	ret.red = inRed;
	ret.green = inGreen;
	ret.blue = inBlue;
	ret.alpha = inAlpha;
    return ret;
}
static inline void Color3DSet(Color3D *color, CGFloat inRed, CGFloat inGreen, CGFloat inBlue, CGFloat inAlpha)
{
    color->red = inRed;
    color->green = inGreen;
    color->blue = inBlue;
    color->alpha = inAlpha;
}

#pragma mark -
#pragma mark Texture
#pragma mark -
typedef struct
{
	GLfloat u;
	GLfloat v;
} TexCoords;

static inline TexCoords TexCoordsMake(GLfloat inU, GLfloat inV)
{
	TexCoords ret;
	ret.u = inU;
	ret.v = inV;
	return ret;
}


#pragma mark -
#pragma mark Vertex3D
#pragma mark -
typedef struct {
	GLfloat	x;
	GLfloat y;
	GLfloat z;
} Vertex3D;

static inline Vertex3D Vertex3DMake(CGFloat inX, CGFloat inY, CGFloat inZ)
{
	Vertex3D ret;
	ret.x = inX;
	ret.y = inY;
	ret.z = inZ;
	return ret;
}
static inline void Vertex3DSet(Vertex3D *vertex, CGFloat inX, CGFloat inY, CGFloat inZ)
{
    vertex->x = inX;
    vertex->y = inY;
    vertex->z = inZ;
}
#pragma mark -
#pragma mark Vector3D
#pragma mark -
typedef Vertex3D Vector3D;
#define Vector3DMake(x,y,z) (Vector3D)Vertex3DMake(x, y, z)
#define Vector3DSet(vector,x,y,z) Vertex3DSet(vector, x, y, z)
static inline Vector3D Vector3DMakeUnitVector(float theta, float phi)
{
	return Vector3DMake(sinf(theta) * cosf(phi), sinf(theta) * sinf(phi), cosf(theta));
}
static inline GLfloat Vector3DMagnitude(Vector3D vector)
{
	return sqrtf((vector.x * vector.x) + (vector.y * vector.y) + (vector.z * vector.z)); 
}
static inline GLfloat InvSqrt(GLfloat x)
{
    GLfloat xhalf = 0.5f * x;
    int i = *(int*)&x;  // store floating-point bits in integer
    i = 0x5f3759d5 - (i >> 1);      // initial guess for Newton's method
    x = *(GLfloat*)&i;              // convert new bits into float
    x = x*(1.5f - xhalf*x*x);       // One round of Newton's method
    return x;
}
static inline GLfloat Vector3DFastInverseMagnitude(Vector3D vector)
{
    return InvSqrt((vector.x * vector.x) + (vector.y * vector.y) + (vector.z * vector.z));
}

static inline void Vector3DFastNormalize(Vector3D *vector)
{
    GLfloat vecInverseMag = Vector3DFastInverseMagnitude(*vector);
    if (vecInverseMag == 0.0)
    {
        vector->x = 1.0;
        vector->y = 0.0;
        vector->z = 0.0;
    }
    vector->x *= vecInverseMag;
    vector->y *= vecInverseMag;
    vector->z *= vecInverseMag;
}

static inline void Vector3DNormalize(Vector3D *vector)
{
	GLfloat vecMag = Vector3DMagnitude(*vector);
		
	if ( vecMag == 0.0 )
	{
		vector->x = 1.0;
		vector->y = 0.0;
		vector->z = 0.0;
        return;
	}
	
	vector->x /= vecMag;
	vector->y /= vecMag;
	vector->z /= vecMag;
	 
}
static inline GLfloat Vector3DDotProduct(Vector3D vector1, Vector3D vector2)
{		
	return vector1.x*vector2.x + vector1.y*vector2.y + vector1.z*vector2.z;
	
}
static inline Vector3D Vector3DCrossProduct(Vector3D vector1, Vector3D vector2)
{
	Vector3D ret;
	ret.x = (vector1.y * vector2.z) - (vector1.z * vector2.y);
	ret.y = (vector1.z * vector2.x) - (vector1.x * vector2.z);
	ret.z = (vector1.x * vector2.y) - (vector1.y * vector2.x);
	return ret;
}

static inline Vector3D Vector3DMultiplyByScalar(Vector3D vector, float scalar)
{	
	Vector3D ret;
	
	ret.x = vector.x * scalar;
	ret.y = vector.y * scalar;
	ret.z = vector.z * scalar;

	return ret;
}

static inline Vector3D Vector3DMakeWithStartAndEndPoints(Vertex3D start, Vertex3D end)
{
	Vector3D ret;
	ret.x = end.x - start.x;
	ret.y = end.y - start.y;
	ret.z = end.z - start.z;
	Vector3DNormalize(&ret);
	return ret;
}
static inline Vector3D Vector3DAdd(Vector3D vector1, Vector3D vector2)
{
	Vector3D ret;
	ret.x = vector1.x + vector2.x;
	ret.y = vector1.y + vector2.y;
	ret.z = vector1.z + vector2.z;
	return ret;
}
static inline Vector3D Vector3DSubtract(Vector3D vector1, Vector3D vector2)
{
	Vector3D ret;
	ret.x = vector1.x - vector2.x;
	ret.y = vector1.y - vector2.y;
	ret.z = vector1.z - vector2.z;
	return ret;
}
static inline void Vector3DFlip (Vector3D *vector)
{
	vector->x = -vector->x;
	vector->y = -vector->y;
	vector->z = -vector->z;
}

static inline float Vector3DAngleBetweenVectorsXYAxis(Vector3D vector1, Vector3D vector2)
{
	Vector3DFastNormalize(&vector1);
	Vector3DFastNormalize(&vector2);
	
	return acosf(vector1.x*vector2.x + vector1.y*vector2.y);
}

static inline float Vector3DAngleBetweenVectorsXZAxis(Vector3D vector1, Vector3D vector2)
{
	Vector3DFastNormalize(&vector1);
	Vector3DFastNormalize(&vector2);
	
	return acosf(vector1.x*vector2.x + vector1.z*vector2.z);
}

static inline float Vector3DAngleBetweenVectorsYZAxis(Vector3D vector1, Vector3D vector2)
{
	Vector3DFastNormalize(&vector1);
	Vector3DFastNormalize(&vector2);
	
	return acosf(vector1.y*vector2.y + vector1.z*vector2.z);
}

static inline float Vector3DAxisAngleBetweenVectors(Vector3D vector1, Vector3D vector2)
{
	Vector3DFastNormalize(&vector1);
	Vector3DFastNormalize(&vector2);
	
	return acosf(Vector3DDotProduct(vector1, vector2));

}

#pragma mark -
#pragma mark Matrix3D
#pragma mark -
typedef struct {
	Vector3D row[3];
} Matrix3D;
static inline Matrix3D Matrix3DMake(Vector3D row1, Vector3D row2, Vector3D row3)
{
	Matrix3D mat;
	
	mat.row[0] = row1;
	mat.row[1] = row2;
	mat.row[2] = row3;
	
	return mat;
}
static inline Matrix3D Matrix3DMakeFromVectorRow(Vector3D row)
{
	return Matrix3DMake(row, Vector3DMake(0, 0, 0), Vector3DMake(0, 0, 0));
}
static inline Matrix3D Matrix3DMakeFromVectorColumn(Vector3D col)
{
	return Matrix3DMake(Vector3DMake(col.x, 0, 0), Vector3DMake(col.y, 0, 0), Vector3DMake(col.z, 0, 0));
}
static inline Matrix3D Matrix3DRotationX(float theta)
{
	Vector3D row1 = Vector3DMake(1, 0, 0);
	Vector3D row2 = Vector3DMake(0, cosf(theta), -sinf(theta));
	Vector3D row3 = Vector3DMake(0, sinf(theta), cosf(theta));
	
	return Matrix3DMake(row1, row2, row3);
}
static inline Matrix3D Matrix3DRotationY(float theta)
{
	Vector3D row1 = Vector3DMake(cosf(theta), 0, sinf(theta));
	Vector3D row2 = Vector3DMake(0, 1, 0);
	Vector3D row3 = Vector3DMake(-sinf(theta), 0, cosf(theta));
	
	return Matrix3DMake(row1, row2, row3);
}
static inline Matrix3D Matrix3DRotationZ(float theta)
{
	Vector3D row1 = Vector3DMake(cosf(theta), -sinf(theta), 0);
	Vector3D row2 = Vector3DMake(sinf(theta), cosf(theta), 0);
	Vector3D row3 = Vector3DMake(0, 0, 1);
	
	return Matrix3DMake(row1, row2, row3);
}
static inline Matrix3D Matrix3DMultiply(Matrix3D mat1, Matrix3D mat2)
{
	Matrix3D matRez;
	Vector3D col;
	
	col = Vector3DMake(mat2.row[0].x, mat2.row[1].x, mat2.row[2].x);
	matRez.row[0].x = Vector3DDotProduct(mat1.row[0], col);
	matRez.row[1].x = Vector3DDotProduct(mat1.row[1], col);
	matRez.row[2].x = Vector3DDotProduct(mat1.row[2], col);
	
	col = Vector3DMake(mat2.row[0].y, mat2.row[1].y, mat2.row[2].y);
	matRez.row[0].y = Vector3DDotProduct(mat1.row[0], col);
	matRez.row[1].y = Vector3DDotProduct(mat1.row[1], col);
	matRez.row[2].y = Vector3DDotProduct(mat1.row[2], col);
	
	col = Vector3DMake(mat2.row[0].z, mat2.row[1].z, mat2.row[2].z);
	matRez.row[0].z = Vector3DDotProduct(mat1.row[0], col);
	matRez.row[1].z = Vector3DDotProduct(mat1.row[1], col);
	matRez.row[2].z = Vector3DDotProduct(mat1.row[2], col);
	
	return matRez;
	
}
static inline void Matrix3DRotateVectorX(Vector3D *vec, float theta)
{
	Matrix3D rotationX = Matrix3DRotationX(theta);
	Matrix3D vectorMat = Matrix3DMakeFromVectorColumn(*vec);
	
	Matrix3D rotationMat = Matrix3DMultiply(rotationX, vectorMat);
	
	*vec = Vector3DMake(rotationMat.row[0].x, rotationMat.row[1].x, rotationMat.row[2].x);
}
static inline void Matrix3DRotateVectorY(Vector3D *vec, float theta)
{
	Matrix3D rotationY = Matrix3DRotationY(theta);
	Matrix3D vectorMat = Matrix3DMakeFromVectorColumn(*vec);
	
	Matrix3D rotationMat = Matrix3DMultiply(rotationY, vectorMat);
	
	*vec = Vector3DMake(rotationMat.row[0].x, rotationMat.row[1].x, rotationMat.row[2].x);
}
static inline void Matrix3DRotateVectorZ(Vector3D *vec, float theta)
{
	Matrix3D rotationZ = Matrix3DRotationZ(theta);
	Matrix3D vectorMat = Matrix3DMakeFromVectorColumn(*vec);
	
	Matrix3D rotationMat = Matrix3DMultiply(rotationZ, vectorMat);
	
	*vec = Vector3DMake(rotationMat.row[0].x, rotationMat.row[1].x, rotationMat.row[2].x);
}


#pragma mark -
#pragma mark Rotation3D
#pragma mark -
// A Rotation3D is just a Vertex3D used to store three angles (pitch, yaw, roll) instead of cartesian coordinates. 
// For simplicity, we just reuse the Vertex3D, even though the member names should probably be either xRot, yRot, 
// and zRot, or else pitch, yaw, roll. 
typedef Vertex3D Rotation3D;
#define Rotation3DMake(x,y,z) (Rotation3D)Vertex3DMake(x, y, z)
#pragma mark -
#pragma mark Face3D
#pragma mark -
// Face3D is used to hold three integers which will be integer index values to another array
typedef struct {
	GLushort	v1;
	GLushort	v2;
	GLushort	v3;
} Face3D;
static inline Face3D Face3DMake(int v1, int v2, int v3)
{
	Face3D ret;
	ret.v1 = v1;
	ret.v2 = v2;
	ret.v3 = v3;
	return ret;
}
#pragma mark -
#pragma mark Triangle3D
#pragma mark -
typedef struct {
	Vertex3D v1;
	Vertex3D v2;
	Vertex3D v3;
} Triangle3D;
static inline Triangle3D Triangle3DMake(Vertex3D inV1, Vertex3D inV2, Vertex3D inV3)
{
	Triangle3D ret;
	ret.v1 = inV1;
	ret.v2 = inV2;
	ret.v3 = inV3;
	return ret;
}
static inline Vector3D Triangle3DCalculateSurfaceNormal(Triangle3D triangle)
{
	Vector3D u = Vector3DMakeWithStartAndEndPoints(triangle.v2, triangle.v1);
	Vector3D v = Vector3DMakeWithStartAndEndPoints(triangle.v3, triangle.v1);
	
	Vector3D ret;
	ret.x = (u.y * v.z) - (u.z * v.y);
	ret.y = (u.z * v.x) - (u.x * v.z);
	ret.z = (u.x * v.y) - (u.y * v.x);
	return ret;
}
#pragma mark -
#pragma mark VertexTextureCombinations
#pragma mark -
// This implements a binary search tree that will help us determine which vertices need to be duplicated. In
// OpenGL, each vertex has to have one and only one set of texture coordinates, so if a single vertex is shared
// by multiple triangles and has different texture coordinates in each, those vertices need to be duplicated
// so that there is one copy of that vertex for every distinct set of texture coordinates.

// This works with index values, not actual Vertex3D values, for speed, and because that's the way the 
// OBJ file format tells us about them
//
// An actualVertex value of UINT_MAX means that the actual integer value hasn't been determined yet. 
typedef struct {
	GLuint	originalVertex;
	GLuint	textureCoords;
	GLuint	actualVertex;
	void	*greater;
	void	*lesser;
	
} VertexTextureIndex;
static inline VertexTextureIndex * VertexTextureIndexMake (GLuint inVertex, GLuint inTextureCoords, GLuint inActualVertex)
{
	VertexTextureIndex *ret = malloc(sizeof(VertexTextureIndex));
	ret->originalVertex = inVertex;
	ret->textureCoords = inTextureCoords;
	ret->actualVertex = inActualVertex;
	ret->greater = NULL;
	ret->lesser = NULL;
	return ret;
}
#define VertexTextureIndexMakeEmpty(x,y) VertexTextureIndexMake(x, y, UINT_MAX)
// recursive search function - looks for a match for a given combination of vertex and 
// texture coordinates. If not found, returns UINT_MAX
static inline GLuint VertexTextureIndexMatch(VertexTextureIndex *node, GLuint matchVertex, GLuint matchTextureCoords)
{
	if (node->originalVertex == matchVertex && node->textureCoords == matchTextureCoords)
		return node->actualVertex;
	
	if (node->greater != NULL)
	{
		GLuint greaterIndex = VertexTextureIndexMatch(node->greater, matchVertex, matchTextureCoords);
		if (greaterIndex != UINT_MAX)
			return greaterIndex;
	}
	
	if (node->lesser != NULL)
	{
		GLuint lesserIndex = VertexTextureIndexMatch(node->lesser, matchVertex, matchTextureCoords);
		return lesserIndex;
	}
	return UINT_MAX;
}
static inline VertexTextureIndex * VertexTextureIndexAddNode(VertexTextureIndex *node, GLuint newVertex, GLuint newTextureCoords)
{
	// If requested new node matches the one being added to, then don't add, just return pointer to match
	if (node->originalVertex == newVertex && node->textureCoords == newTextureCoords)
		return node;
	if (node->originalVertex > newVertex || (node->originalVertex == newVertex && node->textureCoords > newTextureCoords))
	{
		if (node->lesser != NULL)
			return VertexTextureIndexAddNode(node->lesser, newVertex, newTextureCoords);
		else
		{
			VertexTextureIndex *newNode = VertexTextureIndexMakeEmpty(newVertex, newTextureCoords);
			node->lesser = newNode;
			return node->lesser;
		}
	}
	else
	{
		if (node->greater != NULL)
			return VertexTextureIndexAddNode(node->greater, newVertex, newTextureCoords);
		else
		{
			VertexTextureIndex *newNode = VertexTextureIndexMakeEmpty(newVertex, newTextureCoords);
			node->greater = newNode;
			return node->greater;
		}	
	}
	return NULL; // shouldn't ever reach here.
}
static inline BOOL VertexTextureIndexContainsVertexIndex(VertexTextureIndex *node, GLuint matchVertex)
{
	if (node->originalVertex == matchVertex)
		return YES;
	
	BOOL greaterHas = NO;
	BOOL lesserHas = NO;
	
	if (node->greater != NULL)
		greaterHas = VertexTextureIndexContainsVertexIndex(node->greater, matchVertex);
	if (node->lesser != NULL)
		lesserHas = VertexTextureIndexContainsVertexIndex(node->lesser, matchVertex);
	return lesserHas || greaterHas;
}
static inline void VertexTextureIndexFree(VertexTextureIndex *node)
{
	if (node != NULL)
	{
		if (node->greater != NULL)
			VertexTextureIndexFree(node->greater);
		if (node->lesser != NULL)
			VertexTextureIndexFree(node->lesser);
		free(node);
	}
	
}
static inline GLuint VertexTextureIndexCountNodes(VertexTextureIndex *node)
{
	GLuint ret = 0;  
	
	if (node)
	{
		ret++; // count this node
		
		// Add the children
		if (node->greater != NULL)
			ret += VertexTextureIndexCountNodes(node->greater);
		if (node->lesser != NULL)
			ret += VertexTextureIndexCountNodes(node->lesser);
	}
	return ret;
}

#pragma mark -
#pragma mark Colored Normal Vertex Data
typedef struct
{
	Vertex3D vertices;
	Vector3D normals;
	Color3D colors;
} ColoredNormalVertex3D; 

#pragma mark -
#pragma mark Textured Normal Vertex Data
typedef struct
{
	Vertex3D vertices;
	Vector3D normals;
	TexCoords texCoords;
} TexturedNormalVertex3D; 

#pragma mark -
#pragma mark Missing GLUT Functionality
// This is a modified version of the function of the same name from 
// the Mesa3D project ( http://mesa3d.org/ ), which is  licensed
// under the MIT license, which allows use, modification, and 
// redistribution


/*
 * Transform a point (column vector) by a 4x4 matrix.  I.e.  out = m * in
 * Input:  m - the 4x4 matrix
 *         in - the 4x1 vector
 * Output:  out - the resulting 4x1 vector.
 */
static void
transform_point(GLfloat out[4], const GLfloat m[16], const GLfloat in[4])
{
#define M(row,col)  m[col*4+row]
	out[0] =
	M(0, 0) * in[0] + M(0, 1) * in[1] + M(0, 2) * in[2] + M(0, 3) * in[3];
	out[1] =
	M(1, 0) * in[0] + M(1, 1) * in[1] + M(1, 2) * in[2] + M(1, 3) * in[3];
	out[2] =
	M(2, 0) * in[0] + M(2, 1) * in[1] + M(2, 2) * in[2] + M(2, 3) * in[3];
	out[3] =
	M(3, 0) * in[0] + M(3, 1) * in[1] + M(3, 2) * in[2] + M(3, 3) * in[3];
#undef M
}




/*
 * Perform a 4x4 matrix multiplication  (product = a x b).
 * Input:  a, b - matrices to multiply
 * Output:  product - product of a and b
 */
static void
matmul(GLfloat * product, const GLfloat * a, const GLfloat * b)
{
	/* This matmul was contributed by Thomas Malik */
	GLfloat temp[16];
	GLint i;
	
#define A(row,col)  a[(col<<2)+row]
#define B(row,col)  b[(col<<2)+row]
#define T(row,col)  temp[(col<<2)+row]
	
	/* i-te Zeile */
	for (i = 0; i < 4; i++) {
		T(i, 0) =
		A(i, 0) * B(0, 0) + A(i, 1) * B(1, 0) + A(i, 2) * B(2, 0) + A(i,
																	  3) *
		B(3, 0);
		T(i, 1) =
		A(i, 0) * B(0, 1) + A(i, 1) * B(1, 1) + A(i, 2) * B(2, 1) + A(i,
																	  3) *
		B(3, 1);
		T(i, 2) =
		A(i, 0) * B(0, 2) + A(i, 1) * B(1, 2) + A(i, 2) * B(2, 2) + A(i,
																	  3) *
		B(3, 2);
		T(i, 3) =
		A(i, 0) * B(0, 3) + A(i, 1) * B(1, 3) + A(i, 2) * B(2, 3) + A(i,
																	  3) *
		B(3, 3);
	}
	
#undef A
#undef B
#undef T
	memcpy(product, temp, 16 * sizeof(GLfloat));
}



/*
 * Compute inverse of 4x4 transformation matrix.
 * Code contributed by Jacques Leroy jle@star.be
 * Return GL_TRUE for success, GL_FALSE for failure (singular matrix)
 */
static GLboolean
invert_matrix(const GLfloat * m, GLfloat * out)
{
	/* NB. OpenGL Matrices are COLUMN major. */
#define SWAP_ROWS(a, b) { GLfloat *_tmp = a; (a)=(b); (b)=_tmp; }
#define MAT(m,r,c) (m)[(c)*4+(r)]
	
	GLfloat wtmp[4][8];
	GLfloat m0, m1, m2, m3, s;
	GLfloat *r0, *r1, *r2, *r3;
	
	r0 = wtmp[0], r1 = wtmp[1], r2 = wtmp[2], r3 = wtmp[3];
	
	r0[0] = MAT(m, 0, 0), r0[1] = MAT(m, 0, 1),
	r0[2] = MAT(m, 0, 2), r0[3] = MAT(m, 0, 3),
	r0[4] = 1.0, r0[5] = r0[6] = r0[7] = 0.0,
	r1[0] = MAT(m, 1, 0), r1[1] = MAT(m, 1, 1),
	r1[2] = MAT(m, 1, 2), r1[3] = MAT(m, 1, 3),
	r1[5] = 1.0, r1[4] = r1[6] = r1[7] = 0.0,
	r2[0] = MAT(m, 2, 0), r2[1] = MAT(m, 2, 1),
	r2[2] = MAT(m, 2, 2), r2[3] = MAT(m, 2, 3),
	r2[6] = 1.0, r2[4] = r2[5] = r2[7] = 0.0,
	r3[0] = MAT(m, 3, 0), r3[1] = MAT(m, 3, 1),
	r3[2] = MAT(m, 3, 2), r3[3] = MAT(m, 3, 3),
	r3[7] = 1.0, r3[4] = r3[5] = r3[6] = 0.0;
	
	/* choose pivot - or die */
	if (fabs(r3[0]) > fabs(r2[0]))
		SWAP_ROWS(r3, r2);
	if (fabs(r2[0]) > fabs(r1[0]))
		SWAP_ROWS(r2, r1);
	if (fabs(r1[0]) > fabs(r0[0]))
		SWAP_ROWS(r1, r0);
	if (0.0 == r0[0])
		return GL_FALSE;
	
	/* eliminate first variable     */
	m1 = r1[0] / r0[0];
	m2 = r2[0] / r0[0];
	m3 = r3[0] / r0[0];
	s = r0[1];
	r1[1] -= m1 * s;
	r2[1] -= m2 * s;
	r3[1] -= m3 * s;
	s = r0[2];
	r1[2] -= m1 * s;
	r2[2] -= m2 * s;
	r3[2] -= m3 * s;
	s = r0[3];
	r1[3] -= m1 * s;
	r2[3] -= m2 * s;
	r3[3] -= m3 * s;
	s = r0[4];
	if (s != 0.0) {
		r1[4] -= m1 * s;
		r2[4] -= m2 * s;
		r3[4] -= m3 * s;
	}
	s = r0[5];
	if (s != 0.0) {
		r1[5] -= m1 * s;
		r2[5] -= m2 * s;
		r3[5] -= m3 * s;
	}
	s = r0[6];
	if (s != 0.0) {
		r1[6] -= m1 * s;
		r2[6] -= m2 * s;
		r3[6] -= m3 * s;
	}
	s = r0[7];
	if (s != 0.0) {
		r1[7] -= m1 * s;
		r2[7] -= m2 * s;
		r3[7] -= m3 * s;
	}
	
	/* choose pivot - or die */
	if (fabs(r3[1]) > fabs(r2[1]))
		SWAP_ROWS(r3, r2);
	if (fabs(r2[1]) > fabs(r1[1]))
		SWAP_ROWS(r2, r1);
	if (0.0 == r1[1])
		return GL_FALSE;
	
	/* eliminate second variable */
	m2 = r2[1] / r1[1];
	m3 = r3[1] / r1[1];
	r2[2] -= m2 * r1[2];
	r3[2] -= m3 * r1[2];
	r2[3] -= m2 * r1[3];
	r3[3] -= m3 * r1[3];
	s = r1[4];
	if (0.0 != s) {
		r2[4] -= m2 * s;
		r3[4] -= m3 * s;
	}
	s = r1[5];
	if (0.0 != s) {
		r2[5] -= m2 * s;
		r3[5] -= m3 * s;
	}
	s = r1[6];
	if (0.0 != s) {
		r2[6] -= m2 * s;
		r3[6] -= m3 * s;
	}
	s = r1[7];
	if (0.0 != s) {
		r2[7] -= m2 * s;
		r3[7] -= m3 * s;
	}
	
	/* choose pivot - or die */
	if (fabs(r3[2]) > fabs(r2[2]))
		SWAP_ROWS(r3, r2);
	if (0.0 == r2[2])
		return GL_FALSE;
	
	/* eliminate third variable */
	m3 = r3[2] / r2[2];
	r3[3] -= m3 * r2[3], r3[4] -= m3 * r2[4],
	r3[5] -= m3 * r2[5], r3[6] -= m3 * r2[6], r3[7] -= m3 * r2[7];
	
	/* last check */
	if (0.0 == r3[3])
		return GL_FALSE;
	
	s = 1.0 / r3[3];		/* now back substitute row 3 */
	r3[4] *= s;
	r3[5] *= s;
	r3[6] *= s;
	r3[7] *= s;
	
	m2 = r2[3];			/* now back substitute row 2 */
	s = 1.0 / r2[2];
	r2[4] = s * (r2[4] - r3[4] * m2), r2[5] = s * (r2[5] - r3[5] * m2),
	r2[6] = s * (r2[6] - r3[6] * m2), r2[7] = s * (r2[7] - r3[7] * m2);
	m1 = r1[3];
	r1[4] -= r3[4] * m1, r1[5] -= r3[5] * m1,
	r1[6] -= r3[6] * m1, r1[7] -= r3[7] * m1;
	m0 = r0[3];
	r0[4] -= r3[4] * m0, r0[5] -= r3[5] * m0,
	r0[6] -= r3[6] * m0, r0[7] -= r3[7] * m0;
	
	m1 = r1[2];			/* now back substitute row 1 */
	s = 1.0 / r1[1];
	r1[4] = s * (r1[4] - r2[4] * m1), r1[5] = s * (r1[5] - r2[5] * m1),
	r1[6] = s * (r1[6] - r2[6] * m1), r1[7] = s * (r1[7] - r2[7] * m1);
	m0 = r0[2];
	r0[4] -= r2[4] * m0, r0[5] -= r2[5] * m0,
	r0[6] -= r2[6] * m0, r0[7] -= r2[7] * m0;
	
	m0 = r0[1];			/* now back substitute row 0 */
	s = 1.0 / r0[0];
	r0[4] = s * (r0[4] - r1[4] * m0), r0[5] = s * (r0[5] - r1[5] * m0),
	r0[6] = s * (r0[6] - r1[6] * m0), r0[7] = s * (r0[7] - r1[7] * m0);
	
	MAT(out, 0, 0) = r0[4];
	MAT(out, 0, 1) = r0[5], MAT(out, 0, 2) = r0[6];
	MAT(out, 0, 3) = r0[7], MAT(out, 1, 0) = r1[4];
	MAT(out, 1, 1) = r1[5], MAT(out, 1, 2) = r1[6];
	MAT(out, 1, 3) = r1[7], MAT(out, 2, 0) = r2[4];
	MAT(out, 2, 1) = r2[5], MAT(out, 2, 2) = r2[6];
	MAT(out, 2, 3) = r2[7], MAT(out, 3, 0) = r3[4];
	MAT(out, 3, 1) = r3[5], MAT(out, 3, 2) = r3[6];
	MAT(out, 3, 3) = r3[7];
	
	return GL_TRUE;
	
#undef MAT
#undef SWAP_ROWS
}



static inline void gluLookAt(GLfloat eyex, GLfloat eyey, GLfloat eyez,
							 GLfloat centerx, GLfloat centery, GLfloat centerz,
							 GLfloat upx, GLfloat upy, GLfloat upz)
{
	GLfloat m[16];
	GLfloat x[3], y[3], z[3];
	GLfloat mag;
	
	/* Make rotation matrix */
	
	/* Z vector */
	z[0] = eyex - centerx;
	z[1] = eyey - centery;
	z[2] = eyez - centerz;
	mag = sqrtf(z[0] * z[0] + z[1] * z[1] + z[2] * z[2]);
	if (mag) {			/* mpichler, 19950515 */
		z[0] /= mag;
		z[1] /= mag;
		z[2] /= mag;
	}
	
	/* Y vector */
	y[0] = upx;
	y[1] = upy;
	y[2] = upz;
	
	/* X vector = Y cross Z */
	x[0] = y[1] * z[2] - y[2] * z[1];
	x[1] = -y[0] * z[2] + y[2] * z[0];
	x[2] = y[0] * z[1] - y[1] * z[0];
	
	/* Recompute Y = Z cross X */
	y[0] = z[1] * x[2] - z[2] * x[1];
	y[1] = -z[0] * x[2] + z[2] * x[0];
	y[2] = z[0] * x[1] - z[1] * x[0];
	
	/* mpichler, 19950515 */
	/* cross product gives area of parallelogram, which is < 1.0 for
	 * non-perpendicular unit-length vectors; so normalize x, y here
	 */
	
	mag = sqrtf(x[0] * x[0] + x[1] * x[1] + x[2] * x[2]);
	if (mag) {
		x[0] /= mag;
		x[1] /= mag;
		x[2] /= mag;
	}
	
	mag = sqrtf(y[0] * y[0] + y[1] * y[1] + y[2] * y[2]);
	if (mag) {
		y[0] /= mag;
		y[1] /= mag;
		y[2] /= mag;
	}
	
#define M(row,col)  m[col*4+row]
	M(0, 0) = x[0];
	M(0, 1) = x[1];
	M(0, 2) = x[2];
	M(0, 3) = 0.0;
	M(1, 0) = y[0];
	M(1, 1) = y[1];
	M(1, 2) = y[2];
	M(1, 3) = 0.0;
	M(2, 0) = z[0];
	M(2, 1) = z[1];
	M(2, 2) = z[2];
	M(2, 3) = 0.0;
	M(3, 0) = 0.0;
	M(3, 1) = 0.0;
	M(3, 2) = 0.0;
	M(3, 3) = 1.0;
#undef M
	glMultMatrixf(m);
	
	/* Translate Eye to Origin */
	glTranslatef(-eyex, -eyey, -eyez);
	
}

static inline void glEnable2D()
{
	int vPort[4];
	
	glGetIntegerv(GL_VIEWPORT, vPort);
	
	glMatrixMode(GL_PROJECTION);
	glPushMatrix();
	glLoadIdentity();
	
	glOrthof(0.0, vPort[2], 0.0, vPort[3], -1.0, 1.0);
	glMatrixMode(GL_MODELVIEW);
	glPushMatrix();
	glLoadIdentity();
}
static inline void glDisable2D()
{
	glMatrixMode(GL_PROJECTION);
	glPopMatrix();   
	glMatrixMode(GL_MODELVIEW);
	glPopMatrix();	
}


static inline void gluPerspective(double fovy, double aspect, double zNear, double zFar) 
{ 
	// Start in projection mode. 
	glMatrixMode(GL_PROJECTION); 
	glLoadIdentity(); 
	double xmin, xmax, ymin, ymax; 
	ymax = zNear * tan(fovy * M_PI / 360.0); 
	ymin = -ymax; 
	xmin = ymin * aspect; 
	xmax = ymax * aspect; 
	glFrustumf(xmin, xmax, ymin, ymax, zNear, zFar); 
}

/* projection du point (objx,objy,obz) sur l'ecran (winx,winy,winz) */
static inline GLint gluProject(GLfloat objx, GLfloat objy, GLfloat objz,
		   const GLfloat model[16], const GLfloat proj[16],
		   const GLint viewport[4],
		   GLfloat * winx, GLfloat * winy, GLfloat * winz)
{
	/* matrice de transformation */
	GLfloat in[4], out[4];
	
	/* initilise la matrice et le vecteur a transformer */
	in[0] = objx;
	in[1] = objy;
	in[2] = objz;
	in[3] = 1.0;
	transform_point(out, model, in);
	transform_point(in, proj, out);
	
	/* d'ou le resultat normalise entre -1 et 1 */
	//if (in[3] == 0.0)
	//	return GL_FALSE;
	
	in[0] /= in[3];
	in[1] /= in[3];
	in[2] /= in[3];
	
	/* en coordonnees ecran */
	*winx = viewport[0] + (1 + in[0]) * viewport[2] / 2;
	*winy = viewport[1] + (1 + in[1]) * viewport[3] / 2;
	/* entre 0 et 1 suivant z */
	*winz = (1 + in[2]) / 2;
	return GL_TRUE;
}



/* transformation du point ecran (winx,winy,winz) en point objet */
static inline GLint gluUnProject(GLfloat winx, GLfloat winy, GLfloat winz,
			 const GLfloat model[16], const GLfloat proj[16],
			 const GLint viewport[4],
			 GLfloat * objx, GLfloat * objy, GLfloat * objz)
{
	/* matrice de transformation */
	GLfloat m[16], A[16];
	GLfloat in[4], out[4];
	
	/* transformation coordonnees normalisees entre -1 et 1 */
	in[0] = (winx - viewport[0]) * 2 / viewport[2] - 1.0;
	in[1] = (winy - viewport[1]) * 2 / viewport[3] - 1.0;
	in[2] = 2 * winz - 1.0;
	in[3] = 1.0;
	
	/* calcul transformation inverse */
	matmul(A, proj, model);
	invert_matrix(A, m);
	
	/* d'ou les coordonnees objets */
	transform_point(out, m, in);
	if (out[3] == 0.0)
		return GL_FALSE;
	*objx = out[0] / out[3];
	*objy = out[1] / out[3];
	*objz = out[2] / out[3];
	return GL_TRUE;
}

#pragma mark -
#pragma mark ADDITIONAL FUNCTIONS

static inline void makeInterleavedTexturedQuad(TexturedNormalVertex3D **vertData, CGSize size)
{	
	int numVerts = 4;
	TexturedNormalVertex3D *tempVertData = malloc(numVerts * sizeof(TexturedNormalVertex3D));
	
	//vertices
	tempVertData[0].vertices.x = 0.0 - size.width;
	tempVertData[0].vertices.y = 0.0 - size.height;
	tempVertData[0].vertices.z = 0.0;
	
	tempVertData[1].vertices.x = 0.0 + size.width;
	tempVertData[1].vertices.y = 0.0 - size.height;
	tempVertData[1].vertices.z = 0.0;
	
	tempVertData[2].vertices.x = 0.0 - size.width;
	tempVertData[2].vertices.y = 0.0 + size.height;
	tempVertData[2].vertices.z = 0.0;
	
	tempVertData[3].vertices.x = 0.0 + size.width;
	tempVertData[3].vertices.y = 0.0 + size.height;
	tempVertData[3].vertices.z = 0.0;
	
	
	//normals
	tempVertData[0].normals.x = 0.0;
	tempVertData[0].normals.y = 0.0;
	tempVertData[0].normals.z = 1.0;
	
	tempVertData[1].normals.x = 0.0;
	tempVertData[1].normals.y = 0.0;
	tempVertData[1].normals.z = 1.0;
	
	tempVertData[2].normals.x = 0.0;
	tempVertData[2].normals.y = 0.0;
	tempVertData[2].normals.z = 1.0;
	
	tempVertData[3].normals.x = 0.0;
	tempVertData[3].normals.y = 0.0;
	tempVertData[3].normals.z = 1.0;
	
	
	//tex coords
	tempVertData[0].texCoords.u = 0.0;
	tempVertData[0].texCoords.v = 1.0;
	
	tempVertData[0].texCoords.u = 1.0;
	tempVertData[0].texCoords.v = 1.0;
	
	tempVertData[0].texCoords.u = 0.0;
	tempVertData[0].texCoords.v = 0.0;
	
	tempVertData[0].texCoords.u = 1.0;
	tempVertData[0].texCoords.v = 0.0;
	
	*vertData = tempVertData;
	//free(tempVertData);
}

