#version 150
in vec3 inPosition; // input from the vertex buffer
in vec3 inNormal; // input from the vertex buffer
out vec3 vertColor; // output from this shader to the next pipeline stage
out vec3 vertNormal;
out vec3 vertPosition;

uniform mat4 mat; // variable constant for all vertices in a single draw
uniform vec3 lightPos; // possibly n
uniform vec3 eyePos;
void main() {
	gl_Position = mat * vec4(inPosition, 1.0);
//	vertColor = inNormal * 0.5 + 0.5;
    // better use uniforms:
    vec3 matDifCol = vec3(0.8, 0.9, 0.6);
    vec3 matSpecCol = vec3(1);
    vec3 ambientLightCol = vec3(0.3, 0.1, 0.5);
    vec3 directLightCol = vec3(1.0, 0.9, 0.9); // possibly n
    // /better use uniforms

    vec3 ambiComponent = ambientLightCol * matDifCol;

    float difCoef = max(0, dot(inNormal, normalize(lightPos - inPosition)));
    vec3 difComponent = directLightCol * matDifCol * difCoef;

    vec3 reflected = reflect(normalize(inPosition - lightPos), inNormal);
    float specCoef = pow(max(0,
        dot(normalize(eyePos - inPosition), reflected)
    ), 70);
    vec3 specComponent = directLightCol * matSpecCol * specCoef;
	vertColor = ambiComponent + difComponent + specComponent;

	vertNormal = inNormal;
	vertPosition = inPosition;
}
