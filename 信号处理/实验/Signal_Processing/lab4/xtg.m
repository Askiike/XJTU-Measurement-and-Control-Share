function xt = xtg(N)
% xtg 产生长度为 N 的单频调幅信号并叠加高通噪声（不绘图）
% xt = xtg(N)
% 输入:
%   N - 信号长度（样点数），若未提供则默认 1000
% 输出:
%   xt - 产生的带有加性高频噪声的单频调幅信号（1 x N 向量）
if nargin < 1 || isempty(N)
    N = 1000;
end

Fs = 1000;          % 采样频率
T = 1/Fs;
t = (0:N-1)*T;

% 调制与载波（按照用户给定的参数）
fc = Fs/10;         % 载波频率 = Fs/10 = 100 Hz
f0 = fc/10;         % 调制频率 = fc/10 = 10 Hz
mt = cos(2*pi*f0*t);    % 调制信号
ct = cos(2*pi*fc*t);    % 载波
xt_base = mt .* ct;     % 单频调幅信号

% 随机噪声（均匀分布在 [-1,1]）
nt = 2*rand(1, N) - 1;

% ======= 设计高通滤波器 hn，用于滤除 nt 中的低频成分，生成高通噪声 =======
% 使用用户原来的参数（fp=150, fs=200, Rp=0.1, As=70）
fp_hp = 150; fs_hp = 200;
Rp_hp = 0.1; As_hp = 70;
fb = [fp_hp, fs_hp];
m  = [0, 1];   % 指定为高通：低频阻带(0)，高频通带(1)
dev = [10^(-As_hp/20), (10^(Rp_hp/20)-1)/(10^(Rp_hp/20)+1)];

% remezord/remez 可能返回最小阶数 0 或 1，确保阶数 >= 1
[n, fo, mo, W] = remezord(fb, m, dev, Fs);
n = max(n, 1);
hn = remez(n, fo, mo, W);

% 生成高通噪声并放大若干倍以显著噪声成分（如原函数）
yt = filter(hn, 1, 10 * nt);

% 合成最终带噪声信号（不绘图）
xt = xt_base + yt;
end