// ┌┬┐┬┌┬┐┌─┐
//  │ ││││├┤
//  ┴ ┴┴ ┴└─┘
// Set time and Date

window.onload = displayClock();
function displayClock() {
  const monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  const d = new Date();
  const mm = monthNames[d.getMonth()];
  const dd = d.getDate();
  const min = (mins = ("0" + d.getMinutes()).slice(-2));
  let hh = d.getHours();
  let ampm = "";

  if (CONFIG.twelveHourFormat) {
    ampm = hh >= 12 ? " pm" : " am";
    hh = hh % 12;
    hh = hh ? hh : 12;
  }

  document.getElementById("hour").innerText = hh;
  document.getElementById("separator").innerHTML = " : ";
  document.getElementById("minutes").innerText = min + ampm;

  document.getElementById("month").innerText = mm;
  document.getElementById("day").innerText = dd;

  setTimeout(displayClock, 1000);
}
