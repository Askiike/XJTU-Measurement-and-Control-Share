
clear;
rng(0);

% 信号参数
N = 1000; Fs = 1000; T = 1/Fs; t = (0:N-1)/Fs; Tp = N*T;
k = 0:N-1; f1 = k/Tp;

% 生成信号：单频调幅信号 + 更杂乱的高频噪声 + 少量白噪声
fc = 50; A = 1;
xt = A*cos(2*pi*fc*t) ...
    + 0.5*sin(2*pi*200*t) + 0.3*sin(2*pi*250*t) + 0.4*sin(2*pi*300*t) ...
    + 0.2*sin(2*pi*350*t) + 0.3*sin(2*pi*400*t) + 0.1*sin(2*pi*450*t) ...
    + 0.05*randn(1,N);

% 设计指标
fp = 120; fs = 150; Rp = 0.2; As = 60;

% ------------- 原始信号：波形 + 频谱（按最初代码样式） -------------
X = fft(xt, N);
figure(1); clf; set(gcf,'Color','w');

subplot(2,1,1);
plot(t, xt, 'k-', 'LineWidth', 1);
title('具有加性噪声的信号 x(t)');
xlabel('时间 (s)'); ylabel('幅度'); grid on;
xlim([0, Tp/2]);    % 显示前半段，更接近最初样式

subplot(2,1,2);
plot(f1(1:floor(N/2)), 20*log10(abs(X(1:floor(N/2)))+eps), 'k-', 'LineWidth', 1);
title('信号 x(t) 的频谱');
xlabel('频率 (Hz)'); ylabel('幅度 (dB)');
grid on; axis([0, Fs/2, -120, 20]);

% ------------- 窗函数法（Blackman）设计与滤波 -------------
wc = (fp + fs) / Fs;         % 归一化截止 (按 Nyquist=Fs/2 的比例)
B  = 2*pi*(fs - fp) / Fs;
Nw = ceil(11*pi / B);
if mod(Nw,2)==0, Nw = Nw+1; end
hn_w = fir1(Nw-1, wc, blackman(Nw));
fprintf('窗函数法（Blackman）阶数: %d\n', Nw-1);

y_w = fftfilt(hn_w, xt);
Hw_w = fft(hn_w, N);  % 用 N 点 FFT 使绘图风格与最初一致

% 绘图：滤波器幅频（用最初风格）、输出波形与频谱（最初风格）
figure(2); clf; set(gcf,'Color','w');
subplot(3,1,1);
plot((0:N-1)*(Fs/N), 20*log10(abs(Hw_w)+eps), 'k-', 'LineWidth', 1);
title('窗函数法低通滤波器幅频特性（Blackman）');
xlabel('f / Hz'); ylabel('幅度 (dB)'); grid on;
axis([0, Fs/2, -120, 20]);

subplot(3,1,2);
plot(t, y_w, 'k-', 'LineWidth', 1);
title('滤除噪声后的信号波形（窗函数法）');
xlabel('时间 (s)'); ylabel('幅度'); grid on;
xlim([0, Tp/2]); ylim([-1.1, 1.1]);

subplot(3,1,3);
Yw = fft(y_w, N);
plot(f1(1:floor(N/2)), abs(Yw(1:floor(N/2)))./max(abs(Yw))+0*eps, 'k-', 'LineWidth', 1);
% 以线性幅值绘图，和最初代码一致（若需要 dB 可改为 20*log10(...)）
title('滤除噪声后的信号频谱（窗函数法）');
xlabel('频率 (Hz)'); ylabel('归一化幅度'); grid on;
axis([0, Fs/2, 0, 1.05]);

% ------------- 等波纹法（remez）设计与滤波 -------------
fb = [fp, fs]; m = [1, 0];
dev = [ (10^(Rp/20)-1)/(10^(Rp/20)+1), 10^(-As/20) ];
[Ne, fo, mo, W] = remezord(fb, m, dev, Fs);
Ne = max(Ne,1);
hn_e = remez(Ne-1, fo, mo, W);
fprintf('等波纹法（remez）阶数: %d\n', Ne-1);

y_e = fftfilt(hn_e, xt);
Hw_e = fft(hn_e, N);

% 绘图：等波纹法结果（与最初代码频谱样式一致）
figure(3); clf; set(gcf,'Color','w');
subplot(3,1,1);
plot((0:N-1)*(Fs/N), 20*log10(abs(Hw_e)+eps), 'k-', 'LineWidth', 1);
title('等波纹法低通滤波器幅频特性（remez）');
xlabel('f / Hz'); ylabel('幅度 (dB)'); grid on;
axis([0, Fs/2, -80, 10]);

subplot(3,1,2);
plot(t, y_e, 'k-', 'LineWidth', 1);
title('滤除噪声后的信号波形（等波纹法）');
xlabel('时间 (s)'); ylabel('幅度'); grid on;
xlim([0, Tp/2]); ylim([-1.1, 1.1]);

subplot(3,1,3);
Ye = fft(y_e, N);
plot(f1(1:floor(N/2)), abs(Ye(1:floor(N/2)))./max(abs(Ye)), 'k-', 'LineWidth', 1);
title('滤除噪声后的信号频谱（等波纹法）');
xlabel('频率 (Hz)'); ylabel('归一化幅度'); grid on;
axis([0, Fs/2, 0, 1.05]);

% 在各图上注记阶数（黑色文本，便于打印）
figure(2);
text(0.72*Fs/2, 0.9, sprintf('阶数 = %d', Nw-1), 'Units','data','Color','k','FontSize',10);

figure(3);
text(0.72*Fs/2, 0.9, sprintf('阶数 = %d', Ne-1), 'Units','data','Color','k','FontSize',10);

% 可选：保存为灰度 PNG 便于打印（取消注释）
% print(figure(1),'signal_xt_firststyle_bw.png','-dpng','-r300');
% print(figure(2),'blackman_firststyle_bw.png','-dpng','-r300');
% print(figure(3),'remez_firststyle_bw.png','-dpng','-r300');