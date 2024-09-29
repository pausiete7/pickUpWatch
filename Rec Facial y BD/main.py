from dotenv import load_dotenv
load_dotenv()

import cv2
import os
import time
import asyncio
import threading
from promisio import promisify
from simple_facerec import SimpleFacerec
from supabase import create_client, Client

url: str = os.getenv("SUPABASE_URL")
key: str = os.getenv("SUPABASE_TOKEN")
supabase: Client = create_client(url, key)

updates_ids = []
detener_timer = False



@promisify
async def push_log(id_familiar, id_niño):
    ts = int(time.time() * 1000)
    supabase.table('logs').insert({'id_familiares': id_familiar, 'id_niño': id_niño, 'time': ts}).execute()

@promisify
async def show_video(frame, z: zip):
    for face_loc, name in z:
        y1,x2,y2,x1 = face_loc[0],face_loc[1],face_loc[2],face_loc[3]
        cv2.putText(frame, name, (x1,y1-10), cv2.FONT_HERSHEY_DUPLEX, 1, (0,0, 200) if (name == 'desconocido') else (0,200,0),2)
        cv2.rectangle(frame, (x1,y1), (x2,y2), (0,0, 200) if (name == 'desconocido') else (0,200,0), 4)
    
    cv2.imshow('Frame', frame)

def timer(timer_runs):
    while timer_runs.is_set():
        updates_ids.clear()
        time.sleep(3600)

async def start(): 
    #Get ids from db
    ids = dict()
    familiares = supabase.table("familiares").select('*').execute()
    for familiar in familiares.data:
        ids[familiar['nombre']] = [familiar['id'], familiar['niño']]
    #Load library and model and cam
    sfr = SimpleFacerec()
    sfr.load_encoding_images("images/")
    cap = cv2.VideoCapture(0)

    detected_faces = {}
   
    tick = 0

    while True:
        ret, frame = cap.read()

        # Detect faces
        face_location, face_names =sfr.detect_known_faces(frame)
        
        # filter face_names to remove 'desconocido'

        video_promise = show_video(frame, zip(face_location, face_names))
        face_names = [name for name in face_names if name != 'desconocido']
        db_promises = []

        for name in face_names:
            # check if name is a key in detected_faces
            if name not in detected_faces.copy():
                detected_faces[name] = tick
        
        for name, t in detected_faces.copy().items():
            if name not in face_names:
                detected_faces.pop(name)
            
            if tick-t == 10:
                id_familiar = ids[name][0]
                id_niño = ids[name][1]
                if id_familiar not in updates_ids:
                    db_promises.append(push_log(id_familiar, id_niño))
                    updates_ids.append(id_familiar)

        await video_promise
        key = cv2.waitKey(1)

        if key == 27:
            cap.release()
            cv2.destroyAllWindows()
            
            return None
        
        tick += 1

timer_runs = threading.Event()
timer_runs.set()
t = threading.Thread(target=timer, args=(timer_runs,))
t.start()
loop = asyncio.get_event_loop()
loop.run_until_complete(start())
timer_runs.clear()
exit(1)
