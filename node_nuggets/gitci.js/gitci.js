//

const util = require("util");
const exec = util.promisify(require("child_process").exec);

async function updateCheck() {
  const latest = await exec("git rev-parse origin/master");
  const current = await exec("git rev-parse HEAD");
  return latest.stdout == current.stdout;
}

async function pullUpdates() {
  if (updateCheck() == true) {
    console.log("updating!!!");
  } else {
    console.log("No Updates :)");
    return;
  }
}

setInterval(pullUpdates, 3000);
