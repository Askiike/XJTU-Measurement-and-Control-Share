%% 卷积运算
clear all; close all; clc;

% 设置信号长度
N = input('请输入信号长度N: ');
n = 0:N-1;

% 生成信号
f = 0.1; % 频率
x_sin = sin(2*pi*f*n);
a = 0.9; % 衰减因子
x_exp = a.^n;

% 创建图形窗口
figure('Position', [100, 100, 1200, 900]);

% 计算卷积
y_conv = conv(x_sin, x_exp);
conv_n = 0:length(y_conv)-1;

% 使用更紧凑的子图布局 - 方法1：直接指定位置
% 第一个子图
ax1 = axes('Position', [0.10, 0.68, 0.80, 0.25]);
stem(n, x_sin, 'filled', 'LineWidth', 1.5, 'Color', 'k', 'MarkerFaceColor', 'k');
title('信号1: 正弦序列 x_1[n] = sin(2πfn)', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('n'); ylabel('幅度');
ylim([-1.2 1.2]);
grid on;

% 第二个子图
ax2 = axes('Position', [0.10, 0.38, 0.80, 0.25]);
stem(n, x_exp, 'filled', 'LineWidth', 1.5, 'Color', 'k', 'MarkerFaceColor', 'k');
title('信号2: 指数序列 x_2[n] = a^n', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('n'); ylabel('幅度');
ylim([0 1.2]);
grid on;

% 第三个子图
ax3 = axes('Position', [0.10, 0.08, 0.80, 0.25]);
stem(conv_n, y_conv, 'filled', 'LineWidth', 1.5, 'Color', 'k', 'MarkerFaceColor', 'k');
title('卷积结果 y[n] = x_1[n] * x_2[n]', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('n'); ylabel('幅度');
xlim([-1, length(y_conv)]);
grid on;

% 添加总标题
annotation('textbox', [0, 0.95, 1, 0.05], ...
    'String', '信号卷积运算', ...
    'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center', ...
    'FontSize', 16, 'FontWeight', 'bold');

% 添加参数信息
info_str = sprintf('N = %d, f = %.2f, a = %.2f | 卷积长度: %d + %d - 1 = %d', ...
    N, f, a, N, N, length(y_conv));
annotation('textbox', [0, 0.01, 1, 0.04], ...
    'String', info_str, ...
    'EdgeColor', 'k', 'BackgroundColor', 'w', ...
    'HorizontalAlignment', 'center', ...
    'FontSize', 10, 'FontWeight', 'bold');

% 设置白色背景
set(gcf, 'Color', 'w');

% 保存图片
print('convolution_result.png', '-dpng', '-r300');

% 显示信息
fprintf('输入信号长度: %d\n', N);
fprintf('卷积结果长度: %d\n', length(y_conv));
fprintf('卷积定理验证: %d + %d - 1 = %d\n', N, N, length(y_conv));