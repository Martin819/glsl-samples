#version 150
#define PI 3.14159265359
in vec2 inParamPos; // input from the vertex buffer
out vec3 vertColor; // output from this shader to the next pipeline stage
out vec3 vertNormal;
out vec3 vertPosition;

uniform mat4 mat; // variable constant for all vertices in a single draw
uniform vec3 lightPos; // possibly n
uniform vec3 eyePos;

vec3 plane(vec2 paramPos) {
    return vec3(10 * paramPos, 3);
}

vec3 sphere(vec2 paramPos) {
	float a = 2 * PI * paramPos.x;
	float z = PI * paramPos.y;
	return vec3(cos(a) * sin(z),
			sin(a) * sin(z),
			sin(z));
}

vec3 planeNormal(vec2 paramPos) {
    return vec3(0,0,1);
}

vec3 sphereNormal(vec2 paramPos) {
    return sphere(paramPos);
}

vec3 something(vec2 paramPos) {
	float a = 2 * PI * paramPos.x;
	float z = PI * paramPos.y;
	return vec3(cos(a) * paramPos.y,
			sin(a) * paramPos.y,
			1 - paramPos.y);
}

vec3 somethingNormal(vec2 paramPos) {
//	float a = 2*PI * paramPos.x;
 //   vec3 t1 = vec3(-sin(a) * paramPos.y, cos(a) * paramPos.y, 0);
  //  vec3 t2 = vec3(cos(a), sin(a), -1);
    float xx = 0.001;
    vec3 t1 = (something(inParamPos + vec2(xx, 0)) - something(inParamPos - vec2(xx, 0)));
    vec3 t2 = (something(inParamPos + vec2(0, xx)) - something(inParamPos - vec2(0, xx)));
    return cross(t2,t1);
}

void main() {
    vertPosition = something(inParamPos);
	gl_Position = mat * vec4(vertPosition, 1.0);

    vertNormal = somethingNormal(inParamPos);
	
//	vertColor = vertNormal * 0.5 + 0.5;
    // better use uniforms:
    vec3 matDifCol = vec3(0.8, 0.9, 0.6);
    vec3 matSpecCol = vec3(1);
    vec3 ambientLightCol = vec3(0.3, 0.1, 0.5);
    vec3 directLightCol = vec3(1.0, 0.9, 0.9); // possibly n
    // /better use uniforms

    vec3 ambiComponent = ambientLightCol * matDifCol;

    float difCoef = max(0, dot(vertNormal, normalize(lightPos - vertPosition)));
    vec3 difComponent = directLightCol * matDifCol * difCoef;

    vec3 reflected = reflect(normalize(vertPosition - lightPos), vertNormal);
    float specCoef = pow(max(0,
        dot(normalize(eyePos - vertPosition), reflected)
    ), 70);
    vec3 specComponent = directLightCol * matSpecCol * specCoef;
	vertColor = ambiComponent + difComponent + specComponent;
	vertColor = vec3(inParamPos,0);
	vertColor = vertNormal;
}
