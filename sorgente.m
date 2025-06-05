clc;
clear all;
close all;

%% LETTURA DATI
[data_acc, data_giro, data_magn, t] = life_importfile('C:\Users\bruna\OneDrive - Università di Pavia\assegno di ricerca\2022_2023\maglietta\life\test_IMU.h5');


%% PLOT Y GIRO

figure
plot(data_acc(2,:), 'LineWidth',1.5, 'Color', '#0072BD')
ylabel('Y Accelerometro [m/s^2]')
xlabel('Tempo [s]')

%% ARTEFATTO
data_acc = data_acc(:,1:9600);
data_giro = data_giro(:,1:9600);



%% FEQUENZA DI CAMPIONAMENTO
Fs = 100;


%% VETTORE DEL TEMPO
T = 0:(length(data_acc(2,:))-1);
time = T/Fs;

%% DATI ACCELEROMETRO
x_acc = data_acc(1,:);
y_acc = data_acc(2,:);
z_acc = data_acc(3,:);

figure
plot(time, x_acc, 'LineWidth',1.5, 'Color', '#0072BD')
hold on
plot(time, y_acc, 'LineWidth',1.5, 'Color', '	#77AC30')
hold on 
plot(time, z_acc, 'LineWidth',1.5, 'Color', '#D95319')
grid on
title('LIFE - GREZZI')
ylabel('Accelerometro [m/s^2]')
xlabel('Tempo [s]')
legend({'X', 'Y', 'Z'})

%% DATI GIROSCOPIO
x_giro = data_giro(1,:);
y_giro = data_giro(2,:);
z_giro = data_giro(3,:);

figure 
subplot(3,1,1)
plot(time, x_giro, 'LineWidth',1.5, 'Color', '#0072BD')
ylabel('Giroscopio X [°/s]')
xlabel('Tempo [s]')
grid on
subplot(3,1,2)
plot(time, y_giro, 'LineWidth',1.5, 'Color', '#77AC30')
ylabel('Giroscopio Y [°/s]')
xlabel('Tempo[s]')
grid on
subplot(3,1,3)
plot(time, z_giro, 'LineWidth',1.5, 'Color', '#D95319')
ylabel('Giroscopio Z [°/s]')
xlabel('Tempo [s]')
grid on




%% FILTRAGGIO - FILTRO A MEDIA MOBILE
%% ACCELEROMETRO
x_accF = movmean(x_acc, 15);
y_accF = movmean(y_acc, 15);
z_accF = movmean(z_acc, 15);


figure 
subplot(2,1,1)
plot(time, x_acc, 'LineWidth',1.5, 'Color', '#0072BD')
ylabel('Accelerazione X [m/s^2]')
xlabel('Tempo[s]')
title('X Grezza')
grid on
subplot(2,1,2)
plot(time, x_accF, 'LineWidth',1.5, 'Color', '#0072BD')
ylabel('Accelerazione X [m/s^2]')
xlabel('Tempo [s]')
title('X Filtrata')
grid on

figure 
subplot(2,1,1)
plot(time, y_acc, 'LineWidth',1.5, 'Color', '#77AC30')
ylabel('Accelerazione Y [m/s^2]')
xlabel('Tempo [s]')
title('Y Grezza')
grid on
subplot(2,1,2)
plot(time, y_accF, 'LineWidth',1.5, 'Color', '#77AC30')
ylabel('Accelerazione Y [m/s^2]')
xlabel('Tempo [s]')
title('Y Grezza')
grid on

figure
subplot(2,1,1)
plot(time, z_acc, 'LineWidth',1.5, 'Color', '#D95319')
ylabel('Accelerazione Z [m/s^2]')
xlabel('Tempo[s]')
title('Z Grezza')
ylim([-15 15])
grid on
subplot(2,1,2)
plot(time, z_accF, 'LineWidth',1.5, 'Color', '#D95319')
ylabel('Accelerazione Z [m/s^2]')
xlabel('Tempo [s]')
title('Z Filtrata')
grid on


%% GIROSCOPIO

x_giroF = movmean(x_giro, 15);
y_giroF = movmean(y_giro, 15);
z_giroF = movmean(z_giro, 15);

%% FASI - ALGORITMO DI SOGLIA -- X GIROSCOPIO

idxt1 = find(time==0);
idxt2 = find(time==20);
mean_girox = mean(x_giroF(1:2500));
std_girox = std(x_giroF(1:2500));
x_giroF = x_giroF';
k = 4;

figure
plot(time, x_giroF, 'LineWidth',1.5, 'Color', '#A2142F')
ylabel('Giroscopio X [°/s]')
xlabel('Tempo [s]')
grid on

%% SOGLIA MEDIA +- SD
[row_up, col_up] = find(x_giroF >= mean_girox + k *std_girox);
hold on
plot(time(row_up), x_giroF(row_up), 'r', 'Marker', 'o', 'LineStyle', 'none', 'Color', '#EDB120')

%% MINIMO LOCALE
step1=row_up(1);

k2 = 100;

row_local_min1 = step1 + find(islocalmin(x_giroF(step1:end)) .* (x_giroF(step1:end)<= mean_girox - k2 *std_girox)==1);

hold on
plot(time(row_local_min1), x_giroF(row_local_min1), 'r', 'Marker', 'o', 'LineStyle', 'none', 'Color', 'b')

