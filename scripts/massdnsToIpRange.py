import sys
import optparse
def main():
    parser = optparse.OptionParser('usage%prog ' + '-m <massdns file> -o <output file>' + '-s <specified scope')
    parser.add_option('-m', dest='inputLoc', type='string', help='specify the input massdns file')
    parser.add_option('-o', dest='outputLoc', type='string', help='specify the output location')
    parser.add_option('-s', dest='scope', type='string', help='specify the scope (string to search urls, you might want to use .com/.net/etc because you might be scanning out of scope in some cases)')
    (options, args) = parser.parse_args()
    with open(options.inputLoc) as f:
        file = open(options.outputLoc, 'w+')
        for line in f:
            try:
                line = line.split('\t')
                curUrl = line[0]
                if curUrl.endswith('.'):
                    curUrl = curUrl[:-1]
                print line
                if (options.scope in curUrl) & (line[3] != 'CNAME'):
                    file.write(line[4])
            except IndexError:
                print line
                print "Length is too short"
                break
if __name__ == '__main__':
    main()
