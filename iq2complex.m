function [cx1r]=iq2complex(dat1r);

% convert iq data to complex data

datIn=dat1r;
npts=length(datIn);
datIn=reshape(datIn, 2, npts/2);    % force error if npts is not even
cx1r=complex(datIn(1, :), datIn(2, :));  % input data in complex form.

return;