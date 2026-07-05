% spectrum_analysis.m
% 对题目所给离散和模拟信号做 FFT 谱分析，绘制幅频特性并比较 N 的影响
% 来源: 同学投稿，已匿名化

clear; close all; clc;

% 创建保存图片的文件夹
output_dir = 'exp3_figures';
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

%% ---- (1) 离散序列谱分析 ----
n_full = 0:7;
R4 = @(n) double((n>=0) & (n<=3));

x1 = R4(n_full);

% x2: piecewise
x2 = zeros(size(n_full));
x2(1:4) = (0:3) + 1;
x2(5:8) = 8 - (4:7);

% x3: piecewise
x3 = zeros(size(n_full));
x3(1:4) = 4 - (0:3);
x3(5:8) = (4:7) - 3;

signals = {x1, x2, x3};
signal_names = {'x_1(n)=R_4(n)', 'x_2(n)', 'x_3(n)'};
Ns = [8, 16];

fig1 = figure('Name','(1) 离散序列幅度谱分析','NumberTitle','off','Position',[100,100,1200,800]);

for si = 1:length(signals)
    x = signals{si};
    for k = 1:length(Ns)
        N = Ns(k);
        X = fft(x, N);
        mag = abs(X);
        f_normalized = (0:(N-1)) / N;
        
        subplot(length(signals), length(Ns), (si-1)*length(Ns) + k);
        stem(f_normalized, mag, 'filled', 'LineWidth', 1.5, 'MarkerSize', 8);
        grid on;
        title(sprintf('%s (N=%d)', signal_names{si}, N), 'FontSize', 12, 'FontWeight', 'bold');
        xlabel('归一化频率 (k/N)', 'FontSize', 11);
        ylabel('幅度 |X[k]|', 'FontSize', 11);
        xlim([0 1]);
        set(gca, 'FontSize', 10, 'GridAlpha', 0.3);
    end
end

% 保存图片
saveas(fig1, fullfile(output_dir, 'discrete_signals.png'));
disp('图1已保存: 离散序列幅度谱');

%% ---- (2) 周期序列谱分析 ----
n = 0:31;
x4 = cos(pi/4 * n);
x5 = cos(pi/4 * n) + cos(pi/8 * n);

signals2 = {x4(1:8), x5(1:8)};
names2 = {'x_4(n)=cos(\pi/4 n)', 'x_5(n)=cos(\pi/4 n)+cos(\pi/8 n)'};

fig2 = figure('Name','(2) 周期序列幅度谱分析','NumberTitle','off','Position',[100,100,1200,600]);
for si = 1:length(signals2)
    x = signals2{si};
    for k = 1:length(Ns)
        N = Ns(k);
        X = fft(x, N);
        mag = abs(X);
        f_normalized = (0:(N-1)) / N;
        
        subplot(length(signals2), length(Ns), (si-1)*length(Ns) + k);
        stem(f_normalized, mag, 'filled', 'LineWidth', 1.5, 'MarkerSize', 8);
        grid on;
        title(sprintf('%s (N=%d)', names2{si}, N), 'FontSize', 12, 'FontWeight', 'bold');
        xlabel('归一化频率 (k/N)', 'FontSize', 11);
        ylabel('幅度 |X[k]|', 'FontSize', 11);
        xlim([0 1]);
        set(gca, 'FontSize', 10, 'GridAlpha', 0.3);
    end
end

% 保存图片
saveas(fig2, fullfile(output_dir, 'periodic_signals.png'));
disp('图2已保存: 周期序列幅度谱');

%% ---- (3) 模拟周期信号谱分析 ----
Fs = 64;
t_total_points = 256;
t = (0:(t_total_points-1)) / Fs;

x6_cont = cos(8*pi*t) + cos(16*pi*t) + cos(20*pi*t);

% 时域波形
fig3a = figure('Name','(3) 模拟信号时域波形','NumberTitle','off','Position',[100,100,800,400]);
plot(t(1:64), x6_cont(1:64), '-o', 'LineWidth', 1.5, 'MarkerSize', 4);
grid on; 
xlabel('时间 (秒)', 'FontSize', 11); 
ylabel('x_6(t)', 'FontSize', 11);
title('x_6(t) 在 Fs=64 Hz 采样后的时域波形', 'FontSize', 12, 'FontWeight', 'bold');
set(gca, 'FontSize', 10, 'GridAlpha', 0.3);

