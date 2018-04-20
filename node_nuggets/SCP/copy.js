const exec = require("child_process").exec;

//Copy folder to remote server using scp
exec(`scp -r ${process.argv[2]} ${process.argv[3]}`, (err, stdout, stderr) => {
  if (err) {
    console.log(err);
  }
  console.log(stdout);
});

console.log(`${process.argv[2]} ${process.argv[3]}`);
