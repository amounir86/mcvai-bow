function varargout = linespec2prop(varargin)
% VL_LINESPEC2PROP  Convert PLOT style line specs to properties
%  PROPR = VL_LINESPEC2PROP(SPEC) converts the string SPEC to a cell
%  array of properties PROPR. SPEC is in the format of PLOT().
%
%  If SPEC is not in a recognized format, the string SPEC is returned
%  unaltered as the only element of PROPR.
%
%  See also:: VL_PLOTFRAME(), PLOT(), VL_HELP().
[varargout{1:nargout}] = vl_linespec2prop(varargin{:});
