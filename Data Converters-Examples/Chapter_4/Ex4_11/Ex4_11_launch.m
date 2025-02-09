%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 4.11                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                           Pipeline Converter                            %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

%-------------------------------------------------------------------------%
%                         DAC Static parameters                           %
%-------------------------------------------------------------------------%


%-------------------------------- Stage 1 --------------------------------%
V_DAC_L1=-0.5;
V_DAC_H1=0.5;
GAIN1=2.0;
VthL1=-0.25+eps;
VthH1=0.25+eps;

%-------------------------------- Stage 2 --------------------------------%
V_DAC_L2=-0.5;
V_DAC_H2=0.5;
GAIN2=2.0;
VthL2=-0.25+eps;
VthH2=0.25+eps;

%------------------------------- Stages 3-9 ------------------------------%
V_DAC_L3=-0.5;
V_DAC_H3=0.5;
GAIN3=2.0;
VthL3=-0.25+eps;
VthH3=0.25+eps;

Vth10=0;

%-------------------------------------------------------------------------%
%                             Dynamic parameters                          %
%-------------------------------------------------------------------------%

%-------------------------------- S&H Block-------------------------------%
srH=250e6;
f_TH=600e6;
betaH=1;
tauH=1/(2*pi*betaH*f_TH);
gainH=1;

%-------------------------------- Stage 1 --------------------------------%
sr1=10000e8;
f_T1=6000e6;
beta1=1/2;
tau1=1/(2*pi*beta1*f_T1);
gain1=1;

%-------------------------------- Stage 2 --------------------------------%
sr2=20000e8;
f_T2=6000e6;
beta2=1/2;
tau2=1/(2*pi*beta2*f_T2);
gain2=1;

%------------------------------- Stages 3-9 ------------------------------%
sr=25000e8;
f_T=6000e6;
beta=1/2;
tau=1/(2*pi*beta*f_T);
gain=1;

%-------------------------------------------------------------------------%
%                         Simulation parameters                           %
%-------------------------------------------------------------------------%

Ts=1e-8
Tmax=Ts/2;
Vfs=2;
N=2^12;
Ntransient=20;         
Tstop=Ts*(N+Ntransient);
nper=73;
Fs=1/Ts;
Fin=nper*Fs/N;                 % Input signal frequency (Fin = nper*Fs/N)
f=Fin/Fs;                      % Normalized signal frequency
bw=Fs/2;

Amp_dB=-0;                     % Amplitude in dB
Ampl=10^(Amp_dB/20)*Vfs/2;     % Input signal amplitude

finrad=Fin*2*pi;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%                           Launch Simulation                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
options=simset('InitialStep', 1, 'RelTol', 1e-3, 'MaxStep', 1,...
    'Fixedstep', 1);
sim('Ex4_11',Tstop, options);           %Starts Simulink simulation

%-------------------------------------------------------------------------% 
%                             Graphic Outputs                             %
%-------------------------------------------------------------------------%
w=hann(N);
f=Fin/Fs;                             % Normalized signal frequency
fB=N*(bw/Fs);                         % Base-band frequency bins
yfft=y(1+Ntransient:N+Ntransient);
[snr,ptot]=calcSNR(yfft',f,fB,w',N);
ptot=ptot-max(ptot);                  % Normalize total spectrum

figure(1);
clf;
plot(linspace(0,Fs/2,N/2), ptot(1:N/2), 'r');
grid on;
title('PSD of the Output')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0 Fs/2 -140 0]);
sfdr=max(ptot(nper+4:N/2))
snr 

