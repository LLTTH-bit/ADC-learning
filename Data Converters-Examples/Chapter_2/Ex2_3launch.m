%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 2.3                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
Npoint=2^14;
Tstop=Npoint+10;

%-------------------------------------------------------------------------%
%                              Input signals                              %
%-------------------------------------------------------------------------%

infreq1=1169/(Tstop);
infreq2=1231/(Tstop);
Amp1=1;
Amp2=1;
N=12;
a=0.001;

%-------------------------------------------------------------------------%
%                        Start Simulink Simulation                        %
%-------------------------------------------------------------------------%

options=simset('RelTol', 1e-3, 'MaxStep', 1);
sim('Ex2_3', Tstop, options);
simout=simout-mean(simout);
w=window(@blackmanharris,Npoint);

%-------------------------------------------------------------------------%
%                    fft with Blackman-Harris windowing                   %
%-------------------------------------------------------------------------%

sp=(abs(fft((simout(Tstop-Npoint+1:Tstop).*w)')));
spdb=20*log10(sp);
spdbmax=max(spdb);
% Normalized to max
spdb=spdb-spdbmax;

%--------------------------------Graphics---------------------------------%
%                                                                         %
%     figure(1) --> Figure 2.20 page 69                                   %
%                                                                         %
%-------------------------------------------------------------------------%

figure(1);
clf
plot(spdb)
grid
axis([1 Npoint/4 -120 0]);
title('Spectrum of the output signal');

text(infreq1*Tstop-60,-30,'\bf\rightarrow','rotation',-45);
text(infreq1*Tstop-150,-30,'\bff1');
text(infreq2*Tstop,-33,'\bf\leftarrow','rotation',45);
text(infreq2*Tstop+50,-30,'\bff2');
text((2*infreq1-infreq2)*Tstop-60,-60,'\bf\rightarrow','rotation',-45);
text((2*infreq1-infreq2)*Tstop-220,-60,'\bf2f1-f2');
text((2*infreq2-infreq1)*Tstop,-63,'\bf\leftarrow','rotation',45);
text((2*infreq2-infreq1)*Tstop+100,-60,'\bf2f2-f1');

text(3*infreq1*Tstop-60,-80,'\bf\rightarrow','rotation',-45);
text(3*infreq1*Tstop-150,-80,'\bf3f1');
text(3*infreq2*Tstop,-83,'\bf\leftarrow','rotation',45);
text(3*infreq2*Tstop+50,-80,'\bf3f2');
text((2*infreq1+infreq2)*Tstop-60,-70,'\bf\rightarrow','rotation',-45);
text((2*infreq1+infreq2)*Tstop-220,-70,'\bf2f1+f2');
text((2*infreq2+infreq1)*Tstop,-73,'\bf\leftarrow','rotation',45);
text((2*infreq2+infreq1)*Tstop+150,-70,'\bf2f2+f1');
