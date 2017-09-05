import sys
import subprocess
import optparse

def openCount():
    return raw_input('How many tabs?: ')

def main ():
    parser = optparse.OptionParser('usage%prog ' + '-u <url list>')
    parser.add_option('-u', dest='listLoc', type='string', help='specifies url list')
    (options, args) = parser.parse_args()
    file = open(options.listLoc, 'r')
    sdata = file.readlines()
    data = [data.replace('\n', '') for data in sdata]
    data = list(set(data))
    length = len(data)
    lineReader = 0
    # eventually filter out the duplicate urls

    #Apologize for this code.. haha I'm so used to 'loop do'

    while True:
        count = openCount()
        cur = lineReader
        lineReader += int(count)
        print str(lineReader)+'/'+str(length)
        for x in xrange(len(data[cur:lineReader])):
            subprocess.call("chromium-browser " + data[cur+x], shell=True)
        if cur>length-1:
            print "Finished"
            exit()

if __name__ == '__main__':
    main()
