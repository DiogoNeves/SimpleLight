//
//  Shader.fsh
//  SimpleLight
//
//  Created by Diogo Neves on 02/12/2011.
//  Copyright (c) 2011 Wildbunny Ltd. All rights reserved.
//

precision mediump float;

varying lowp vec4 colorVarying;

varying vec3 vNormal;
varying vec3 vLightDirection;
varying vec3 vLightReflection;
varying vec3 vViewDirection;

vec4 PhongDiffuse(in vec4 color, in vec3 light, in vec3 normal)
{
	return max(dot(normal, light), 0.0) * color;
}

vec4 OrenNayarDiffuse(in vec4 color, in vec3 light, in vec3 view, in vec3 normal, in float roughness)
{
	float viewToNormal = dot(view, normal);
	float lightToNormal = dot(light, normal);
	float cosThetaI = lightToNormal;
	float thetaR = acos(viewToNormal);
	float thetaI = acos(cosThetaI);
	float cosPhiDiff = dot(normalize(view - normal * viewToNormal), normalize(light - normal * lightToNormal));
	float alpha = max(thetaI, thetaR);
	float beta = min(thetaI, thetaR);
	float sigma2 = roughness * roughness;
	float A = 1.0 - 0.5 * sigma2 / (sigma2 + 0.33);
	float B = 0.45 * sigma2 / (sigma2 + 0.09);
	
	if (cosPhiDiff >= 0.0)
		B *= sin(alpha) * tan(beta);
	else
		B = 0.0;
		
	return cosThetaI * (A + B) * color;
}

vec4 PhongSpecular(in vec4 light, in vec3 reflection, in vec3 viewDirection, in float exponent)
{
	return pow(max(dot(reflection, viewDirection), 0.0), exponent) * light;
}

void main()
{
	// Ambient
	vec4 ambient = vec4(0.1, 0.05, 0.08, 1.0);

	// Diffuse
	vec4 lightDiffuse = vec4(1.0, 1.0, 1.0, 1.0);
	vec3 lightDirection = normalize(vLightDirection);
	vec3 viewDirection = normalize(vViewDirection);
	vec3 normal = normalize(vNormal);
	//vec4 diffuse = PhongDiffuse(colorVarying * lightDiffuse, lightDirection, normal);
	vec4 diffuse = OrenNayarDiffuse(colorVarying * lightDiffuse, lightDirection, viewDirection, normal, 50.0);

	// Specular
	vec4 lightSpecular = vec4(1.0, 1.0, 1.0, 1.0);
	vec3 lightReflection = normalize(vLightReflection);
	vec4 specular = PhongSpecular(lightSpecular * 0.2, lightReflection, viewDirection, 255.0);
	//vec4 specular = vec4(0.0);

	// All
	gl_FragColor = ambient + diffuse + specular;
}