% 保存时域图
saveas(fig3a, fullfile(output_dir, 'time_domain.png'));
disp('图3a已保存: 模拟信号时域波形');

% 双边频谱
Ns3 = [16, 32, 64];
fig3b = figure('Name','(3) 模拟信号双边频谱','NumberTitle','off','Position',[100,100,1200,500]);

for i = 1:length(Ns3)
    N = Ns3(i);
    x_sample = x6_cont(1:N);
    X = fft(x_sample, N);
    mag = abs(X);
    f = (-N/2:N/2-1) * (Fs/N);
    mag_shifted = fftshift(mag);

    subplot(1, length(Ns3), i);
    stem(f, mag_shifted, 'filled', 'LineWidth', 1.5, 'MarkerSize', 6);
    grid on;
    xlabel('频率 (Hz)', 'FontSize', 11);
    ylabel('幅度 |X(f)|', 'FontSize', 11);
    title(sprintf('N=%d (分辨率=%.2f Hz)', N, Fs/N), 'FontSize', 12, 'FontWeight', 'bold');
    xlim([-Fs/2 Fs/2]);
    ylim([0 max(mag_shifted)*1.1]);
    set(gca, 'FontSize', 10, 'GridAlpha', 0.3);
    
    % 标记主要频率分量
    hold on;
    for freq = [4, 8, 10]
        plot([freq, freq], [0, max(mag_shifted)*0.8], 'r--', 'LineWidth', 1);
        plot([-freq, -freq], [0, max(mag_shifted)*0.8], 'r--', 'LineWidth', 1);
    end
end

% 保存频谱图
saveas(fig3b, fullfile(output_dir, 'freq_domain_double.png'));
disp('图3b已保存: 模拟信号双边频谱');

% 单边频谱
fig3c = figure('Name','(3) 模拟信号单边频谱','NumberTitle','off','Position',[100,100,1200,500]);

for i = 1:length(Ns3)
    N = Ns3(i);
    x_sample = x6_cont(1:N);
    X = fft(x_sample, N);
    mag = abs(X);
    
    % 单边谱
    if mod(N,2) == 0
        f_single = (0:N/2) * Fs/N;
        mag_single = mag(1:N/2+1);
        mag_single(2:end-1) = 2*mag_single(2:end-1);
    else
        f_single = (0:(N-1)/2) * Fs/N;
        mag_single = mag(1:(N+1)/2);
        mag_single(2:end) = 2*mag_single(2:end);
    end
    
    subplot(1, length(Ns3), i);
    stem(f_single, mag_single, 'filled', 'LineWidth', 1.5, 'MarkerSize', 6);
    grid on;
    xlabel('频率 (Hz)', 'FontSize', 11);
    ylabel('幅度 |X(f)|', 'FontSize', 11);
    title(sprintf('N=%d (分辨率=%.2f Hz)', N, Fs/N), 'FontSize', 12, 'FontWeight', 'bold');
    xlim([0 Fs/2]);
    ylim([0 max(mag_single)*1.1]);
    set(gca, 'FontSize', 10, 'GridAlpha', 0.3);
    
    % 标记主要频率分量
    hold on;
    for freq = [4, 8, 10]
        plot([freq, freq], [0, max(mag_single)*0.8], 'r--', 'LineWidth', 1);
    end
end

% 保存单边谱图
saveas(fig3c, fullfile(output_dir, 'freq_domain_single.png'));
disp('图3c已保存: 模拟信号单边频谱');

%% ---- 总结输出 ----
fprintf('\n========== 实验三：用FFT对信号作频谱分析 ==========\n');
fprintf('所有图片已保存至文件夹: %s\n', output_dir);
fprintf('包含以下PNG文件:\n');
fprintf('  1. discrete_signals.png      - 离散序列谱分析\n');
fprintf('  2. periodic_signals.png      - 周期序列谱分析\n');
fprintf('  3. time_domain.png           - 模拟信号时域波形\n');
fprintf('  4. freq_domain_double.png    - 模拟信号双边频谱\n');
fprintf('  5. freq_domain_single.png    - 模拟信号单边频谱\n');
fprintf('===================================================\n');

% 关闭所有图形窗口
close all;
