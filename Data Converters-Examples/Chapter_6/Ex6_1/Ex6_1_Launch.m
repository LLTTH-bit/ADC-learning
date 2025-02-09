%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 6.1                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                        First Order Sigma Delta                          %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Tstop=2^14+100;;
points=Tstop+1;
octaves=floor(log2(points));
p_fft=2^octaves
Nbit=3;                     % number of bits of quantizer
Ampl=0.85;                  % Amplitude of the input sine wave
dc=1/7+0.001;               % DC input
Ksine=1;                    % Sine wave Flag: 1 -> on  0 -> off
Kdc=0;                      % DC input Flag:  1 -> on  0 -> off
periods=131;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%                        Start Simulink Simulation                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

options=simset('InitialStep', 1, 'RelTol', 1e-3, 'MaxStep', 1,...
    'Fixedstep', 1);
sim('Ex6_1',Tstop, options);

%-------------------------------------------------------------------------% 
%                             Graphic Outputs                             %
%-------------------------------------------------------------------------%

y_fft=out(points-p_fft+1:points);
plot_spectrum(p_fft,3,y_fft)
axis([1 p_fft/2 -120 0])
title('Power Spectrum');
xlabel('Frequency');
ylabel('Spectrum in dB');