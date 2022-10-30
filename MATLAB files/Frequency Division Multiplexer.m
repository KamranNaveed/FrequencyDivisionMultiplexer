
%{

***********************************************************************************************
--------------------------------------- SEMESTER PROJECT --------------------------------------
***********************************************************************************************
------------------------------- FREQUENCY DIVISION MULTIPLEXING -------------------------------
***********************************************************************************************

                                    Made By Group F, BEE10A:
    
   +-----------------------+---------------------+-----------------------------------------+
   |         Name          | Registration Number |            Tasks Alloted                |
   +-----------------------+---------------------+-----------------------------------------+
   | Kamran Naveed Syed    |              266897 | Inputting signals, Standardize Function |
   | Muhammad Ismail       |              258279 | Demodulation, Recovery                  |
   | Rehman Afzal          |              218058 | Band Pass Filter Design on FDA Tool     |
   | Makhdoom Tayyab Altaf |              255030 | Spectrum Plotter Function, Modulation   |          |
   | Muhammad Haris Javed  |              245021 | Low Pass Filter Designa on FDA Tool     |
   +-----------------------+---------------------+-----------------------------------------+

    Note: The final code was constructed in an orderly member with the help of all the members

%} 
 
clc,close all,clear variables;

%**********************************************************************************************


%                      Taking input of audio messages from group members
%______________________________________________________________________________________________

% Message 1
[message1input,Fs_message1] = audioread('message 1.wav'); %sampling audio
% Message 2
[message2input,Fs_message2] = audioread('message 2.wav');
% Message 3
[message3input,Fs_message3] = audioread('message 3.wav');
% Message 1
[message4input,Fs_message4] = audioread('message 4.wav');

%Standardising Sampling Frequency
standard_Fs = 48e3; %std frequency meets minimum for Nyquist Criterion
message1 = standardize(standard_Fs,message1input,Fs_message1);
message2 = standardize(standard_Fs,message2input,Fs_message2);
message3 = standardize(standard_Fs,message3input,Fs_message3);
message4 = standardize(standard_Fs,message4input,Fs_message4);
Fs_message = standard_Fs;

%                                      Playing Original Messages
%____________________________________________________________________________________________

%{
 player1=audioplayer(message1,Fs_message); %using player objects to play sounds
 playblocking(player1);
 pause(1); %pause after each message
 player2=audioplayer(message2,Fs_message2);
 playblocking(player2);
 pause(1);

 player3=audioplayer(message3,Fs_message3);
 playblocking(player3);
 pause(1);
 player4=audioplayer(message4,Fs_message4);
 playblocking(player4);
 %}

%                                    Making time vector  
%____________________________________________________________________________________________

Lmax=max(max(max(length(message1),length(message2)), length(message3)),length(message4)); %determining message with longest duration
message1(length(message1):Lmax,1)=0; %appending shorter messages with zero to make them of same length
message2(length(message2):Lmax,1)=0;
message3(length(message3):Lmax,1)=0;
message4(length(message4):Lmax,1)=0;
slength = Lmax/Fs_message; %time span of audio signal
time_message = linspace(0, slength, Lmax); %final time vector


%                             Plotting the original audio messages 
%______________________________________________________________________________________________

figure('NumberTitle', 'on', 'Name', 'Original Messages'); 
subplot(2,4,1), plot(time_message,message1); %plotting message in time domain
title('Message 1');
ylim([-0.5,0.5]);  xlabel('Time / s'); %setting appropriate limits for axes
ylabel('Amplitude');
subplot(2,4,2), plot(time_message,message2);
title('Message 2');
ylim([-0.5,0.5]);  xlabel('Time / s');
ylabel('Amplitude');
subplot(2,4,3), plot(time_message,message3);
title('Message 3');
ylim([-0.5,0.5]);  xlabel('Time / s');
ylabel('Amplitude');
subplot(2,4,4), plot(time_message,message4);
title('Message 4');
ylim([-0.5,0.5]);  xlabel('Time / s');
ylabel('Amplitude');
subplot(2,4,5);
SpectrumPlotter(message1, Fs_message); %plotting message in frequency domain using custom function
xlim([-5,5]); ylim([0,3e-3]);
subplot(2,4,6);
SpectrumPlotter(message2, Fs_message);
xlim([-5,5]); ylim([0,3e-3]);
subplot(2,4,7);
SpectrumPlotter(message3, Fs_message); 
xlim([-5,5]); ylim([0,3e-3]);
subplot(2,4,8);
SpectrumPlotter(message4, Fs_message);
xlim([-5,5]); ylim([0,3e-3]);

