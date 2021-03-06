
# MK-LINKS
# Creates directories and links in APS FS that point back to DAQ

import os, stat, shutil, sys

class mk_links:

    def __init__(self):
        perms = stat.S_IRUSR | stat.S_IWUSR | stat.S_IXUSR | \
                stat.S_IRGRP | stat.S_IWGRP | stat.S_IXGRP
    
    def usage(self):
        print "usage: <source directory (DAQ)> " + \
                     "<destination directory (APS)>"

    def mk_ups(self, n):
        result = ""
        for i in range(0,n-1):
            result = result + "../"
        return result

    def go(self, src, dst):
        for root,dirs,files in os.walk(src, followlinks=True):
            # print "root:", root
            tokens = root.split("/")
            #  print tokens
            n = len(tokens)
            tokens = tokens[7:n]
            # print tokens
            subpath = "/".join(tokens)
            newdir = dst+"/rosenkranz-311-1/"+subpath
            # print "newdir:",newdir
            if not os.path.exists(newdir):
                print "mkdir:",newdir
                os.mkdir(newdir)
                os.chmod(newdir, self.perms)
            self.copy_files(files, tokens, n)

    def copy_files(self, files, tokens, n):
        for f in files:
            # print "f:",f
            prefix = self.mk_ups(n-4)
            # print prefix
            subpath = "/".join(tokens)
            source    = prefix+"daq/current/a2/rosenkranz-311-1/"+subpath+"/"+f
            copy_name = dst+"/rosenkranz-311-1/"+subpath+"/"+f
            if f.endswith(".nxs"):
                if not os.path.isfile(copy_name):
                    print ("cp " + source + "\n   " + copy_name)
                    shutil.copyfile(source, copy_name)
                    os.chmod(copy_name, perms)
            else:
                if not os.path.islink(copy_name):
                    print ("ln " + source + "\n   " + copy_name)
                    os.symlink(source, copy_name)
                
if __name__ == "__main__":
    if len(sys.argv) != 3:
        usage()
        sys.exit(1)
    src = sys.argv[1]
    dst = sys.argv[2]
    mk_links().go(src,dst)
