import ssl
import sys
import json
import random
import time
import paho.mqtt.client as mqtt
import paho.mqtt.publish
import numpy
import datetime

# GENERAR MAC ADDRESS RANDOM
def randomMAC():
    
    return [ 
        random.randint(0x00, 0x99), 
        random.randint(0x00, 0x16), 
        random.randint(0x00, 0x3e),
        random.randint(0x00, 0x7f),
        random.randint(0x00, 0xff),
        random.randint(0x00, 0xff) ]

# IMPRIMIR MAC ADDRESS
def ImprimirMAC(mac):
    
    return ':'.join(map(lambda x: "%02x" % x, mac))

def on_connect(client, userdata, flags, rc):
    
    print('\n Publicador conectado: ')



def main():
    
    client = mqtt.Client("sambil", False)
    client.qos = 0
    client.connect(host='localhost')
    cpersonas = int(numpy.random.uniform(30,41))

    while(cpersonas>0):
        
        telefono = int(numpy.random.uniform(0,2))
        nsexo = int(numpy.random.uniform(0,2))
        edad = int(numpy.random.uniform(13,76)) #Desde 13 años hasta 75 anos
        cedula = int(numpy.random.uniform(5000000,50000001))

        if nsexo == 0:
            sexo = "Masculino"
        else:
            sexo = "Femenino"
    
        if telefono == 1:

            fechaE = datetime.datetime.now().replace(hour=0,minute=0,second=0)
            fechaE = fechaE + datetime.timedelta(hours=int(numpy.random.uniform(12,15)),minutes=int(numpy.random.uniform(0,60)), seconds=int(numpy.random.uniform(0,60)))
            sensore = int(numpy.random.uniform(1,9))
            sensors = int(numpy.random.uniform(1,9))

            macAddress = ImprimirMAC(randomMAC())
            ctiendas = int(numpy.random.uniform(0,6))
            tiendas = []
            hentrada = fechaE
            hsalida = fechaE

            while(ctiendas>0):
                
                hentrada = hsalida + datetime.timedelta(minutes=int(numpy.random.uniform(5,31)))
                timestampStr1 = hentrada.strftime("%H:%M:%S.%f - %b %d %Y")
                idtienda = int(numpy.random.uniform(1,6))
                rcompra = int(numpy.random.uniform(0,2))
                
                if rcompra == 0:
                    idcompra = None
                    montocompra = None
                else:
                    idcompra = int(numpy.random.uniform(1,1001))
                    montocompra = int(numpy.random.uniform(5000,10001))

                hsalida = hentrada + datetime.timedelta(minutes=int(numpy.random.uniform(30,61)))
                timestampStr2 = hsalida.strftime("%H:%M:%S.%f - %b %d %Y")
                
                objeto = {'idtienda':idtienda,'horae':timestampStr1,'idcompra':idcompra,'montocompra':montocompra, 'horas':timestampStr2}
                tiendas.append(objeto)
                ctiendas-=1

            tmesa = 0
            rmesa = int(numpy.random.uniform(0,2))
            
            if rmesa == 1:
                tmesa = int(numpy.random.uniform(30,91))
                nmesa = int(numpy.random.uniform(1,6))
                payloadmesa = {
                    "macaddress": str(macAddress),
                    "tiempo": str(tmesa),
                    "mesa": int(nmesa),
                }
                client.publish('sambil/admin/mesas',json.dumps(payloadmesa),qos=0)
                print("Mesa: ")
                print(payloadmesa)
            
            fechaS = hsalida + datetime.timedelta(minutes=(tmesa + int(numpy.random.uniform(30,61))))

        if telefono == 0:
            
            macAddress = None
            tiendas = None
            fechaE = None
            fechaS = None
            sensore = -1
            sensors = -1
            tmesa = -1

            tiendas = []
            ctiendas = int(numpy.random.uniform(0,6))

            while(ctiendas>0):
                
                idtienda = int(numpy.random.uniform(1,6))
                rcompra = int(numpy.random.uniform(0,2))
                if rcompra == 1:
                    idcompra = int(numpy.random.uniform(1,1001))
                    montocompra = int(numpy.random.uniform(5000,10001))
                    timestampStr1 = None
                    timestampStr2 = None
                    objeto = {'idtienda':idtienda,'horae':timestampStr1,'idcompra':idcompra,'montocompra':montocompra, 'horas':timestampStr2}
                    tiendas.append(objeto)
                else:
                    idcompra = None
                    montocompra = None
                    timestampStr1 = None
                    timestampStr2 = None
                    objeto = {'idtienda':idtienda,'horae':timestampStr1,'idcompra':idcompra,'montocompra':montocompra, 'horas':timestampStr2}
                    tiendas.append(objeto)
  
                ctiendas-=1

            rmesa = int(numpy.random.uniform(0,2))
            if rmesa == 1:
                nmesa = int(numpy.random.uniform(1,6))
                payload = {
                    "macaddress": str(macAddress),
                    "tiempo": str(tmesa),
                    "mesa": int(nmesa),
                }
                client.publish('sambil/admin/mesas',json.dumps(payload),qos=0)
                print("Mesa: ")
                print(payload)

        payload = {
            "sensore": int(sensore),
            "horae": str(fechaE),
            "macaddress": str(macAddress),
            "sexo": str(sexo),
            "edad": int(edad),
            "tiendas": tiendas,
            "sensors": int(sensors),
            "horas": str(fechaS),
            "cedula": int(cedula),
        }
        
        client.publish('sambil/admin/entradas',json.dumps(payload),qos=0)
        cpersonas-=1
        print(payload)
        print('------------------------------')
        time.sleep(0.5)

if __name__ == '__main__':
    main()
    sys.exit(0)