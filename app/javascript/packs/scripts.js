const markdown = require('./markdown.min');

window.imagePreloader = function (e) {
	return e.classList.add('loaded')
}

window.close_popup_alert_box = (close_button) => {
	close_button.parentElement.style.display = "none"
}

document.addEventListener("turbolinks:load", function() {
	const markdownDivsToHtml = document.querySelector('.md_to_html')
	if (markdownDivsToHtml) {
		markdownDivsToHtml.innerHTML = markdown.toHTML(markdownDivsToHtml.innerHTML.trim());
	}

	const fileuploadDiv = document.querySelector('.fileupload')
	if (fileuploadDiv) {
		fileuploadDiv.querySelector('input').onchange = (e) => {
		  const file = fileuploadDiv.querySelector('input').files[0]
		  const imageTag = fileuploadDiv.querySelector('.image img')
		  if (file) {
		  	const imageTag = fileuploadDiv.querySelector('.image img')
		  	imageTag.src = URL.createObjectURL(file)

		  	fileuploadDiv.querySelector('.image').style.display = 'block'
		  }
		}
	}
})