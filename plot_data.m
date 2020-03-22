#!/usr/bin/octave
close all;
clear;
clc;

days = 13:21;
days_predicion = 13:25;

regions = {'Italy' 'Spain' 'France' 'UK' 'Germany'};
data = importdata('data.txt');
num_regions = size(data,1);

colors = lines(num_regions);

graphics_toolkit qt;
figure('Position',[0 0 400 400]);
h = [];

for i=1:num_regions
  deceased = data(i,:);
  h(end+1) = plot(days,log2(deceased),'o','color',colors(i,:));
  hold on;
  P = fminsearch(@(P) sum((log2(deceased) - (P(2).*(days-P(1)))).^2),[0;0]);
  prediction_linear = P(2).*(days_predicion-P(1));
  plot(days_predicion,prediction_linear,'--','color',colors(i,:));
  P = fminsearch(@(P) sum((log2(deceased) - (P(2).*(days-P(1)) + P(3).*(days-P(1)).^2)).^2),[P(1);P(2);0]);
  prediction_quadratic = P(2).*(days_predicion-P(1)) + P(3).*(days_predicion-P(1)).^2;
  plot(days_predicion,prediction_quadratic,'-','color',colors(i,:));
end
ylabel('Deceased');
xlabel('Days in March');
ytickvals = 2.^(0:15);
yticks(log2(ytickvals));
yticklabels(ytickvals);
xticks(days_predicion);
xlim(days_predicion([1,end]));
grid on;

legend(h,regions,'location','southeast');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 4 4].*1.4);
print('-dpng','prediction.png');
