% suppress m-lint warnings for unused assigned values

% compute the double-sided frequency axis
N = length(signal(1, :));
if mod(N, 2)==0
    
    % N is even
    f = (-N/2:N/2-1) * Fs/N;
    
else
    
    % N is odd
    f = (-(N-1)/2:(N-1)/2) * Fs/N;
    
end

% compute gaussian filter coefficients
mean = freq;
variance = (bandwidth / 100 * freq / (2 * sqrt(2 * log(2)))).^2;
magnitude = 1;

% create the double-sided Gaussian filter
gauss_filter = max(gaussian(f, magnitude, mean, variance), gaussian(f, magnitude, -mean, variance));

% store a copy of the central signal element if required for plotting
if nargin == 5 && plot_filter
    example_signal = signal(ceil(end/2), :);
end

% apply filter
signal = real(ifft(ifftshift(...
            bsxfun(@times, gauss_filter, ...
                fftshift(fft(signal, [], 2), 2) ...
            )...
        , 2), [], 2));

% plot filter if required
if nargin == 5 && plot_filter
    
    % compute amplitude spectrum of central signal element
    as = fftshift(abs(fft(example_signal)) / N);
    as_filtered = fftshift(abs(fft(signal(ceil(end/2), :))) / N);
    
    % get axis scaling factors
    [f_sc, f_scale, f_prefix] = scaleSI(f);
    
    % produce plot
    figure;
    plot(f .* f_scale, as ./ max(as(:)), 'k-');
    hold on;
    plot(f .* f_scale, gauss_filter, 'b-');
    plot(f .* f_scale, as_filtered ./ max(as(:)), 'r-');
    xlabel(['Frequency [' f_prefix 'Hz]']);
    ylabel('Normalised Amplitude');
    legend('Original Signal', 'Gaussian Filter', 'Filtered Signal');
    axis tight;
    set(gca, 'XLim', [0, f(end) .* f_scale]);
    
end