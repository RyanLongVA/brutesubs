import sys
import optparse
def main():
    parser = optparse.OptionParser('usage%prog ' + '-m <massdns file> -o <output file>')
    parser.add_option('-m', dest='inputLoc', type='string', help='specify the input massdns file')
    parser.add_option('-o', dest='outputLoc', type='string', help='specify the output location')
    (options, args) = parser.parse_args()
    with open(options.inputLoc) as f:
        file = open(options.outputLoc, 'w+')
        for line in f:
            line = line.split('\t')
            curUrl = line[0]
            if curUrl.endswith('.'):
                curUrl = curUrl[:-1]
            file.write('https://'+curUrl+'\n')
if __name__ == '__main__':
    main()
