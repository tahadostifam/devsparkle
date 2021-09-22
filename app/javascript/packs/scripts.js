import SimpleMDE from './simplemde.min'

window.imagePreloader = function (e) {
	return e.classList.add('loaded')
}

window.onload = () => {
    const simplemde = new SimpleMDE({
        element: document.getElementById('simplemde_textarea'),
    });
}