import Image

def list_avg(lst):
    tmp = 0
    for i in range(len(lst)):
        tmp += lst[i]
    return tmp / len(lst)

def cell_9(path):
    try:
        img = Image.open(path)
        data = img.getdata()
        cell_n = 3
        cell_w = img.size[0] / cell_n
        cell_h = img.size[1] / cell_n
        # initialize multi list
        cell = cell_n*[cell_n*[0]]

        for i_w in range(cell_n):
            for i_h in range(cell_n):
                pixel = []
                for cell_iw in range(cell_w * i_w, cell_w * (i_w + 1)):
                    for cell_ih in range(cell_h * i_h, cell_h * (i_h + 1)):
                        pixel.append(img.getpixel((cell_iw,cell_ih)))
                # average
                r_sum = 0
                g_sum = 0
                b_sum = 0
                for i in pixel:
                    r_sum += i[0]
                    g_sum += i[1]
                    b_sum += i[2]
                r_avg = r_sum / len(pixel)
                g_avg = g_sum / len(pixel)
                b_avg = b_sum / len(pixel)
                # push
                tp = (r_avg, g_avg, b_avg)
                cell[i_w][i_h] = tp
        print cell

        # put pixel
        img_out = Image.new(img.mode, (3,3))
        for i_w in range(cell_n):
            for i_h in range(cell_n):
                img_out.putpixel((i_w, i_h), cell[i_w][i_h])
        img_out.save('out.jpg')

        f = open('dump','w')
        f.write(str(cell))
        f.close()
    except IOError:
        print 'IOERROR: ', path
        return

cell_9('smp2.jpg')
