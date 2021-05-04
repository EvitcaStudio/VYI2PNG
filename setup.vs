Client
	screenBackground = '#23272A'
	hideFPS = true

	onMouseMove(diob, x, y)
		if (this.dragging)
			this.dragging['element'].setPos(x - this.dragging['xOff'], y - this.dragging['yOff'])

	onMouseUp(diob, x, y, button)
		if (this.dragging && button === 1)
			this.dragging = null

	onConnect()
		this.showInterface('interface')
		output = this.getInterfaceElement('interface', 'import_output')
		client = this
		JS.document.getElementById('ti_interface_buffer_x_input').setAttribute('type', 'number')
		JS.document.getElementById('ti_interface_buffer_y_input').setAttribute('type', 'number')

		JS.document.getElementById('ti_interface_buffer_x_input').setAttribute('min', 0)
		JS.document.getElementById('ti_interface_buffer_y_input').setAttribute('min', 0)

		JS.document.getElementById('ti_interface_buffer_x_input').setAttribute('placeholder', 0)
		JS.document.getElementById('ti_interface_buffer_y_input').setAttribute('placeholder', 0)

		JS.document.getElementById('ti_interface_buffer_x_input').setAttribute('max', 100)
		JS.document.getElementById('ti_interface_buffer_y_input').setAttribute('max', 100)

		JS.document.getElementById('ti_interface_buffer_x_input').setAttribute('list', 'defaultNumbers')
		JS.document.getElementById('ti_interface_buffer_y_input').setAttribute('list', 'defaultNumbers')

#DEFINE HUD_LAYER 1000
var uploadedFiles = 0
var fileContent = []
var fileName = []
var frameInfo = {'maxRows': 15}
var output
var client
var BUFFER_X = 0
var BUFFER_Y = 0

Interface
	layer = HUD_LAYER
	textStyle = {'fill': '#f3f3f3'}

	onMouseDown(client, x, y, button)
		if (this.draggable && button === 1)
			client.dragging = {'element': this, 'xOff': x, 'yOff': y}

	Import
		interfaceType = 'WebBox'
		Import_Output
			width = 300
			height = 200
			color = '#f8f7ed'
			textStyle = {'fill': '#313639'}

		Import_Button
			width = 120
			height = 18
			textStyle = { 'fill': '#f3f3f3', 'fontFamily': 'Helvetica', 'fontSize': 13 }

			onShow()
				this.text = '
							<label class="fake-button">
								<input type="file" onchange="handleFileSelect(event)" style="display: none; id="upload" accept=".vyi">
								<div>Import</div>
							</label>
							'

		Canvas
			width = 960
			height = 540
			// mouseOpacity = 0
			layer = HUD_LAYER - 100
			var draggable = true
			var defaultText

			onShow()
				this.defaultPos = {'x': this.xPos, 'y': this.yPos}
				this.text = '<canvas id="canvas"></canvas>'
				this.defaultText = this.text

			onMouseClick(client, x, y, button)
				if (button === 3)
					this.setPos(this.defaultPos['x'], this.defaultPos['y'])

	Export
		Export_Button
			interfaceType = 'WebBox'
			width = 120
			height = 18
			textStyle = { 'fill': '#f3f3f3', 'fontFamily': 'Helvetica', 'fontSize': 13 }

			onShow()
				this.text = '
							<label class="fake-button">
								<a id="export">Export</a>
							</label>
							'


	Info
		interfaceType = 'WebBox'
		textStyle = { 'fill': '#f3f3f3', 'fontFamily': 'Helvetica', 'fontSize': 13 }

		Buffer_X_Input
			interfaceType = 'CommandInput'
			width = 40
			height = 20
			color = '#fff'
			textStyle = { 'fill': '#313639', 'fontFamily': 'Helvetica', 'fontSize': 11}

			onExecute(client)
				if (this.text > 100)
					return alert('Number can\'t be over 100')
				
				BUFFER_X = Util.toNumber(this.text)
				spawn()
					this.text = BUFFER_X

		Buffer_Y_Input
			interfaceType = 'CommandInput'
			width = 40
			height = 20
			color = '#fff'
			textStyle = { 'fill': '#313639', 'fontFamily': 'Helvetica', 'fontSize': 11}

			onExecute(client)
				if (this.text > 100)
					return alert('Number can\'t be over 100')

				BUFFER_Y = Util.toNumber(this.text)
				spawn()
					this.text = BUFFER_Y

		x
			mouseOpacity = 0
			onShow()
				this.text = '<div class="log-text">X</div>
				<datalist id="defaultNumbers">
  					<option value="8">
  					<option value="16">
  					<option value="24">
  					<option value="32">
 					<option value="48">
				</datalist>'			

		Y
			mouseOpacity = 0
			onShow()
				this.text = '<div class="log-text">Y</div>'

		Text
			mouseOpacity = 0
			width = 200
			height = 250
			onShow()
				this.text = '<div class="log-text">• Only input values in here when the .vyi you supplied has icons in it that differ in size. These values allow you to change the buffer size between rows/colums.<br><br> • Note, input these values before the import. The system tries to do this for you, where it grabs the tallest image, and the widest image, and uses that as a buffer by default. If the results aren\'t as fined tuned as you\'d like. Use these values to tweak'