import cv2
import albumentations as A
import os
import face_recognition

#Define augmentor options
transform = A.augmentor = A.Compose([A.RandomCrop(width=450, height=450), 
                         A.HorizontalFlip(p=0.5), 
                         A.RandomBrightnessContrast(p=0.2),
                         A.RandomGamma(p=0.2), 
                         A.RGBShift(p=0.2), 
                         A.VerticalFlip(p=0.5)], 
                       bbox_params=A.BboxParams(format='pascal_voc', 
                                                  label_fields=[]))

folder = input()


for file in os.listdir(f'./images/{folder}'):
        name, formatt = file.split('.')

        #Load and process image
        img = cv2.imread(f'./images/{folder}/{file}')
        img = cv2.resize(img, [450,450])
        cv2.imwrite(f'./images/{folder}/{file}', img)

        #Get face locations in order
        face_loc = list(face_recognition.face_locations(img)[0])
        face_loc = list(map(int, face_loc))
        y1,x2,y2,x1 = face_loc[0], face_loc[1],face_loc[2],face_loc[3],
        face_loc_ord = [[x1,y1,x2,y2]] 
            
        #Augmentation
        i = 1
        while i < 4:
            face_loc_aug = []
            list_images = [img]
            write = True
         
            #Get face augmention and face location
            augmentation = transform(image=img, bboxes=face_loc_ord)['image']
            face_loc_aug = face_recognition.face_locations(augmentation)

            #chek that is not repited
            for mat in list_images:
                if (augmentation == mat).all():
                   write = False 

            #Write the imatge
            if write == True and face_loc_aug != []:
                i += 1
                cv2.imwrite(f'./images/{folder}/{name}{i}.jpg', augmentation)
                list_images.append(augmentation)