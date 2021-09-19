%% Read Audio


%% Do Calculations
%find subsamle size using largest frequency component
Y = abs(fftshift(fft(S)));
Y = Y(length(Y)/2:end);
kmax = find(Y == max(Y));
subsamplesize = round(length(Y)/kmax);

%calculate closed quotient for subsamples of the signal, 
%then find the average for the whole signal
subsamples = ceil(length(S)/subsamplesize);
cq = 0; %running total of closed quotient for each subsample
for i = 1:subsamples
    starti = ((i-1)*subsamplesize)+1;
    endi = i*subsamplesize;
    if(endi <= length(S))
        s = S(starti:endi);
    else
        s = S(starti:end);
    end
    minval = min(s);
    s = s - minval;
    maxval = max(s);
    closed = length(find(s < (maxval*cutoff)));
    cq = cq + (closed/length(s));
end

%calculate average closed quotient for whole signal
CQ = cq/subsamples;
