#version 150
in vec2 inParamPos;
in vec3 inPosition; // input from the vertex buffer
in vec3 inNormal; // input from the vertex buffer
out vec3 vertColor; // output from this shader to the next pipeline stage
out vec3 vertNormal;
out vec3 vertPosition;
uniform mat4 matCube; // variable constant for all vertices in a single draw
uniform vec3 lightPosCube;
uniform vec3 eyePosCube;
void main() {
    vertColor = difComponent + ambComponent + specComponent;
    vertNormal = vec3(0,0,1);
    vertPosition = vec3(inParamPos, 0.0);
    float distance = length(lightPosCube - inPosition);
	gl_Position = matCube * vec4(vertPosition, 1.0);
//	vertColor = inNormal * 0.5 + 0.5;
    vec3 matDifCol = vec3(0.8, 0.9, 0.6);
    vec3 matSpecCol = vec3(1);
    vec3 ambientLightCol = vec3(0.3, 0.1, 0.5);
    vec3 directLightCol = vec3(1.0, 0.9, 0.9);
	vec3 lightVector = normalize(lightPosCube - vertPosition);
	vec3 eyeVector = normalize(eyePosCube - vertPosition);
	float diffuse = max(0, dot(vertNormal, lightVector));
	vec3 difComponent = directLightCol * matDifCol * diffuse;
	vec3 ambComponent = ambientLightCol * matDifCol;
	vec3 reflected = reflect(normalize(vertPosition - lightPosCube), vertNormal);
	float specCoef = pow(max(0, dot(eyeVector, reflected)), 70);
	vec3 specComponent = directLightCol * specCoef * matSpecCol;
    vertColor = vec3(inParamPos, 0);
//	vertColor = (difComponent + ambComponent) / (0.4 * distance);
//  diffuse = diffuse / (0.4 * distance);
//	vertColor = vec3(1) * diffuse;
}
