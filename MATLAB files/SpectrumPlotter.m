function SpectrumPlotter(message,frequency)
    samples = length(message); %time domain vector sample number
    Fsub = fftshift(fft(message))/samples; %fourier transform
    Faxis =(-samples/2:samples/2-1)*frequency/(1000*samples); %frequency vector in kHz 
    plot(Faxis,abs(Fsub)); %plot in frequency domain with magenta colour
    xlabel('Frequency / kHz');
    ylabel('Magnitude');
end


