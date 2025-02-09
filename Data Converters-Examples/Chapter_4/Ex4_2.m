%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 4.2                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                           Timing Accuracy                               %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

%-------------------------------------------------------------------------%
%                                                                         %
%                          Input Data (L=150 um)                          %
%                                                                         %
%-------------------------------------------------------------------------%

RU=0.04;                            % Resistance  per unity lenght
CU=2.5*10^-16;                      % Capacitance per unity lenght
L=150;                              % Lenght of metal interconnection
tau=0.25*RU*CU*L*L                       % Delay
tau1=tau
psec=10^-12;
TR=0.05*psec;                       % Clock Rise Time
tstep=0.01*psec;
tstop=2*psec;
npoint=tstop/tstep;

for i=1:npoint;
    t=i*tstep;
    t1=t-TR;
    if t1<=0
        t1=t;
    end
    arg=tau/(4*t);
    arg1=tau/(4*t1);
    v1=1/TR*((t+tau/2)*erfc(sqrt(arg))-sqrt(t*tau/pi)*exp(-arg));
    v2=1/TR*((t1+tau/2)*erfc(sqrt(arg1))-sqrt(t1*tau/pi)*exp(-arg1));
    if (t-TR)<=0 
        v2=0;
    end
    eout1(i)=v1-v2;
    time(i)=t;
end

%-------------------------------------------------------------------------%
%                                                                         %
%                          Input Data (L=300 um)                          %
%                                                                         %
%-------------------------------------------------------------------------%

L=300;                              % Lenght of metal interconnection                                
tau=0.25*RU*CU*L*L                       % Delay
tau2=tau

for i=1:npoint;
    t=i*tstep;
    t1=t-TR;
    if t1<=0
        t1=t;
    end
    arg=tau/(4*t);
    arg1=tau/(4*t1);
    v1=1/TR*((t+tau/2)*erfc(sqrt(arg))-sqrt(t*tau/pi)*exp(-arg));
    v2=1/TR*((t1+tau/2)*erfc(sqrt(arg1))-sqrt(t1*tau/pi)*exp(-arg1));
    if (t-TR)<=0 
         v2=0;
    end
    eout2(i)=v1-v2;
end

figure(1);
plot(time,eout1,time,eout2);
xlabel('time [ps]');
ylabel('Normalized Amplitude');
legend('\bf150\mu strip','\bf300\mu strip','location','northwest');
grid on;
text(3*npoint/4*tstep,eout1(3*npoint/4),sprintf('\\bf1/4RuCuL^2=%3.3fps',...
    tau1*1e12),'horizontalalignment','left','verticalalignment','top');
text(3*npoint/4*tstep,eout2(3*npoint/4),sprintf('\\bf1/4RuCuL^2=%3.3fps',...
    tau2*1e12),'horizontalalignment','left','verticalalignment','top');

b=(eout1>=0.5);
for i=1:1:npoint
    if b(i)==1
        a1=i;
        break
    end
end

b=(eout2>=0.5);
for i=1:1:npoint
    if b(i)==1
        a2=i;
        break
    end
end

slope1=(eout1(a1+15)-eout1(a1-15))/30/tstep;

slope2=(eout2(a2+15)-eout2(a2-15))/30/tstep;

text(a1*tstep,eout1(a1),sprintf('\\bfslope\n%3.3f Vfs/psec',...
    slope1*1e-12),'horizontalalignment','center');
text(a2*tstep,eout2(a2),sprintf('\\bfslope\n%3.3f Vfs/psec',...
    slope2*1e-12),'horizontalalignment','center');
