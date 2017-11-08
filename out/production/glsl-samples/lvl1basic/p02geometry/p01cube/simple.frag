#version 150
in vec3 vertColor; // input from the previous pipeline stage
in vec3 v;
in vec3 N;
in vec3 vertNormal;
in vec3 vertPosition;
out vec4 outColor; // output from the fragment shader
uniform vec3 lightPosCube;
uniform vec3 eyePosCube;
void main() {

	//	vertColor = inNormal * 0.5 + 0.5;
	vec3 inNormal = normalize(vertNormal);
    vec3 matDifCol = vec3(0.8, 0.9, 0.6);
    vec3 matSpecCol = vec3(1);
    vec3 ambientLightCol = vec3(0.3, 0.1, 0.5);
    vec3 directLightCol = vec3(1.0, 0.9, 0.9);
    vec3 lightVector = normalize(lightPosCube - vertPosition);
    vec3 eyeVector = normalize(eyePosCube - vertPosition);
    float diffuse = max(0, dot(inNormal, lightVector));
    vec3 difComponent = directLightCol * matDifCol * diffuse;
    vec3 ambComponent = ambientLightCol * matDifCol;
    vec3 reflected = reflect(normalize(vertPosition - lightPosCube), inNormal);
    float specCoef = pow(max(0, dot(eyeVector, reflected)), 70);
    vec3 specComponent = directLightCol * specCoef * matSpecCol;
    outColor = vec4(difComponent + ambComponent + specComponent, 1.0);
}
