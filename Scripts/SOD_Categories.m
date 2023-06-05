% Jacob Arnold

% 25-jan-2022


% Explore rate of change of use of each stage of development categroy over time



figure;
plot_dim(1000,300)
plot(SIT.dn, sum(SIT.sa>0)./length(SIT.lon));hold on;
plot(SIT.dn, sum(SIT.sb>0)./length(SIT.lon));
plot(SIT.dn, sum(SIT.sc>0)./length(SIT.lon));
plot(SIT.dn, sum(SIT.sd>0)./length(SIT.lon));




