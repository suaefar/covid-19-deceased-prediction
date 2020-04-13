#!/usr/bin/octave
close all;
clear;
clc;

days = -6:12;
past_days_fit = 11;
future_days_predicion = 3;

regions = {'US' 'Italy' 'Spain' 'France' 'UK' 'Germany' 'Netherlands' 'Sweden'};
data = importdata('data.txt');
num_regions = size(data,1);

colors = lines(num_regions);

graphics_toolkit qt;
figure('Position',[0 0 500 500]);
h = [];
Ps = cell(1,num_regions);

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
  Ps{i} = P;
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
ylim([4 17]);
legend(h,regions,'location','southeast');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5].*1.4);
drawnow;
print('-depsc2','prediction.eps');
print('-dpng','prediction.png');


figure('Position',[0 0 500 500]);
h = [];
plot([-0.3 0.3],[0 0],'-k');
hold on;
plot([0 0],[-0.01 0.01],'-k');
text(-0.15,0.005,'Slope negative and increasing','horizontalalignment','center')
text(0.15,0.005,'Slope positve and increasing','horizontalalignment','center')
text(0.15,-0.005,'Slope positve and decreasing','horizontalalignment','center')
for i=1:num_regions
  P = Ps{i};
  h(end+1) = scatter(P(2), P(3), sqrt(2.^P(1)), colors(i,:),'filled');
end
ylabel('Curvature');
xlabel('Slope');
xticks([-0.3:0.05:-0.05 0 0.05:0.05:0.3]);
yticks([-0.01:0.001:-0.001 0 0.001:0.001:0.01]);
yticks();
grid on;
legend(h,regions,'location','southwest');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5].*1.4);
drawnow;
print('-depsc2','classification.eps');
print('-dpng','classification.png');
