[y,Fs] = audioread("Audio.mp3");

%2.(1)Waveform
time = (0:length(y)-1)/Fs;
figure;
plot(time,y);
title('(1)Waveform');
xlabel('Time (s)');
ylabel('Amplitude');


%2.(2)Energy contour
window_time = 0.02;
window_length = floor(window_time * Fs);
window_num = floor(length(y)/window_length);
energy = zeros(1, window_num);
for i = 1:window_num
    cal_energy = 0;
    start = (i-1)*window_length+1;
    stop = i*window_length;
    one_window = y(start:stop);
    one_window = one_window .* rectwin(window_length)';
    for j = 1:window_length
        cal_energy = cal_energy + one_window(j).^2;
    end
    energy(i) = cal_energy;
end
figure;
plot((0:length(energy)-1),energy)
time_x = window_time/2:window_time:((length(energy))*window_time);
plot( time_x , energy);
title('(2)Energy contour');
xlabel('Time (s)');
ylabel('Energy');


%2.(3)Zero-crossing rate contour
zero_crossing_rate = zeros(1, window_num);
for i = 1:window_num
    cal_zero_crossing = 0;  
    start = (i-1)*window_length+1;
    stop = i*window_length;
    one_window = y(start:stop);
    for j = 1:length(one_window)-1
        if (one_window(j)>=0 && one_window(j+1)<0)
            cal_zero_crossing = cal_zero_crossing + 1;
        elseif (one_window(j)<0 && one_window(j+1)>=0)
            cal_zero_crossing = cal_zero_crossing + 1;
        end
    end
    rate = cal_zero_crossing/window_length;
    zero_crossing_rate(i) = rate;
end
figure;
plot( (0:window_num-1)* window_length/Fs , zero_crossing_rate);
title('(3)Zero-crossing rate contour');
xlabel('Time (s)');
ylabel('Zero-crossing rate');


%2.(4)End point detection
ITU = mean(energy(1:round(0.001*Fs))); 
start = 0;
stop = 0;
for i = 1:window_num
    if energy(i)>ITU && start==0
        start = i;
    elseif energy(i)>ITU
        stop = i;
    end
end
figure;
time = (0:length(y)-1)/Fs;
plot(time,y);
xline(start*window_time,'--r');
xline(stop*window_time,'--r');
title('(4)End point detection');
xlabel('Time (s)');
ylabel('Amplitude');


%2.(5)Pitch contour
y_pitch = mean(y, 2);
figure;
pitch(y_pitch,Fs)
title("(5)Pitch contour")
xlabel('Time (s)');


%3.Calculate the spectrogram
y = y(:, 1);
overlap_ratio = 0.5;
[s,f,t] = spectrogram(y,window_length,round(overlap_ratio*window_length),512,Fs);
figure;
surf(t,f,20*log10(abs(s)),'EdgeColor','none');
axis xy;
axis tight;
view(0,90);
title('Spectrogram');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colorbar;