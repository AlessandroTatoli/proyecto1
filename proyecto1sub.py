import ssl
import sys
import psycopg2
import paho.mqtt.client as mqtt
import json

conn = psycopg2.connect(host = 'localhost', user = 'postgres', password = '3098', dbname = 'proyecto1') # CONECTARSE A LA BASE DE DATOS

def doQuery(a):
    
    # INSERTAR USUARIOS
    cur = conn.cursor()
    sql = 'INSERT INTO usuarios(cedula, sexo, edad, macaddress) VALUES (%s, %s, %s, %s);'
    cur.execute(sql, (a["cedula"], a["sexo"], a["edad"], a["macaddress"],))
    conn.commit()

    # INSERTAR ENTRADAS
    cur = conn.cursor()
    sql = 'INSERT INTO entradas(camaraentrada, camarasalida, horaentrada, horasalida, macaddress) VALUES (%s, %s, %s, %s. %s);'
    cur.execute(sql, (a["sensore"], a["sensors"], a["horae"], a["horas"],a["macaddress"],))
    conn.commit()

    # INSERTAR TIENDAS
    if len(a["tiendas"]) != 0:
        for x in a["tiendas"]:
            print(x)
            cur = conn.cursor()
            sql = 'INSERT INTO tiendausuarios(horaentrada, horasalida, macaddress, tiendaid) VALUES (%s, %s, %s, %s);'
            cur.execute(sql, (x["horae"], x["horas"], a["macaddress"], x["idtienda"],))
            conn.commit()

            # VERFICAR SI REALIZO COMPRA
            if(x["idcompra"] != None):
                cur = conn.cursor()
                sql = 'INSERT INTO compras(tiendaid, usuariomacaddress, itemid, itemmonto, usuariocedula) VALUES (%s, %s, %s, %s, %s);'
                cur.execute(sql, (x["idtienda"], a["macaddress"], x["idcompra"], x["montocompra"], a["cedula"]))
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