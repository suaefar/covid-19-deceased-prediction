#!/usr/bin/octave
close all;
clear;
clc;

days = 13:23;
days_predicion = 13:27;
days_last = days(end);

regions = {'Italy' 'Spain' 'UK' 'Germany' 'Belgium' 'Austria'};
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
  P = fminsearch(@(P) sum((log2(deceased) - (P(1) + P(2).*(days-days_last))).^2),[0;0]);
  prediction_linear = P(1) + P(2).*(days_predicion-days_last);
  plot(days_predicion,prediction_linear,'--','color',colors(i,:));
  P = fminsearch(@(P) sum((log2(deceased) - (P(1) + P(2).*(days-days_last) + P(3).*(days-days_last).^2)).^2),[P(1);P(2);0]);
  prediction_quadratic = P(1) + P(2).*(days_predicion-days_last) + P(3).*(days_predicion-days_last).^2;
  plot(days_predicion,prediction_quadratic,'-','color',colors(i,:));
  next_day_prediction = P(1) + P(2) + P(3);
  plot(days_last+1,next_day_prediction,'x','color',colors(i,:));
  text(days_last+1,next_day_prediction, ['  ' num2str(2.^(next_day_prediction),'%5.0f')],'color',colors(i,:));
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
print('-depsc2','prediction.eps');
