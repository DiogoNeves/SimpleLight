//
//  Shader.vsh
//  SimpleLight
//
//  Created by Diogo Neves on 02/12/2011.
//  Copyright (c) 2011 Wildbunny Ltd. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;

varying lowp vec4 colorVarying;

varying vec3 vNormal;
varying vec3 vLightDirection;
varying vec3 vLightReflection;
varying vec3 vViewDirection;

uniform mat4 modelViewProjectionMatrix;
uniform mat4 normalMatrix;

void main()
{
	vec3 worldPosition = vec3(normalMatrix * position);

	vNormal = normalize(mat3(normalMatrix) * normal);
	vLightDirection = vec3(0.0, 0.0, 1.5) - worldPosition;
	vLightReflection = -reflect(vLightDirection, vNormal);
	vViewDirection = -worldPosition;
	
    colorVarying = vec4(0.4, 0.4, 1.0, 1.0);
    
    gl_Position = modelViewProjectionMatrix * position;
}
