#BEGIN WEBSTYLE

// #wb_interface_import_output {
// 	// border: 2px solid #070812;
// 	// padding: 2px;
// }

#wb_interface_canvas {
	overflow: visible;
}

::-webkit-scrollbar {
	width: 8px;
	height: 8px;
}

::-webkit-scrollbar-track {
	border-radius: 10px;
	background: rgba(0, 0, 0, 0.1);
}

::-webkit-scrollbar-thumb {
	border-radius: 10px;
	background: rgba(0, 0, 0, 0.2);
}
	
::-webkit-scrollbar-thumb:hover {
	background: rgba(0, 0, 0, 0.4);
}
	
::-webkit-scrollbar-thumb:active {
	background: rgba(0, 0, 0, 0.9);
}

label {
	display: inline-block;
	width: 120px;
	height 50px;
	overflow: visible;
}

.fake-button {
	display:inline-block;
	border:0.1em solid #000;
	border-radius:0.12em;
	box-sizing: border-box;
	text-decoration:none;
	font-family:'Roboto',sans-serif;
	font-color: #f3f3f3;
	font-weight:300;
	color: #f3f3f3;
	background-color: rgb(51, 51, 51);
	text-align:center;
	transition: all 0.2s;
}

.fake-button:hover {
	color:#a9a9a9;
	background-color:#1c1e1f;
}

.unsupported {
	color: #ff0000;
	font-weight: bold;
}

.log-text {
	font-weight: bold;
	font-size: 14;
	font-family: 'Arial';
}


input[type=number] {
	/*for absolutely positioning spinners*/
	position: relative; 
	padding: 1px;
	padding-right: 1px;
	color: #313639;
}

input[type=number]::-webkit-inner-spin-button,
input[type=number]::-webkit-outer-spin-button {
	opacity: 1;
	color: #313639;
}

input[type=number]::-webkit-outer-spin-button, 
input[type=number]::-webkit-inner-spin-button {
	-webkit-appearance: inner-spin-button !important;
	width: 2px;
	position: absolute;
	top: 0;
	right: 0;
	height: 100%;
	color: #313639;
}
