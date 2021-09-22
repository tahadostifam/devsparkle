window.imagePreloader = function (e) {
	return e.classList.add('loaded')
}

document.addEventListener("turbolinks:load", function() {
	new SimpleMDE({
		element: document.querySelector(".mde_textarea")
	})
})