step2 = row_local_min1(1);
soglia = row_up(row_up > step2);
fine_alzata=soglia(1);
inizio_alzata=row_up(1);
hold on
plot(time(fine_alzata), x_giroF(fine_alzata), 'r', 'Marker', 'o', 'LineStyle', 'none', 'Color', 'r')

tempo_alzata = time(fine_alzata) - time(inizio_alzata)


figure
plot(time, x_giroF, 'LineWidth',1.5, 'Color', '#A2142F')
ylabel('Giroscopio X [°/s]')
xlabel('Tempo [s]')
grid on
hold on
plot(time(inizio_alzata), x_giroF(inizio_alzata), 'r', 'Marker', '.', 'MarkerSize',20, 'LineStyle', 'none', 'Color', '#77AC30')
hold on
plot(time(fine_alzata), x_giroF(fine_alzata), 'r', 'Marker', '.', 'MarkerSize',20, 'LineStyle', 'none', 'Color', '#77AC30')


%% FLIP
flip_x_giroF = flipud(x_giroF);

[row_up, col_up] = find(flip_x_giroF >= mean_girox + k *std_girox);

step1=row_up(1);

k2 = 100;

row_local_min1 = step1 + find(islocalmax(flip_x_giroF(step1:end)) .* (flip_x_giroF(step1:end)>= mean_girox + k2 *std_girox)==1);

step2 = row_local_min1(1);


fine_alzata=soglia(1);
inizio_alzata=row_up(1);

tempo_alzata = time(fine_alzata) - time(inizio_alzata)

inizio_seduta = length(x_giroF) - fine_alzata;
fine_seduta = length(x_giroF) - inizio_alzata;

hold on
plot(time(inizio_seduta), x_giroF(inizio_seduta), 'r', 'Marker', '.', 'MarkerSize',20, 'LineStyle', 'none', 'Color', '#77AC30')
hold on
plot(time(fine_seduta), x_giroF(fine_seduta), 'r', 'Marker', '.', 'MarkerSize',20, 'LineStyle', 'none', 'Color', '#77AC30')

%% COUNTING STEPS
%% MODULO
G = 9.80665;
acc = sqrt(sum(x_accF.^2 + y_accF.^2 + z_accF.^2, 1))';
accNoG = acc - G;

figure
plot(time, accNoG, 'LineWidth',1.5, 'Color', '#A2142F')
ylabel('Accelerazione [m/s^2]')
xlabel('Tempo [s]')
grid on
% hold on
% plot(time(inizio_alzata), x_giroF(inizio_alzata), 'r', 'Marker', '.', 'MarkerSize',20, 'LineStyle', 'none', 'Color', '#77AC30')
% hold on
% plot(time(fine_alzata), x_giroF(fine_alzata), 'r', 'Marker', '.', 'MarkerSize',20, 'LineStyle', 'none', 'Color', '#77AC30')
% hold on
% plot(time(inizio_seduta), accNoG(inizio_seduta), 'r', 'Marker', '.', 'MarkerSize',20, 'LineStyle', 'none', 'Color', '#77AC30')
% hold on
% plot(time(fine_seduta), accNoG(fine_seduta), 'r', 'Marker', '.', 'MarkerSize',20, 'LineStyle', 'none', 'Color', '#77AC30')


[pks, locs] = findpeaks(accNoG(fine_alzata: inizio_seduta),'MinPeakHeight',0.9, 'MinPeakDistance',0.6);
idx = find(ismember(accNoG,pks) == 1);
hold on
plot(time(idx), pks, 'Color', '#EDB120', 'Marker', 'v', 'LineWidth', 1, 'LineStyle', 'none')
title('Numero di passi: ', numel(pks))


%% INVILUPPO
[upper, lower] = envelope(accNoG,15,'peak'); 
%restituisce gli inviluppi del picco superiore e inferiore di x.
%Gli inviluppi sono determinati utilizzando l'interpolazione spline
%su massimi locali separati da almeno np campioni.

figure
plot(time, accNoG, 'LineWidth',1.5, 'Color', '#A2142F')
ylabel('Accelerazione [m/s^2]')
xlabel('Tempo [s]')
grid on
hold on
plot(time, upper, 'LineWidth', 1.5, 'Color', '#0000FF')

figure
plot(time, upper, 'LineWidth',1.5, 'Color', '#0000FF')
ylabel('Inviluppo Accelerazione [m/s^2]')
xlabel('Tempo [s]')
grid on 

% hold on
% plot(time(inizio_alzata), x_giroF(inizio_alzata), 'r', 'Marker', '.', 'MarkerSize',20, 'LineStyle', 'none', 'Color', '#77AC30')
% hold on
% plot(time(fine_alzata), x_giroF(fine_alzata), 'r', 'Marker', '.', 'MarkerSize',20, 'LineStyle', 'none', 'Color', '#77AC30')
% hold on
% plot(time(inizio_seduta), accNoG(inizio_seduta), 'r', 'Marker', '.', 'MarkerSize',20, 'LineStyle', 'none', 'Color', '#77AC30')
% hold on
% plot(time(fine_seduta), accNoG(fine_seduta), 'r', 'Marker', '.', 'MarkerSize',20, 'LineStyle', 'none', 'Color', '#77AC30')


[pks, locs] = findpeaks(upper(fine_alzata: inizio_seduta),'MinPeakHeight',0.9, 'MinPeakDistance',0.6);
idx = find(ismember(upper,pks) == 1);
hold on
plot(time(idx),pks, 'Color', '#EDB120', 'Marker', 'v', 'LineWidth',1, 'LineStyle', 'none')
title('Numero di passi: ', numel(pks))