precision mediump float;
uniform vec2 u_resolution; uniform float u_time,u_damage;
uniform float u_intensity,u_noise,u_scan,u_rgb,u_glitch,u_track,u_blur,u_color;
varying vec2 v_uv;
float hash(vec2 p){return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453);}
void main(){
  float line=floor(v_uv.y*u_resolution.y), tick=floor(u_time*24.);
  float scan=step(.5,fract(line*.5))*u_scan*.18;
  float grain=(hash(vec2(floor(v_uv.x*u_resolution.x*.32),line+tick*17.))-.5)*u_noise;
  float scratch=step(.988-u_glitch*.09,hash(vec2(line,tick*.31)));
  float tracking=step(.996-u_track*.06,hash(vec2(floor(v_uv.y*70.),floor(tick*.17))));
  float aging=u_damage*(.05+.10*hash(vec2(line,tick)));
  vec3 tint=vec3(.24,.38,.52)+vec3(grain*.62,grain*.15,-grain*.32);
  tint=mix(tint,vec3(.88,.10,.16),scratch*.72);
  tint=mix(tint,vec3(.66,.82,1.),tracking*.58);
  float alpha=scan+abs(grain)*.18+scratch*.27+tracking*.20+aging;
  alpha*=.25+u_intensity*.55;
  gl_FragColor=vec4(clamp(tint,0.,1.),clamp(alpha,0.,.52));
}
