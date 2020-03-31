#!/usr/bin/octave
close all;
clear;
clc;

days = 22:30;
days_predicion = 22:33;
days_last = days(end);

regions = {'Italy' 'Spain' 'France' 'UK' 'Netherlands' 'Germany' 'Belgium' 'Switzerland' 'Portugal' 'Austria'};
data = importdata('data.txt');
num_regions = size(data,1);

colors = lines(num_regions);

graphics_toolkit qt;
figure('Position',[0 0 400 500]);
h = [];

for i=1:num_regions
  deceased = data(i,:);
  valid_days = ~isnan(deceased);
  h(end+1) = plot(days(valid_days),log2(deceased(valid_days)),'o','color',colors(i,:));
  hold on;
  P = fminsearch(@(P) sum((log2(deceased(valid_days)) - (P(1) + P(2).*(days(valid_days)-days_last))).^2),[0;0]);
  prediction_linear = P(1) + P(2).*(days_predicion-days_last);
  plot(days_predicion,prediction_linear,'--','color',colors(i,:));
  P = fminsearch(@(P) sum((log2(deceased(valid_days)) - (P(1) + P(2).*(days(valid_days)-days_last) + P(3).*(days(valid_days)-days_last).^2)).^2),[P(1);P(2);0]);
  prediction_quadratic = P(1) + P(2).*(days_predicion-days_last) + P(3).*(days_predicion-days_last).^2;
  plot(days_predicion,prediction_quadratic,'-','color',colors(i,:));
  next_day_prediction = P(1) + P(2) + P(3);
  today_prediction = P(1);
  plot(days_last+1,next_day_prediction,'x','color',colors(i,:));
  regions{i} = [regions{i} ' x - ' num2str(2.^(next_day_prediction),'%5.0f') ' (' num2str(2.^(next_day_prediction)-2.^(today_prediction),'%+5.0f')  ')'];
end
ylabel('Deceased');
xlabel('Days in March');
ytickvals = 2.^(0:0.5:20);
yticks(log2(ytickvals));
yticklabels(round(ytickvals));
xticks(days_predicion);
xlim(days_predicion([1,end]));
grid on;
axis image;
ylim([0 log2(20000)]);
legend(h,regions,'location','southeast');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 4 5].*1.4);
drawnow;
print('-depsc2','prediction.eps');
print('-dpng','prediction.png');
