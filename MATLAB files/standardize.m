function new_message = standardize(standard_Fs,message,Fs_message)
 if (Fs_message == standard_Fs)
     new_message = message;
 else
     [P,Q] = rat(standard_Fs/Fs_message); %ratio p/q of 
     new_message = resample(message,P,Q); %resample using ratio P/Q, downsample by Q upsample by P
 end

[~, n] = size(new_message); %n is the number of stereo channels
 if n == 2
    y = new_message(:, 1) + new_message(:, 2); 
    peakAmp = max(abs(y)); 
    y = y/peakAmp;
    %  check the L/R channels for orig. peak Amplitudes
    peakL = max(abs(new_message(:, 1)));
    peakR = max(abs(new_message(:, 2))); 
    maxPeak = max([peakL peakR]);
    %apply x's original peak amplitude to the normalized mono mixdown 
    new_message = y*maxPeak;   
  else
 end
 
end