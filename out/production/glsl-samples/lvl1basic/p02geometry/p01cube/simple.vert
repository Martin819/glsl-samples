#version 150
in vec3 inPosition; // input from the vertex buffer
in vec3 inNormal; // input from the vertex buffer
out vec3 vertColor; // output from this shader to the next pipeline stage
out vec3 vertNormal;
out vec3 vertPosition;
uniform mat4 matCube; // variable constant for all vertices in a single draw
uniform vec3 lightPosCube;
uniform vec3 eyePosCube;
void main() {
    float distance = length(lightPosCube - inPosition);
	gl_Position = matCube * vec4(inPosition, 1.0);
//	vertColor = inNormal * 0.5 + 0.5;
    vec3 matDifCol = vec3(0.8, 0.9, 0.6);
    vec3 matSpecCol = vec3(1);
    vec3 ambientLightCol = vec3(0.3, 0.1, 0.5);
    vec3 directLightCol = vec3(1.0, 0.9, 0.9);
	vec3 lightVector = normalize(lightPosCube - inPosition);
	vec3 eyeVector = normalize(eyePosCube - inPosition);
	float diffuse = max(0, dot(inNormal, lightVector));
	vec3 difComponent = directLightCol * matDifCol * diffuse;
	vec3 ambComponent = ambientLightCol * matDifCol;
	vec3 reflected = reflect(normalize(inPosition - lightPosCube), inNormal);
	float specCoef = pow(max(0, dot(eyeVector, reflected)), 70);
	vec3 specComponent = directLightCol * specCoef * matSpecCol;
    vertColor = difComponent + ambComponent + specComponent;
    vertNormal = inNormal;
    vertPosition = inPosition;
//	vertColor = (difComponent + ambComponent) / (0.4 * distance);
//  diffuse = diffuse / (0.4 * distance);
//	vertColor = vec3(1) * diffuse;
}
