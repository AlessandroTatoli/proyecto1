import ssl
import sys
import psycopg2
import paho.mqtt.client as mqtt
import json

conn = psycopg2.connect(host = 'localhost', user = 'postgres', password = '3098', dbname = 'proyecto1') # CONECTARSE A LA BASE DE DATOS

def doQuery(a):
    
    # INSERTAR EN TABLA MESAS_FERIA 
    cur = conn.cursor()
    sql = 'INSERT INTO mesasferias(usuariomacaddress, minutos, mesa) VALUES (%s, %s, %s);'
    cur.execute(sql, (a["macaddress"], a["tiempo"], a["mesa"]))
    conn.commit()

    # ACTUALIZAR MESA NO DISPONIBLE
    cur = conn.cursor()
    sql = 'UPDATE mesas SET disponibilidad = false WHERE sensorm = %s;'
    cur.execute(sql, (a["mesa"]))
    conn.commit()

def on_connect(client, userdata, flags, rc):

    print('\n Bienvenido al apartado de Feria del Centro Comercial Inteligente Sambil')
    print('\n Subscriptor conectado: (%s)' % client._client_id)
    client.subscribe(topic='sambil/#', qos = 0)

def on_message(client, userdata, message):
    
    a = json.loads(message.payload)
    print(a) 
    print('------------------------------')
    doQuery(a)

def main():
    
    client = mqtt.Client()
    client.on_connect = on_connect
    client.message_callback_add('sambil/admin/mesas', on_message)
    client.connect(host='localhost') 
    client.loop_forever()

if __name__ == '__main__':
    
    main()
    sys.exit(0)