%                                      Low Pass Filter
%______________________________________________________________________________________________
%{
    Parameters:
    Fs = 48kHz, Fpass = 3kHz, Fstop = 3.1kHz, Minimum Order
%}

load('Low_pass_3000.mat'); %load filter file which has saved filter coefficient

lpf_message1 = filter(Low_pass_3000,1,message1); %Passing message1 through LPF
lpf_message2 = filter(Low_pass_3000,1,message2); %Passing message2 through LPF
lpf_message3 = filter(Low_pass_3000,1,message3); %Passing message3 through LPF
lpf_message4 = filter(Low_pass_3000,1,message4); %Passing message4 through LPF

%                                    Plotting LPF Responses 
%______________________________________________________________________________________________

figure('NumberTitle', 'on', 'Name', 'LPF Response Spectrums'); 
subplot(2,2,1);
SpectrumPlotter(lpf_message1, Fs_message); 
title('LPF Response of Message 1');
xlim([-5,5]); ylim([0,3e-3]);
subplot(2,2,2);
SpectrumPlotter(lpf_message2, Fs_message);
title(' LPF Response ofMessage 2');
xlim([-5,5]); ylim([0,3e-3]);
subplot(2,2,3);
SpectrumPlotter(lpf_message3, Fs_message); 
title('LPF Response of Message 3');
xlim([-5,5]); ylim([0,3e-3]);
subplot(2,2,4);
SpectrumPlotter(lpf_message4, Fs_message);
title('LPF Response of Message 4');
xlim([-5,5]); ylim([0,3e-3]);


%                                         Modulation
%_____________________________________________________________________________________________

%taking 4 unique carrierss
carrier1 = transpose((cos(2*pi*3000*time_message))); %carrier signal_1 with 3kHz freq
carrier2 = transpose((cos(2*pi*9000*time_message))); %%carrier signal_1 with 9kHz freq
carrier3 = transpose((cos(2*pi*15000*time_message))); %%carrier signal_1 with 15kHz freq
carrier4 = transpose((cos(2*pi*21000*time_message))); %%carrier signal_1 with 21kHz freq
%All carriers in transpose form
%Modulate each of the filtered signal by multiplying with a unique Cosine
%function using frequencies 3kHz, 9 kHz, 15 kHz and 21 kHz respectively
mod_message1=lpf_message1.*carrier1;
mod_message2=lpf_message2.*carrier2;
mod_message3=lpf_message3.*carrier3;
mod_message4=lpf_message4.*carrier4;
%Adding the four modulated signals
add_mod_message=mod_message1+mod_message2+mod_message3+mod_message4; 


%                             Plotting the modulated messages 
%______________________________________________________________________________________________

figure('NumberTitle', 'on', 'Name', 'Modulated Signals'); 
subplot(2,2,1);
SpectrumPlotter(mod_message1, Fs_message); 
title('Modulated Message 1');
xlim([-8,8]); ylim([0,1.5e-3]);
subplot(2,2,2);
SpectrumPlotter(mod_message2, Fs_message);
title('Modulated Message 2');
xlim([-12,12]); ylim([0,3e-3]);
subplot(2,2,3);
SpectrumPlotter(mod_message3, Fs_message); 
title('Modulated Message 3');
xlim([-20,20]); ylim([0,1.5e-3]);
subplot(2,2,4);
SpectrumPlotter(mod_message4, Fs_message);
title('Modulated Message 4');
xlim([-26,26]); ylim([0,1.5e-3]);

%                            Plotting the sum of modulated messages 
%______________________________________________________________________________________________

figure('NumberTitle', 'on', 'Name', 'Sum of Modulated Signals'); 
SpectrumPlotter(add_mod_message, Fs_message);
title('Sum of Modulated Signals');
xlim([-25,25]); ylim([0,1.5e-3]);



%                                     Band Pass Filters
%______________________________________________________________________________________________

%{
    Equiripple FIR, minimum order
    Density Factor = 20
    Fs = 48000 Hz
    Apass  = 1dB
    Astop2 = 80dB

    Band Pass 1 
    ___________

    Astop1 = 10dB
    Fstop1 = 1Hz
    Fpass1 = 100Hz
    Fpass2 = 2800Hz
    Fstop2 = 3000Hz

    Band Pass 2
    ___________

    Astop1 = 80dB
    Fstop1 = 6kHz
    Fpass1 = 6.2Hz
    Fpass2 = 8.8Hz
    Fstop2 = 9kHz

    Band Pass 3
    ___________

    Astop1 = 80dB
    Fstop1 = 12kHz
    Fpass1 = 12.2kHz
    Fpass2 = 14.8kHz
    Fstop2 = 15kHz
    
    Band Pass 4 
    ___________

    Astop1 = 80dB
    Fstop1 = 18kHz
    Fpass1 = 18.2kHz
    Fpass2 = 20.8kHz
    Fstop2 = 21kHz

%}

