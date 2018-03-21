// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .


//= require rails-ujs
//= require turbolinks
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require gmaps
//= require_tree .


document.addEventListener("turbolinks:load", function () {
    setUpObserver();

    if (document.body.contains(document.getElementById('map'))) {
        getPosition({
            enableHighAccuracy: true
        }).then(function (position) {
            var c = {
                latitude: position.coords.latitude,
                longitude: position.coords.longitude
            };
            setCookie('geocoderLocation', JSON.stringify(c))
                .then(function () {
                    redirectWithLocation();
                    document.body.dataset.geocoded = true;
                }).catch(function (error) {
                console.log(error);
            });
        }).catch(function (error) {
            console.log(error);
        });
    }

});

function getPosition(options) {
    if (document.body.dataset.env === 'test') {
        return new Promise(function (resolve) {
            var fakePosition = JSON.parse(document.getElementById('fake_position').content);
            resolve({
                coords: {
                    latitude: fakePosition.coords.latitude,
                    longitude: fakePosition.coords.longitude
                }
            });
        });
    } else {
        return new Promise(function (resolve, reject) {
            navigator.geolocation.getCurrentPosition(function (position) {
                return resolve(position);
            }, function (error) {
                return reject(error);
            }, options);
        });
    }
}

function redirectWithLocation() {
    var url = new URL(window.location.href);

    if (document.body.dataset.geocoded !== 'true') {
        window.location.replace(url);
    }
}

function setCookie(name, value) {
    var days = arguments.length > 2 && arguments[2] !== undefined ? arguments[2] : 7;
    var path = arguments.length > 3 && arguments[3] !== undefined ? arguments[3] : '/';

    return new Promise(function (resolve) {
        var expires = new Date(Date.now() + days * 864e5).toUTCString();
        document.cookie = name + '=' + encodeURIComponent(value) + '; expires=' + expires + '; path=' + path;
        resolve();
    });
}

function getCookie(name) {
    return new Promise(function (resolve) {
        var value = document.cookie.split('; ').reduce(function (r, v) {
            var parts = v.split('=');
            return parts[0] === name ? decodeURIComponent(parts[1]) : r
        }, '');
        resolve(value);
    })
}

function setUpObserver() {
    var element = document.querySelector('body');
    var callback = function (mutations) {
        mutations.forEach(function (mutation) {
            if (mutation.type === "attributes") {
                initiateMap()
            }
        });
    };
    var observer = new MutationObserver(callback);
    observer.observe(element, {
        attributes: true
    });
}

function initiateMap() {
    getCookie('geocoderLocation').then(function (value) {
        console.log('cookie read');
        var coords = JSON.parse(value);
        map = GMaps({
            div: '#map',
            zoom: 12,
            lat: coords.latitude,
            lng: coords.longitude
        });
        map.addStyle({
            styles: style,
            mapTypeId: 'custom-style'
        });
        map.setStyle('custom-style');
        //addMarkers();
        //addCenterMarker();
    })
}


function addCenterMarker() {
    map.addMarker({
        lat: map.getCenter().lat(),
        lng: map.getCenter().lng(),
        title: 'Your location',
        infoWindow: {
            content: '<h4>You are here</h4>'
        },
        icon: {
            scaledSize: new google.maps.Size(30, 30),
            url: 'https://furtaev.ru/preview/man.png'
        }
    });
}

function addMarkers() {
    restaurants.forEach(function (item) {
        map.addMarker({
            lat: item.latitude,
            lng: item.longitude,
            title: item.name,
            infoWindow: {
                content: '<h4>' + item.name + '</h4><p>' + item.city + '</p>'
            },
            icon: {
                scaledSize: new google.maps.Size(30, 30),
                url: 'https://furtaev.ru/preview/eat_at_home.png'
            }
        });
    });
}


var style = [{
    "elementType": "geometry",
    "stylers": [{
        "color": "#f5f5f5"
    }]
},
    {
        "elementType": "labels.icon",
        "stylers": [{
            "visibility": "off"
        }]
    },
    {
        "elementType": "labels.text.fill",
        "stylers": [{
            "color": "#616161"
        }]
    },
    {
        "elementType": "labels.text.stroke",
        "stylers": [{
            "color": "#f5f5f5"
        }]
    },
    {
        "featureType": "administrative.land_parcel",
        "elementType": "labels.text.fill",
        "stylers": [{
            "color": "#bdbdbd"
        }]
    },
    {
        "featureType": "poi",
        "elementType": "geometry",
        "stylers": [{
            "color": "#eeeeee"
        }]
    },
    {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [{
            "color": "#757575"
        }]
    },
    {
        "featureType": "poi.park",
        "elementType": "geometry",
        "stylers": [{
            "color": "#e5e5e5"
        }]
    },
    {
        "featureType": "poi.park",
        "elementType": "labels.text.fill",
        "stylers": [{
            "color": "#9e9e9e"
        }]
    },
    {
        "featureType": "road",
        "elementType": "geometry",
        "stylers": [{
            "color": "#ffffff"
        }]
    },
    {
        "featureType": "road.arterial",
        "elementType": "labels.text.fill",
        "stylers": [{
            "color": "#757575"
        }]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [{
            "color": "#dadada"
        }]
    },
    {
        "featureType": "road.highway",
        "elementType": "labels.text.fill",
        "stylers": [{
            "color": "#616161"
        }]
    },
    {
        "featureType": "road.local",
        "elementType": "labels.text.fill",
        "stylers": [{
            "color": "#9e9e9e"
        }]
    },
    {
        "featureType": "transit.line",
        "elementType": "geometry",
        "stylers": [{
            "color": "#e5e5e5"
        }]
    },
    {
        "featureType": "transit.station",
        "elementType": "geometry",
        "stylers": [{
            "color": "#eeeeee"
        }]
    },
    {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [{
            "color": "#c9c9c9"
        }]
    },
    {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [{
            "color": "#9e9e9e"
        }]
    }
]
