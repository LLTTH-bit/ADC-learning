# ADI Chapter5 question

## 11.输入参考噪声相关

## 12.为什么使用反码？serial format

电路中存在噪声，输出码字具有一个概率分布，而不是固定的值，因此LED灯会来回跳动。只有当原码和反码亮度一致时，说明输出码字在两边的概率分布相同，此时的输入正是跳变点。

serial format的问题，我理解是，ADC输出结果是串行输出的，需要再用数字电路来串转并。

## 13.直接使用码转移点定义的优点

计算两个码转移点的差值，能够直接得到DNL。

## 14.测量offset与gain error需要那些码转换点

从图5.29来看，offset需要第一个码转换点的值，而gain需要第一个和最后一个码转换点的值。确实如此。

## 15.实现波形相减

在ADC的输出码字驱动DAC之前，先取补码，这样DAC输出电压就是ADC输出取负之后的结果，再与输入相加就能实现波形相减。

## 16.减小DAC频率

从结果上看，减小DAC频率也就相当于减小了采样频率。但我理解，如果想让“错误波形”看起来是连续的，采样频率应该本身就比斜坡信号的频率高很多，因此降低DAC频率也没有太大影响，如果降低太多就可能看起来不连贯了。

## 17.调整电位器

我理解的与问题中的理解不太一样。

这里应该是运放接成同相放大的形式，然后调整电位器来调整ADC输入和DAC输出相加时候的放大倍数（DAC输出和ADC输入可能存在一定增益？）。在误差为0时候调节相加后结果为0，应该能够得到正确的增益。

## 18.背对背测试中DAC性能高于ADC

## 19.DNL与INL测试使用的输入

为什么使用的输入不同？一个是"low amplitude"，一个是"full_scale"？

这里我也没太理解，只能根据原文内容推测一下。测DNL应该是一个点一个点地测，测完一个转换点之后再调整直流电压，去下一个转换点；而INL应该是测整体的，只需要关注整体的最大值就可以。

## 20."As the ADC resolution is increased, the frequency of the input signal must be made lower, the amplitude of the error waveform decreases, and the effects of ADC noise and DAC errors become more pronounced."这几句话的逻辑关系

**问** 我不太理解，个人推测是：随着分辨率升高，能够得到的ADC采样率自然会降低（高速高精度不可能兼得？），因此输入频率就需要下降。而误差波形的幅度下降是因为分辨率上升导致的。噪声影响增大应该也是因为分辨率上升，一个LSB对应的电压更小，因此更容易受影响吧。

## 21.为什么输入信号overdrive

为了保证ADC量程内的信号具有比较高的线性度。

## 22.Nonmonotonic相关

"However, a non-monotonic ADC will also generally have a higher level of distortion, and this condition is easily detected with an FFT analysis of the output data"这句话意思是虽然直方图无法看出单调性，但是非单调的ADC会在FFT中出现较大的失真，因此不必担心（直方图无法看出单调性）。

## 23.Eq.5.20推导

sin里面 $\frac{\pi}{2}$ 前面的因子是 除去两端区间后的点数 占总点数的比值。在时间轴上采样，时间轴上点是均匀分布的。通过这个式子来确定A，能够保证 $ 1\sim2^N-2$ 区间上的点占满量程，保证过驱动。

## 24."deglitcher"概念如何理解？

参考文章：[ADI-Deglitching Techniques for High-Voltage R-2R DACs](https://www.analog.com/en/resources/technical-articles/deglitching-techniques-for-highvoltage-r2r-dacs.html)

在DAC发生主进位转换时，由于开关之间的延迟，可能出现大的毛刺（glitch）。有两种消除毛刺的方法，一种是在DAC输出与地之间接一个大电容，构成一个RC低通滤波器消除毛刺。但由于需要较大的电容，这种方法会让DAC的建立时间变地相当大。

另一种方法是使用采样保持电路，原则上能够完全消除输出上的毛刺。但这种方法需要外部电路和延迟控制单元。
![Figure.2](deglitcher-figure-2.png)
在更新码字前闭合SW1，在更新码字时断开SW1，在毛刺消失后重新闭合SW1。

## 25.Is there any ADC that is not sampling ADC?

Flash ADC？

## 26."The output low-pass filter is chosen to have a cut-off frequency of approximately fs/2.2K so that images are attenuated over the bandwidth of interest. "

重建的频率是$f_s/K$，实际上重建信号的频谱是输入信号的频谱以$f_s/K$周期延拓后，再与sinc函数相乘得到的结果，因此感兴趣的频带外也存在频谱，需要加低通滤波器抑制。

## 27.关于包络测试

## 28.背对背测试装置测试带宽相关

## 29."end-to-end"是什么意思

我认为这里的端到端应该是ADC输入端到DAC输出端，通过DAC输出能够直观展示ADC的量化结果，对比两端的信号就能看出ADC性能。

## 30.如何推导式5.21

## 31.关于式5.21

## 32.如何理解式5.23

## 33.解释这句话："Digital filters can be constructed based on their impulse response, because the coefficients of an FIR filter and its impulse response are identical."

FIR滤波器的脉冲响应是有限长的，根据脉冲响应值能够直接构建FIR滤波器。

## 34."Although "complex" ADCs are not available, it is very common to use two ADCs to synchronously sample the I and Q data streams from a quadrature demodulator, in which the FFT input data is complex — however, this is a special case."

这里应该是信号的IQ分解？窄带信号可以分解：
$$X(t)=X_{I}(t)cos\omega_0 t-X_Q (t)sin\omega_0 t$$

## 35."repetitive patterns"的影响

如果采到的数据在一个FFT周期内是周期重复的，那么量化噪声也是周期重复的，丧失了随机性。

同时，对谐波有什么影响。
