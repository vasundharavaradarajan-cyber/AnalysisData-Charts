suffix = ".tif";
input = getDirectory("Choose an Input Directory");
run("Set Measurements...", "area mean redirect=None decimal=3");
processFolder(input);
output = getDirectory("Output Directory");
selectWindow("Summary");
Table.save(output + "combined_summary_GFAP.csv");
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
	// --- force into a proper 2-channel hyperstack ---
	run("Stack to Hyperstack...", "order=xyzct channels=2 slices=1 frames=1 display=Color");
	Dialog.create("Assign Channels - " + file);
	Dialog.addNumber("DAPI is channel #:", 1);
	Dialog.addNumber("GFAP is channel #:", 2);
	Dialog.show();
	dapiSlice = Dialog.getNumber();
	gfapSlice = Dialog.getNumber();
	// --- manual ROI step ---
	setTool("polygon");
	roiCount = 0;
	while (roiCount == 0) {
		waitForUser("Draw the CA1 ROI (polygon tool) on " + file + ", press 't' to add it to the ROI Manager, then click OK.");
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
	selectWindow("C" + gfapSlice + "-" + a);
	rename("GFAP_channel");
	// === DAPI: Huang threshold, watershed, total nuclei count ===
	selectWindow("DAPI_channel");
	roiManager("Select", 0);
	setAutoThreshold("Huang dark");
	run("Convert to Mask");
	run("Select None");
	rename("DAPI_mask");
	closeThresholdWindow();
	selectWindow("DAPI_mask");
	roiManager("Select", 0);
	run("Clear Outside");
	run("Select None");
	selectWindow("DAPI_mask");
	run("Watershed");
	roiManager("Select", 0);
	run("Analyze Particles...", "size=20-1000 display summarize");
	run("Select None");
	tagRow(file, "TotalDAPI");
	// === GFAP: remove outliers, MANUAL threshold selection each time ===
	selectWindow("GFAP_channel");
	run("Remove Outliers...", "radius=2 threshold=50 which=Bright");
	roiManager("Select", 0);

	setThreshold(8092, 65535);
	run("Threshold...");
	waitForUser("Adjust the GFAP threshold for " + file + " using the sliders, then click OK to continue.");
	getThreshold(gfapLower, gfapUpper);

	setThreshold(gfapLower, gfapUpper);
	run("Convert to Mask");
	run("Select None");
	rename("GFAP_mask");
	closeThresholdWindow();
	selectWindow("GFAP_mask");
	roiManager("Select", 0);
	run("Clear Outside");
	run("Select None");
	roiManager("Select", 0);
	run("Analyze Particles...", "size=0-Infinity display summarize");
	run("Select None");
	tagRow(file, "GFAP");
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