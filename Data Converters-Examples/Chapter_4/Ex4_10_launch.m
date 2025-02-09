%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 4.10   page 181                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%                           Pipeline Converter                            %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

%-------------------------------------------------------------------------%
%                         Simulation parameters                           %
%-------------------------------------------------------------------------%

Tstop=19900;
t=([1:Tstop+1]'-Tstop/2)/Tstop*2;
slope=2/Tstop;                      % slope of the input ramp
initial=-1;

%-------------------------------------------------------------------------%
%                             DAC parameters                              %
%-------------------------------------------------------------------------%

V_DAC_L=-0.5;
V_DAC_H=0.5;

%-------------------------------- Stage 1 --------------------------------%
GAIN1=2;                % interstage gain
VthL1=-0.25;            % ADC lower threshold
VthH1=0.18;             % ADC higher threshold

%-------------------------------- Stage 2 --------------------------------%
GAIN2=2;                % interstage gain
VthL2=-0.28;            % ADC lower threshold
VthH2=0.19;             % ADC higher threshold

%-------------------------------- Stage 3 --------------------------------%
GAIN3=2;                % interstage gain
VthL3=-0.25;            % ADC lower threshold
VthH3=0.25;             % ADC higher threshold


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%                           Launch Simulation                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

options=simset('InitialStep', 1, 'RelTol', 1e-3, 'MaxStep', 1,...
    'Fixedstep', 1);
sim('Ex4_10',Tstop, options);           %Start Simulink simulation


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%                            Graphic Outputs                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
figure (1);
subplot(2,1,1);
plot(t,res1,'b-', 'LineWidth', 1.5);
grid on;
axis([-1 1 -1 1]);
title('First Stage Residue');
text(-0.9,0.8,sprintf('\\bfVthL=%1.2f\nVthH=%1.2f', VthL1, VthH1),...
    'horizontalalignment','left','verticalalignment','top');
hold on;
plot([VthL1 VthL1],[-1 1], 'r--');
plot([VthH1 VthH1],[-1 1], 'r--');
hold off;

subplot(2,1,2);
plot(t,out1, 'b-', 'linewidth', 1.5);
grid on;
axis([-1 1 -1.2 1.2]);
hold on;
plot([VthL1 VthL1],[-1.2 1.2], 'r--');
plot([VthH1 VthH1],[-1.2 1.2], 'r--');
hold off;
title('First Stage ADC output');

figure (2);
subplot(2,1,1);
plot(t,res2,'b-', 'linewidth', 1.5);
grid on;
axis([-1 1 -1 1]);
title('Second Stage Residue');
text(-0.9,0.8,sprintf('\\bfVthL=%1.2f\nVthH=%1.2f', VthL2, VthH2),...
    'horizontalalignment','left','verticalalignment','top');
hold on;
plot([-VthL1 -VthL1],[-1 1], 'r--');
plot([-VthH1 -VthH1],[-1 1], 'r--');
hold off

subplot(2,1,2);
plot(t,out2,'b-', 'linewidth', 1.5);
grid on;
axis([-1 1 -1.2 1.2]);
title('Second Stage ADC output');
hold on;
plot([-VthL1 -VthL1],[-1.2 1.2], 'r--');
plot([-VthH1 -VthH1],[-1.2 1.2], 'r--');
hold off;


figure (3);
subplot(2,1,1);
plot(t,res3,'r-', 'linewidth', 1.2);
grid on;
axis([-1 1 -1 1]);
title('Third Stage Residue');
text(-0.9,0.8,sprintf('\\bfVthL=%1.2f\nVthH=%1.2f', VthL3, VthH3),...
    'horizontalalignment','left','verticalalignment','top');
subplot(2,1,2);
plot(t,out3,'r-', 'linewidth', 1.2);
grid on;
axis([-1 1 -1.2 1.2]);
title('Third Stage ADC output');

