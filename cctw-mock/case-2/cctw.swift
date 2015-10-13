
import io;
import files;
import string;
import sys;

pars = argv("script");  // script
in_file = argp(1); 
in_entry = argv("in_entry"); // in h5_path
out_file = argv("o"); 
out_entry = argv("out_entry"); // out h5_path

fname = argv("m");
fn_s = argv("f");

fn = toint(fn_s);

app qsub(string line[])
{
  "qsub-block" line;
}

app (void o)
cctw(string directory, string jobname, string command[], int threads)
{
  "qsub-block" "-j" threads "--" directory jobname 
    command;
}

app (void o)
cctw_merge(string directory, string jobname, string a)
{
  "qsub-block" "-j" 1 directory jobname a;
}

S = 8; // Number of partial CCTWs
threads = 12;

cctw_zsh = "/home/wozniak/proj/d-e.test/nexus/bin/chess/cctw.zsh";

int A[];
foreach i in [0:S-1]
{
  subset_arg = "%i/%i"%(i,S);
  out_file_n = replace(out_file, ".nxs", "-%i.nxs"%i, 0);
  command = [ cctw_zsh, pars,
                        in_file, in_entry,
                        out_file_n, out_entry,
                        "-S", subset_arg,
                        "-j", toString(threads) ];
  
  void o = cctw(getenv("PWD"), "cctw-%i"%i,
                command,
                threads);
  o => A[i] = 0;
}

/*
wait deep (A)
{
  cctw_merge(getenv("PWD"), "cctw-merge.zsh", out_file);
}
*/
