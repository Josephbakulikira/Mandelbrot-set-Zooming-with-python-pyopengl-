#version 330 core
layout(location = 0) in vec3 vPos;

void main()
{
    gl_Position = vec4( vPos.xyz, 1.0);
}