import sys
import dbus, dbus.mainloop.glib
from gi.repository import GLib
from example_advertisement import Advertisement
from example_advertisement import register_ad_cb, register_ad_error_cb
from example_gatt_server import Service, Characteristic
from example_gatt_server import register_app_cb, register_app_error_cb
import socket
import time

BLUEZ_SERVICE_NAME =		   'org.bluez'
DBUS_OM_IFACE =				'org.freedesktop.DBus.ObjectManager'
LE_ADVERTISING_MANAGER_IFACE = 'org.bluez.LEAdvertisingManager1'
GATT_MANAGER_IFACE =		   'org.bluez.GattManager1'
GATT_CHRC_IFACE =			  'org.bluez.GattCharacteristic1'
UART_SERVICE_UUID =			'6e400001-b5a3-f393-e0a9-e50e24dcca9e'
UART_RX_CHARACTERISTIC_UUID =  '6e400002-b5a3-f393-e0a9-e50e24dcca9e'
UART_TX_CHARACTERISTIC_UUID =  '6e400003-b5a3-f393-e0a9-e50e24dcca9e'
LOCAL_NAME =				   'rpi-gatt-server'
mainloop = None
 

def BBB(obj):
	global send

	s = obj
	value1 = []
	value2 = []

	n = 0
	for c in s:
		if n <= 100:
			value1.append(dbus.Byte(c.encode()))
		else:
			value2.append(dbus.Byte(c.encode()))
		n = n + 1


	send.PropertiesChanged(GATT_CHRC_IFACE, {'Value': value1}, [])
	
	time.sleep(0.1)
	if n >= 100:
		send.PropertiesChanged(GATT_CHRC_IFACE, {'Value': value2}, [])

	# print(str(bytearray(value1).decode()))
	# print(str(bytearray(value2).decode()))

class TxCharacteristic(Characteristic):
	def __init__(self, bus, index, service):
		Characteristic.__init__(self, bus, index, UART_TX_CHARACTERISTIC_UUID,
								['notify'], service)
		self.notifying = False
		#GLib.io_add_watch(sys.stdin, GLib.IO_IN, self.on_console_input)
		global send
		send = self
 
	def on_console_input(self, fd, condition):
		s = fd.readline()
		if s.isspace():
			pass
		else:
			self.send_tx(s)
		return True
 
	def send_tx(self, s):
		if not self.notifying:
			return
		value = []
		for c in s:
			value.append(dbus.Byte(c.encode()))
		self.PropertiesChanged(GATT_CHRC_IFACE, {'Value': value}, [])
 
	def StartNotify(self):
		if self.notifying:
			return
		self.notifying = True
 
	def StopNotify(self):
		if not self.notifying:
			return
		self.notifying = False
 
class RxCharacteristic(Characteristic,object):
	def __init__(self, bus, index, service):
		Characteristic.__init__(self, bus, index, UART_RX_CHARACTERISTIC_UUID,
								['write'], service)
 
	def WriteValue(self, value, options):
		self.noStr = str(bytearray(value[0:5]).decode())
		# print(self.noStr)
		if self.noStr == "scan1":
			HOST = '127.0.0.1'
			PORT = 9999
			client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
			client_socket.connect((HOST, PORT))
			msg = 'scan1';
			data = msg.encode();
			length = len(data);
			client_socket.sendall(length.to_bytes(4, byteorder="little"));
			client_socket.sendall(data);
			data = client_socket.recv(4);
			length = int.from_bytes(data, "little");
			data = client_socket.recv(length);
			msg = data.decode();
			## print('Received from : ', msg);

			client_socket.close();
			
			BBB(msg)
		elif self.noStr == "scan2":
			HOST = '127.0.0.1'
			PORT = 9999
			client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
			client_socket.connect((HOST, PORT))
			msg = str(bytearray(value[0:len(value)-2]).decode()) 
			#'scan2';
			data = msg.encode();
			length = len(data);
			client_socket.sendall(length.to_bytes(4, byteorder="little"));
			client_socket.sendall(data);
			data = client_socket.recv(4);
			length = int.from_bytes(data, "little");
			data = client_socket.recv(length);
			msg = data.decode();
			## print('Received from : ', msg);

			client_socket.close();
			
			BBB(msg)
		elif self.noStr == "scan3":
			HOST = '127.0.0.1'
			PORT = 9999
			client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
			client_socket.connect((HOST, PORT))
			msg = 'scan3';
			data = msg.encode();
			length = len(data);
			client_socket.sendall(length.to_bytes(4, byteorder="little"));
			client_socket.sendall(data);
			data = client_socket.recv(4);
			length = int.from_bytes(data, "little");
			data = client_socket.recv(length);
			msg = data.decode();
			## print('Received from : ', msg);

			client_socket.close();
			
			BBB(msg)



class UartService(Service):
	def __init__(self, bus, index):
		Service.__init__(self, bus, index, UART_SERVICE_UUID, True)
		self.add_characteristic(TxCharacteristic(bus, 0, self))
		self.add_characteristic(RxCharacteristic(bus, 1, self))
 
class Application(dbus.service.Object):
	def __init__(self, bus):
		self.path = '/'
		self.services = []
		dbus.service.Object.__init__(self, bus, self.path)
 
	def get_path(self):
		return dbus.ObjectPath(self.path)
 
	def add_service(self, service):
		self.services.append(service)
 
	@dbus.service.method(DBUS_OM_IFACE, out_signature='a{oa{sa{sv}}}')
	def GetManagedObjects(self):
		response = {}
		for service in self.services:
			response[service.get_path()] = service.get_properties()
			chrcs = service.get_characteristics()
			for chrc in chrcs:
				response[chrc.get_path()] = chrc.get_properties()
		return response
 
class UartApplication(Application):
	def __init__(self, bus):
		Application.__init__(self, bus)
		self.add_service(UartService(bus, 0))
 
class UartAdvertisement(Advertisement):
	def __init__(self, bus, index):
		Advertisement.__init__(self, bus, index, 'peripheral')
		self.add_service_uuid(UART_SERVICE_UUID)
		self.add_local_name(LOCAL_NAME)
		self.include_tx_power = True
 
def find_adapter(bus):
	remote_om = dbus.Interface(bus.get_object(BLUEZ_SERVICE_NAME, '/'),
							   DBUS_OM_IFACE)
	objects = remote_om.GetManagedObjects()
	for o, props in objects.items():
		if LE_ADVERTISING_MANAGER_IFACE in props and GATT_MANAGER_IFACE in props:
			return o
		# print('Skip adapter:', o)
	return None
 
def main():
	global mainloop
	dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
	bus = dbus.SystemBus()
	adapter = find_adapter(bus)
	if not adapter:
		# print('BLE adapter not found')
		return
 
	service_manager = dbus.Interface(
								bus.get_object(BLUEZ_SERVICE_NAME, adapter),
								GATT_MANAGER_IFACE)
	ad_manager = dbus.Interface(bus.get_object(BLUEZ_SERVICE_NAME, adapter),
								LE_ADVERTISING_MANAGER_IFACE)
 
	app = UartApplication(bus)
	adv = UartAdvertisement(bus, 0)
 
	mainloop = GLib.MainLoop()
 
	service_manager.RegisterApplication(app.get_path(), {},
										reply_handler=register_app_cb,
										error_handler=register_app_error_cb)
	ad_manager.RegisterAdvertisement(adv.get_path(), {},
									 reply_handler=register_ad_cb,
									 error_handler=register_ad_error_cb)
	try:
		mainloop.run()
	except KeyboardInterrupt:
		adv.Release()
 
if __name__ == '__main__':
	main()