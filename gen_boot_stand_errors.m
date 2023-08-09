function uboot = gen_boot_stand_errors(uhat,indices)

numvars=cols(uhat);
[numrealizations numscenarios]=size(indices);
uboot=nan(numrealizations,numvars,numscenarios);

for i=1:numvars
    for b=1:numscenarios
        try
        uboot(:,i,b)=uhat(indices(:,b),i);
        catch
            keyboard
        end
%     u1=uhat(indices(:),i);
%     uboot(:,i,:)=reshape(u1,[numrealizations numscenarios]);
    end
end
% keyboard
