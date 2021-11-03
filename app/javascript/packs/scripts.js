const markdown = require('./markdown.min');

function loadImages() {
	const images = document.querySelectorAll('.image')
	images.forEach((item, index) => {
		item.querySelector('img').classList.add('loaded')
	})
}

window.close_popup_alert_box = (close_button) => {
	close_button.parentElement.style.display = "none"
}

window.include = (file) => {
	let script = document.createElement('script');
	script.src = file;
	script.type = 'text/javascript';
	script.defer = true;
	document.getElementsByTagName('head').item(0).appendChild(script);
}

window.onload = () => {
	loadImages();
}

document.addEventListener("turbolinks:load", function() {
	include('https://www.google.com/recaptcha/api.js')

	loadImages()

	const markdownDivsToHtml = document.querySelector('.md_to_html')
	if (markdownDivsToHtml) {
		markdownDivsToHtml.innerHTML = markdown.toHTML(markdownDivsToHtml.innerHTML.trim());
	}

	const imageuploadDiv = document.querySelector('.imageupload')
	if (imageuploadDiv) {
		imageuploadDiv.querySelector('input').onchange = (e) => {
		  const file = imageuploadDiv.querySelector('input').files[0]
		  const imageTag = imageuploadDiv.querySelector('.image img')
		  if (file) {
		  	imageTag.src = URL.createObjectURL(file)

		  	imageuploadDiv.querySelector('.image').style.display = 'block'
		  }
		}
	}

	// TODO
	// const videouploadDiv = document.querySelector('.videoupload')
	// if (videouploadDiv) {
	// 	videouploadDiv.querySelector('input').onchange = (e) => {
	// 	  const file = videouploadDiv.querySelector('input').files[0]
	// 	  const progressTag = videouploadDiv.querySelector('.progress')
	// 	  if (file) {
	// 	  	// const imageTag = videouploadDiv.querySelector('.image img')
	// 	  	// imageTag.src = URL.createObjectURL(file)

	// 	  	videouploadDiv.querySelector('.progress').style.display = 'block'
	// 	  }
	// 	}
	// }
})