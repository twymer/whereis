$(function () {
  var map = L.map('map').setView([51.505, -0.09], 3);

  L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);

  $(".checkin").each(function () {
    if ($(this).data('lat') && $(this).data('lng')) {
      L.marker([$(this).data('lat'), $(this).data('lng')]).addTo(map);
    }
  });
});
