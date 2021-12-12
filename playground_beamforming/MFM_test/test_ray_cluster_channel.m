% Script: MAIN_EXAMPLE_04.M
% Summary: Demonstrates how MFM can be used at the device/link-level.
% By: Ian P. Roberts, MIMO for MATLAB (MFM)
% Date: 01-13-2020

% -------------------------------------------------------------------------
% Setup.
% -------------------------------------------------------------------------
clc; clearvars; close all;
rng(99);

% -------------------------------------------------------------------------
% System variables.
% -------------------------------------------------------------------------
symbol_bandwidth_Hz = 50e6;
carrier_frequency_Hz = 5e9;
propagation_velocity_meters_per_sec = 3e8;
noise_power_per_Hz_dBm_Hz = -174;
num_streams = 500;
transmit_power_dBm = 0;

% -------------------------------------------------------------------------
% Channel object.
% -------------------------------------------------------------------------
channel_object = channel.create('Rayleigh');

% -------------------------------------------------------------------------
% Path loss object.
% -------------------------------------------------------------------------
path_loss_object = path_loss.create('free-space');
path_loss_object.set_path_loss_exponent(3.5);

% -------------------------------------------------------------------------
% Create transmitting device.
%  * Fully-digital transmitter (as opposed to hybrid digital/analog)
% -------------------------------------------------------------------------
dev_tx = device.create('transmitter','digital');
dev_tx.set_symbol_bandwidth(symbol_bandwidth_Hz);
dev_tx.set_num_streams(num_streams);
dev_tx.set_transmit_power(transmit_power_dBm,'dBm');
dev_tx.set_name('Tx-1');
dev_tx.set_coordinate([0,0,0]);
dev_tx.set_marker('bx');

% -------------------------------------------------------------------------
% Create and set transmit array.
%  * Using a uniform linear array for simplicity here.
% -------------------------------------------------------------------------
Nt = 20;
array_transmit_object = array.create(Nt);
dev_tx.set_transmit_array(array_transmit_object);

% -------------------------------------------------------------------------
% Create receiving device.
%  * Fully-digital receiver (as opposed to hybrid digital/analog)
% -------------------------------------------------------------------------
dev_rx = device.create('receiver','digital');

% -------------------------------------------------------------------------
% Setup receiver.
% -------------------------------------------------------------------------
dev_rx.set_symbol_bandwidth(symbol_bandwidth_Hz);
dev_rx.set_num_streams(num_streams);
dev_rx.set_noise_power_per_Hz(-174,'dBm_Hz');
dev_rx.set_name('Rx-1');
dev_rx.set_coordinate([0,1,0]);
dev_rx.set_marker('bo');

% -------------------------------------------------------------------------
% Create and set transmit array.
%  * Using a uniform linear array for simplicity here.
% -------------------------------------------------------------------------
Nr = 4;
array_receive_object = array.create(Nr);
dev_rx.set_receive_array(array_receive_object);

% -------------------------------------------------------------------------
% Create link between the two devices.
%  * First device is transmitter, second device is receiver.
%  * Some properties of the link, such as its distance is automatically
%    computed based on the two devices.
% -------------------------------------------------------------------------
lnk = link(dev_tx,dev_rx);

% -------------------------------------------------------------------------
% Set channel and path loss models to use on the link.
% -------------------------------------------------------------------------
lnk.set_path_loss(path_loss_object);
lnk.set_channel(channel_object);

% -------------------------------------------------------------------------
% Link setup.
%  * Sets these properties on the channel and path loss models also.
% -------------------------------------------------------------------------
lnk.set_propagation_velocity(propagation_velocity_meters_per_sec);
lnk.set_carrier_frequency(carrier_frequency_Hz);

% -------------------------------------------------------------------------
% View the link.
%  * lnk.show_2d() or lnk.show_3d()
% -------------------------------------------------------------------------
%lnk.show_2d();
 lnk.show_3d();

% -------------------------------------------------------------------------
% Invoke a realization of the entire link (path loss and channel).
%  * Can invoke the realizations individually via lnk.realization_channel()
%  and lnk.realization_path_loss().
% -------------------------------------------------------------------------
lnk.realization();

