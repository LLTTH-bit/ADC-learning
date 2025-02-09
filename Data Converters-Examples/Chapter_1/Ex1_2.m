%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Example 1.2                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear ;
close all;
clc;
%% 关于ex1.2
%先根据信噪比和输入信号功率计算出抖动噪声的功率
%根据抖动噪声定义式计算出抖动时间的均值
%抖动噪声随着输入频率的变化而变化，其他部分噪声不变
%改变频率后计算SNR

%% 
%-------------------------------------------------------------------------%
%                                                                         %
%                              Input values                               %
%                                                                         %
%-------------------------------------------------------------------------%

sampl_freq=100e6;            % clock frequency
input_freq=20e6;             % signal frequency
SNR=80;
ampl=1;                      % signal amplitude (full scale)
perc=20;                     % percentuage of noise due to jitter

%-------------------------------------------------------------------------%
%                                                                         %
%                          Outputs                                        %
%                                                                         %
%-------------------------------------------------------------------------%

noise_power=ampl^2/(2*10^(SNR/10))                    % total noise power 
jitter_power=noise_power*perc/100                     % jitter noise power
time_jitter=(jitter_power/(2*pi*input_freq)^2)^0.5    
norm_freq=[0:0.025:1.0];         
vn_square=(100-perc)/100*noise_power+jitter_power*(norm_freq*sampl_freq/...
    input_freq).^2;
SNR=10*log10(ampl^2/2) -10*(log10(vn_square));        % Eq. (1.8) page 14

%---------------------------Graphics--------------------------------------%
%                                                                         %
%    figure(1) --> Fig 1.13 page 15                                       %
%                                                                         %
%-------------------------------------------------------------------------%
figure(1);
plot(norm_freq,SNR)
grid
xlabel('Normalized input frequency, f/f_C_K')
ylabel('snr [dB]')
title('SNR degradation caused by the jitter noise')

%老师,kT/C噪声这里我有些不太懂：
%RS产生的热噪声，这里的4kTR是它的单边功率谱吗，这个噪声是可以看成加在vin上的吗
%ex1.3中的 cascade of two sampled-and-hold
%circuit是指的两个RC低通滤波器串联吗，这样的话热噪声的来源两个电阻吗？
%第一个电阻的热噪声再通过RC低通应该怎么分析呢，不太理解ex1.3中为什么把总的热噪声功率除以2
