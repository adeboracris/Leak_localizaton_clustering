function [ATDTime,ATDTime_node] = ATD_timeserie(mu,eucl_out,sensors,D,D_1,Tts,image,scenario)
scenario_s=1;
n=268;

ConfusionMatrixTime = zeros(n,n,Tts*24);
theta=[];
j=1;
ConfusionMatrix=zeros(n);
for node=1:n
    for i = 1:24*Tts
        euclidean =sqrt(sum((mu'-eucl_out(j,:)').^2));
        theta(i,:,node)=euclidean./sum(euclidean);
        j=1+j;
    end
    [~,Class] = min(theta(i,:,node));
    ConfusionMatrix(n,sensors(Class)) = ConfusionMatrix(n,sensors(Class))+1;
end

 Accuracy = 0;
    for i = 1:31
        Accuracy = Accuracy+ConfusionMatrix(i,i);
    end
    Accuracy = 100*Accuracy/(31*24*Tts);
    
    ATD = sum(sum(ConfusionMatrix.*D))/sum(sum(ConfusionMatrix));

AccuracyTime = zeros(Tts*24,length(sensors));
for i = 1:n
    for j = 1:Tts*24
        Prob(1,1:length(sensors)) = 1;
        for k = 0:Tts*24-1
            if j+k <= Tts*24
                
                Prob = Prob.*theta(j+k,:,i);
            else
                Prob = Prob.*theta(j+k-Tts*24,:,i);
            end
            Prob = Prob/sum(Prob);
            [~,Class] = min(Prob);
            Class;
            ConfusionMatrixTime(i,sensors(Class),k+1) = ConfusionMatrixTime(i,sensors(Class),1)+1;
        end
    end
end

for j = 1:Tts*24
    for i = 1:n
        AccuracyTime(j) = AccuracyTime(j,scenario_s)+ConfusionMatrixTime(i,i,j);
    end
    ATDTime(j,scenario_s) = sum(sum(ConfusionMatrixTime(:,:,j).*D))/sum(sum(ConfusionMatrixTime(:,:,j)));
    ATDTime_node(j,scenario_s) = sum(sum(ConfusionMatrixTime(:,:,j).*D_1))/sum(sum(ConfusionMatrixTime(:,:,j)));

end
AccuracyTime(:,scenario_s) = 100*AccuracyTime(:,scenario_s)/(n*24*Tts);
figure(1)
subplot(1,2,image)
color=[1 0 0;0 1 0;0 0 1;1 0 1;1 1 0;0.5 0.5 0.3];
hold on
ATDTime_node=ATDTime_node./1000;
plot(ATDTime,'-','MarkerIndices',1:5:length(ATDTime_node),'Color',(color(scenario,:)),'LineWidth', 1)
% plot(ATDTime,'.','MarkerIndices',1:5:length(ATDTime),'Color',(color(scenario,:)))
end

