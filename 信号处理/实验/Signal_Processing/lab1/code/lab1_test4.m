% 音频录制与处理

% % 检查音频设备
% info = audiodevinfo;
% if isempty(info.input)
%     warning('没有找到音频输入设备。请检查麦克风连接和权限。');
%     return;
% end

% % 参数
% fs = 44100;
% time = 5;
% bit = 16;

% % 录制
% R = audiorecorder(fs, bit, 1);
% recordblocking(R, time);
% sample_audio = getaudiodata(R);

% % 检查是否录制到数据
% if isempty(sample_audio) || all(sample_audio == 0)
%     warning('录制失败：没有检测到音频信号。请检查麦克风设置。');
%     return;
% end

fs = 44100;
[sample_audio, fs] = audioread('sample_audio.wav');

% 设置黑白配色
set(0, 'DefaultAxesColorOrder', [0 0 0]); % 黑色
set(0, 'DefaultLineLineWidth', 1.5);

% 绘制波形 - 黑白配色
figure(1);
plot(sample_audio, 'k', 'LineWidth', 1.5);
title('原始音频波形', 'FontWeight', 'bold', 'FontSize', 12);
xlabel('采样点');
ylabel('幅度');
grid on;
set(gcf, 'Color', 'w'); % 白色背景
set(gca, 'FontSize', 10);

% 保存原始波形图片
saveas(gcf, 'audio_waveform.png');

% 保存
audiowrite('sample_audio.wav', sample_audio, fs);

% 频谱分析
N = length(sample_audio);
f = (0:N-1)*(fs/N);
Y = fft(sample_audio);
P = abs(Y)/N;

% 绘制频谱 - 黑白配色
figure(2);
plot(f(1:floor(N/2)), P(1:floor(N/2)), 'k', 'LineWidth', 1.5);
title('原始音频频谱', 'FontWeight', 'bold', 'FontSize', 12);
xlabel('频率 (Hz)');
ylabel('幅度');
grid on;
set(gcf, 'Color', 'w'); % 白色背景
set(gca, 'FontSize', 10);

% 保存原始频谱图片
saveas(gcf, 'audio_spectrum.png');

% 低通滤波器 (进一步调整：降低截止频率到500Hz以增强闷的效果，阶数增到6)
cutoff = 500;   % 进一步降低截止频率使声音更闷
order = 6;      % 增加阶数以陡峭过渡带
[b, a] = butter(order, cutoff/(fs/2), 'low');
filtered_audio = filter(b, a, sample_audio);
filtered_audio = filtered_audio * 2;  % 放大信号以确保音量

% 绘制滤波后波形 - 黑白配色
figure(3);
plot(filtered_audio, 'k', 'LineWidth', 1.5);
title('滤波后音频波形', 'FontWeight', 'bold', 'FontSize', 12);
xlabel('采样点');
ylabel('幅度');
grid on;
set(gcf, 'Color', 'w'); % 白色背景
set(gca, 'FontSize', 10);

% 保存滤波后波形图片
saveas(gcf, 'filtered_waveform.png');

% 绘制滤波后频谱
Y_filtered = fft(filtered_audio);
P_filtered = abs(Y_filtered)/N;

% 绘制滤波后频谱 - 黑白配色
figure(4);
plot(f(1:floor(N/2)), P_filtered(1:floor(N/2)), 'k', 'LineWidth', 1.5);
title('滤波后音频频谱', 'FontWeight', 'bold', 'FontSize', 12);
xlabel('频率 (Hz)');
ylabel('幅度');
grid on;
set(gcf, 'Color', 'w'); % 白色背景
set(gca, 'FontSize', 10);

% 保存滤波后频谱图片
saveas(gcf, 'filtered_spectrum.png');

% 播放
sound(filtered_audio, fs);
sound(sample_audio, fs);

% 保存滤波信号
audiowrite('filtered_sample_audio.wav', filtered_audio, fs);

fprintf('音频处理完成！\n');
fprintf('生成的图片文件：\n');
fprintf('  - audio_waveform.png (原始波形)\n');
fprintf('  - audio_spectrum.png (原始频谱)\n');
fprintf('  - filtered_waveform.png (滤波后波形)\n');
fprintf('  - filtered_spectrum.png (滤波后频谱)\n');
fprintf('  - filtered_sample_audio.wav (滤波后音频)\n');
