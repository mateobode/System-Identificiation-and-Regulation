%% Discretizare

Te = 2.5;
Hr = tf([19.6 1], [39 0]);
Hr_disc = c2d(Hr, Te, 'tustin');

%% Simulare
Hp = tf(2.6, [19.6 1], 'IODelay', 5);
Hp2 = tf(2.6, [19.6 1]);
figure;
step(Hp);
figure;
step(Hp2);
x = feedback (Hp*Hr, 1);
w = c2d(x, Te, 'tustin');
Hd = series(Hr, Hp);

H0 = feedback(Hd, 1);
[y, t] = step(H0);
plot(t,y);
stepinfo(y,t);

s = tf('s');

reg = (19.6*s + 1)/(39*s + 2.6*(1-exp(-5*s)));

reg_disc = c2d(reg, Te, 'tustin');