load('Band_pass_3000.mat'); %load band pass 1 filter file
Band_pass_1 = Band_pass_3000; %save coefficient
%Do with rest
load('Band_pass_9000.mat'); 
Band_pass_2 = Band_pass_9000;

load('Band_pass_15000.mat'); 
Band_pass_3 = Band_pass_15000;

load('Band_pass_21000.mat'); 
Band_pass_4 = Band_pass_21000;

% Bandpass filter for 3Khz
bpf_message1 = filter(Band_pass_1,1,add_mod_message); %passing through BPF

% Bandpass filter for 9Khz
bpf_message2 = filter(Band_pass_2,1,add_mod_message);

% Bandpass filter for 15Khz
bpf_message3 = filter(Band_pass_3,1,add_mod_message);

% Bandpass filter for 21Khz
bpf_message4 = filter(Band_pass_4,1,add_mod_message);


%                                   Plotting BPF Responses 
%______________________________________________________________________________________________


figure('NumberTitle', 'on', 'Name', 'Modulated Signals'); 
subplot(2,2,1);
SpectrumPlotter(bpf_message1, Fs_message); 
title('BPF Response of Message 1');
xlim([-5,5]); ylim([0,1.5e-3]);
subplot(2,2,2);
SpectrumPlotter(bpf_message2, Fs_message);
title('BPF Response of Message 2');
xlim([-10,10]); ylim([0,1.5e-3]);
subplot(2,2,3);
SpectrumPlotter(bpf_message3, Fs_message); 
title('BPF Response of Message 3');
xlim([-20,20]); ylim([0,1.5e-3]);
subplot(2,2,4);
SpectrumPlotter(bpf_message4, Fs_message);
title('BPF Response of Message 4');
xlim([-25,25]); ylim([0,1.5e-3]);

%                                          Demodulation
%______________________________________________________________________________________________

%Multiply with cosines again to re-center
recov_message1 = bpf_message1.*carrier1;
recov_message2 = bpf_message2.*carrier2;
recov_message3 = bpf_message3.*carrier3;
recov_message4 = bpf_message4.*carrier4;


%                                   Restored Original Signals
%______________________________________________________________________________________________

%passing through LPF to retrieve original signals
%multiplying by 4 to recover lost amplitude during modulation and demodulation
restored_message1 = 4*filter(Low_pass_3000,1,recov_message1); 
restored_message2 = 4*filter(Low_pass_3000,1,recov_message2); 
restored_message3 = 4*filter(Low_pass_3000,1,recov_message3); 
restored_message4 = 4*filter(Low_pass_3000,1,recov_message4); 

%                             Plotting the restored messages 
%______________________________________________________________________________________________


figure('NumberTitle', 'on', 'Name', 'Recovered Original Messages'); 
subplot(2,4,1), plot(time_message,restored_message1); %plotting message in time domain
title('Restored Message 1');
ylim([-0.5,0.5]);  xlabel('Time / s');
ylabel('Amplitude');
subplot(2,4,2), plot(time_message,restored_message2);
title('Restored Message 2');
ylim([-0.5,0.5]);  xlabel('Time / s');
ylabel('Amplitude');
subplot(2,4,3), plot(time_message,restored_message3);
title('Restored Message 3');
ylim([-0.5,0.5]);  xlabel('Time / s');
ylabel('Amplitude');
subplot(2,4,4), plot(time_message,restored_message4);
title('Restored Message 4');
ylim([-0.5,0.5]);  xlabel('Time / s');
ylabel('Amplitude');
subplot(2,4,5);
SpectrumPlotter(restored_message1, Fs_message); %plotting message in frequency domain
xlim([-5,5]); ylim([0,3e-3]);
subplot(2,4,6);
SpectrumPlotter(restored_message2, Fs_message);
xlim([-5,5]); ylim([0,3e-3]);
subplot(2,4,7);
SpectrumPlotter(restored_message3, Fs_message); 
xlim([-5,5]); ylim([0,3e-3]);
subplot(2,4,8);
SpectrumPlotter(restored_message4, Fs_message);
xlim([-5,5]); ylim([0,3e-3]);

%                                      Playing Back Messages
%______________________________________________________________________________________________


%Playing each reconstructed audio signal 
%{
player1=audioplayer(restored_message1,Fs_message);
playblocking(player1); 
player2=audioplayer(restored_message2,Fs_message);
playblocking(player2); %play audio after the previous one ends

player3=audioplayer(restored_message3,Fs_message);
playblocking(player3);
player4=audioplayer(restored_message4,Fs_message);
playblocking(player4);
%}

