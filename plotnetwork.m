function [] = plotnetwork(idx,sensors)
figure
hold on
load('data.mat')
for j=1:length(pipes)
    p1 = find(cell2mat(cellfun(@(x)(strcmp(x,pipes(j,1))),coords(:,1),'UniformOutput',0)));
    p2 = find(cell2mat(cellfun(@(x)(strcmp(x,pipes(j,2))),coords(:,1),'UniformOutput',0)));
    plot([coords{p1,2} coords{p2,2}],[coords{p1,3} coords{p2,3}],'b');
end
for j=1:3
    plot(distance1(sensors(j),1),distance1(sensors(j),2),'ro','MarkerSize',10)
end
for j=6:3
    plot(distance1(sensors(j),1),distance1(sensors(j),2),'ko','MarkerSize',10)
end
gscatter(distance1(:,1),distance1(:,2),idx)
for j=1:length(sensors)
    text(distance1(sensors(j),1)-115,distance1(sensors(j),2)+250,num2str(j))
end
end

