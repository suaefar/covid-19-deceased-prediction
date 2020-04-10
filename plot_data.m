#!/usr/bin/octave
close all;
clear;
clc;

days = -9:9;
past_days_fit = 11;
future_days_predicion = 3;

regions = {'Italy' 'Spain' 'France' 'US' 'UK' 'Netherlands' 'Germany' 'Sweden'};
data = importdata('data.txt');
num_regions = size(data,1);

colors = lines(num_regions);

graphics_toolkit qt;
figure('Position',[0 0 500 500]);
h = [];

for i=1:num_regions
  deceased = data(i,:);
  h(end+1) = plot(days,log2(deceased),'o','color',colors(i,:));
  hold on;
  y = log2(deceased(end-past_days_fit+1:end));
  x = -past_days_fit+1:0;
  P = fminsearch(@(P) sum((y - (P(1) + P(2).*x)).^2),[0;0]);
  xi = 1-past_days_fit:future_days_predicion;
  prediction_linear = P(1) + P(2).*xi;
  plot(days(end)+xi,prediction_linear,'--','color',colors(i,:));
  P = fminsearch(@(P) sum((y - (P(1) + P(2).*x + P(3).*x.^2)).^2),[P(1);P(2);0]);
  prediction_quadratic = P(1) + P(2).*xi + P(3).*xi.^2;
  plot(days(end)+xi,prediction_quadratic,'-','color',colors(i,:));
  next_day_prediction = P(1) + P(2) + P(3);
  today_prediction = P(1);
  plot(days(end)+1,next_day_prediction,'x','color',colors(i,:));
  regions{i} = [regions{i} ' x - ' num2str(2.^(next_day_prediction),'%5.0f') ' (' num2str(2.^(next_day_prediction)-2.^(today_prediction),'%+5.0f')  ')'];
end
ylabel('Deceased');
xlabel('Days in April');
ytickvals = 2.^(0:0.5:20);
yticks(log2(ytickvals));
yticklabels(round(ytickvals));
xticks(days(1):days(end)+future_days_predicion);
grid on;
xlim([days(1)-1 days(end)+future_days_predicion+1]);
ylim([2 15]);
legend(h,regions,'location','southeast');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5].*1.4);
drawnow;
print('-depsc2','prediction.eps');
print('-dpng','prediction.png');
