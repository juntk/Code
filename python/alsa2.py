import alsaaudio as alsa
import struct
from pylab import *
import numpy as np

def avg(l):
    result = 0
    for i in l:
        result = result + i
    result = result / (len(l))
    return result;

print alsa.cards()

pay =512

dev = alsa.PCM(type=alsa.PCM_CAPTURE, mode=alsa.PCM_NORMAL)
dev.setformat(alsa.PCM_FORMAT_FLOAT_LE)
dev.setrate(8000)
dev.setchannels(1)
dev.setperiodsize(pay)
plt.ion()
freqList = np.fft.fftfreq(pay, d=1.0/8000)
while 1:
    l = []
    data = dev.read()
    d = struct.unpack("512L",data[1])
    for i in d:
        l.append(i/1000000000)
    d_ft = np.fft.fft(l)
    d_amp = [np.sqrt(c.real ** 2 + c.imag ** 2) for c in d_ft]
    plt.plot(d_amp)
    plt.axis([0, len(d_amp)/2, 0, 500])
    plt.draw()
    plt.clf()
    # handan
    wom_f = 0
    man_f = 0
    mavg =  avg(d_amp) + 30
    for i in d_amp[61:500]:
        if i > 50:
            wom_f = wom_f + i
        continue;
    for i in d_amp[5:60]:
        # men
        if i > 50:
            man_f = man_f + i
            continue;
    if man_f > wom_f:
        print "man"
    elif man_f < wom_f:
        print "woman"
    for i in d_amp[80:90]:
        # men
        if i > 200:
            print "docchi?"
            continue;

dev.close()

