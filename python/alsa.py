import alsaaudio as alsa
import struct
from pylab import *

def avg(l):
    result = 0
    for i in l:
        result = result + i
    result = result / (len(l))
    return result;

print alsa.cards()

dev = alsa.PCM(type=alsa.PCM_CAPTURE, mode=alsa.PCM_NORMAL)
dev.setformat(alsa.PCM_FORMAT_FLOAT_LE)
dev.setchannels(1)
dev.setperiodsize(128)
plt.ion()
while 1:
    l = []
    for i in range(60):
        data = dev.read()
        d = struct.unpack("128L",data[1])
        l.append(((avg(d)-1800000000)/10000000)*1.5)
    #data = dev.read()
    #d = struct.unpack("128L",data[1])
    #print len(d),d
    plt.plot(range(len(l)),l)
    plt.axis([0,len(l),0,60])
    plt.draw()
    plt.clf()

dev.close()

