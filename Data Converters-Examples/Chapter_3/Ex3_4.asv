%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 3.4                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                      R-2R Ladder Current-mode                           %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
n=8;                    % Number of bits
errandom=1/2^n;         % Error random: both arm and riser
errorgradlad=1/2^n;     % Error gradient: arm 
Iref=2^n;               % Reference current
grad=[1:n];

echo on;

%                      VALORI SIMULAZIONE                                 %

echo off;

%-------------------------------------------------------------------------%
%                                                                         %
%                           Ladder Resistors                              %
%                                                                         %
%-------------------------------------------------------------------------%

Ra=2*ones(1,n)+errandom*random('normal',0,1,1,n)+(grad-1)*errorgradlad;

                      %-----------------------------%
% Ra(1)=2+2/2^n         % To set one value or Ra change number and index
                      %-----------------------------%

Rr=ones(1,n)+errandom*random('normal',0,1,1,n)

                      %-----------------------------%
% Rr(2)=1+2/2^n          % To set one value or Rr change number and index
                      %-----------------------------%
                      
Rt=2;                   % Termination resistance

%-------------------------------------------------------------------------%
%                                                                         %
%                Resistances at the right side of node i-th               %
%                                                                         %
%-------------------------------------------------------------------------%

RR=ones(1,n);
RR(n)=Rt;
for i=1:n-1,
    k=n-i;
    R1=RR(k+1);
    R2=Ra(k+1);
    RR(k)=R1*R2/(R1+R2)+Rr(k);
end
RR

%-------------------------------------------------------------------------%
%                                                                         %
%                         Current on the i-th arm                         %
%                                                                         %
%-------------------------------------------------------------------------%

Iin=Iref;
for i=1:n,
    Ia(i)=Iin*RR(i)/(RR(i)+Ra(i));
    Iin=Iin-Ia(i);
end

Ia

%-------------------------------------------------------------------------%
%                                                                         %
%             Output current for a given decimal input xin                %
%                                                                         %
%-------------------------------------------------------------------------%

for k=1:2^n-1;
    xin=k;                          %ramp at the input
    xbin=dec2bin(xin,n);
ID=0;
for i=1:n,
    ID=ID+bin2dec(xbin(i))*Ia(i);
end
IDAC(k)=ID;                         %output voltage
Iid(k)=xin/2^n*Iref;                %ideal response
err(k)=(IDAC(k)-Iid(k))/Iref*2^n;   % INL
end

%--------------------------------Graphics---------------------------------%
%                                                                         %
%     figure(1) --> Output Voltage                                        %
%     figure(2) --> Figure 3.22 page 104                                  %
%     figure(3) --> Figure 3.23 page 105                                  %
%     figure(4) --> Figure 3.24 page 105                                  %
%                                                                         %
%-------------------------------------------------------------------------%

figure(1);
clf;
plot(IDAC,'r');
grid on;
title('Output signal')
xlabel('bin')
ylabel('Out')
xlim([0 2^n]);

figure(2);
clf;
subplot(2,1,1);
plot(grad,Ra,'rs-');
xlabel('Arm Number');
ylabel('value[\Omega]');
title('Arm Resistors Values');
grid on;
subplot(2,1,2);
plot(grad,Rr,'bs-');
xlabel('Riser Number');
ylabel('value[\Omega]');
title('Riser Resistors Values');
grid on;

figure(3);
clf;
plot(err,'r');
grid on;
title('Integral nonlinearity')
xlabel('bin')
ylabel('INL')
axis([0 2^n min(err)-0.1 max(err)+0.1]);

%-------------------------------------------------------------------------%
%                                                                         %
%               Output current for an input sinewave                      %
%                                                                         %
%-------------------------------------------------------------------------%

N=2^12;
Ntransient=12;         
Ntot=N+Ntransient;
nper=31;
Fs=1;
Fin=nper*Fs/N;                   % Input signal frequency (Fin = nper*Fs/N)
f=Fin/Fs;                        % Normalized signal frequency
bw=Fs/2;
Amp_dB=-0.1;                     % Amplitude in dB
Ampl=10^(Amp_dB/20)*Iref/2;      % Input signal amplitude

finrad=Fin*2*pi;
for k=1:Ntot,
    xin=Ampl*sin(finrad*(k-1))+Iref/2;  % Unipolar range
    xbin=dec2bin(xin,n);
ID=0;
for i=1:n,
    ID=ID+bin2dec(xbin(i))*Ia(i);
end
y(k)=ID;                  
end
y=y-mean(y);                          % Output with zero average
w=hann(N);
f=Fin/Fs;                             % Normalized signal frequency
fB=N*(bw/Fs);                         % Base-band frequency bins
[snr,ptot]=calcSNR(y(1:N),f,fB,w',N);
ptot=ptot-max(ptot);                  % Normalize total spectrum

figure(4);
clf;
plot(linspace(0,Fs/8,N/8), ptot(1:N/8), 'r');
grid on;
title('PSD of the Output')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0 Fs/8 -120 0]);
text(f*3,ptot((f*N)*3+1),sprintf('\\bf%3.1f dB',ptot((f*N)*3)+1),'Fontsize'...
    ,8,'HorizontalAlignment','center');
text(f*5,ptot((f*N)*5+1),sprintf('\\bf%3.1f dB',ptot((f*N)*5)+1),'Fontsize'...
    ,8,'HorizontalAlignment','center');
text(f*7,ptot((f*N)*7+1),sprintf('\\bf%3.1f dB',ptot((f*N)*7)+1),'Fontsize'...
    ,8,'HorizontalAlignment','center');
text(Fs/16,-30,sprintf('\\bfSNR = %3.2f dB',snr),'Fontsize'...
    ,12,'HorizontalAlignment','center');  
    
    



