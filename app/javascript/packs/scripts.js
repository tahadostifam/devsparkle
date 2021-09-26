const markdown = require('./markdown.min');

window.imagePreloader = function (e) {
	return e.classList.add('loaded')
}

document.addEventListener("turbolinks:load", function() {
	new SimpleMDE({
		element: document.querySelector(".mde_textarea"),
		hideIcons: ["fullscreen", "side-by-side", "guide"],
	})

	const markdownDivsToHtml = document.querySelector('.md_to_html')
	if (markdownDivsToHtml) {
		console.log(markdown.toHTML(markdownDivsToHtml.innerHTML.trim()).trim());
		markdownDivsToHtml.innerHTML = markdown.toHTML(markdownDivsToHtml.innerHTML.trim()).trim();
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