suffix = ".tif";
input = getDirectory("Choose an Input Directory");

run("Set Measurements...", "area mean redirect=None decimal=3");

processFolder(input);

output = getDirectory("Output Directory");
selectWindow("Summary");
Table.save(output + "combined_summary.csv");
run("Clear Results");
selectWindow("Summary");
run("Close");

function processFolder(input) {
	list = getFileList(input);
	for (i=0; i<list.length; i++) {
	    if(File.isDirectory(list[i]))
			processFolder(""+input+list[i]);
	    if(endsWith(list[i],suffix))
			processFile(input,list[i]);
	}
}

function processFile(input, file) {
	run("Close All");
	closeRoiManager();
	closeThresholdWindow();

	run("Bio-Formats Importer", "open=[" + input + file + "] autoscale color_mode=Default view=Hyperstack stack_order=XYCZT");
	a = getTitle();

	// --- force this into a proper 2-channel hyperstack ---
	run("Stack to Hyperstack...", "order=xyzct channels=2 slices=1 frames=1 display=Color");

	Dialog.create("Assign Channels - " + file);
	Dialog.addNumber("DAPI is channel #:", 1);
	Dialog.addNumber("NeuN is channel #:", 2);
	Dialog.show();
	dapiSlice = Dialog.getNumber();
	neunSlice = Dialog.getNumber();

	setTool("polygon");
	roiCount = 0;
	while (roiCount == 0) {
		waitForUser("Draw the PrL ROI (polygon tool) on " + file + ", press 't' to add it to the ROI Manager, then click OK.");
		if (isOpen("ROI Manager")) {
			roiCount = roiManager("count");
		} else {
			roiCount = 0;
		}
		if (roiCount == 0) {
			showMessage("No ROI Detected", "No ROI was added to the Manager. Please draw the ROI and press 't' before clicking OK.");
			setTool("polygon");
		}
	}

	// --- split into separate channel windows ---
	selectWindow(a);
	run("Split Channels");

	selectWindow("C" + dapiSlice + "-" + a);
	rename("DAPI_channel");

	selectWindow("C" + neunSlice + "-" + a);
	rename("NeuN_channel");

	// --- threshold DAPI (Huang, tightened), computed on ROI pixels only ---
	selectWindow("DAPI_channel");
	roiManager("Select", 0);
	setAutoThreshold("Huang dark");
	getThreshold(lower, upper);
	lower = lower + 5;
	setThreshold(lower, upper);
	run("Convert to Mask");
	run("Select None");
	rename("DAPI_mask");
	closeThresholdWindow();

	// --- threshold NeuN (Huang, tightened), computed on ROI pixels only ---
	selectWindow("NeuN_channel");
	roiManager("Select", 0);
	setAutoThreshold("Huang dark");
	getThreshold(lower, upper);
	lower = lower + 5;
	setThreshold(lower, upper);
	run("Convert to Mask");
	run("Select None");
	rename("NeuN_mask");
	closeThresholdWindow();

	selectWindow("DAPI_mask");
	roiManager("Select", 0);
	run("Clear Outside");
	run("Select None");

	selectWindow("NeuN_mask");
	roiManager("Select", 0);
	run("Clear Outside");
	run("Select None");

	// --- dilate NeuN mask to compensate for perinuclear (not nuclear) labeling ---
	selectWindow("NeuN_mask");
	run("Dilate");
	run("Dilate");

	run("Duplicate...", "title=NeuN_mask_dilated");

	// --- Neuronal: DAPI nuclei overlapping (dilated) NeuN signal ---
	imageCalculator("AND create", "NeuN_mask_dilated","DAPI_mask");
	rename("Neuronal_mask");
	run("Watershed");
	roiManager("Select", 0);
	run("Analyze Particles...", "size=20-1000 display summarize");
	run("Select None");
	tagRow(file, "Neuronal");

	// --- NonNeuronal: DAPI nuclei NOT overlapping (dilated) NeuN signal ---
	// NOTE: uses the same dilated mask as the Neuronal step (inverted here),
	// so a nucleus can't fall into the gap between the undilated and dilated
	// boundary and get miscounted in both branches (or neither).
	selectWindow("NeuN_mask_dilated");
	run("Invert");
	imageCalculator("AND create", "NeuN_mask_dilated","DAPI_mask");
	rename("NonNeuronal_mask");
	run("Watershed");
	roiManager("Select", 0);
	run("Analyze Particles...", "size=20-1000 display summarize");
	run("Select None");
	tagRow(file, "NonNeuronal");

	// --- TotalDAPI: all nuclei, independent of NeuN ---
	selectWindow("DAPI_mask");
	run("Watershed");
	roiManager("Select", 0);
	run("Analyze Particles...", "size=20-1000 display summarize");
	run("Select None");
	tagRow(file, "TotalDAPI");

	run("Close All");
	closeRoiManager();
	closeThresholdWindow();
}

function closeRoiManager() {
	if (isOpen("ROI Manager")) {
		selectWindow("ROI Manager");
		run("Close");
	}
}

function closeThresholdWindow() {
	if (isOpen("Threshold")) {
		selectWindow("Threshold");
		run("Close");
	}
}

function tagRow(imageName, rowType) {
	selectWindow("Summary");
	rowIndex = Table.size - 1;
	Table.set("Image", rowIndex, imageName);
	Table.set("Type", rowIndex, rowType);
	Table.set("Label", rowIndex, imageName + " - " + rowType);
	Table.update;
}
