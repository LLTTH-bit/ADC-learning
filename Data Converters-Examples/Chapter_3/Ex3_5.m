%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 3.5                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                             Current Steering                            %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

%-------------------------------------------------------------------------%
%                                                                         %
%                                Input data                               %
%                                                                         %
%-------------------------------------------------------------------------%

n=12;                   % Number of bits
Vfs=1;                  % Full scale voltage
RL=25;
Iu=Vfs/RL/(2^n-1);      % Nominal unity current
Ru=2e8;
Ron=1e2;
VDD=3.3;

IN=(Iu*Ru+VDD)/(Ru+Ron);       % Norton equivalent circuit
RN=Ru+Ron;
alpha=RL/RN;

%-------------------------------------------------------------------------%
%                                                                         %
%             Output current for a given decimal input xin                % 
%                                                                         %
%-------------------------------------------------------------------------%

for i=1:2^n;                                    % ramp
    k=i-1;                          
Vout(i)=k*IN*RL/(1+alpha*k);
INL(i)=k*(1+alpha*(2^n-1))/(1+alpha*k)-k;
end

%--------------------------------Graphics---------------------------------%
%                                                                         %
%     figure(1) --> Output Voltage                                        %
%     figure(2) --> Integral Non-Linearity                                %
%     figure(3) --> Figure 3.34 page 117 / Figure 3.35 page 117           %
%                                                                         %
%-------------------------------------------------------------------------%

figure(1);
clf;
plot(Vout,'r');
grid on;
title('Output signal')
xlabel('bin')
ylabel('Vout')
xlim([0 2^n])

figure(2);
clf;
plot(INL,'r');
grid on;
title('Integral Nonlinearity')
xlabel('bin')
ylabel('INL')
xlim([0 2^n])
text(2^(n-1),max(INL)+0.05,sprintf('\\bfINL = %1.3f LSB\n',max(INL)),...
    'FontSize', 12, 'HorizontalAlignment','center');

%-------------------------------------------------------------------------%
%                                                                         %
%                Output Voltage for an input sinewave                     %
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
Ampl=10^(Amp_dB/20)*Vfs/2;       % Input signal amplitude

finrad=Fin*2*pi;
for j=1:Ntot,
    xin=Ampl*sin(finrad*(j-1))+Vfs/2; % Unipolar range
    k=round(xin*2^n);
    x(j)=xin;
    y(j)=Vout(k);                 
                                   %--------------------------------------%
    y(j)=y(j)-Vout(2^n-1-k);      % uncomment to have fully differential %
                                   %--------------------------------------%
end

y=y-mean(y);
w=hann(N);
f=Fin/Fs;                             % Normalized signal frequency
fB=N*(bw/Fs);                         % Base-band frequency bins
[snr,ptot]=calcSNR(y(1:N),f,fB,w',N);
ptot=ptot-max(ptot);                  % Normalize total spectrum

figure(3);
clf;
plot(linspace(0,Fs/2,N/2), ptot(1:N/2), 'r');
grid on;
title('PSD of the Output')
xlabel('Frequency [Hz]')
ylabel('PSD [dB]')
axis([0 Fs/8 -140 0]);

text(f*2,ptot((f*N)*2),sprintf('\\bf%3.1f dB',ptot((f*N)*2)),'Fontsize'...
    ,8,'HorizontalAlignment','center');
text(Fs/16,-30,sprintf('\\bfSNR = %3.2f dB',snr),'Fontsize'...
    ,12,'HorizontalAlignment','center');
snr   


