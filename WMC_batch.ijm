#@ File[](label="Select image files/folders", style="both", persist=false) paths
#@ String(label="File extension (eg. 'tif', leave empty to allow all files)", value="", persist=false) suffix
#@ String(label="Filter RegExp (will override extension check)", value="", persist=false) pattern
#@ BigDecimal(label="Artifact diameter for gaussian blurring", value=1.8, persist=false) g_size
#@ Boolean(label="Use separate output directory?", value=false, persist=false) use_outdir
#@ File(label="Output directory", value="", style="directory", persist=false) outdir
#@ BigDecimal(label="Rolling ball radius", value=12, persist=false) r_size
#@ BigDecimal(label="Noise tolerance level", value=20, persist=false) noise
#@ BigDecimal(label="Intensity seed for background", value=100, persist=false) low_seed
#@ BigDecimal(label="Intensity seed for foreground", value=2000, persist=false) high_seed
#@ BigDecimal(label="Prior probability for background", value=0.6, persist=false) low_bound
#@ BigDecimal(label="Prior probability for foreground", value=0.8, persist=false) high_bound
#@ BigDecimal(label="Min. std. tolerance level for foreground obj.", value=0.2, persist=false) min_std
#@ Boolean(label="Equalize image level", value=false, persist=false) equalize
#@ Boolean(label="Use paraboloid kernel for objects", value=false, persist=false) paraboloid
#@ Boolean(label="Quit afterwards", value=false, persist=false) quit

function stripExtension(path) {
	dotIndex = lastIndexOf(path, ".");
	if (dotIndex!=-1) {
		return substring(path, 0, dotIndex);
	} else {
		return path;
	}
}

function runWMCSegment(input, g_size, r_size, noise, low_seed, high_seed, low_bound, high_bound, min_std, equalize, paraboloid) {
	//Open file without popup
	run("Bio-Formats Windowless Importer", "open=[" + input + "]"); 

	//Do the WMC Segment
	if (!equalize && !paraboloid) 
		run("WMC Segment", "g_size=&g_size r_size=&r_size noise=&noise low_seed=&low_seed high_seed=&high_seed low_bound=&low_bound high_bound=&high_bound min_std=&min_std ");
	else if (equalize && !paraboloid) 
		run("WMC Segment", "g_size=&g_size r_size=&r_size noise=&noise low_seed=&low_seed high_seed=&high_seed low_bound=&low_bound high_bound=&high_bound min_std=&min_std is_equalize");
	else if (!equalize && paraboloid) 
		run("WMC Segment", "g_size=&g_size r_size=&r_size noise=&noise low_seed=&low_seed high_seed=&high_seed low_bound=&low_bound high_bound=&high_bound min_std=&min_std use_paraboloid");	
	else 
		run("WMC Segment", "g_size=&g_size r_size=&r_size noise=&noise low_seed=&low_seed high_seed=&high_seed low_bound=&low_bound high_bound=&high_bound min_std=&min_std is_equalize use_paraboloid");			

	//Determine output name
	dir = File.getParent(input);
	if(use_outdir) {
		dir = outdir;
	}
	fname = stripExtension(File.getName(input));
	ofname = dir + File.separator + fname + '_WMCMask.tiff';

	//Save and close
	saveAs("TIFF", ofname);
	run("Close All");
}

function processFile(file, fromFolder) {
	valid = true;
	if (pattern!="") {
		if (!matches(file, pattern)) {
			if(!fromFolder)
				print(file + " doesn't match " + pattern);
			valid = false;
		}			
	} else {
		if (suffix!="") {
			if (!endsWith(file, suffix)) {
				if(!fromFolder) 
					print(file + " doesn't end with " + suffix);
				valid = false;
			}
		}
	}
	if (valid) {
		print("Processing file " + file);
		runWMCSegment(file, g_size, r_size, noise, low_seed, high_seed, low_bound, high_bound, min_std, equalize, paraboloid);
	}
}

function processFolder(folder) {
	fileList = getFileList(folder);
	for (f=0; f<fileList.length; f++) {
		file = folder + File.separator + fileList[f];
        processFile(file, true);
    }
}


//MAIN

if(use_outdir) {
	if(!File.exists(outdir)) {
		exit("Directory " + outdir + " does not exist.");
	} else {
		print("Using " + outdir + " as output directory.");
	}
}

setBatchMode(true);
for (i=0; i<paths.length; i++) {
        path=paths[i];
        if (File.exists(path)) {
                if (File.isDirectory(path)) {
                        print("Processing directory " + path);
                        processFolder(path)
                } else {
                        processFile(path, false);	
                }
        } else {
        	print(path + " does not exist.");
        }
}
setBatchMode(false);

if (quit)
run("Quit");

