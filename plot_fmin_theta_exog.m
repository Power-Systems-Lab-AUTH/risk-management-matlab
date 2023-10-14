x_values = linspace(0, 3/2, 100);
lag_structure = 1;
dstar = 1;
trend_term = 0;
y_values = arrayfun(@(x) fmin_theta_exog(x, X_dstar,exog_dstar,lag_structure,dstar,trend_term), x_values);

figure;
plot(x_values, y_values, 'b', 'DisplayName', 'fmin_theta_exog');
title('Plot of fmin-theta-exog');
xlabel('Theta');
ylabel('Function Value');
ylim([0 10]);
legend;
grid on;

