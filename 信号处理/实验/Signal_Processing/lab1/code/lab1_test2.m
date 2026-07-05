%% 信号基本运算
figure('Position', [100, 100, 1000, 800]);

% 信号和
sig_sum = x_sin + x_exp(1:N);
subplot(3,2,1);
stem(n, sig_sum, 'filled', 'LineWidth', 1.5, 'Color', 'k', 'MarkerFaceColor', 'k');
title('正弦序列 + 指数序列', 'FontWeight', 'bold', 'FontSize', 11);
xlabel('n'); ylabel('幅度');
grid on;

% 信号积
sig_prod = x_sin .* x_exp(1:N);
subplot(3,2,2);
stem(n, sig_prod, 'filled', 'LineWidth', 1.5, 'Color', 'k', 'MarkerFaceColor', 'k');
title('正弦序列 × 指数序列', 'FontWeight', 'bold', 'FontSize', 11);
xlabel('n'); ylabel('幅度');
grid on;

% 信号移位（延迟2个单位）
k = 2;
delta_shifted = [zeros(1,k), delta(1:end-k)];
subplot(3,2,3);
stem(0:length(delta_shifted)-1, delta_shifted, 'filled', 'LineWidth', 1.5, 'Color', 'k', 'MarkerFaceColor', 'k');
title('单位抽样序列移位', 'FontWeight', 'bold', 'FontSize', 11);
xlabel('n'); ylabel('幅度');
grid on;

% 信号标乘
alpha = 2;
sig_scaled = alpha * x_sin;
subplot(3,2,4);
stem(n, sig_scaled, 'filled', 'LineWidth', 1.5, 'Color', 'k', 'MarkerFaceColor', 'k');
title('正弦序列标乘', 'FontWeight', 'bold', 'FontSize', 11);
xlabel('n'); ylabel('幅度');
grid on;

% 信号翻转
sig_flipped = fliplr(x_sin);
subplot(3,2,5);
stem(n, sig_flipped, 'filled', 'LineWidth', 1.5, 'Color', 'k', 'MarkerFaceColor', 'k');
title('正弦序列翻转', 'FontWeight', 'bold', 'FontSize', 11);
xlabel('n'); ylabel('幅度');
grid on;

% 信号累加
sig_cumsum = cumsum(x_sin);
subplot(3,2,6);
stem(n, sig_cumsum, 'filled', 'LineWidth', 1.5, 'Color', 'k', 'MarkerFaceColor', 'k');
title('正弦序列累加', 'FontWeight', 'bold', 'FontSize', 11);
xlabel('n'); ylabel('幅度');
grid on;

sgtitle('信号基本运算', 'FontSize', 14, 'FontWeight', 'bold');

% 设置白色背景，调整子图
set(gcf, 'Color', 'w');
set(gcf, 'PaperPositionMode', 'auto');

% 调整所有子图的字体大小
h = findobj(gcf, 'Type', 'axes');
set(h, 'FontSize', 10);

% 调整子图位置使其更紧凑
for i = 1:length(h)
    pos = get(h(i), 'Position');
    set(h(i), 'Position', [pos(1) pos(2) pos(3)*0.9 pos(4)*0.9]);
end

% 保存图片（可选）
 print('signal_operations.png', '-dpng', '-r300');