%% Read Audio Data
[file,path]=uigetfile('.wav');
[S,Fs]=audioread(file);
S=S(:,2);

%% Set constants
cutoff=0.35;

%% FFT Test
m = length(S);       % original sample length
n = pow2(nextpow2(m));  % transform length
y = fft(S,n); 
f = (0:n-1)*(Fs/n)/10;
power = abs(y).^2/n;      

plot(f(1:floor(n/2)),power(1:floor(n/2)))
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
