function[data_acc, data_giro, data_magn,time] = life_importfile(path)

t = h5read(path,'/ACCELEROMETER_3D/0x0268fd9f/t');

time = datetime(1970,1,1,0,0,0,t);

x_data_acc = double(h5read(path,'/ACCELEROMETER_3D/0x0268fd9f/x/v'));
y_data_acc = double(h5read(path,'/ACCELEROMETER_3D/0x0268fd9f/y/v'));
z_data_acc = double(h5read(path,'/ACCELEROMETER_3D/0x0268fd9f/z/v'));

data_acc = [x_data_acc; y_data_acc; z_data_acc];

x_data_giro = double(h5read(path,'/GYROSCOPE_3D/0x0268fd9f/x/v'));
y_data_giro = double(h5read(path,'/GYROSCOPE_3D/0x0268fd9f/y/v'));
z_data_giro = double(h5read(path,'/GYROSCOPE_3D/0x0268fd9f/z/v'));

data_giro = [x_data_giro; y_data_giro; z_data_giro];

x_data_magn = double(h5read(path,'/MAGNETOMETER_3D/0x0268fd9f/x/v'));
y_data_magn = double(h5read(path,'/MAGNETOMETER_3D/0x0268fd9f/y/v'));
z_data_magn = double(h5read(path,'/MAGNETOMETER_3D/0x0268fd9f/z/v'));

data_magn = [x_data_magn; y_data_magn; z_data_magn];


end