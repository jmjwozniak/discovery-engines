
/**
   MERGE-ALL.SWIFT

   Run this from the top-level directory.
*/

import files;
import io;
import string;
import sys;

app (file background) merge_tiffs_background(string directory,
                                             string arguments[])
{
  "/home/wozniak/proj/d-e/bin/merge-tiffs.sh" background
    "-d" directory arguments;
}

app merge_tiffs(string directory, file background, string arguments[])
{
  "/home/wozniak/proj/d-e/bin/merge-tiffs.sh" background
    "-d" directory arguments;
}

main
{
  list = argv("list");
  data = argv("data");
  printf("merge-all.swift in %s", data);

  string work[] = split(read(input(list)), "\n");

  // string matt[] =
  //   [
  //     // "lsmo34_090k",
  //                  // "lsmo39_130k", (broken - sent email to Ray)
  //     //             "lsmo42_150k",
  //     //            "lsmo48_090k"
  //                 "lsmo56_100k",
  //                 "lsmo52_195k",
  //                 "lsmo50_220k"
  //    ];

  foreach directory in work
  {
    if (directory != "")
    {
      file background<data/directory/"darkbeg.nxs"> =
      merge_tiffs_background(directory, split("-p darkbeg -c", " "));
      merge_tiffs(directory, background,
                  split("-p fb1scan -b darkbeg -o 0 -s 0.1 -r -c", " "));
      merge_tiffs(directory, background,
                  split("-p ff1scan -b darkbeg -o 0 -s 0.1 -c", " "));
      merge_tiffs(directory, background,
                  split("-p ff2scan -b darkbeg -o 0 -s 0.1 -c", " "));
      merge_tiffs(directory, background,
                  split("-p fb2scan -b darkbeg -o 0 -s 0.1 -r -c", " "));
      merge_tiffs(directory, background,
                  split("-p sfscan -b darkbeg -o 0 -s 0.1 -c", " "));
      merge_tiffs(directory, background,
                  split("-p sbscan -b darkbeg -o 0 -s 0.1 -r -c", " "));
      merge_tiffs(directory, background,
                  split("-p ubfscan -b darkbeg -o 0 -s 0.1 -c", " "));
      merge_tiffs(directory, background,
                  split("-p ubbscan -b darkbeg -o 0 -s 0.1 -r -c", " "));
    }
  }
}
