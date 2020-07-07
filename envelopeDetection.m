% if the input is one-dimensional, force to be 1 x Nx
if numDim(x) == 1
    x = reshape(x, 1, []);
end

% compute the FFT of the input function (use zero padding to prevent
% effects of wrapping at the beginning of the envelope), if x is a matrix
% the fft's are computed across each row
X = fft(x, length(x(1, :)) * 2, 2);

% multiply the fft by -1i
X = -1i * X;

% set the DC frequency to zero
X(1) = 0;

% calculate where the negative frequencies start in the FFT
neg_f_index = ceil(length(X(1, :)) / 2) + 1;

% multiply the negative frequency components by -1
X(:, neg_f_index:end) = -1 * X(:, neg_f_index:end);

% compute the Hilbert transform using the inverse fft
z = ifft(X, [], 2);

% extract the envelope
env = abs(x + 1i * z(:, 1:length(x)));