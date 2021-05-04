#BEGIN JAVASCRIPT

function handleFileSelect(event){
	VS.global.uploadedFiles = 0; /* Reset */
	VS.global.fileContent = []; /* Reset */
	VS.global.fileName = []; /* Reset */
	if (!event.target.files[0]) {
		VS.global.client.getInterfaceElement('interface', 'canvas').text = VS.global.client.getInterfaceElement('interface', 'canvas').defaultText;
		document.getElementById('wb_interface_canvas').style.border = '';
		return;
	}
	var extension = event.target.files[0].name.split('.').pop();
	var fileName = event.target.files[0].name;
	var file = event.target.files[0];
	var loadedFiles = event.target.files.length;

	if (loadedFiles > 1) { /* If you uploaded multiple files */
		for (var x = 0; x < event.target.files.length; x++) { /* Search uploaded files */
			var reader = new FileReader(); /* Create a new file reader object per file so it doesn't get backed up */
			extension = event.target.files[x].name.split('.').pop();
			fileName = event.target.files[x].name;
			file = event.target.files[x];
			reader.onload = handleFileLoad; /* Give the onload event to this function */
			if (extension !== 'vyi') { /* If one of the files extension is not = to '.vyi' */
				VS.global.output.text += '<div class="unsupported">Unsupported file type.</div>'; /* Notify the uploader */
			} else {
				reader.readAsText(file); /* If the extension is '.vyi' read the file */
				VS.global.uploadedFiles++; /* Add to the global var of how many files are uploaded */
				VS.global.fileName.push(fileName);
				VS.global.output.text += '<div class="log-text">' + fileName + ' uploaded.</div>'; /* Notify the uploader, the file is uploaded */
			}
		}

	} else if (loadedFiles === 1) { /* If you only uploaded one file */
		var reader = new FileReader() /* Create a new file reader object  */
		reader.onload = handleFileLoad; /* Give the onload event to this function */
		if (extension !== 'vyi') { /* If the file extension is not = to '.vyi' */
			VS.global.output.text += '<div class="unsupported">Unsupported file type.</div>'; /* Notify the uploader */
		} else {
			reader.readAsText(file); /* If the extension is '.vyi' read the file */
			VS.global.uploadedFiles++; /* Add to the global var of how many files are uploaded */
			VS.global.fileName.push(fileName);
			VS.global.output.text += '<div class="log-text">' + fileName + ' uploaded.</div>'; /* Notify the uploader, the file is uploaded */
		}
	}
}

function handleFileLoad(event){
	var iconData = JSON.parse(event.target.result);
	var canvas = document.getElementById('canvas');
	var ctx = canvas.getContext('2d');
	VS.global.fileContent.push(iconData["i"]);
	ctx.clearRect(0, 0, canvas.width, canvas.height);
	VS.global.extractImages(VS.global.fileContent);
	// console.log('Uploaded Files: ' + VS.global.uploadedFiles);
}

#END JAVASCRIPT

// var vyi = {}

function createImage(width, height, base64)
	var x = JS.document.createElement('img')
	var src = 'data:image/png;base64,' + base64
	x.setAttribute('src', src)
	x.setAttribute('width', width)
	x.setAttribute('height', height)
	// output.text += '<img alt="test" src="' + src + '"width="' + x.width + '"height="' + x.height + '">'
	return x

function extractImages(fileContent)
	for (var i = 0; i < fileContent.length; i++)
		parseFile(fileContent[i], i)
		// vyi[i] = fileContent[i]

function parseFile(data, num)
	frameInfo['frames' + num] = [] /* Create a array for this frame array */
	foreach (var d in data)
		frameInfo['frames' + num].push(createImage(d[1], d[2], d[4])) /* Width, Height, Base64 */

		if (d.length > 5)
			foreach (var f in d[5]) /* searching frames */
				frameInfo['frames' + num].push(createImage(d[1], d[2], f[0])) /* Width, Height, Base64 */

		if (d.length > 6)
			foreach (var g in d[6]) /* searching states */
				frameInfo['frames' + num].push(createImage(d[1], d[2], g[1])) /* Width, Height, Base64 */

				if (g.length > 3)
					foreach (var h in g[3])
						frameInfo['frames' + num].push(createImage(d[1], d[2], h[0])) /* Width, Height, Base64 */

	spawn ()
		buildSpriteSheet(num)

