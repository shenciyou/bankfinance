//////////////////////////////////////////////////////////////////
////Macro-prudential, Monetary Policy and Bank Systematic Risk////
/////////////////////////////////////////////////////////////////
 
 
// This code introduces bank sector in Christiano et al. (2005) model. As for financial frictions, we introduces CAR shock as macro-prudential requirement and bank default loss as bank systematic risk transmission.
// The code runs on the last version of Dynare (Dynare 4.4.0)
// Code written by SCY (shenciyou@qq.com)
 
// I. ENDOGENOUS VARIABLES
var y m c pi i w n rl rd rk k q u b u_w u_p z a g v s;
 
// II. EXOGENOUS VARIABLES
varexo e_b e_w e_p e_z e_a e_g e_v e_s;  
 
// III. PARAMETERS
parameters beta sigma phi nu delta alpha theta gamma omega phi_i phi_u xi_p xi_w phi_y phi_pi rl_bar rd_bar rk_bar rho_b rho_w rho_p rho_z rho_a rho_g rho_v rho_s;
 
// 1. Fixed parameters
beta=0.98868;  //消费贴现因子
delta=0.035;  //资本折旧率
alpha=0.5;  //资本产出弹性
theta=0.08;  //巴塞尔协议资本充足率要求
gamma=4;  //资本监管周期参数
omega=0.38;  //稳态时的投资产出比
phi_y=-0.2;  //货币政策对产出的反应系数
phi_pi=-0.2;  //货币政策对通胀的反应系数
rl_bar=1.0173;  //稳态时的贷款价格
rd_bar=1.01145;  //稳态时的存款价格
rk_bar=1.084575;  //稳态时的资本租赁价格

// 2.Estimated parameters initialisation
sigma=2.75;  //消费跨期替代弹性的倒数
phi=0.34052;  //劳动跨期替代弹性的倒数
nu=3;  //货币需求对利率弹性的倒数
phi_i=0.148;  //投资调整成本参数
phi_u=0.169;  //资本利用成本参数
xi_p=0.7121;  //价格粘性
xi_w=0.5962;  //工资粘性
rho_b=0.5;  //消费需求冲击自相关系数
rho_w=0.5;  //工资加成冲击自相关系数
rho_p=0.5;  //价格加成冲击自相关系数
rho_z=0.5;  //技术冲击自相关系数
rho_a=0.5;  //投资边际效率冲击自相关系数
rho_g=0.5;  //货币政策冲击自相关系数
rho_v=0.5;  //违约冲击自相关系数
rho_s=0.5;  //资本充足率冲击自相关系数

initval;
y=0;
m=0;
c=0;
pi=0;
i=0;
w=0;
n=0;
rl=0;
rd=0;
rk=0;
k=0;
q=0;
u=0;
b=0;
u_w=0;
u_p=0;
z=0;
a=0;
g=0;
v=0;
s=0;
e_b=0;
e_w=0;
e_p=0;
e_z=0;
e_a=0;
e_g=0;
e_v=0;
e_s=0;
end;

// 3. Derived from steady state
steady;
check;
resid;
 
// IV. MODEL 
model; 
 
