import os,re
import commands


def scan():
    # only unix
    result = commands.getstatusoutput('/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s')
    result_list = {}
    count = 0
    for line in str(result[1]).split("\n"):
        line_list = line.split(' ')
        print line_list
        result_list[count] = sorted(set(line_list), key=line_list.index)
        if result_list[count][0] == '':
           result_list[count].remove('')
        count += 1
    return result_list

def strength_avg(result_list):
    num = 0
    count = 0
    for line in result_list:
        if not line == 0:
            num += int(result_list[line][2])
            count += 1
    return num / count

def strength_less(result_list):
    tmp = 100
    for line in result_list:
        if not line == 0:
            print result_list[line][2]
            if -1 * int(result_list[line][2]) < tmp:
                print 'call'
                tmp = -1 * int(result_list[line][2])
    return tmp

def strength_more(result_list):
    tmp = -1
    for line in result_list:
        if not line == 0:
            print result_list[line][2]
            if -1 * int(result_list[line][2]) > tmp:
                print 'call'
                tmp = -1 * int(result_list[line][2])
    return tmp


print strength_less(scan())
