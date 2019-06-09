import ssl
import sys
import paho.mqtt.client as mqtt
import json
import psycopg2
import numpy
import time
import pandas

conn = psycopg2.connect(host = 'localhost', user = 'postgres', password = 'gilberto', dbname = 'pruebas') # CONECTARSE A LA BASE DE DATOS

def doQuery(a):
    
    # INSERTAR USUARIOS
    cur = conn.cursor()
    sql = 'INSERT INTO usuarios(cedula, sexo, edad, macaddress) VALUES (%s, %s, %s, %s);'
    cur.execute(sql, (a["cedula"], a["sexo"], a["edad"], a["macaddress"],))
    conn.commit()

    # INSERTAR ENTRADAS
    cur = conn.cursor()
    sql = 'INSERT INTO entradas(camaraentrada, camarasalida, horaentrada, horasalida, macaddress) VALUES (%s, %s, %s, %s, %s);'
    cur.execute(sql, (a["sensore"], a["sensors"], a["horae"], a["horas"], a["macaddress"],))
    conn.commit()
                                   
    # INSERTAR USUARIOS QUE ENTREN A LAS TIENDAS
    if len(a["tiendas"]) != 0:
        for x in a["tiendas"]:
            print(x)
            cur = conn.cursor()
            sql = 'INSERT INTO tiendausuarios(horaentrada, horasalida, macaddress, tiendaid) VALUES (%s, %s, %s, %s);'
            cur.execute(sql, (x["horae"], x["horas"], a["macaddress"], x["idtienda"],))
            conn.commit()

            if(x["idcompra"] != None):
                # SE RETORNA LA HORA DE ENTRADA AL CC DE LA PERSONA QUE COMPRA
                cur = conn.cursor()
                cur.callproc('registrar_venta', (x["idtienda"], a["macaddress"], x["idcompra"], x["montocompra"]))
                row = cur.fetchone()
                print("Hora de Entrada: ",row)

                # INSERTAR COMPRAS REALIZADAS
                cur = conn.cursor()
                sql = 'INSERT INTO compras(comprastiendaid, comprasusuariomacaddress, itemid, itemmonto, usuariocedula) VALUES (%s, %s, %s, %s, %s);'
                cur.execute(sql, (x["idtienda"], a["macaddress"], x["idcompra"], x["montocompra"], a["cedula"],))
                conn.commit()

def on_connect(client, userdata, flags, rc):

    print('\n Bienvenido al centro comercial inteligente Sambil')
    print('\n Subscriptor conectado: (%s)' % client._client_id)
    client.subscribe(topic='sambil/#', qos = 0)

def on_message(client, userdata, message):
    
    a = json.loads(message.payload)
    #print(a) 
    print('------------------------------')
    doQuery(a)

def main():
    
    client = mqtt.Client()
    client.on_connect = on_connect
    client.message_callback_add('sambil/admin/entradas', on_message)
    client.connect(host='localhost') 
    client.loop_forever()

if __name__ == '__main__':
    
    main()
    sys.exit(0)