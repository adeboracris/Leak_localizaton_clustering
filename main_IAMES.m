close all
clc
figure

centroinds{1}=[10 44 93  120 160]; %3+2=5
centroinds{2}=[10 44 93 37 134 151 224];%3+4=7
centroinds{3}=[10 44 93  120 160 102 250 129 149 ];%3+6=9

centroinds{4}=[9 65  94 109 247    196   246]; %5+2=7
centroinds{5}=[9 65  94 109 247    130 189 231 267]; %5+4=9
centroinds{6}=[9 65  94 109 247    85 113 178 166 214 232];%5+6=11
n_sensor=[3 3 3 5 5 5];


scenario=2

%----
    load('data','TrainingPressure','Pressure_leak')
    disp('-------*****------')
    real_s=centroinds{1, scenario}
    number_sensor=n_sensor(scenario);
    TrainingPressure=TrainingPressure(real_s,1:24);
    TrainingPressure=mean(TrainingPressure,2);
    
    Pressure_m=Pressure_leak(real_s,1:24,:);
    Pressure_m=squeeze(mean(Pressure_m,2));
    
    residual= TrainingPressure-Pressure_m;
    residual=residual([1:number_sensor],real_s);
    residual=residual+abs(min(residual));
    
    mu = (residual./sum(residual))';
    %%
    num_iterations =272-4;Tts=2;
    first_cluster=clustering(real_s);
    plotnetwork(first_cluster,real_s)
    [state, eucl_out,node]=data_generation(num_iterations,24*Tts,real_s(1:number_sensor),first_cluster);
    
    infer_state=[];
    for i = 1:num_iterations*24*Tts
        euclidean =sqrt(sum((eucl_out(i,:)'-mu').^2));
        infer_state = [infer_state; find(euclidean==min(euclidean))];
    end
    
    load('data.mat', 'D','D_1')
    [ATDt_node,ATDt_km]= ATD_timeserie(mu,eucl_out,real_s,D_1,D,Tts,2,scenario);
    %%
    disp('-------------')
    
    distM=squareform(pdist(eucl_out));
    accuracy = sum(state == infer_state)/(num_iterations*24*Tts)
    CM=confusionmat(node,real_s(infer_state));
    %     sum(sum(CM.*D_1))/sum(sum(CM)) ,
    disp(sprintf('ATD(node) %f ', ATDt_node(24)));
    disp(sprintf('ATD(km) %f ', ATDt_km(24)));
%     disp(sprintf('Dunns index for kmeans %f', dunns(length(real_s),distM,infer_state)));    
    
    cm=confusionmat(infer_state,state);
    statsOfMeasure(cm,1)
