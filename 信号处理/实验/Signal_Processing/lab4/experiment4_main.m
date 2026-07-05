% experiment4_main.m
% 主脚本：使用 xtg(N) 生成不带绘图的原始带噪信号，
% 然后用 Blackman 窗与 remez 设计算法进行滤波并绘图
clear; close all; clc;
rng(0); % 为可重复性固定随机种子

% ========== 新增：创建保存目录 ==========
output_dir = 'exp4_output';
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
    fprintf('已创建输出目录: %s\n', output_dir);
end

% 参数
N  = 1000;
Fs = 1000;
T  = 1/Fs;
t  = (0:N-1)/Fs;
Tp = N*T;
k  = 0:N-1; f1 = k/Tp;

% 调用 xtg 生成信号（xtg 不绘图，仅返回信号）
xt = xtg(N);

% ---------------- 原始信号：波形 + 频谱 ----------------
X = fft(xt, N);
figure(1); clf; set(gcf,'Color','w');

subplot(2,1,1);
plot(t, xt, 'k-', 'LineWidth', 1);
title('具有加性噪声的信号 x(t)');
xlabel('时间 (s)'); ylabel('幅度'); grid on;
xlim([0, Tp/2]);    % 显示前半段，更清晰

subplot(2,1,2);
plot(f1(1:floor(N/2)), abs(X(1:floor(N/2)))./max(abs(X)), 'k-', 'LineWidth', 1);
title('信号 x(t) 的频谱');
xlabel('频率 (Hz)'); ylabel('归一化幅度'); grid on;
axis([0, Fs/2, 0, 1.2]);

% ========== 新增：保存图1 ==========
saveas(gcf, fullfile(output_dir, 'exp4_original_signal.png'));
fprintf('已保存图1: %s\n', fullfile(output_dir, 'exp4_original_signal.png'));

% ---------------- 设计指标 ----------------
fp = 120; fs = 150; Rp = 0.2; As = 60;

% ---------------- 窗函数法（Blackman） ----------------
wc = (fp + fs) / Fs;         % 归一化截止 (0~1，相对于 Fs)
B  = 2*pi*(fs - fp) / Fs;
Nw = ceil(11*pi / B);
if mod(Nw,2)==0, Nw = Nw+1; end
hn_w = fir1(Nw-1, wc, blackman(Nw));
fprintf('窗函数法（Blackman）阶数: %d\n', Nw-1);

% 滤波并计算滤波器频率响应
y_w = fftfilt(hn_w, xt);
Hw_w = fft(hn_w, N);

figure(2); clf; set(gcf,'Color','w');
subplot(3,1,1);
plot((0:N-1)*(Fs/N), 20*log10(abs(Hw_w)+eps), 'k-', 'LineWidth', 1);
title('窗函数法低通滤波器幅频特性（Blackman）');
xlabel('f / Hz'); ylabel('幅度 (dB)'); grid on;
axis([0 Fs/2 -120 20]);

subplot(3,1,2);
plot(t, y_w, 'k-', 'LineWidth', 1);
title('滤除噪声后的信号波形（窗函数法）');
xlabel('时间 (s)'); ylabel('幅度'); grid on;
xlim([0, Tp/2]); ylim([-1.1, 1.1]);

subplot(3,1,3);
Yw = fft(y_w, N);
plot(f1(1:floor(N/2)), abs(Yw(1:floor(N/2)))./max(abs(Yw)), 'k-', 'LineWidth', 1);
title('滤除噪声后的信号频谱（窗函数法）');
xlabel('频率 (Hz)'); ylabel('归一化幅度'); grid on;
axis([0 Fs/2 0 1.05]);

% 在图中注记阶数
text(0.72*Fs/2, 0.9, sprintf('阶数 = %d', Nw-1), 'Units','data','Color','k','FontSize',10);

% ========== 新增：保存图2 ==========
saveas(gcf, fullfile(output_dir, 'exp4_window_method.png'));
fprintf('已保存图2: %s\n', fullfile(output_dir, 'exp4_window_method.png'));

% ---------------- 等波纹法（remez） ----------------
fb = [fp, fs]; m = [1, 0];
dev = [ (10^(Rp/20)-1)/(10^(Rp/20)+1), 10^(-As/20) ];
[Ne, fo, mo, W] = remezord(fb, m, dev, Fs);
Ne = max(Ne,1);
hn_e = remez(Ne-1, fo, mo, W);
fprintf('等波纹法（remez）阶数: %d\n', Ne-1);

% 保存滤波器系数到文件
save(fullfile(output_dir, 'filter_coefficients.mat'), 'hn_w', 'hn_e', 'Nw', 'Ne', 'fp', 'fs', 'Rp', 'As');

y_e = fftfilt(hn_e, xt);
Hw_e = fft(hn_e, N);

figure(3); clf; set(gcf,'Color','w');
subplot(3,1,1);
plot((0:N-1)*(Fs/N), 20*log10(abs(Hw_e)+eps), 'k-', 'LineWidth', 1);
title('等波纹法低通滤波器幅频特性（remez）');
xlabel('f / Hz'); ylabel('幅度 (dB)'); grid on;
axis([0 Fs/2 -80 10]);

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
axis([0 Fs/2 0 1.05]);

text(0.72*Fs/2, 0.9, sprintf('阶数 = %d', Ne-1), 'Units','data','Color','k','FontSize',10);

% ========== 新增：保存图3 ==========
saveas(gcf, fullfile(output_dir, 'exp4_remez_method.png'));
fprintf('已保存图3: %s\n', fullfile(output_dir, 'exp4_remez_method.png'));

fprintf('\n所有图片已保存到目录: %s\n', output_dir);

% --------------- End ---------------