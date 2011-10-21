import alsaaudio as alsa

#pcm = alsa.PCM(type=alsa.PCM_CAPTURE)
pcm = alsa.PCM()


while(1):
    #data = pcm.read()
    #data_avg = data[1]
    #print (data)
    pcm.write("tttt");
pcm.close()
