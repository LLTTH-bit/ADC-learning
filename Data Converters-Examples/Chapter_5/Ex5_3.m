%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 5.2                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;


%-------------------------------------------------------------------------%
%                            Design variables                             %
%-------------------------------------------------------------------------%

Cs=1e-12;
CL=2e-12;
Ron=10;
gm=12e-3;
angpole=1/Ron/Cs;
decback=4
omegamin=angpole/10^decback;
a=gm;
b=CL+Cs*(1+gm*Ron);
c=2*CL*Cs*Ron;
points=140;
for i=1:points
    omega=omegamin*10^(i/20);
    freq(i)=omega/angpole;
real=gm+c*omega^2;
imm=b*omega;
amp1(i)=sqrt((gm^2+(omega*CL)^2))/sqrt(real^2+imm^2);
amp2(i)=(omega*CL)/sqrt(real^2+imm^2);
amp3(i)=gm/sqrt(real^2+imm^2);
amp4(i)=1/(sqrt(1+(omega/angpole)^2));
end
loglog(freq,amp1,'r')
hold on
loglog(freq,amp2,'b')
hold on
loglog(freq,amp3,'g')
hold on
loglog(freq,amp4,'k')
grid
xlabel('f/(2\pi/(R_{on}C_S)')
ylabel('|H_n(f)|')
hold off
xlim([freq(1) freq(points)]);
legend('amp1','amp2','amp3','amp4','location','SouthWest');

%-------------------------------------------------------------------------%
%                        Noise Power Multiplier                           %
%-------------------------------------------------------------------------%

step=angpole/10;
mult1=0;
mult2=0;
mult3=0;
mult4=0;

%-------------------------------------------------------------------------%
%                        Approximate integrals                            %
%-------------------------------------------------------------------------%

steps=50000;
resol=0.01;
for i=1:steps
omega=i*angpole*resol;    
real=gm+c*omega^2;
imm=b*omega;
ampl1=sqrt((gm^2+(omega*CL)^2))/sqrt(real^2+imm^2);
ampl2=(omega*CL)/sqrt(real^2+imm^2);
ampl3=gm/sqrt(real^2+imm^2);
ampl4=1/(sqrt(1+(omega/angpole)^2));
mult1=mult1+ampl1^2;
mult2=mult2+ampl2^2;
mult3=mult3+ampl3^2;
mult4=mult4+ampl4^2;
end
mult1=mult1*resol
mult2=mult2*resol
mult3=mult3*resol
mult4=mult4*resol