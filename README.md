# wmc_imagej

**Work in progress, feel free to edit**

## Installation

**Make sure you use [Fiji](https://fiji.sc/), the ImageJ that ISSC installs may not work!**

* Install `WMC Segment` in ImageJ

  Download [DImageSVN_.jar](https://github.com/lacdr-tox/cellprofiler-plugins/blob/master/ij_plugins/DImageSVN_.jar) and place it in your ImageJ plugin directory. You should be able to use *WMC Segment* from *Plugins > Analysis > Segmentation > WMC Segment*. You can use this to determine the optimal settings for batch mode.

* Download [`WMC_batch.ijm`](https://github.com/lacdr-tox/wmc_imagej/raw/master/WMC_batch.ijm) by saving it as `WMC_batch.ijm` (make sure it ends with `.ijm` and not `.txt`, it doesn't matter where you save it).

## Usage

The `WMC_batch.ijm` file cannot be installed as a macro, but must be run as script, which can be done in the following ways:

* **(Recommended)** Using the macro editor
  * Open ImageJ and go to *Plugins > Macros > Edit...* (or use the `[` keyboard shortcut).
  * Open the `WMC_batch.ijm` file and click *Run* (bottom left)
* Using the commandline:  
  Use the syntax described [here](https://imagej.net/Scripting_Headless) (**NB** running with `--headless` doesn't work since `WMCSegment` requires a gui). Example uses:

      ~/opt/Fiji.app/ImageJ-linux64 --run /home/gerhard/WMC_batch.ijm 'paths="/data/gerhard/example_dir",suffix="tif",quit=true'
      
  or for multi files/folders

      ~/opt/Fiji.app/ImageJ-linux64 --run /home/gerhard/WMC_batch.ijm 'paths=["/data/gerhard/example_dir/test1.tif","/data/gerhard/example_dir/test2.tif"],quit=true'
      
  The `quit=true` option is to quit ImageJ after the job is done.
  
  **Notes:***
  * The output folder (if set) does not copy the directory structure of the input folders, everything will be dumped in the same output folder, so files with the same names will probably be overwritten.
