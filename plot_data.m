#!/usr/bin/octave
close all;
clear;
clc;

days = -3:19;
past_days_fit = 14;
future_days_predicion = 3;

regions = {'US' 'UK' 'Spain' 'Brazil' 'Germany' 'Mexico' 'India' 'Russia' 'Sweden'};
data = importdata('data.txt');
num_regions = size(data,1);

colors = lines(num_regions);

graphics_toolkit qt;
figure('Position',[0 0 500 1000]);
subplot(2,1,1);
h = [];
Ds = cell(1,num_regions);
regions_info = regions;

asymmetry = @(x) min(x,0) + max(x,0).*4;

for i=1:num_regions
  deceased = data(i,:);
  h(end+1) = plot(days,log2(deceased),'o','color',colors(i,:),'markerfacecolor',colors(i,:));
  hold on;
  y = log2(deceased(end-past_days_fit+1:end));
  x = -past_days_fit+1:0;
  P = fminunc(@(P) sum(asymmetry(y - (P(1) + P(2).*x)).^2),[0;0]);
  xi = 1-past_days_fit:future_days_predicion;
  prediction_linear = P(1) + P(2).*xi;
  plot(days(end)+xi,prediction_linear,'--','color',colors(i,:));
  P = fminunc(@(P) sum(asymmetry(y - (P(1) + P(2).*x + P(3).*x.^2)).^2),[P(1);P(2);0]);
  prediction_quadratic = P(1) + P(2).*xi + P(3).*xi.^2;
  plot(days(end)+xi,prediction_quadratic,'-','color',colors(i,:));
  next_day_prediction = P(1) + P(2) + P(3);
  Ds{i} = P;
  today_prediction = P(1);
  plot(days(end)+1,next_day_prediction,'x','color',colors(i,:));
  regions_info{i} = [regions{i} ' x - ' num2str(2.^(next_day_prediction),'%5.0f') ' (' num2str(2.^(next_day_prediction)-2.^(today_prediction),'%+5.0f')  ')'];
end
ylabel('Deceased');
xlabel('Days in May');
ytickvals = 2.^(0:0.5:20);
yticks(log2(ytickvals));
yticklabels(round(ytickvals));
xticks(days(1):days(end)+future_days_predicion);
grid on;
xlim([days(1)-1 days(end)+future_days_predicion+1]);
ylim([3 17]);
legend(h,regions_info,'location','southeast');

subplot(2,1,2);
h = [];
plot([0 50],[0 50],'--k');
hold on;
for i=1:num_regions
  D = Ds{i};
  x = min(50,1./D(2));
  y = min(50,D(2)./max(eps,-D(3)));
  s = 0.01.*2.^D(1);
  h(end+1) = scatter(x, y, s, colors(i,:),'filled');
  t = text(x,y,[' ' regions{i}]);
end
ylabel('Current curvature (bending) / Days to zero slope');
xlabel('Current slope / Days doubling');
xlim([0 50]);
ylim([0 50]);
xticks(0:7:50);
yticks(0:7:50);
axis image;
grid on;

drawnow;
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 10].*1.4);
print('-depsc2','prediction.eps');
print('-dpng','prediction.png');

