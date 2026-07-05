%% 实验1：常见信号的MATLAB产生和图形显示
clear all; close all; clc;

% 设置信号长度（可输入确定）
N = input('请输入信号长度N: ');
n = 0:N-1;

%% 创建单个图形窗口显示所有信号
figure('Position', [100, 100, 1000, 800]);

%% 1. 单位抽样序列
delta = zeros(1,N);
delta(1) = 1; % 在n=0处为1

subplot(3,2,1);
stem(n, delta, 'filled', 'LineWidth', 1.5, 'Color', 'k', 'MarkerFaceColor', 'k');
title('单位抽样序列 \delta[n]', 'FontWeight', 'bold', 'FontSize', 11);
xlabel('n'); ylabel('幅度');
axis([-1 N 0 1.2]);
grid on;

%% 2. 单位阶跃序列
u = ones(1,N);

subplot(3,2,2);
stem(n, u, 'filled', 'LineWidth', 1.5, 'Color', 'k', 'MarkerFaceColor', 'k');
title('单位阶跃序列 u[n]', 'FontWeight', 'bold', 'FontSize', 11);
xlabel('n'); ylabel('幅度');
axis([-1 N 0 1.2]);
grid on;

%% 3. 正弦序列
f = 0.1; % 频率
A = 1;   % 幅度
phi = 0; % 初相位
x_sin = A * sin(2*pi*f*n + phi);

subplot(3,2,3);
stem(n, x_sin, 'filled', 'LineWidth', 1.5, 'Color', 'k', 'MarkerFaceColor', 'k');
title('正弦序列 x[n] = sin(2\pifn)', 'FontWeight', 'bold', 'FontSize', 11);
xlabel('n'); ylabel('幅度');
grid on;

%% 4. 复正弦序列 - 显示实部和虚部
f_complex = 0.15; % 频率
x_complex = exp(1j*2*pi*f_complex*n);

subplot(3,2,4);
% 黑白配色：实部用黑色圆圈，虚部用灰色星号
stem(n, real(x_complex), 'o-', 'LineWidth', 1.5, 'Color', 'k', 'MarkerFaceColor', 'k');
hold on;
stem(n, imag(x_complex), 's--', 'LineWidth', 1.5, 'Color', [0.4 0.4 0.4], 'MarkerFaceColor', [0.4 0.4 0.4]);
title('复正弦序列', 'FontWeight', 'bold', 'FontSize', 11);
xlabel('n'); ylabel('幅度');
legend('实部', '虚部', 'Location', 'best', 'FontSize', 9);
grid on;

%% 5. 指数序列
a = 0.9; % 衰减因子
x_exp = a.^n;

subplot(3,2,5);
stem(n, x_exp, 'filled', 'LineWidth', 1.5, 'Color', 'k', 'MarkerFaceColor', 'k');
title('指数序列 x[n] = a^n', 'FontWeight', 'bold', 'FontSize', 11);
xlabel('n'); ylabel('幅度');
grid on;

% 第6个子图位置添加信息
subplot(3,2,6);
axis off;
text(0.5, 0.7, '参数设置', 'HorizontalAlignment', 'center', ...
    'FontSize', 12, 'FontWeight', 'bold');
text(0.5, 0.5, sprintf('信号长度 N = %d', N), 'HorizontalAlignment', 'center', ...
    'FontSize', 11);
text(0.5, 0.4, '正弦频率 f = 0.1', 'HorizontalAlignment', 'center', ...
    'FontSize', 11);
text(0.5, 0.3, '复正弦频率 f = 0.15', 'HorizontalAlignment', 'center', ...
    'FontSize', 11);
text(0.5, 0.2, '指数衰减因子 a = 0.9', 'HorizontalAlignment', 'center', ...
    'FontSize', 11);

% 添加总标题
sgtitle('常见离散信号的MATLAB产生和图形显示', 'FontSize', 14, 'FontWeight', 'bold');

% 调整子图间距
set(gcf, 'Color', 'w'); % 设置背景为白色
set(gcf, 'PaperPositionMode', 'auto');

% 调整所有子图的位置，使它们更紧凑
h = findobj(gcf, 'Type', 'axes');
for i = 1:length(h)
    set(h(i), 'FontSize', 10);
    % 调整前5个子图的位置
    if i <= 5
        pos = get(h(i), 'Position');
        set(h(i), 'Position', [pos(1) pos(2) pos(3)*0.9 pos(4)*0.9]);
    end
end

% 保存图片（可选）
% print('basic_signals.png', '-dpng', '-r300');