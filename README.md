# wmc_imagej

**Work in progress, feel free to edit**

## Install WMCSegment in ImageJ

Download [DImageSVN_.jar](https://github.com/lacdr-tox/cellprofiler-plugins/blob/master/ij_plugins/DImageSVN_.jar) and place it in your ImageJ plugin directory. You should be able to use *WMC Segment* from *Plugins > Analysis > Segmentation > WMC Segment*

## Use the ImageJ script

Cannot be installed as macro, but must be run as script (could be that it doesn't work with ImageJ1, use ImageJ2 (included in Fiji)):

* Using the script editor: Use `[` to open the script editor and run
* Using the commandline: Use the syntax as described in [Scripting Headless](https://imagej.net/Scripting_Headless) (although, running with `--headless` doesn't work, `WMCSegment` requires a gui (something to fix later)). Example uses:

      ~/opt/Fiji.app/ImageJ-linux64 --run 'paths="/data/gerhard/example_dir",suffix="tif",quit=true'
      
  or for multi files/folders

      ~/opt/Fiji.app/ImageJ-linux64 --run 'paths=["/data/gerhard/example_dir/test1.tif","/data/gerhard/example_dir/test2.tif"],quit=true'
      
  The `quit=true` option is to quit ImageJ after the job is done.
