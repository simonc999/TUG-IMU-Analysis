clc
clear 
close all

%% lettura dati

% tempo compimento
% conta passi

% calibrazione iniziale con angolo
% dati accelerometro e giroscopio (magn non guardiamo) e tempo
[data_acc,data_giro,data_magn,t] = life_importfile("TUG test.h5");


t = t(1:9600);
data_acc = data_acc(:,1:9600);

data_giro = data_giro(:,1:9600);
% x rappresenta bene il movimento di seduta

figure
%plot(t,data_acc')
plot(t,data_giro')


%% 
Fs=100;
T = 0:(length(data_acc(2,:))-1);
time = T/Fs;

figure
%plot(t,data_acc')

plot(time,data_acc)

%% filtraggio
close all
data_giro_filtrataX = movmean(data_giro(1,:),15);
% figure
% %plot(t,data_acc')
% plot(t,data_giro_filtrataX')

mean_giroX = mean(data_giro_filtrataX(1:2500));
std_giroX = std(data_giro_filtrataX(1:2500));

k = 4;
indexinit = find(data_giro_filtrataX>(mean_giroX+std_giroX*k));
figure
%plot(t,data_acc')
plot(t,data_giro_filtrataX')
hold on
plot(t(indexinit),data_giro_filtrataX(indexinit)','o')

INITIAL_STAND_index = indexinit(1);
hold on
indexmin = islocalmin(data_giro_filtrataX);
indexmin(1:2500)=0;
indexmin(7500:end)=0;


hold on
%plot(t(indexmin),data_giro_filtrataX(indexmin)','*')

hold on 
k_min = 200;
indextest = (data_giro_filtrataX<(mean_giroX-std_giroX*k_min)); 
%plot(t(indextest),data_giro_filtrataX(indextest)','o')
% FIRSTiNDEXsEARCH = find(indexinit>)
FINAL_STAND_index = indexinit(1);

hold on 
indexfinal = indextest.*indexmin;
indexfinal = logical(indexfinal);
plot(t(indexfinal),data_giro_filtrataX(indexfinal)','o')

% tempo di alzata 

%% valuto n passi
data_accX = data_acc(1,:);
data_accY = data_acc(2,:);
data_accZ = data_acc(3,:);

data_ACC = sqrt(sum(data_accX.^2 + data_accY.^2 +data_accZ.^2,1))-9.81;
figure
plot(t,data_ACC)
hold on 
[indexPeaks,peaks] = findpeaks(data_ACC(indextest));



% trovo i picchi dels segnale