function varargout = imsmooth(varargin)
% VL_IMSMOOTH  Smooth image
%   I=VL_IMSMOOTH(I,SIGMA) convolves the image I by an isotropic Gaussian
%   kernel of standard deviation SIGMA.  I must be an array of
%   doubles. IF the array is three dimensional, the third dimension is
%   assumed to span different channels (e.g. R,G,B). In this case,
%   each channel is convolved independently.
%
%   See also:: VL_HELP().
[varargout{1:nargout}] = vl_imsmooth(varargin{:});
