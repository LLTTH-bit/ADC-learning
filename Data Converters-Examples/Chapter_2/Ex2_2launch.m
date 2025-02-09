%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 2.2                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
Npoint=2^14+1;
Tstop=Npoint+20;
N=14;

%------------------------Coefficients-------------------------------------%
%                                                                         %
%       Start with all the coefficients equal to zero and then change     %
%       them one by one with positive or negative sign.                   %
%                                                                         %
%-------------------------------------------------------------------------%

c2=-0.01;
c3=0.01;
c4=0.001;
c5=0.1;
c6=-0.01;
c7=0.01;
c8=0.1;
c9=0.001;
c10=-0.1;
coefficients=[c2 c3 c4 c5 c6 c7 c8 c9 c10];

infreq=671/Npoint;

%-------------------------------------------------------------------------%
%                        Start Simulink Simulation                        %
%-------------------------------------------------------------------------%

options=simset('RelTol', 1e-3, 'MaxStep', 1);
sim('Ex2_2', Tstop, options);
simout=simout-mean(simout);
w = window(@blackmanharris,Npoint);

%-------------------------------------------------------------------------%
%                    fft with Blackman-Harris windowing                   %
%-------------------------------------------------------------------------%

sp=(abs(fft((simout(Tstop-Npoint+1:Tstop).*w)')));
spdb=20*log10(sp);
spdbmax=max(spdb);
spdb=spdb-spdbmax;

%--------------------------------Graphics---------------------------------%
%                                                                         %
%     figure(1) --> Figure 2.16 page 65                                   %
%                                                                         %
%-------------------------------------------------------------------------%

figure(1)
clf
plot(spdb([1:Npoint/2]))
title('Low frequency input: Spectrum of Signal [dB]')
axis([0 Npoint/2 -180 0])
text(infreq*Npoint,-20,'\bf\leftarrow','rotation',45);
text(infreq*Npoint,-10,'\bfinput','fontsize',12);
if  c2~=0 
text(infreq*Npoint*2,spdb(infreq*Npoint*2)-7,'\bf\leftarrow','rotation',45);
text(infreq*Npoint*2,spdb(infreq*Npoint*2),'\bf2^n^d','fontsize',10);
end
if  c3~=0 
text(infreq*Npoint*3,spdb(infreq*Npoint*3)-7,'\bf\leftarrow','rotation',45);
text(infreq*Npoint*3,spdb(infreq*Npoint*3),'\bf3^r^d','fontsize',10);
end
if c4~=0
text(infreq*Npoint*4,spdb(infreq*Npoint*4)-7,'\bf\leftarrow','rotation',45);
text(infreq*Npoint*4,spdb(infreq*Npoint*4),'\bf4^t^h','fontsize',10);
end
if c5~=0
text(infreq*Npoint*5,spdb(infreq*Npoint*5)-7,'\bf\leftarrow','rotation',45);
text(infreq*Npoint*5,spdb(infreq*Npoint*5),'\bf5^t^h','fontsize',10);
end
if c6~=0
text(infreq*Npoint*6,spdb(infreq*Npoint*6)-7,'\bf\leftarrow','rotation',45);
text(infreq*Npoint*6,spdb(infreq*Npoint*6),'\bf6^t^h','fontsize',10);
end
if c7~=0
text(infreq*Npoint*7,spdb(infreq*Npoint*7)-7,'\bf\leftarrow','rotation',45);
text(infreq*Npoint*7,spdb(infreq*Npoint*7),'\bf7^t^h','fontsize',10);
end
if c8~=0
text(infreq*Npoint*8,spdb(infreq*Npoint*8)-7,'\bf\leftarrow','rotation',45);
text(infreq*Npoint*8,spdb(infreq*Npoint*8),'\bf8^t^h','fontsize',10);
end
if c9~=0
text(infreq*Npoint*9,spdb(infreq*Npoint*9)-7,'\bf\leftarrow','rotation',45);
text(infreq*Npoint*9,spdb(infreq*Npoint*9),'\bf9^t^h','fontsize',10);
end
if c10~=0
text(infreq*Npoint*10,spdb(infreq*Npoint*10)-7,'\bf\leftarrow','rotation',45);
text(infreq*Npoint*10,spdb(infreq*Npoint*10),'\bf10^t^h','fontsize',10);
end
grid


%-------------------------------------------------------------------------%
%                          change the frequency                           %
%-------------------------------------------------------------------------%

infreq=2311/Npoint;

%-------------------------------------------------------------------------%
%                        Start Simulink Simulation                        %
%-------------------------------------------------------------------------%

options=simset('RelTol', 1e-3, 'MaxStep', 1);
sim('Ex2_2', Tstop, options);
simout=simout-mean(simout);
w = window(@blackmanharris,Npoint);

%-------------------------------------------------------------------------%
%                    fft with Blackman-Harris windowing                   %
%-------------------------------------------------------------------------%

sp=(abs(fft((simout(Tstop-Npoint+1:Tstop).*w)')));
spdb=20*log10(sp);
spdbmax=max(spdb);
spdb=spdb-spdbmax;

%--------------------------------Graphics---------------------------------%
%                                                                         %
%     figure(2) --> Figure 2.17 page 66                                   %
%                                                                         %
%-------------------------------------------------------------------------%

figure(2)
clf
plot(spdb([1:Npoint/2]))
title('High frequency input:Spectrum of Signal [dB]')
axis([0 Npoint/2 -180 0])
grid


text(infreq*Npoint,-20,'\bf\leftarrow','rotation',45);
text(infreq*Npoint,-10,'\bfinput','fontsize',12);
for i=1:1:9
if  coefficients(i)~=0 
    if (infreq*(i+1)<=0.5)
        text(infreq*Npoint*(i+1),spdb(infreq*Npoint*(i+1))-7,...
            '\bf\leftarrow','rotation',45);
        text(infreq*Npoint*(i+1),spdb(infreq*Npoint*(i+1)),sprintf...
            ('%d',(i+1)),'fontsize',10,'fontweight','bold');
    elseif (infreq*(i+1)<=1)
        text(Npoint/2-(infreq*Npoint*(i+1)-Npoint/2),spdb(Npoint/2-...
            (infreq*Npoint*(i+1)-Npoint/2))-7,'\bf\leftarrow'...
            ,'rotation',45);
        text(Npoint/2-(infreq*Npoint*(i+1)-Npoint/2),spdb(Npoint/2-...
            (infreq*Npoint*(i+1)-Npoint/2)),sprintf('%d',(i+1)),...
            'fontsize',10,'fontweight','bold');
    elseif  (infreq*(i+1)<=1.5)
        text((infreq*Npoint*(i+1)-Npoint),spdb(infreq*Npoint*(i+1)-...
            Npoint)-7,'\bf\leftarrow','rotation',45);
        text((infreq*Npoint*(i+1)-Npoint),spdb(infreq*Npoint*(i+1)-...
            Npoint),sprintf('%d',(i+1)),'fontsize',10,'fontweight','bold');
    end
end
end
