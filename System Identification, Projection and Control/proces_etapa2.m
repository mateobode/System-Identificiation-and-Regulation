%% Comparare grafic

Hp = tf(2.6, [19.6 1], 'IODelay', 5);
figure;
step(Hp, 500);
hold on;
Hp2 = tf(2.6, [98 24.6 1]);
step(Hp2, 500);
hold off;

%% Discretizare Regulator

Te = 2.5;
Hr = tf([0.98/2.6*19.6 0.98/2.6],[19.6 0]);
Hr_discret = c2d(Hr, Te, 'Tustin');