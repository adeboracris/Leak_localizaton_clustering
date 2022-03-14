function  clustering_min = clustering(sensors)
load('data.mat', 'Diameter', 'length1','S','T')
weights=length1/Diameter.^4.87; %length/diameter^5 [m][m]
G = graph(S,T,weights);

 N=272;

preference=distances(G);
preference=preference(:,sensors);

for i=1:length(preference)
    for j=1:length(sensors)
        euclidean (i,j) =sqrt(sum((preference(i,:)-preference(sensors(j),:)).^2));    
     
    end   
end
for i=1:272
    [~,id]=min(euclidean (i,:));
    clustering_min(i)=id;    
end

end

