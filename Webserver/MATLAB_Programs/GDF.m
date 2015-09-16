%Function to compute GDFs for 6 value array. Returns 6 value array
%AJR 08-23-2013

function[GDF_OUT]=GDF(STRAIN_IN)

strain_sum=sum(STRAIN_IN);
for k=1:6
    GDF_OUT(k)=STRAIN_IN(k)/strain_sum;
end
