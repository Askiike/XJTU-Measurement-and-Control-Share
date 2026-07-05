clear; close all; clc;

%% ------------------- (1) 时域采样理论验证 -------------------
A = 444.128;
alpha = 50 * sqrt(2) * pi;
omega0 = 50 * sqrt(2) * pi;

Fs = [1000, 300, 200];
Tp = 64e-3;
M = 64;

% 高采样率参考信号
Fs_ref = 20000;
t_ref = 0:1/Fs_ref:Tp;
x_ref = A * exp(-alpha * t_ref) .* sin(omega0 * t_ref);

% 原始信号频谱
N_ref = 4096;
X_ref = fft(x_ref, N_ref);
f_ref = (0:N_ref-1) * Fs_ref / N_ref;

%% ---------- 原始信号 ----------
fig1 = figure('Name','时域采样理论验证（原始信号）','Position',[100,100,1000,600]);

subplot(2,1,1);
t_show = t_ref(t_ref <= 0.01); % 前10 ms波形
x_show = x_ref(1:length(t_show));
plot(t_show*1000, x_show, 'k-', 'LineWidth', 1.0);
xlabel('时间 / ms'); ylabel('幅值');
title('(a) 原始模拟信号 x(t)');
grid on;
xlim([0,10]);
ylim([min(x_show)*1.1, max(x_show)*1.1]);

subplot(2,1,2);
magX_ref = abs(X_ref)/max(abs(X_ref));  % 归一化幅度谱
plot(f_ref(1:round(500/Fs_ref*N_ref)), magX_ref(1:round(500/Fs_ref*N_ref)), 'k-', 'LineWidth', 1.0);
xlabel('频率 / Hz'); ylabel('归一化 |X(f)|');
title('(b) 原始信号的归一化幅度谱');
grid on;
xlim([0 500]);
ylim([0 1.1]);

% 保存第一张图
saveas(fig1, 'original_signal.png');

%% ---------- 三组采样信号 ----------
fig2 = figure('Name','时域采样理论验证（采样信号）','Position',[100,100,1200,800]);

for i = 1:3
    fs = Fs(i);
    N = round(Tp * fs);
    n = 0:N-1;
    t = n / fs;
    x = A * exp(-alpha * t) .* sin(omega0 * t);

    % ---- 填零以统一长度 ----
    if length(x) < M
        x = [x zeros(1, M - length(x))];
        t = (0:M-1)/fs;
    end

    X = fft(x, M);
    f = (0:M-1) * fs / M;
    magX = abs(X)/max(abs(X));  % 归一化幅度谱

    % ---- 时域图 ----
    subplot(3,2,2*i-1);
    plot(t_ref*1000, x_ref, 'k--', 'LineWidth', 0.8); hold on;
    stem(t*1000, x, 'k.', 'MarkerSize', 7);
    grid on;
    xlabel('时间 / ms'); ylabel('幅值');
    title(sprintf('(%c) 采样信号, Fs=%d Hz', 'c'+(i-1)*2, fs));
    xlim([0, 10]);
    ylim([min(x_show)*1.1, max(x_show)*1.1]);

    % ---- 幅频图 ----
    subplot(3,2,2*i);
    stem(f(1:M/2), magX(1:M/2), 'k.', 'MarkerSize', 6);
    grid on;
    xlabel('频率 / Hz'); ylabel('归一化 |X(k)|');
    title(sprintf('(%c) 幅度谱, Fs=%d Hz', 'd'+(i-1)*2, fs));

    if fs == 200
        xlim([0, 80]); % 低采样率时压缩横轴
    elseif fs == 300
        xlim([0, 250]); 
    else
        xlim([0, 500]);
    end
    ylim([0, 1.1]);
end

sgtitle('时域采样理论验证');

% 保存第二张图
saveas(fig2, 'time_domain.png');

%% ------------------- (2) 频域采样理论验证（三角波信号） -------------------
% 三角波定义：
% x(n) = n+1, 0≤n≤13
% x(n) = 27−n, 14≤n≤26
% x(n) = 0, 其它
n = 0:26;
x = zeros(size(n));
x(n<=13) = n(n<=13) + 1;
x(n>=14) = 27 - n(n>=14);

% 1024 点近似连续频谱
N_exact = 1024;
X_exact = fft(x, N_exact);
omega_exact = (0:N_exact-1)/N_exact * 2*pi;

% 32 点采样
N32 = 32;
X32 = fft(x, N32);
x32 = ifft(X32, N32);

% 16 点采样（偶数抽取）
X16 = X32(1:2:end);
N16 = length(X16);
x16 = ifft(X16, N16);

%% ---------- 绘图 ----------
fig3 = figure('Name','频域采样理论验证（三角波）','Position',[100,100,1200,800]);

% (a) 原信号
subplot(3,2,1);
stem(n, x, 'k.', 'MarkerSize',8);
xlabel('n'); ylabel('x(n)');
title('(a) 原始三角波信号');
grid on;
xlim([0, 26]); ylim([0, 15]);

% (b) 理论频谱
subplot(3,2,3);
plot(omega_exact, abs(X_exact), 'k-', 'LineWidth', 1.2);
xlabel('\omega (rad)'); ylabel('|X(e^{j\omega})|');
title('(b) 三角波频谱 (1024点近似)');
xlim([0, 2*pi]); grid on;

% (c) 32点频域采样
subplot(3,2,5);
plot(omega_exact, abs(X_exact), 'k--', 'LineWidth', 0.8); hold on;
stem((0:N32-1)/N32*2*pi, abs(X32), 'k.', 'MarkerSize',8);
xlabel('\omega (rad)'); ylabel('|X_{32}(k)|');
title('(c) 32点频域采样');
xlim([0, 2*pi]); grid on;

% (d) 32点 IFFT结果（不对比）
subplot(3,2,2);
stem(0:N32-1, real(x32), 'k.', 'MarkerSize',8);
xlabel('n'); ylabel('幅值');
title('(d) 32点 IFFT结果');
xlim([0, 26]); ylim([0, 15]); grid on;

% (e) 16点频域采样
subplot(3,2,4);
plot(omega_exact, abs(X_exact), 'k--', 'LineWidth', 0.8); hold on;
stem((0:N16-1)/N16*2*pi, abs(X16), 'k^','MarkerFaceColor','k','MarkerSize',6);
xlabel('\omega (rad)'); ylabel('|X_{16}(k)|');
title('(e) 16点频域采样');
xlim([0, 2*pi]); grid on;

% (f) 16点 IFFT结果（不对比）
subplot(3,2,6);
stem(0:N16-1, real(x16), 'k^','MarkerFaceColor','k','MarkerSize',6);
xlabel('n'); ylabel('幅值');
title('(f) 16点 IFFT结果（时域混叠）');
xlim([0, 15]); ylim([0, 15]); grid on;

sgtitle('频域采样理论验证（三角波信号）');

% 保存第三张图
saveas(fig3, 'freq_domain.png');

disp('三张图片已保存：');
disp('  original_signal.png');
disp('  time_domain.png');
disp('  freq_domain.png');