// 1. FOC and Constraint Equation
m=(sigma/nu)*c-(beta/(nu*(1-beta)))*rd;  //货币需求方程
c=c(+1)+(1/sigma)*pi(+1)-(1/sigma)*rd-(1/sigma)*(b(+1)-b);  //消费方程
q=beta*(1-delta)*q(+1)-rd+pi(+1)+(1-(beta*(1-delta)))*rk(+1); //资本方程
rk=(1/phi_u)*u;  //资本租赁方程
w=(1/(1+beta))*(pi(-1)+w(-1))-pi+(beta/(1+beta))*(w(+1)+pi(+1))-(((1-(beta*xi_w))*(1-xi_w))/((1+beta)*xi_w))*(w-u_w-phi*n-sigma*c);  //工资方程
y=z+alpha*(k+u)+(1-alpha)*n;  //中间品生产方程
u+k+rk=w+rl+n; //中间品成本方程
pi=(1/(1+beta))*pi(-1)+(beta/(1+beta))*pi(+1)+(((1-(beta*xi_p))*(1-xi_p))/(1+beta))*(alpha*rk+(1-alpha)*(w+rl)-z+u_p);  //通胀方程
k=(1-delta)*k(-1)+delta*i(-1);  //资本积累方程
i=(1/(1+beta))*i(-1)+(beta/(1+beta))*i(+1)+(phi_i/(1+beta))*(q-rl)+(beta/(1+beta))*a(+1)-(1/(1+beta))*a;  //投资方程
rl_bar*rl-rk_bar*theta*rk+(rd_bar*theta-rd_bar)*rd+(rl_bar+rd_bar*theta*gamma-rk_bar*theta*gamma-1)*v+(rd_bar*theta)*s=0;  //商业银行方程

// 2. Equilibrium
y=(1-omega)*c+omega*i;  //IS方程
m-m(-1)=g-pi;  //LM方程
 
                    
// 3. AR(1) shocks
b=rho_b*b(-1)+e_b;
u_w=rho_w*u_w(-1)+e_w;
u_p=rho_p*u_p(-1)+e_p;
z=rho_z*z(-1)+e_z;
a=rho_a*a(-1)+e_a;
g=rho_g*g(-1)+phi_y*(y-y(-1))+phi_pi*pi+e_g;
v=rho_v*v(-1)+e_v;
s=rho_s*s(-1)+e_s;

// 4. END
end; 
 
 
 
// V. SHOCKS
shocks;
var e_b;
stderr 1;
var e_z;
stderr 1;
var e_g;
stderr 1;
var e_p;
stderr 1;
var e_w;
stderr 1;
var e_a;
stderr 1;
var e_s; 
stderr 1;
var e_v; 
stderr 1;
end;

// VI. ESTIMATION
 
estimated_params;

stderr e_b,inv_gamma_pdf,0.1,2;
stderr e_z,inv_gamma_pdf,0.1,2;
stderr e_g,inv_gamma_pdf,0.1,2;
stderr e_p,inv_gamma_pdf,0.1,2;
stderr e_w,inv_gamma_pdf,0.1,2;
stderr e_a,inv_gamma_pdf,0.1,2;
stderr e_s,inv_gamma_pdf,0.1,2;
stderr e_v,inv_gamma_pdf,0.1,2;

rho_b,beta_pdf,0.85,0.1;
rho_z,beta_pdf,0.85,0.1;
rho_g,beta_pdf,0.85,0.1;
rho_p,beta_pdf,0.85,0.1;
rho_w,beta_pdf,0.85,0.1;
rho_a,beta_pdf,0.85,0.1;
rho_s,beta_pdf,0.85,0.1;
rho_v,beta_pdf,0.85,0.1;

xi_p,beta_pdf,0.75,0.1;
xi_w,beta_pdf,0.75,0.1;

sigma,gamma_pdf,2.5,0.5;
phi,gamma_pdf,0.75,0.5;
nu,gamma_pdf,3,0.5;

phi_i,normal_pdf,0.15,0.025;
phi_u,normal_pdf,0.15,0.025;
end;
 
varobs y m c pi i w n;
estimation(bayesian_irf,irf=40,optim=('MaxIter',200),datafile='macrodata.mat',mode_compute=1,first_obs=1,nobs=79,presample=4,lik_init=2,prefilter=0,mh_replic=20000,mh_nblocks=2,mh_jscale=0.20,mh_drop=0.2) y m c pi i w n rl rd rk k q u b u_w u_p z a g v s;
stoch_simul(irf=40, conditional_variance_decomposition=[1, 10, 40]) y m c pi i w n;
