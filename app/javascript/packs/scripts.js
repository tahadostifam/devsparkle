const axios = require('./axios.min');
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

	// const new_course_episode = document.getElementById('new_course_episode')
	// if (new_course_episode) {
	// 	new_course_episode.addEventListener('submit', (e) => {
	// 		e.preventDefault();
	// 		const slug = $("[name='course_episode[slug]']").val()
	// 		const formData = new FormData()
	// 		formData.append("slug", slug);
	// 		formData.append("header", $("[name='course_episode[header]']").val());
	// 		formData.append("cover_text", $("[name='course_episode[cover_text]']").val());
	// 		formData.append("published", $("[name='course_episode[published]']").val());
	// 		const videoFile = $("[name='course_episode[video_file]']")[0].files[0];
	// 		if (videoFile) {
	// 			formData.append("video_file", videoFile);
	// 		}
	// 		formData.append("g-recaptcha-response", $("[name='g-recaptcha-response']").val());
	// 		formData.append("authenticity_token", $("[name='authenticity_token']").val());
	// 		axios.post('/courses/videos/submit_new_episode', formData, {
	// 			onUploadProgress: (e) => {
	// 				var percentCompleted = Math.round((e.loaded * 100) / e.total)
	// 				const stringPercentCompleted = percentCompleted.toString() + '%'
	// 				const progress_bar = $(".progress .progress-bar");
	// 				progress_bar.css('width', stringPercentCompleted);
	// 				progress_bar.html(stringPercentCompleted)
	// 				$(".progress").css('display', 'block')
	// 			}
	// 		}).then((callback) => {
	// 			if (callback.data.status == 'error') {
	// 				if (callback.data.message == 'service unavailable') {
	// 					window.location.pathname = '/courses/show/' + slug
	// 				}
	// 				else if (callback.data.message == 'course not found') {
	// 					window.location.pathname = '/courses/index'
	// 				}
	// 				else if (callback.data.errors) {
	// 					const error_list = $(".form_error_list")
	// 					error_list.html("")
	// 					callback.data.errors.forEach((i) => {
	// 						error_list.append(`<div class="item">${i}</div>`)
	// 					})
	// 				}
	// 			}
	// 			else if (callback.data.status == 'success') {
	// 				window.location.pathname = '/courses/episode_created'
	// 			}
	// 		}).catch((error) => {
	// 			if (error) {
	// 				console.log(error);
	// 			}
	// 		}).finally(() => {
	// 			$('#new_episode_submit_button').removeAttr('disabled', 'disabled');
	// 		});
	// 	})
	// }

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