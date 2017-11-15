#version 150
in vec3 vertColor; // input from the previous pipeline stage
in vec3 vertNormal;
in vec3 vertPosition;

out vec4 outColor; // output from the fragment shader
uniform vec3 lightPos; // possibly n
uniform vec3 eyePos;
void main() {
    // better use uniforms:
    vec3 matDifCol = vec3(0.8, 0.9, 0.6);
    vec3 matSpecCol = vec3(1);
    vec3 ambientLightCol = vec3(0.3, 0.1, 0.5);
    vec3 directLightCol = vec3(1.0, 0.9, 0.9); // possibly n
    // /better use uniforms
    
    vec3 inNormal = normalize(vertNormal);

    vec3 ambiComponent = ambientLightCol * matDifCol;

    float difCoef = max(0, dot(inNormal, normalize(lightPos - vertPosition)));
    vec3 difComponent = directLightCol * matDifCol * difCoef;

    vec3 reflected = reflect(normalize(vertPosition - lightPos), inNormal);
    float specCoef = pow(max(0,
        dot(normalize(eyePos - vertPosition), reflected)
    ), 70);
    vec3 specComponent = directLightCol * matSpecCol * specCoef;

	outColor = vec4(ambiComponent + difComponent + specComponent, 1.0);
//	outColor = vec4(vertColor, 1.0);
} 