% -------------------------------------------------------------------------
% Fetch channel matrix in a variety of ways.
%  * All three methods below are equivalent.
% -------------------------------------------------------------------------
H = lnk.channel_matrix_forward;
% H = lnk.channel_forward.get_channel_matrix();
% H = lnk.channel_forward.H;

% -------------------------------------------------------------------------
% Fetch the path loss in a variety of ways.
%  * L and G are related by: 1 / G^2 = L
% -------------------------------------------------------------------------
G = lnk.large_scale_gain_forward; % amplitude gain (linear)
L = lnk.path_loss_forward.get_attenuation(); % power loss (linear)

% -------------------------------------------------------------------------
% Fetch the large-scale SNR of the link (linear).
%  * SNR = Pt * G^2 / (N0 * B)
% -------------------------------------------------------------------------
snr = lnk.snr_forward;

% -------------------------------------------------------------------------
% Return a link budget.
%  * A struct containing some link budget values.
% -------------------------------------------------------------------------
budget = lnk.compute_link_budget();

% -------------------------------------------------------------------------
% Fetch the channel state information of the link.
% -------------------------------------------------------------------------
csi = lnk.compute_channel_state_information();

% -------------------------------------------------------------------------
% Set transmitter's precoder.
%  * Both are valid; the second is a shortcut.
% -------------------------------------------------------------------------
%F=(exp(-1i*pi*sin(pi/2)*[0:Nt-1])/Nt).'*ones(1,num_streams);
%dev_tx.transmitter.set_precoder(F);
%dev_tx.set_precoder(F);

% -------------------------------------------------------------------------
% Set receiver's combiner.
%  * Both are valid; the second is a shortcut.
% -------------------------------------------------------------------------
% dev_rx.receiver.set_combiner(W);
% dev_rx.set_combiner(W);

% -------------------------------------------------------------------------
% Another way to set the transmitter's precoder.
% -------------------------------------------------------------------------
%dev_tx.set_transmit_channel_state_information(csi);
%dev_tx.configure_transmitter('eigen');
steering_vector=exp(-1i*pi*sin(0)*[0:Nt-1])/Nt;
array_transmit_object.set_weights(steering_vector)
array_transmit_object.show_array_pattern();
% -------------------------------------------------------------------------
% Another way to set the receiver's combiner.
% -------------------------------------------------------------------------
%dev_rx.set_receive_channel_state_information(csi);
%dev_rx.configure_receiver('mmse');

% -------------------------------------------------------------------------
% Set transmit symbol.
%  * Both are valid; first is a shortcut.
% -------------------------------------------------------------------------
s_tx = randsrc(1,num_streams,[1+1i 1-1i -1+1i -1-1i]) ./ sqrt(num_streams);
dev_tx.set_transmit_symbol(s_tx);
% dev_tx.transmitter.set_transmit_symbol(s);

% -------------------------------------------------------------------------
% Compute the received signal (at the receive antennas plus noise).
%  * z is the signal vector plus noise
%  * y is the signal vector
%  * n is the noise vector
% -------------------------------------------------------------------------
[z,y,n] = lnk.compute_received_signal_forward();

% -------------------------------------------------------------------------
% Fetch the receive symbol.
%  * Both are valid; first is a shortcut.
% -------------------------------------------------------------------------
s_rx = dev_rx.s_rx;
% s_rx = dev_rx.receiver.receive_symbol;

% -------------------------------------------------------------------------
% Compare transmit and receive symbols.
% -------------------------------------------------------------------------
figure();
plot(s_tx,".b"); hold on;
plot(s_rx,".r");

% -------------------------------------------------------------------------
% Report the mutual information and symbol estimation error achieved on 
% the link.
%  * Is based on default transmitter and receiver configurations since they
%  have not been set.
% -------------------------------------------------------------------------
mi = lnk.report_mutual_information_forward();
disp(['M.I.: ' num2str(mi) ' bps/Hz']);

[err,nerr] = lnk.report_symbol_estimation_error_forward();
disp(['Norm. symb. est. error: ' num2str(10*log10(nerr)) ' dB']);
