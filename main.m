% チャープ信号（time-stretched pulse）を生成するスクリプト
% 参照：森勢将雅, "ひたすら楽して音響信号解析," コロナ社, p. 104, 2021.
clear; close all; clc;

%% 設定値
fs = 44100; % サンプリング周波数 [Hz]
sigLen = 4; % 信号長 [s]
f1 = 10; % 開始周波数 [Hz]
f2 = 22000; % 終了周波数 [Hz]

%% メイン処理
timeAx = (0:1/fs:sigLen).'; % 時間軸
freqAx = linspace(0, fs, size(timeAx, 1)); % 周波数軸
% sig = chirp(timeAx, f1, sigLen, f2); % チャープ信号
k = (f2-f1)/sigLen;
sig = sin(2*pi*(f1*timeAx+(k/2)*timeAx.^2)); % チャープ信号
powSpect = 20*log10(max(abs(fft(sig)), eps)); % パワースペクトル

%% 結果表示
% 波形
figure; plot(timeAx, sig);
xlabel("Time [s]"); ylabel("Amplitude");
grid on;

% パワースペクトログラム
figure;
pspectrum(sig, fs, "spectrogram", ...
    "TimeResolution", 0.1, ...
    "OverlapPercent", 99, ...
    "Leakage", 0.85);

% 周波数特性
figure; plot(freqAx, powSpect);
xlabel("Frequency [Hz]"); ylabel("Power [dB]");
xlim([10, fs/2]); ylim([0, 53]);
set(gca, "XScale", "log");
grid on;

% 音再生
sound(0.1*sig, fs);

%% 保存
saveName = "./chirp_" + sigLen + "s_" + f1 + "Hz_" + f2 + "Hz.wav";
audiowrite(saveName, sig, fs, "BitsPerSample", 32);