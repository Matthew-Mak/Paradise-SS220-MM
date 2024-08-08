#define DEFAULT_TITLE_SCREEN_IMAGE_PATH 'modular_ss220/title_screen/icons/default.jpg'

#define DEFAULT_TITLE_HTML {"
	<html>
		<head>
			<title>Title Screen</title>
			<meta http-equiv="X-UA-Compatible" content="IE=edge">
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
			<link rel="stylesheet" type="text/css" href="v4shim.css">
			<link rel="stylesheet" type="text/css" href="font-awesome.css">
			<style type='text/css'>
				@font-face {
					font-family: "Fixedsys";
					src: url("FixedsysExcelsior3.01Regular.ttf");
				}
				body,
				html {
					font-family: Verdana, Geneva, sans-serif;
					font-size: 1.2vw;
					overflow: hidden;
					text-align: center;
					-ms-user-select: none;
					user-select: none;
					cursor: default;
					margin: 0;
					background-color: black;
				}

				img {
					border-style: none;
				}

				hr {
					border: 0;
					border-bottom: 0.15em solid rgba(255, 255, 255, 0.1);
				}

				i {
					width: 1em;
					height: 1em;
					transition: transform 0.2s;
				}

				.bg {
					position: absolute;
					width: auto;
					height: 100vmin;
					min-width: 100vmin;
					min-height: 100vmin;
					top: 50%;
					left: 50%;
					transform: translate(-50%, -50%);
					z-index: 0;
				}

				.container_notice {
					position: absolute;
					box-sizing: border-box;
					width: 100vw;
					top: 0;
					left: 20em;
					padding-right: 20em;
					background-color: rgba(22, 22, 22, 0.85);
					border-bottom: 1px solid rgba(255, 255, 255, 0.2);
					transition: left 0.2s, padding 0.2s;
					z-index: 1;
				}

				#hide_menu:checked ~ .container_notice {
					left: 0;
					padding-right: 0;
				}

				.menu_notice {
					margin: 0.75em 0.5em;
					line-height: 1.75rem;
					font-size: 1.5rem;
					color: #bd2020;
				}

				.container_menu {
					display: flex;
					flex-direction: column;
					justify-content: space-between;
					position: absolute;
					overflow: hidden;
					box-sizing: border-box;
					bottom: 0;
					left: 0;
					width: 20em;
					height: 100vh;
					background-color: rgba(22, 22, 22, 0.85);
					border-right: 1px solid rgba(255, 255, 255, 0.1);
					transition: transform 0.2s;
					z-index: 2;
				}

				#hide_menu:checked ~ .container_menu {
					transform: translateX(-100%);
				}

				.container_logo {
					display: flex;
					flex-direction: column;
					align-items: center;
					background-color: #191919;
					box-shadow: 0 0.25em 1.75em rgba(0,0,0,0.75);
				}

				.logo {
					width: 17.5vw;
					padding: 1em;
					transform: scale(0.9);
				}

				.character_info {
					display: flex;
					flex-direction: column;
					box-sizing: border-box;
					width: 100%;
					padding: 0.5em 0.75em;
					background-color: rgba(255,255,255,0.05);
					border-bottom: 1px solid rgba(255, 255, 255, 0.1);
					border-top: 1px solid rgba(255, 255, 255, 0.1)
				}

				.character {
					width: 100%;
					margin-top: 0.25em;
					font-weight: bold;
					font-size: 1.2rem;
					text-align: right;
					color: #d4dfec;
				}

				.character:first-of-type {
					font-weight: normal;
					font-size: 1.1rem;
					text-align: left;
					margin: 0;
					color: #898989;
				}

				.container_buttons {
					flex: 1;
					text-align: left;
					margin: 0.5em 0.5em 0.5em 0
				}

				.menu_button {
					display: block;
					cursor: pointer;
					overflow: hidden;
					position: relative;
					font-size: 1.35rem;
					text-decoration: none;
					box-sizing: border-box;
					width: 100%;
					margin-bottom: 0.25em;
					padding: 0.25em 0.25em 0.25em 0.5em;
					color: #898989;
					border: 1px solid transparent;
					border-radius: 0 0.25em 0.25em 0;
					transition: color 0.2s, background-color 0.2s, border-color 0.2s;
				}

				.menu_button::after {
					content: '';
					position: absolute;
					top: 50%;
					left: 0;
					width: 2px;
					height: 0;
					background-color: #d4dfec;
					transform: translateY(-50%);
					transition: height 0.2s, background-color 0.2s;
				}

				.menu_button:hover::after {
					height: 100%;
				}

				.menu_button:hover,
				.link_button:hover {
					background-color: rgba(255, 255, 255, 0.075);
					color: #d4dfec;
				}

				.good {
					color: #1b9638;
				}

				.good:hover {
					color: #2fb94f;
				}

				.good::after {
					background-color: #2fb94f;
				}

				.bad {
					color: #bd2020;
				}

				.bad:hover {
					color: #d93f3f;
				}

				.bad::after {
					background-color: #d93f3f;
				}

				.container_links {
					display: flex;
				}

				.link_button {
					position: relative;
					cursor: pointer;
					width: 100%;
					font-size: 1.5rem;
					padding: 0.5em;
					color: #898989;
					transition: color 0.2s, background-color 0.2s;
				}

				.link_button::after {
					content: '';
					position: absolute;
					left: 50%;
					bottom: 0;
					width: 0;
					height: 2px;
					background-color: #d4dfec;
					transform: translateX(-50%);
					transition: width 0.2s;
				}

				.link_button:hover::after {
					width: 100%;
				}

				.hide_button {
					cursor: pointer;
					position: fixed;
					bottom: 0;
					left: 20em;
					padding: 0.9em;
					vertical-align: middle;
					background-color: rgba(22, 22, 22, 0.85);
					color: #898989;
					border: 1px solid rgba(255, 255, 255, 0.1);
					border-width: 1px 1px 0 0;
					transition: color 0.2s, left 0.2s;
				}

				.hide_button i {
					font-size: 1.5rem;
				}

				.hide_button:hover {
					color: #d4dfec;
				}

				#hide_menu:checked ~ .container_menu .hide_button {
					left: 0;
				}

				#hide_menu:checked ~ .container_menu .hide_button i {
					transform: rotate(180deg);
				}
			</style>
		</head>
		<body>
			"}