function buildSpriteSheet(num)
	// World.log('called')
	var canvas = JS.document.getElementById('canvas') /* Reference the canvas */
	var ctx = canvas.getContext('2d')
	var status = {'x': 0, 'y': 0} /* Status object to hold where the next draw will take place */
	var count = 0
	var buffer

	var canvasInfo = getCanvasInfo(frameInfo['frames' + num])
	canvas.width = canvasInfo['x']
	canvas.height = canvasInfo['y']
	status['x'] = canvasInfo['maxW'] /* Get the first draw information based on width of first image */

	if (BUFFER_X) status['x'] = BUFFER_X


	foreach (var i in frameInfo['frames' + num]) /* loop through the data in this array */
		if (BUFFER_X && BUFFER_Y)
			buffer = {'x': BUFFER_X, 'y': BUFFER_Y} /* The buffer space between each draw */

		if (BUFFER_X && !BUFFER_Y)
			buffer = {'x': BUFFER_X, 'y': canvasInfo['maxH']} /* The buffer space between each draw */

		if (BUFFER_Y && !BUFFER_X)
			buffer = {'x': canvasInfo['maxW'], 'y': BUFFER_Y} /* The buffer space between each draw */

		if (!BUFFER_X && !BUFFER_Y)
			buffer = {'x': canvasInfo['maxW'], 'y': canvasInfo['maxH']} /* The buffer space between each draw */

		if (status['x'] + buffer['x'] >= buffer['x'] * frameInfo['maxRows']) /* If row is full of draws */
			status['x'] = buffer['x'] /* Reset row status */
			status['y'] += buffer['y'] /* Change the column */
			ctx.drawImage(i, status['x'] + buffer['x'], status['y'] + buffer['y']) /* Draw image on the next column */

		else /* Drawing on the first row */
			ctx.drawImage(i, status['x'] + buffer['x'], status['y'] + buffer['y']) /* Draw image on the next x coordinate */

		status['x'] += buffer['x'] /* Increase column space each draw */
		count++
		// World.log('Buffer(x): ' + buffer['x'] + '\n' + 'Buffer(y): ' + buffer['y'] + '\nLength: ' + frameInfo['frames' + num].length)

	JS.autoCropCanvas(canvas, ctx);
	var canvasEL = client.getInterfaceElement('interface', 'canvas')
	canvasEL.width = canvas.width
	canvasEL.height = canvas.height
	JS.document.getElementById('wb_interface_canvas').style.border = '2px solid #f3f3f3'
	JS.document.getElementById('wb_interface_canvas').style.overflow = 'hidden';
	
	var exporter = JS.document.getElementById('export')
	exporter.href = canvas.toDataURL()
	exporter.download = fileName[0].replace('.vyi', '') + '.png'
	// World.log(fileName[0])

function getCanvasInfo(array)
	var count = 0
	var width = 0
	var height = 0
	var maxW = 0
	var maxH = 0
	var status = {'x': 0, 'y': 0}

	for (var j = 0; j < array.length; j++)
		if (array[j].height > maxH)
			maxH = array[j].height
		
		if (array[j].width > maxW)
			maxW = array[j].width

	status['x'] = maxW

	for (var r = 3, c = 1, total = 0; total <= array.length; c++)
		if (BUFFER_X)
			if (status['x'] + BUFFER_X >= BUFFER_X * frameInfo['maxRows'])
				status['x'] = BUFFER_X
				if (BUFFER_Y)
					status['y'] += BUFFER_Y
				else	
					status['y'] += maxH
				c = 1
				r++

		else
			if (status['x'] + maxW >= maxW * frameInfo['maxRows'])
				status['x'] = maxW
				if (BUFFER_Y)
					status['y'] += BUFFER_Y
				else	
					status['y'] += maxH
				c = 1
				r++			

		if (BUFFER_X)
			status['x'] += BUFFER_X
		else
			status['x'] += maxW

		total++

	width = maxW * frameInfo['maxRows']
	height = r * maxH

	if (BUFFER_X) width = frameInfo['maxRows'] * BUFFER_X
	if (BUFFER_Y) height = r * BUFFER_Y

	return {'x': width, 'y': height, 'maxW': maxW, 'maxH': maxH}

#BEGIN JAVASCRIPT
function autoCropCanvas(canvas, ctx) {
	var bounds = {
		left: 0,
		right: canvas.width,
		top: 0,
		bottom: canvas.height
	};
	var rows = [];
	var cols = [];
	var imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
	for (var x = 0; x < canvas.width; x++) {
		cols[x] = cols[x] || false;
		for (var y = 0; y < canvas.height; y++) {
			rows[y] = rows[y] || false;
			const p = y * (canvas.width * 4) + x * 4;
			const [r, g, b, a] = [imageData.data[p], imageData.data[p + 1], imageData.data[p + 2], imageData.data[p + 3]];
			var isEmptyPixel = Math.max(r, g, b, a) === 0;
			if (!isEmptyPixel) {
				cols[x] = true;
				rows[y] = true;
			}
		}
	}
	for (var i = 0; i < rows.length; i++) {
		if (rows[i]) {
			bounds.top = i ? i: i;
			break;
		}
	}
	for (var i = rows.length; i--; ) {
		if (rows[i]) {
			bounds.bottom = i < canvas.height ? i + 1: i;
			break;
		}
	}
	for (var i = 0; i < cols.length; i++) {
		if (cols[i]) {
			bounds.left = i ? i: i;
			break;
		}
	}
	for (var i = cols.length; i--; ) {
		if (cols[i]) {
			bounds.right = i < canvas.width ? i + 1: i;
			break;
		}
	}
	var newWidth = bounds.right - bounds.left;
	var newHeight = bounds.bottom - bounds.top;
	var cut = ctx.getImageData(bounds.left, bounds.top, newWidth, newHeight);
	canvas.width = newWidth;
	canvas.height = newHeight;
	ctx.putImageData(cut, 0, 0);
}
#END JAVASCRIPT
