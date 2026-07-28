precision highp float;
uniform sampler2D u_video; uniform vec2 u_resolution; uniform float u_time,u_damage;
uniform float u_intensity,u_noise,u_scan,u_rgb,u_glitch,u_track,u_blur,u_color;
varying vec2 v_uv;
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
float n(vec2 p){vec2 i=floor(p),f=fract(p);f=f*f*(3.-2.*f);return mix(mix(hash(i),hash(i+vec2(1,0)),f.x),mix(hash(i+vec2(0,1)),hash(i+vec2(1,1)),f.x),f.y);}
vec3 sampleVideo(vec2 uv,float shift){return texture2D(u_video,clamp(uv+vec2(shift,0.),0.,1.)).rgb;}
void main(){
  float t=u_time, line=floor(v_uv.y*u_resolution.y), r=hash(vec2(line,floor(t*18.)));
  float glitch=step(1.-u_glitch*.12,r)*(.012+u_damage*.035)*(hash(vec2(floor(t*25.),line))-0.5);
  float wobble=(sin(v_uv.y*70.+t*3.)+sin(v_uv.y*12.-t*2.))*u_intensity*.012;
  float tracking=step(1.-u_track*.18,hash(vec2(floor(v_uv.y*55.),floor(t*3.))))*(hash(vec2(line,t))-0.5)*u_track*.08;
  vec2 uv=vec2(v_uv.x+wobble+glitch+tracking,v_uv.y);
  float sep=(u_rgb*.009+u_damage*.012)*(1.+sin(t*1.7)*.25);
  vec3 c=vec3(sampleVideo(uv,sep).r,sampleVideo(uv,0.).g,sampleVideo(uv,-sep).b);
  float b=u_blur*.003; c=(c+sampleVideo(uv+vec2(b,0.),0.)+sampleVideo(uv-vec2(b,0.),0.))/3.;
  float grain=(n(v_uv*u_resolution*.7+vec2(t*90.,t*13.))-.5)*(u_noise*.22+u_damage*.14);
  float scan=(sin(v_uv.y*u_resolution.y*3.14159)*.5+.5)*u_scan*.13;
  float interlace=mod(line+floor(t*60.),2.)*.018*(u_intensity/100.);
  /* Independent bright/dark tape flecks keep the overlay visible even where
     a browser prevents a media frame from being sampled as a texture. */
  float tapeFleck=step(.992-u_noise*.035,hash(vec2(line,floor(t*30.))));
  float tearLine=step(.997-u_glitch*.045,hash(vec2(floor(v_uv.y*90.),floor(t*6.))));
  c+=(grain-scan-interlace); c=mix(c,vec3(dot(c,vec3(.35,.48,.17))),u_color*.35+u_damage*.12);
  c*=1.-u_color*.18-u_damage*.07; c+=vec3(.035,.018,-.01)*u_color*.8;
  c=mix(c,vec3(.78,.86,1.),tapeFleck*.52);
  c=mix(c,vec3(.95,.12,.32),tearLine*.45);
  c*=1.+sin(t*9.1)*(.006+u_damage*.014);
  /* The native video remains visible below this translucent WebGL layer. */
  float overlayAlpha=.20+u_intensity*.55+u_damage*.12+tapeFleck*.22+tearLine*.28;
  gl_FragColor=vec4(clamp(c,0.,1.),clamp(overlayAlpha,0.,.78));
}
