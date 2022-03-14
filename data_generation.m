function [state, eucl_out,node]=data_generation(num_iterations,time,real_s,cluster_index)
load('data','TrainingPressure','Pressure_leak')
[~,~,ix] = unique(cluster_index(1:272-4));
C = accumarray(ix,1).'
z=1;
for i = 1:num_iterations
    for j=1:time
        node(z)=i;
        state(z)=cluster_index(node(z));
        
        TrainingPressure_2=TrainingPressure(real_s,j);
        
        
        Pressure_m=Pressure_leak(real_s,j,i);
%         Pressure_m=squeeze(Pressure_m,2);
        
        residual= TrainingPressure_2-Pressure_m;
        residual=residual+abs(min(residual));
        eucl_out(z,:) = residual./sum(residual);
        z=z+1;
    end
end
state=state';
end

