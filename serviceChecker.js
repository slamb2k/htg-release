const axios = require("axios");

const wait = (time) => new Promise((resolve) => setTimeout(resolve, time));

function exec(
  cmd,
  handler = function (error, stdout, stderr) {
    console.log(stdout);
    if (error !== null) {
      console.log(stderr);
    }
  }
) {
  const childfork = require("child_process");
  return childfork.exec(cmd, handler);
}

const response = async () => {
  let statusCheck = await axios
    .get("http://192.168.0.230:3000/")
    .then((res) => res.status)
    .catch((err) => err);

  if (statusCheck !== 200) {
    // TODO: log to file
    console.log("Service Unavailable - Retry..");
    wait(500);
    exec("bash ./run-chromium.sh", (err, stdout) => console.log(stdout));
  } else {
    // Poll successful
    //console.log('Successful');
    // TODO: log daily status check
  }
};

setInterval(function checkRepeat() {
  response();
}, 5000);