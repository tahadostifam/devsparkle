window.imagePreloader = function (e) {
	return e.classList.add('loaded')
}

$(function() {
	console.log('test');
	if (window.location.pathname === '/') {
		console.log('root');
	}
});

$(document).ready(() => {
	console.log('jquery is here!');
})