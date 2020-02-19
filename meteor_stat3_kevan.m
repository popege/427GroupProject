function [meteor]=meteor_stat3(cxd1p, avgPwr1p, hdr, to_plot);

%% find if there is a meteor. If there is, output meteor statistics
%% Q.Zhou, Jan. 2015

%format compact
% define parameters and thresholds
nTxSmp = hdr.nTxSmp;
npts1p = length(cxd1p);
sn_thold = 2;                       % threshold for meteor
len_thold = floor(hdr.rfLen/hdr.gw*0.8);   % length threshold

% get S/N
snr1p=(abs(cxd1p).^2)./avgPwr1p;

% determine if a meteor is present
bigs= snr1p >= sn_thold;            % meteor echoes are ones
diff_bigsid = diff([0, bigs, 0]);        % meteor start with 1 and end with -1
bigs_beg_id=find(diff_bigsid == 1);
bigs_end_id=find(diff_bigsid == -1);
length_bigs = bigs_end_id - bigs_beg_id;
[maxLen_bigs, maxLen_idx] = max(length_bigs);

if maxLen_bigs <= len_thold;      % no meteor found
    meteor = [];
    return
end



% big values have been found, figure out where they are
begID = bigs_beg_id(maxLen_idx);
endID = bigs_end_id(maxLen_idx);

% Extract the useful data, find the location of correlation peak
cxdat_bigs=cxd1p(begID:endID);
ccxTx = conj(cxd1p(1:nTxSmp));      % Conjugate of Tx pulses
ccc=xcorr(cxdat_bigs, ccxTx);       
% if 2nd array is shorter, 2nd array is zero-filled to the length of first
% array. Shift is performed to 2nd array. 

[max_ccc, max_id]=max(abs(ccc));
N = max( [ length(ccxTx), length(cxdat_bigs)] );
ishift=max_id - N;
% if ishift is positive, shift 2nd array to the left. 
% if ishift is negative, shift abs(ishift) 
if ishift > 0 ;     % N=1, there is no shift
    new_ccxTx=ccxTx(ishift:end);
    min_length=min( length(new_ccxTx), length(cxdat_bigs) );
    product = cxdat_bigs(1:min_length).*new_ccxTx(1:min_length);
elseif ishift < 0;
    new_cxdat_bigs=cxdat_bigs(abs(ishift):end);
    min_length=min( length(ccxTx), length(new_cxdat_bigs) );
    product = new_cxdat_bigs(1:min_length).*ccxTx(1:min_length);
else
    meteor = [];       % this should rarely happen
    return
end

if length(product) <=1, 
    meteor = [];
    return
end

phases=angle(product);
del_phase=diff(phases);
largeID = find(del_phase >= pi);
smallID = find(del_phase <= -pi);
del_phase(largeID)=(del_phase(largeID)-2*pi);
del_phase(smallID)=(del_phase(smallID)+2*pi);
neg_ID=find(del_phase < 0);
del_phase(neg_ID)=pi+del_phase(neg_ID);
mean_delphase = mean(del_phase);
aVel = floor(mean_delphase*0.699/(hdr.gw*1.e-6)/(4*pi))/1000;   % in km/s
hts=hdr.gd*0.15+hdr.gw*0.15*(0:(npts1p-1))-hdr.gw*0.15*nTxSmp;
meteor_ht=hts(begID);

% output parameters
meteor.date = hdr.date;
meteor.time = hdr.asthr;
meteor.ht = meteor_ht;
meteor.vel = aVel;
if to_plot
    figure(2)
    subplot(211)
    semilogy(hts, abs(cxd1p).^2, 'b',  hts, avgPwr1p, 'r');
    xlabel('hts in km'); ylabel( 'pwr'); grid; axis tight;
    subplot(212)
    plot(del_phase*180/pi, '*')
    xlabel(['data index (date time: ', num2str(hdr.date), '  ', ...
        num2str(hdr.asthr),')']) 
    ylabel('del phase (degree)'), 
    title(['~ht(km), ~vel(km/s): ', num2str(meteor_ht), '  ', num2str(aVel) ])
    axis([1, length(del_phase), -180, 180]); grid
    pause(2)
end
return




