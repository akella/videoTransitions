precision mediump float;

   varying vec3 vVertexPosition;
   varying vec2 vTextureCoord;
   varying vec2 vFirstTextureCoord;
   varying vec2 vSecondTextureCoord;

   // custom uniforms
   uniform float uTransitionTimer;
   uniform float uTimer;
   uniform float uTo;
   uniform float uFrom;

   // our textures samplers
   uniform sampler2D firstTexture;
   uniform sampler2D secondTexture;
   uniform sampler2D thirdTexture;
   uniform sampler2D displacement;

    vec4 getTextureByIndex(float index, vec2 vUv){
        vec4 result;
        if(index==0.){
            result = texture2D(firstTexture,vUv);
        }
        if(index==1.){
            result = texture2D(secondTexture,vUv);
        }
        if(index==2.){
            result = texture2D(thirdTexture,vUv);
        }
        return result;
    }
    float circle (in vec2 uv, in float radius, in float sharpness) {
        float dist = length(uv - vec2(0.5));
        return 1. - smoothstep(radius-sharpness,radius,dist);
    }
   void main() {
       float progress = fract(uTransitionTimer);

       vec2 center = vec2(0.5);
       vec2 centerVector = vFirstTextureCoord - center;
       vec2 vUv = vFirstTextureCoord;

        float circleProgress = circle(vTextureCoord, progress*0.9, 0.2);
        float ease = progress*(2. - progress);
        vec2 nextUV = vUv + centerVector * (circleProgress - 1.0) + centerVector * ( 1. - ease) * 0.;
        vec2 currentUV = vUv - centerVector * circleProgress*0.5 - centerVector * progress * 0.2;

        float currentTexture = mod(uFrom,3.);
        float nextTexture =  mod(uTo, 3.);

        vec4 current = getTextureByIndex(currentTexture, currentUV);
        vec4 next = getTextureByIndex(nextTexture, nextUV);
        
        gl_FragColor = mix(current,next,circleProgress);
   }