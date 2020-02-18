function RMAX = Range()
    %{
    %https://copradar.com/rdrrange/
    %https://www.amsat.org/amsat/archive/amsat-bb/200901/msg10302.html
    %http://www.naic.edu/~astro/RXstatus/Lwide/Lwide.shtml
    k = 1.38e-23; %(Blotzmann's Constant (Watt*sec/°Kelvin))
    T = (40+25)/2; %Temperatureof system (°Kelvin) %average for arecibo is 25-40
    B = (1.73+1.15)/2; %Receiver Bandwidth (Hz)
    F = .7;%Noise Factor (ratio), Noise Figure (dB)
    MSNR = 1;%Minimum Signal to Noise Ratio

    Pmin = k * T * B * F * MSNR; %minimum detectable signal (power)
    C = 2.99e8; %speed of light
    freq = 400e6%transmit frequency Hz (e6 for MHz)
    % The observatory has four radar transmitters, with effective isotropic radiated powers of 20 TW (continuous) at 2380 MHz, 2.5 TW (pulse peak) at 430 MHz, 300 MW at 47 MHz, and 6 MW at 8 MHz.
    Pt = 2.5e12;%Transmit Power (Watts) (e12 = terra)
    lambda = C/freq; %transmit wavelength (length)
    omega = 1; %target radar cross section (Area)
    G = .6; %antenna gain (ratio)
    numerator = Pt * (G ^ 2) * (lambda ^ 2) * omega;
    denominator = Pmin * ((4*pi) ^ 3);
    RMAX = numerator / denominator;
    }%

end